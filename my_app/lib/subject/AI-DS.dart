
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_app/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:my_app/subjectstudent/studentAI-DS.dart';
import 'package:my_app/subjectteacher/teacherAI-DS.dart';

// class AIDSHomePage extends StatefulWidget {
//   @override
//   _AIDSHomePageState createState() => _AIDSHomePageState();
// }
//
// class _AIDSHomePageState extends State<AIDSHomePage> {
//   List<File> _pickedFiles = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _requestPermission(); // Request storage permission when the app starts
//     _loadFiles();
//   }
//
//   Future<void> _requestPermission() async {
//     // Request storage permission
//     PermissionStatus status = await Permission.storage.request();
//     if (status.isGranted) {
//       // Permission granted, you can now access external storage
//     } else {
//       // Permission denied
//       // You can display a message or take appropriate action
//     }
//   }
//
//   Future<void> _loadFiles() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? filePaths = prefs.getStringList('file_paths');
//     if (filePaths != null) {
//       setState(() {
//         _pickedFiles = filePaths.map((path) => File(path)).toList();
//       });
//     }
//   }
//
//   Future<void> _saveFiles() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> filePaths = _pickedFiles.map((file) => file.path).toList();
//     await prefs.setStringList('file_paths', filePaths);
//   }
//
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _pickedFiles.add(File(result.files.single.path!));
//       });
//       await _saveFiles();
//     }
//   }
//
//   void _downloadFile(File file) async {
//     try {
//       // Get the directory where the files will be saved
//       Directory? directory = await getDownloadsDirectory();
//       if (directory == null) {
//         print('Failed to access downloads directory');
//         return;
//       }
//       String downloadPath = '${directory.path}';
//
//       // Check if the file exists
//       if (!await file.exists()) {
//         print('File not found: ${file.path}');
//         return;
//       }
//
//       // Copy the file from its current location to the download path
//       await file.copy('$downloadPath/${file.path.split('/').last}');
//
//       // Optionally, you can display a message to indicate that the file has been downloaded
//       print('File downloaded successfully');
//     } catch (e) {
//       print('Error downloading file: $e');
//     }
//   }
//
//   void _removeFile(int index) {
//     setState(() {
//       _pickedFiles.removeAt(index);
//       _saveFiles();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('File Upload'),
//         actions: [
//           IconButton(
//             onPressed: _pickFile,
//             icon: Icon(Icons.attach_file),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: DataTable(
//           columnSpacing: 16, // Add spacing between columns
//           dataRowHeight: 80, // Set the height of each DataRow
//           columns: [
//             DataColumn(label: Text('File Name')),
//             DataColumn(label: Text('Download')),
//             DataColumn(label: Text('Delete')),
//           ],
//           rows: List<DataRow>.generate(
//             _pickedFiles.length,
//                 (index) => DataRow(
//               cells: [
//                 DataCell(
//                   SizedBox(
//                     width: 150, // Set width to limit text overflow
//                     child: Text(_pickedFiles[index].path.split('/').last),
//                   ),
//                 ),
//                 DataCell(
//                   IconButton(
//                     onPressed: () => _downloadFile(_pickedFiles[index]),
//                     icon: Icon(Icons.download),
//                   ),
//                 ),
//                 DataCell(
//                   IconButton(
//                     onPressed: () => _removeFile(index),
//                     icon: Icon(Icons.delete),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TeacherC extends StatelessWidget {
//   final List<File> pickedFiles;
//   final Function pickFile;
//   final Function downloadFile;
//   final Function removeFile;
//
//   TeacherC(
//       this.pickedFiles,
//       this.pickFile,
//       this.downloadFile,
//       this.removeFile,
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('File Upload'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               pickFile();
//             },
//             icon: Icon(Icons.attach_file),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: pickedFiles.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(pickedFiles[index].path.split('/').last),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   onPressed: () => downloadFile(pickedFiles[index]),
//                   icon: Icon(Icons.download),
//                 ),
//                 IconButton(
//                   onPressed: () => removeFile(index),
//                   icon: Icon(Icons.delete),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class StudentC extends StatelessWidget {
//   final List<File> pickedFiles;
//   final Function pickFile;
//   final Function downloadFile;
//   final Function removeFile;
//
//   StudentC(
//       this.pickedFiles,
//       this.pickFile,
//       this.downloadFile,
//       this.removeFile,
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('File Upload'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               pickFile();
//             },
//             icon: Icon(Icons.attach_file),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: pickedFiles.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(pickedFiles[index].path.split('/').last),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   onPressed: () => downloadFile(pickedFiles[index]),
//                   icon: Icon(Icons.download),
//                 ),
//                 IconButton(
//                   onPressed: () => removeFile(index),
//                   icon: Icon(Icons.delete),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//

class AIDSHomePage extends StatefulWidget {
  final String userType;

  AIDSHomePage({required this.userType});

  @override
  _AIDSHomePageState createState() => _AIDSHomePageState();
}

class _AIDSHomePageState extends State<AIDSHomePage> {
  List<File> _pickedFiles = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _loadFiles();
  }

  Future<void> _requestPermission() async {
    // Request storage permission
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, you can now access external storage
    } else {
      // Permission denied
      // You can display a message or take appropriate action
    }
  }

  Future<void> _loadFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? filePaths = prefs.getStringList('aids_file_paths'); // Use different key
    if (filePaths != null) {
      setState(() {
        _pickedFiles = filePaths.map((path) => File(path)).toList();
      });
    }
  }

  Future<void> _saveFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> filePaths = _pickedFiles.map((file) => file.path).toList();
    await prefs.setStringList('aids_file_paths', filePaths); // Use different key
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _pickedFiles.add(File(result.files.single.path!));
      });
      await _saveFiles();
    }
  }


  void _downloadFile(File file) async {
    try {
      // Get the directory where the files will be saved
      Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        print('Failed to access external storage directory');
        return;
      }
      String downloadPath = '${directory.path}/AIDS_Files';

      // Create the directory if it doesn't exist
      Directory(downloadPath).createSync(recursive: true);

      // Check if the file exists
      if (!await file.exists()) {
        print('File not found: ${file.path}');
        return;
      }

      // Copy the file from its current location to the download path
      await file.copy('$downloadPath/${file.path.split('/').last}');

      // Optionally, you can display a message to indicate that the file has been downloaded
      print('File downloaded successfully');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }


  void _removeFile(int index) {
    setState(() {
      _pickedFiles.removeAt(index);
      _saveFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AIDS Files'),
      ),
      body: SingleChildScrollView(
        child: widget.userType == 'teacher'
            ? TeacherAIDS(
          pickedFiles: _pickedFiles,
          pickFile: _pickFile,
          // downloadFile: _downloadFile,
          removeFile: _removeFile,
        )
            : StudentAIDS(
          pickedFiles: _pickedFiles,
          // pickFile: _pickFile,
          // downloadFile: _downloadFile,
          // removeFile: _removeFile,
        ),
      ),
    );
  }
}


