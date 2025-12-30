import 'package:flutter/material.dart';
import 'package:src/models/requests.dart';
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

  // status
  bool isLow = false;
  bool isMedium = false;
  bool isHigh = false;
  // priority
  bool isNewlyCreated = false;
  bool isInProgress = false;
  bool isCompleted = false;

  List<Requests> filteredRequests = [];

  Future<void> _loadStatistics() async {
    int inProgressCount = await RequestService().getInProgressRequests();
    int RequestCount = await RequestService().getRequests();
    int CompletedCount = await RequestService().getCompletedRequests();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStatistics();
    _loadFilteredRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                Card(
                  color: Colors.blue[100],
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment,
                            size: 40,
                            color: Colors.blue[800],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Total request:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "$totalRequest",
                            style: TextStyle(
                              fontSize: 28,
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
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_bottom,
                            size: 40,
                            color: Colors.amber[800],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "In Progress:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "$totalInProgress",
                            style: TextStyle(
                              fontSize: 28,
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
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 40,
                            color: Colors.green[800],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Completed:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "$totalCompleted",
                            style: TextStyle(
                              fontSize: 28,
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
                            subtitle: Text(
                              "Priority: ${request.priority.name} | Status: ${request.status.name}",
                              style: TextStyle(fontSize: 13),
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
