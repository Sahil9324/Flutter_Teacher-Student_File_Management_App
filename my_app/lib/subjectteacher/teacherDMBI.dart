import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherDMBI extends StatelessWidget {
  final List<File> pickedFiles;
  final Function pickFile;
  final Function removeFile;

  TeacherDMBI({
    required this.pickedFiles,
    required this.pickFile,
    required this.removeFile,
  });

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      uploadFileToStorage(file);
    }
  }

  Future<void> uploadFileToStorage(File file) async {
    try {
      String fileName = file.path.split('/').last;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('DMBI')
          .child(fileName);

      await ref.putFile(file);
      print('File uploaded successfully!');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> downloadFile(String fileName, BuildContext context) async {
    try {
      if (!(await Permission.storage.isGranted)) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          print('Error: Storage permission not granted.');
          return;
        }
      }

      final Directory? downloadsDir = await getExternalStorageDirectory();
      if (downloadsDir == null) {
        print('Error: Downloads directory not found.');
        return;
      }

      final String filePath = '${downloadsDir.path}/$fileName';
      final firebase_storage.Reference fileRef =
      firebase_storage.FirebaseStorage.instance.ref('DMBI/$fileName');

      final http.Response response =
      await http.get(Uri.parse(await fileRef.getDownloadURL()));
      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded to $filePath')),
        );
        print('File downloaded to: $filePath');
      } else {
        print('Failed to download file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<void> removeFileFromStorage(String fileName) async {
    try {
      await firebase_storage.FirebaseStorage.instance.ref('DMBI/$fileName').delete();
      print('File deleted successfully from Firebase Storage');
    } catch (e) {
      print('Error deleting file from Firebase Storage: $e');
    }
  }

  Future<void> removeFileFromFirestore(String fileName) async {
    try {
      await FirebaseFirestore.instance.collection('files').doc(fileName).delete();
      print('File entry deleted successfully from Firestore');
    } catch (e) {
      print('Error deleting file entry from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.attach_file, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text(
                    'Attach Files',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: pickAndUploadFile,
                    icon: Icon(Icons.add),
                    label: Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 10),
              DataTable(
                columnSpacing: 12,
                dataRowHeight: 70,
                headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.blueAccent.withOpacity(0.2)),
                columns: [
                  DataColumn(label: Text('File Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Download')),
                  DataColumn(label: Text('Delete')),
                ],
                rows: List<DataRow>.generate(
                  pickedFiles.length,
                      (index) => DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            pickedFiles[index].path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () {
                            downloadFile(pickedFiles[index].path.split('/').last, context);
                          },
                          icon: Icon(Icons.download_rounded, color: Colors.green),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () {
                            final fileName = pickedFiles[index].path.split('/').last;
                            removeFileFromStorage(fileName);
                            removeFileFromFirestore(fileName);
                            removeFile(index);
                          },
                          icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 10),
              StreamBuilder<firebase_storage.ListResult>(
                stream: firebase_storage.FirebaseStorage.instance
                    .ref('DMBI')
                    .listAll()
                    .asStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final files = snapshot.data!.items;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final fileName = files[index].name;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(Icons.insert_drive_file, color: Colors.blueAccent),
                          title: Text(fileName),
                          trailing: Wrap(
                            spacing: 12,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final downloadUrl = await files[index].getDownloadURL();
                                  final response = await http.get(Uri.parse(downloadUrl));

                                  if (response.statusCode == 200) {
                                    final Directory? downloadsDir = await getDownloadsDirectory();
                                    if (downloadsDir == null) {
                                      print('Error: Downloads directory not found.');
                                      return;
                                    }

                                    final String filePath = '${downloadsDir.path}/$fileName';
                                    final File file = File(filePath);
                                    await file.writeAsBytes(response.bodyBytes);

                                    print('File downloaded to: $filePath');
                                  } else {
                                    print('Failed to download file: ${response.reasonPhrase}');
                                  }
                                },
                                icon: Icon(Icons.download, color: Colors.green),
                              ),
                              IconButton(
                                onPressed: () {
                                  removeFileFromStorage(fileName);
                                  removeFileFromFirestore(fileName);
                                },
                                icon: Icon(Icons.delete, color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
