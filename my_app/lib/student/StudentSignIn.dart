import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:my_app/Home.dart';

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5),

            // Display error message if any
            Text(
              errorMessage,
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),

            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),

            SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),

            SizedBox(height: 20), // Adding space between widgets
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text.trim();
                String password = passwordController.text.trim();

                if (username.isNotEmpty && password.isNotEmpty) {
                  Map<String, dynamic> loginResult =
                  await _performLogin(username, password);

                  if (loginResult['success']) {
                    // Check if userType is not null
                    if (loginResult['userType'] != null) {
                      // Navigate to home page with user type
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(userType: loginResult['userType']),
                        ),
                      );
                    } else {
                      // Handle case when userType is null
                      setState(() {
                        errorMessage = 'User type not specified.';
                      });
                    }
                  } else {
                    setState(() {
                      errorMessage = 'Invalid username or password.';
                    });
                  }
                } else {
                  setState(() {
                    errorMessage = 'Username and password cannot be empty.';
                  });
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _performLogin(
      String username, String password) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    bool credentialsMatch =
    await databaseHelper.checkStudentCredentials(username, password);

    if (credentialsMatch) {
      // Return userType along with success status
      return {'success': true, 'userType': 'student'};
    } else {
      return {'success': false};
    }
  }
}

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      version: 1,
      readOnly: false,
    );

    return _database!;
  }

  Future<bool> checkStudentCredentials(
      String username, String password) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'student',
      columns: ['id'],
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }
}
