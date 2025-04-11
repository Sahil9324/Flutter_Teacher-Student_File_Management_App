import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_app/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:my_app/subjectstudent/studentDMBI.dart';
import 'package:my_app/subjectteacher/teacherDMBI.dart';



class DMBIHomePage extends StatefulWidget {
  final String userType;

  DMBIHomePage({required this.userType});

  @override
  _DMBIHomePageState createState() => _DMBIHomePageState();
}

class _DMBIHomePageState extends State<DMBIHomePage> {
  List<File> _pickedFiless = [];

  @override
  void initState() {
    super.initState();
    _requestPermission(); // Request storage permission when the app starts
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
    List<String>? filePaths = prefs.getStringList('dmbi_file_paths'); // Use different key
    if (filePaths != null) {
      setState(() {
        _pickedFiless = filePaths.map((path) => File(path)).toList();
      });
    }
  }

  Future<void> _saveFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> filePaths = _pickedFiless.map((file) => file.path).toList();
    await prefs.setStringList('dmbi_file_paths', filePaths); // Use different key
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _pickedFiless.add(File(result.files.single.path!));
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

      String downloadPath = '${directory.path}/DMBI_Files';

      // Create the directory if it doesn't exist
      await Directory(downloadPath).create(recursive: true);

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
      _pickedFiless.removeAt(index);
      _saveFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DMBI Files'),
      ),
      body: SingleChildScrollView(
        child: widget.userType == 'teacher'
            ? TeacherDMBI(
          pickedFiles: _pickedFiless,
          pickFile: _pickFiles,
          // downloadFile: _downloadFile,
          removeFile: _removeFile,
        )
            : StudentDMBI(
          pickedFiles: _pickedFiless,
          // pickFile: _pickFiles,
          // downloadFile: _downloadFile,
          // removeFile: _removeFile,
        ),
      ),
    );
  }
}
