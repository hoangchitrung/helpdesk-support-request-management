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
}
