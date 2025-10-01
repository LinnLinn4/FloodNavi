import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          mainAxisAlignment: MainAxisAlignment.center, // center vertically
          children: [
            Text(
              "River Mae Sai\n Mae Sai-Myanmar Bridge Station 1",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20), // space between widgets
            Placeholder(fallbackHeight: 150),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // rounded corners
                    ),
                    padding: EdgeInsets.all(10),
                    maximumSize: Size(100, 100),
                  ),

                  onPressed: () => {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // shrink to fit
                    children: const [
                      Icon(Icons.safety_check),
                      Text(
                        "Find the\nnearest SafeZone",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                Placeholder(fallbackWidth: 100, fallbackHeight: 100),
              ],
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Placeholder(fallbackWidth: 100, fallbackHeight: 100),
                SizedBox(width: 50),
                Placeholder(fallbackWidth: 100, fallbackHeight: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
