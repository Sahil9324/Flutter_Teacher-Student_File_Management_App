// registration_page.dart

import 'package:flutter/material.dart';
import 'package:my_app/teacher/TeacherSignIn.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';



class TeacherRegistrationPage extends StatefulWidget {
  @override
  _TeacherRegistrationPageState createState() => _TeacherRegistrationPageState();
}
//
// class _TeacherRegistrationPageState extends State<TeacherRegistrationPage> {
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   DatabaseHelper _databaseHelper = DatabaseHelper();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Teacher Sign Up'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () async {
//                 String username = _usernameController.text.trim();
//                 String email = _emailController.text.trim();
//                 String password = _passwordController.text.trim();
//
//                 if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
//                   bool userExists = await _databaseHelper.isUserExists(username);
//
//                   if (userExists) {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('Error'),
//                           content: Text('User with the username already exists.'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('OK'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   } else {
//                     Teacher teacher = Teacher(username: username, email: email, password: password);
//                     await _databaseHelper.insertTeacher(teacher);
//
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('Success'),
//                           content: Text('Teacher registration successful.'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 // Navigate to login page or any other page as needed
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => LoginPage()),
//                                 );
//                               },
//                               child: Text('OK'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Error'),
//                         content: Text('Username, Email, and Password cannot be empty.'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('OK'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//               child: Text('Register'),
//             ),
//               SizedBox(height: 16), // Add space between buttons
//               ElevatedButton(
//                 onPressed: () {
//                   // Action for the Another Button
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Already have an Account'),
//                         content: Text('Verify Creadintials'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                               // Navigate to login page or any other page as needed
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => LoginPage()),
//                               );
//                             },
//                             child: Text('OK'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Text('signin'),
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class DatabaseHelper {
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     print('Database path: ${await getDatabasesPath()}');
//
//     _database = await openDatabase(
//       join(await getDatabasesPath(), 'my_database.db'),
//       version: 1,
//       onCreate: (db, version) async {
//         // Handle initial database creation if needed
//       },
//       onUpgrade: (db, oldVersion, newVersion) async {
//         if (oldVersion < 2) {
//           // Handle migration from oldVersion to newVersion
//           await _createTeacherTable(db);
//         }
//       },
//       readOnly: false,
//     );
//
//     return _database!;
//   }
//
//   Future<void> _createTeacherTable(Database db) async {
//     await db.execute(
//       'CREATE TABLE IF NOT EXISTS teacher(id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT)',
//     );
//   }
//
//   Future<void> insertTeacher(Teacher teacher) async {
//     final Database db = await database;
//     await _createTeacherTable(db); // Ensure the table exists
//     await db.insert(
//       'teacher',
//       teacher.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<bool> isUserExists(String username) async {
//     final Database db = await database;
//
//     // Check if the 'teacher' table exists before querying
//     var tableExists = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='teacher'");
//     if (tableExists.isNotEmpty) {
//       final List<Map<String, dynamic>> result = await db.query(
//         'teacher',
//         where: 'username = ?',
//         whereArgs: [username],
//       );
//       return result.isNotEmpty;
//     }
//
//     return false;
//   }
// }
//
// class Teacher {
//   String username;
//   String email;
//   String password;
//
//   Teacher({required this.username, required this.email, required this.password});
//
//   Map<String, dynamic> toMap() {
//     return {'username': username, 'email': email, 'password': password};
//   }
// }


class _TeacherRegistrationPageState extends State<TeacherRegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Other code remains the same

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Sign Up'),
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

                try {
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // If registration successful, navigate to login page with user type
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } catch (e) {
                  // Handle registration errors
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to register: $e'),
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
          ],
        ),
      ),
    );
  }
}