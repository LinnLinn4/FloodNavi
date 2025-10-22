import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                'lib/assets/Stewie.jpg',
              ), // Make sure this matches your file!
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 10),
            const Text(
              "NS",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            const Text(
              "nsjerry@gmail.com",
              style: TextStyle(color: Color.fromARGB(255, 104, 104, 104)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(130, 38),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.black87),
              title: const Text('Downloads'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.black87),
              title: const Text('Language'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.black87),
              title: const Text('Location'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.black87),
              title: const Text('Share with Friends'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.star_rate, color: Colors.orange),
              title: const Text('Rate Our App'),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out'),
              onTap: () {},
            ),
            const SizedBox(height: 8),
            const Text(
              'App version 0.03',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
      // Add your bottom navigation bar here if it's part of the main scaffold
    );
  }
}
