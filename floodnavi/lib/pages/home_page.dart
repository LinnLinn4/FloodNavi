import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
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
        decoration: const BoxDecoration(
          color: Colors.black,
          // image: DecorationImage(
          //   image: AssetImage("assets/images/background.jpg"),
          //   fit: BoxFit.cover,
          // ),
        ),

        child: Column(
          children: [
            Text(
              "River Mae Sai\n Mae Sai-Myanmar Bridge Station 1",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20), // space between widgets
            Placeholder(fallbackHeight: 200),
            SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.crisis_alert, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "High risk! Flood expected in your area.\nLast update: 10 mins ago",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Expanded(
                        child: _buildButton(
                          Icons.safety_check,
                          "Nearest SafeZone",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildButton(
                          Icons.insert_drive_file_rounded,
                          "Report Info",
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildButton(Icons.phone, "Emergency Contact"),
                      ),
                      SizedBox(width: 10),
                      Expanded(child: _buildButton(Icons.book, "Handbook")),
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

Widget _buildButton(IconData icon, String label) {
  return SizedBox(
    height: 120,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // rounded corners
        ),
        padding: EdgeInsets.all(10),
      ),

      onPressed: () => {},
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
