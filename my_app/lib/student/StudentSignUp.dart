// registration_page.dart
// student_registration_page.dart

import 'package:flutter/material.dart';
import 'package:my_app/student/StudentSignIn.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StudentRegistrationPage extends StatefulWidget {
  @override
  _StudentRegistrationPageState createState() => _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text.trim();
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();

                if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                  bool userExists = await _databaseHelper.isStudentExists(username);

                  if (userExists) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Student with the username already exists.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Student student = Student(username: username, email: email, password: password);
                    await _databaseHelper.insertStudent(student);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: Text('Student registration successful.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Navigate to login page or any other page as needed
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => StudentLoginPage()),
                                );
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Username, Email, and Password cannot be empty.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                // Action for the Another Button
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Already have an Account'),
                      content: Text('Verify Creadintials'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Navigate to login page or any other page as needed
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StudentLoginPage()),
                            );
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('signin'),

            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    print('Database path: ${await getDatabasesPath()}');

    _database = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      version: 1,
      onCreate: (db, version) async {
        // Handle initial database creation if needed
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Handle migration from oldVersion to newVersion
          await _createStudentTable(db);
        }
      },
      readOnly: false,
    );

    return _database!;
  }

  Future<void> _createStudentTable(Database db) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS student(id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT)',
    );
  }

  Future<void> insertStudent(Student student) async {
    final Database db = await database;
    await _createStudentTable(db); // Ensure the table exists
    await db.insert(
      'student',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isStudentExists(String username) async {
    final Database db = await database;

    // Check if the 'student' table exists before querying
    var tableExists = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='student'");
    if (tableExists.isNotEmpty) {
      final List<Map<String, dynamic>> result = await db.query(
        'student',
        where: 'username = ?',
        whereArgs: [username],
      );
      return result.isNotEmpty;
    }

    return false;
  }
}

class Student {
  String username;
  String email;
  String password;

  Student({required this.username, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'username': username, 'email': email, 'password': password};
  }
}
