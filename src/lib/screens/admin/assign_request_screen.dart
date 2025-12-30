import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:src/models/requests.dart';
import 'package:src/models/users.dart';
import 'package:src/services/request_service.dart';

class AssignRequestScreen extends StatefulWidget {
  final Requests request;
  const AssignRequestScreen({super.key, required this.request});

  @override
  State<StatefulWidget> createState() => _AssignRequestState();
}

class _AssignRequestState extends State<AssignRequestScreen> {
  Map<String, String> usernameCache = {};

  List<Users> staffList = [];
  String? selectedStaffId;
  String currentStaffName = '';

  Future<String> _getUsername(String userId) async {
    if (usernameCache.containsKey(usernameCache[userId])) {}
    try {
      String username = await RequestService().getUsernameById(userId);
      usernameCache[userId] = username;
      return username;
    } catch (e) {
      return "Unknown";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStaffList();
    _loadCurrentStaff();
  }

  Future<void> _loadStaffList() async {
    List<Users> staff = await RequestService().getStaffList();
    setState(() {
      staffList = staff;
    });
  }

  Future<void> _loadCurrentStaff() async {
    if (widget.request.staffId != null && widget.request.staffId!.isNotEmpty) {
      try {
        String name = await RequestService().getUsernameById(
          widget.request.staffId!,
        );
        setState(() {
          currentStaffName = name;
        });
      } catch (e) {
        setState(() {
          currentStaffName = 'Unknown';
        });
      }
    } else {
      setState(() {
        currentStaffName = 'Not assigned';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign Staff"),
        backgroundColor: Colors.blue[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: _getUsername(widget.request.userId!),
                  builder: (context, snapshot) {
                    String username = snapshot.data ?? 'Loading...';
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Username: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: username,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Content: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.request.content,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Priority: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.request.priority.name,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Status: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.request.status.name,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Date: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "${widget.request.submissionTime.day}/${widget.request.submissionTime.month}/${widget.request.submissionTime.year}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Assigned to: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: currentStaffName,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Select New Staff: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedStaffId,
                  items: staffList.map((staff) {
                    return DropdownMenuItem(
                      value: staff.userId,
                      child: Text(staff.username),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStaffId = value;
                    });
                  },
                  hint: Text("Select Staff"),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedStaffId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a staff")),
                  );
                  return;
                }

                try {
                  await RequestService().updateRequestStatus(
                    widget.request.id!,
                    selectedStaffId!,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Staff assigned successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Quay lại Dashboard để refresh (trả về true như dấu hiệu có thay đổi)
                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text("Assign", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
