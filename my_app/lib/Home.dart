import 'package:flutter/material.dart';
import 'package:my_app/subject/AI-DS.dart';
import 'package:my_app/subject/DMBI.dart';
import 'package:my_app/subjectstudent/studentAI-DS.dart';

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Column(
//         children: [
//
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Welcome to My App!',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 InkWell(
//                   onTap: () {
//                     // Navigate to the next page when the box is clicked
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => AIDSHomePage()),
//                     );
//                   },
//                   child: Container(
//                     width: 350, // Set the desired width
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       'DMBI',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 InkWell(
//                   onTap: () {
//                     // Navigate to the next page when the box is clicked
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => DMBIHomePage()),
//                     );
//                   },
//                   child: Container(
//                     width: 350, // Set the desired width
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       'AI-DS-1',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Add more widgets or functionality as needed
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class MyHomePage extends StatelessWidget {
  final String userType;

  MyHomePage({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                userType == 'teacher'
                    ? 'Welcome, Teacher!'
                    : 'Welcome, Student!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                    children: [
                      _buildBrightBoxButton(context, 'AIDS', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AIDSHomePage(userType: userType)),
                        );
                      }),
                      _buildBrightBoxButton(context, 'DMBI', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DMBIHomePage(userType: userType)),
                        );
                      }),
                      _buildBrightBoxButton(context, 'Wireless Technology', () {
                        // Navigation for Wireless Technology
                      }),
                      _buildBrightBoxButton(context, 'Web X.0', () {
                        // Navigation for Web X.0
                      }),
                      _buildBrightBoxButton(context, 'Ethical Hacking', () {
                        // Navigation for Ethical Hacking
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrightBoxButton(BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.lightBlueAccent.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlue.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.lightBlue.shade300,
            width: 2,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.lightBlue.shade700,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}


// class TeacherContent extends StatelessWidget {
//   final String userType;
//
//   TeacherContent({required this.userType});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AIDSHomePage(userType: userType)),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(16),
//             margin: EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               'AIDS',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//         InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DMBIHomePage()),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(16),
//             margin: EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               'DMBI',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


//
// class StudentContent extends StatelessWidget {
//   final String userType;
//
//   StudentContent({required this.userType});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AIDSHomePage(userType: userType)),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(16),
//             margin: EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               'AIDS',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//         InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DMBIHomePage()),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.all(16),
//             margin: EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               'DMBI',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   final String userType;
//
//   MyHomePage({required this.userType});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               userType == 'teacher'
//                   ? 'You are logged in as a Teacher.'
//                   : 'You are logged in as a Student.',
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: userType != 'teacher'
//                   ? StudentAIDS(
//                 pickedFiles: [], // Pass empty list or null if needed
//                 pickFile: () {},
//                 downloadFile: (file) {},
//                 removeFile: (index) {},
//               )
//                   : AIDSHomePage(userType: userType),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
