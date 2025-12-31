import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:src/models/requests.dart';
import 'dart:async';
import 'package:src/screens/admin/assign_request_screen.dart';
import 'package:src/screens/auth/login_screen.dart';
import 'package:src/services/request_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashboardScreen> {
  TextEditingController _searchController = TextEditingController();

  int totalRequest = 0;
  int totalInProgress = 0;
  int totalCompleted = 0;
  int currentIndex = 0;

  int inProgressCount = 0;
  int RequestCount = 0;
  int CompletedCount = 0;

  List<Requests> allRequests = [];
  List<Requests> filteredList = [];

  bool isLoadingAllRequests = true;

  // hàm logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _loadStatistics() async {
    inProgressCount = await RequestService().getInProgressRequests();
    RequestCount = await RequestService().getRequests();
    CompletedCount = await RequestService().getCompletedRequests();

    setState(() {
      totalRequest = RequestCount;
      totalInProgress = inProgressCount;
      totalCompleted = CompletedCount;
    });
  }

  void _onSearchChanged(String searchQuery) {
    // remove the unnecessary space of the search query and lowercase
    String query = searchQuery.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredList = allRequests;
      } else if (query == 'low' || query == 'medium' || query == 'high') {
        filteredList = allRequests.where((r) {
          return r.priority.name.toLowerCase().contains(query);
        }).toList();
      } else {
        filteredList = allRequests.where((r) {
          return r.content.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadStatistics();
    _loadAllRequests();
  }

  Future<void> _loadAllRequests() async {
    setState(() {
      isLoadingAllRequests = true;
    });
    try {
      List<Requests> list = await RequestService().loadAllRequests();
      setState(() {
        allRequests = list;
        filteredList = allRequests;
      });
    } catch (e) {
      setState(() {
        allRequests = [];
      });
      throw Exception(e);
    } finally {
      setState(() {
        isLoadingAllRequests = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Dashboard",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: _logout,
              child: Icon(Icons.logout_outlined, color: Colors.black, size: 30),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: [
                Card(
                  color: Colors.blue[100],
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment,
                            size: 26,
                            color: Colors.blue[800],
                          ),
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$totalRequest",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.amber[100],
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_bottom,
                            size: 26,
                            color: Colors.amber[800],
                          ),
                          Text(
                            "In Progress",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$totalInProgress",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.green[100],
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 26,
                            color: Colors.green[800],
                          ),
                          Text(
                            "Completed",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$totalCompleted",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Search input (auto-search by content)
            // Text Field
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search_outlined),
                labelText: "Searching...",
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: isLoadingAllRequests
                  ? Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                  ? Text("No requests found")
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        Requests request = filteredList[index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AssignRequestScreen(request: request);
                                },
                              ),
                            );

                            // Nếu AssignRequestScreen trả về true => có thay đổi, reload data
                            if (result == true) {
                              await _loadStatistics();
                              await _loadAllRequests();
                            }
                          },
                          child: Card(
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
                                subtitle: Text.rich(
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
                                trailing: Text(
                                  "${request.submissionTime.day}/${request.submissionTime.month}/${request.submissionTime.year}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Manage'),
        ],
      ),
    );
  }
}
