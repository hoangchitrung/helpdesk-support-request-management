import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:src/models/requests.dart';

class RequestService {
  Future<String> createRequests(String content, Priority priority) async {
    try {
      // lấy userId từ currentUser
      String userId = FirebaseAuth.instance.currentUser!.uid;
      // tạo object request mới
      Requests newRequest = Requests(
        userId: userId,
        content: content,
        status: Status.newly_created,
        priority: priority,
        submissionTime: DateTime.now(),
      );

      // Convert sang map
      Map<String, dynamic> data = newRequest.toMap();

      // Add vào firestore collection 'requests'
      await FirebaseFirestore.instance.collection('requests').add(data);

      return "Requests created successfully";
    } catch (e) {
      throw Exception("Error at create request: $e");
    }
  }

  Future<List<Requests>> loadAllRequests() async {
    // lấy tất cả danh sách từ firebase về
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .get();
    List<Requests> requests = snapshot.docs.map((doc) {
      return Requests.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    return requests;
  }

  // delete request
  Future<void> deleteRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .delete();
    } catch (e) {
      throw Exception("$e");
    }
  }

  // load user requests
  Future<List<Requests>> loadUserRequest() async {
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

  Future<List<Requests>> loadRequestsByPriority(List<String> priority) async {
    // lấy những quest nào thực hiện
    List<Requests> allRequests = await loadAllRequests();

    if (priority.isEmpty) {
      return loadAllRequests();
    }

    return allRequests
        .where((request) => priority.contains(request.priority.name))
        .toList();
  }

  Future<List<Requests>> loadRequestsByStatus(List<String> status) async {
    // lấy những quest nào thực hiện
    List<Requests> allRequests = await loadAllRequests();

    if (status.isEmpty) {
      return loadAllRequests();
    }

    return allRequests
        .where((request) => status.contains(request.status.name))
        .toList();
  }

  Future<int> getInProgressRequests() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'in_progress')
        .get();
    return snapshot.docs.length;
  }

  Future<int> getRequests() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .get();
    return snapshot.docs.length;
  }

  Future<int> getCompletedRequests() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'completed')
        .get();
    return snapshot.docs.length;
  }
}
