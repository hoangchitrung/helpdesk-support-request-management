import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:src/models/requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isFilterApplied = false;
  // search
  final TextEditingController _searchController = TextEditingController();
  bool isSearchActive = false;
  List<Requests> searchResults = [];
  List<Requests> allRequests = [];
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

  Future<void> _loadFilteredRequests() async {
    // Collect priorities được tick
    List<String> selectedPriorities = [];
    List<String> selectedStatus = [];
    List<Requests> filtered = [];
    // collect all selected priorities (allow multiple selections)
    if (isLow) selectedPriorities.add('low');
    if (isMedium) selectedPriorities.add('medium');
    if (isHigh) selectedPriorities.add('high');

    // collect all selected statuses
    if (isNewlyCreated) selectedStatus.add('newly_created');
    if (isInProgress) selectedStatus.add('in_progress');
    if (isCompleted) selectedStatus.add('completed');

    // Determine whether any filter is applied
    isFilterApplied =
        selectedPriorities.isNotEmpty || selectedStatus.isNotEmpty;

    // Call appropriate service
    if (selectedPriorities.isNotEmpty) {
      filtered = await RequestService().loadRequestsByPriority(
        selectedPriorities,
      );
    } else if (selectedStatus.isNotEmpty) {
      filtered = await RequestService().loadRequestsByStatus(selectedStatus);
    } else {
      // no filters -> clear filtered list
      filtered = [];
    }

    setState(() {
      filteredRequests = filtered;
    });

    // ensure usernames for filtered list
    await _ensureUsernamesFor(filtered);

    // If user has active search, reapply search on the new filtered set
    if (_searchController.text.trim().isNotEmpty) {
      await _onSearchChanged(_searchController.text.trim());
    }
  }

  Future<void> _onSearchChanged(String q) async {
    String query = q.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        isSearchActive = false;
        searchResults = [];
      });
      return;
    }

    // choose base list: if filters applied use filteredRequests, else allRequests
    List<Requests> base = isFilterApplied ? filteredRequests : allRequests;
    List<Requests> results = base
        .where((r) => r.content.toLowerCase().contains(query))
        .toList();
    // prefetch usernames for results
    await _ensureUsernamesFor(results);

    setState(() {
      isSearchActive = true;
      searchResults = results;
    });
  }

  // Ensure username cache contains usernames for given requests by batch fetching missing users
  Future<void> _ensureUsernamesFor(List<Requests> requests) async {
    final missing = requests
        .map((r) => r.userId)
        .where((id) => !usernameCache.containsKey(id))
        .toSet()
        .toList();

    if (missing.isEmpty) return;

    try {
      // Firestore whereIn supports up to 10 items per query; batch if necessary
      for (int i = 0; i < missing.length; i += 10) {
        final end = (i + 10 > missing.length) ? missing.length : i + 10;
        final batch = missing.sublist(i, end);
        final snap = await FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: batch)
            .get();
        for (var doc in snap.docs) {
          try {
            usernameCache[doc.id] = doc['username'] ?? 'Unknown';
          } catch (_) {
            usernameCache[doc.id] = 'Unknown';
          }
        }
      }
      setState(() {});
    } catch (_) {
      // ignore errors for username prefetch
    }
  }

  @override
  void initState() {
    super.initState();
    AppLifecycleListener(onResume: _loadStatistics);
    _loadStatistics();
    _loadFilteredRequests();
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
      });
      // prefetch usernames for the loaded requests
      await _ensureUsernamesFor(list);
    } catch (e) {
      setState(() {
        allRequests = [];
      });
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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search requests by content...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
              ),
              onChanged: (value) {
                _onSearchChanged(value);
              },
            ),
            SizedBox(height: 12),
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
              child: isLoadingAllRequests
                  ? Center(child: CircularProgressIndicator())
                  : Builder(
                      builder: (context) {
                        List<Requests> requests = isSearchActive
                            ? searchResults
                            : (isFilterApplied
                                  ? filteredRequests
                                  : allRequests);

                        if (requests.isEmpty) {
                          return Text("No requests found");
                        }

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
                                      return AssignRequestScreen(
                                        request: request,
                                      );
                                    },
                                  ),
                                );

                                // Nếu AssignRequestScreen trả về true => có thay đổi, reload data
                                if (result == true) {
                                  await _loadStatistics();
                                  await _loadFilteredRequests();
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
                                    subtitle: Text(
                                      'Sent by: ${usernameCache[request.userId] ?? 'Loading...'} | Priority: ${request.priority.name}',
                                      style: TextStyle(fontSize: 12),
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
