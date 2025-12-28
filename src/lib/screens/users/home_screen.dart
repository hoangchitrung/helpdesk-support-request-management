import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:src/models/requests.dart';
import 'package:src/screens/auth/login_screen.dart';
import 'package:src/screens/users/add_request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "Loading...";

  // hàm logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Get user info from firebase
  Future<void> _loadUserInfo() async {
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uuid)
        .get();
    setState(() {
      username = doc['username'];
    });
  }

  Future<List<Requests>> _loadUserRequest() async {
    // take current user uid
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Query firebase
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: userId)
        .get();

    // Convert mỗi document sang request object
    List<Requests> requests = snapshot.docs.map((doc) {
      return Requests.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    return requests;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserInfo();
    _loadUserRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.home, color: Colors.black, size: 30),
            TextButton(
              onPressed: _logout,
              child: Icon(Icons.logout_outlined, color: Colors.black, size: 30),
            ),
          ],
        ),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
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
                      Text("${username}", style: TextStyle(fontSize: 20)),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
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
                            "In Progress: 5 / 11",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.warning, color: Colors.yellow[800]),
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
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Text(
              "List of requests",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadUserRequest(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Error");
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No requests found');
                  }

                  List<Requests> requests = snapshot.data!;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      Requests request = requests[index];
                      return Card(
                        child: ListTile(
                          title: Text(request.content),
                          subtitle: Text("Priority: ${request.priority.name}"),
                          trailing: Text("Status: ${request.status.name}"),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddRequestScreen();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
