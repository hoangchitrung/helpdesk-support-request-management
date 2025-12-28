import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.blue[400],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // User Info
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "User Info:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      CircleAvatar(radius: 30, child: Icon(Icons.person)),
                      SizedBox(width: 20),
                      Text("Hoàng Chí Trung", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              // Statistic Requests
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Statistics Requests:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total Requests: 11",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.assessment, color: Colors.blue[800]),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Completed Requests: 6 / 11",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.check, color: Colors.green[300]),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "In Progress: 5 / 11",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.warning, color: Colors.yellow[800]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Column(
              children: [
                Text(
                  "Recent Requests",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
