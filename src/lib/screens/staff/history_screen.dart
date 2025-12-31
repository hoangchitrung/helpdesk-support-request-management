import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:src/models/requests.dart';
import 'package:src/screens/auth/login_screen.dart';
import 'package:src/services/request_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryScreen> {
  String staffId = FirebaseAuth.instance.currentUser!.uid;
  late Future<List<Requests>> _futureRequests = RequestService()
      .getCompletedRequestsByStaffId(staffId);

  // hàm logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    // _futureRequests đã được khởi tạo trong khai báo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "History Screen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Placeholder for list of completed requests
            Expanded(
              child: FutureBuilder(
                future: _futureRequests,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No completed requests');
                  }
                  List<Requests> requests = snapshot.data!;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      Requests request = requests[index];
                      return Card(
                        color: request.priority.name == "low"
                            ? Colors.blue[50]
                            : request.priority.name == "medium"
                            ? Colors.amber[50]
                            : Colors.red[50],
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: ListTile(
                            leading: Icon(
                              request.priority.name == "low"
                                  ? Icons.trending_down
                                  : request.priority.name == "medium"
                                  ? Icons.trending_flat
                                  : Icons.trending_up,
                              color: request.priority.name == "low"
                                  ? Colors.blue[800]
                                  : request.priority.name == "medium"
                                  ? Colors.amber[800]
                                  : Colors.red[800],
                              size: 30,
                            ),
                            title: Text(
                              request.content,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Priority: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: request.priority.name,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Last changes: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: request.submissionTime.toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ),
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
    );
  }
}
