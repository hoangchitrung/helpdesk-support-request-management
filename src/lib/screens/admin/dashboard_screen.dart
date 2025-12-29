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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStatistics();
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
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Total request:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$totalRequest",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "In Progress: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$totalInProgress",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Completed: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$totalCompleted",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                        value: isLow,
                        onChanged: (bool? value) {
                          setState(() {
                            isMedium = value!;
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
                        value: isLow,
                        onChanged: (bool? value) {
                          setState(() {
                            isHigh = value!;
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
                        value: isLow,
                        onChanged: (bool? value) {
                          setState(() {
                            isNewlyCreated = value!;
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
                        value: isLow,
                        onChanged: (bool? value) {
                          setState(() {
                            isInProgress = value!;
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
                        value: isLow,
                        onChanged: (bool? value) {
                          setState(() {
                            isCompleted = value!;
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

                  List<Requests> requests = snapshot.data!;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      Requests request = requests[index];
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(request.content),
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
