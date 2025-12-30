import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:src/models/requests.dart';
import 'package:src/screens/admin/assign_request_screen.dart';
import 'package:src/screens/auth/login_screen.dart';
import 'package:src/services/request_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashboardScreen> {
  int totalRequest = 0;
  int totalInProgress = 0;
  int totalCompleted = 0;
  int currentIndex = 0;

  // status
  bool isLow = false;
  bool isMedium = false;
  bool isHigh = false;
  // priority
  bool isNewlyCreated = false;
  bool isInProgress = false;
  bool isCompleted = false;

  int inProgressCount = 0;
  int RequestCount = 0;
  int CompletedCount = 0;

  List<Requests> filteredRequests = [];
  Map<String, String> usernameCache = {};

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

  Future<void> _loadFilteredRequests() async {
    // Collect priorities được tick
    List<String> selectedPriorities = [];
    List<String> selectedStatus = [];
    List<Requests> filtered = [];

    if (isLow) {
      selectedPriorities.add('low');
    } else if (isMedium) {
      selectedPriorities.add('medium');
    } else if (isHigh) {
      selectedPriorities.add('high');
    } else if (isNewlyCreated) {
      selectedStatus.add('newly_created');
    } else if (isInProgress) {
      selectedStatus.add('in_progress');
    } else if (isCompleted) {
      selectedStatus.add('completed');
    }

    // Gọi service
    if (selectedPriorities.isNotEmpty) {
      filtered = await RequestService().loadRequestsByPriority(
        selectedPriorities,
      );
    } else {
      filtered = await RequestService().loadRequestsByStatus(selectedStatus);
    }

    setState(() {
      filteredRequests = filtered;
    });
  }

  Future<String> _getUsername(String userId) async {
    if (usernameCache.containsKey(userId)) {
      return usernameCache[userId]!;
    }
    try {
      String username = await RequestService().getUsernameById(userId);
      usernameCache[userId] = username;
      return username;
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  void initState() {
    super.initState();
    AppLifecycleListener(onResume: _loadStatistics);
    _loadStatistics();
    _loadFilteredRequests();
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isLow,
                        onChanged: (bool? value) {
                          setState(() {
                            isLow = value!;
                            _loadFilteredRequests();
                          });
                        },
                      ),
                      Text("Low"),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isMedium,
                        onChanged: (bool? value) {
                          setState(() {
                            isMedium = value!;
                            _loadFilteredRequests();
                          });
                        },
                      ),
                      Text("Medium"),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isHigh,
                        onChanged: (bool? value) {
                          setState(() {
                            isHigh = value!;
                            _loadFilteredRequests();
                          });
                        },
                      ),
                      Text("High"),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isNewlyCreated,
                        onChanged: (bool? value) {
                          setState(() {
                            isNewlyCreated = value!;
                            _loadFilteredRequests();
                          });
                        },
                      ),
                      Text("Newly Created"),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isInProgress,
                        onChanged: (bool? value) {
                          setState(() {
                            isInProgress = value!;
                            _loadFilteredRequests();
                          });
                        },
                      ),
                      Text("In Progress"),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isCompleted,
                        onChanged: (bool? value) {
                          setState(() {
                            isCompleted = value!;
                            _loadFilteredRequests();
                          });
                        },
                      ),
                      Text("Completed"),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: RequestService().loadAllRequests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<Requests> requests = filteredRequests.isNotEmpty
                      ? filteredRequests
                      : snapshot.data ?? [];

                  if (requests.isEmpty) {
                    return Text("No requests found");
                  }

                  // List<Requests> filter = snapshot.data!;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      Requests request = requests[index];
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
                            await _loadFilteredRequests();
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
                              subtitle: FutureBuilder<String>(
                                future: _getUsername(request.userId!),
                                builder: (context, snapshot) {
                                  String username = snapshot.data ?? 'Unknown';
                                  return Text(
                                    'Sent by: $username | Priority: ${request.priority.name}',
                                    style: TextStyle(fontSize: 12),
                                  );
                                },
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
