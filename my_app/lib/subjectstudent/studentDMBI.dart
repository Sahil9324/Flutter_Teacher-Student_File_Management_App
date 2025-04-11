import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';


class StudentDMBI extends StatelessWidget {
  final List<File> pickedFiles;

  StudentDMBI({
    required this.pickedFiles,
  });

  Future<void> downloadFile(String fileName, BuildContext context) async {
    try {
      // Request storage permission if not granted
      if (!(await Permission.storage.isGranted)) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          print('Error: Storage permission not granted.');
          return;
        }
      }

      // Get a list of external storage directories
      List<Directory>? externalDirs = await getExternalStorageDirectories();

      // Check if externalDirs is not empty and iterate over each directory
      if (externalDirs != null && externalDirs.isNotEmpty) {
        for (Directory dir in externalDirs) {
          final String filePath = '${dir.path}/$fileName';

          final firebase_storage.Reference fileRef =
          firebase_storage.FirebaseStorage.instance.ref('DMBI/$fileName');

          final http.Response response =
          await http.get(Uri.parse(await fileRef.getDownloadURL()));
          if (response.statusCode == 200) {
            final File file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('File downloaded to $filePath'),
              ),
            );

            print('File downloaded to: $filePath');
            return; // Exit the loop once the file is successfully downloaded
          }
        }
      }

      // If no suitable external storage directory is found or file download fails
      print('Failed to download file: No suitable external storage directory found');
    } catch (e) {
      // Handle error
      print('Error downloading file: $e');
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
