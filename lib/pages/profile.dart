import 'package:flutter/material.dart';

class Profile_page extends StatelessWidget {
  const Profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            ListTile(
              title: Text(
                  'Developer' ,style: TextStyle(fontWeight: FontWeight.bold),), // Display developer info
              subtitle: Text(
                  'Dipak Singh Thagunna'), // Display address below
            ),
            ListTile(
              title: Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ), // Display developer info
              subtitle: Text('Sudurpaschim, Kanchanpur'), // Display address below
            ),
            ListTile(
              title: Text(
                'Contact',
                style: TextStyle(fontWeight: FontWeight.bold),
              ), // Display developer info
              subtitle: Text('9841419315'), // Display address below
            ),
            ListTile(
              title: Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ), // Display developer info
              subtitle: Text('dipakst999@gmail.com'), // Display address below
            ),
            
          ],
        ),
      ),


    );
  }
}
