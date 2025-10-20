import 'package:flutter/material.dart';
import 'emergency_contact.dart'; // Import your emergency contact page

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "HOME",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No new notifications")),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Column(
          children: [
            const Text(
              "River Mae Sai\n Mae Sai-Myanmar Bridge Station 1",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // space between widgets
            const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: const [
                  Icon(Icons.crisis_alert, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "High risk! Flood expected in your area.\nLast update: 10 mins ago",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildButton(
                          Icons.safety_check,
                          "Nearest SafeZone",
                          () {
                            // Add navigation or action here
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildButton(
                          Icons.insert_drive_file_rounded,
                          "Report Info",
                          () {
                            // Add navigation or action here
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildButton(
                          Icons.phone,
                          "Emergency Contact",
                          () {
                            // Navigate to EmergencyContactScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmergencyContactScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildButton(Icons.book, "Handbook", () {
                          // Add navigation or action here
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
  return SizedBox(
    height: 120,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // rounded corners
        ),
        padding: const EdgeInsets.all(10),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, size: 50),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
