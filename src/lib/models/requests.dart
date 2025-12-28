import 'package:cloud_firestore/cloud_firestore.dart';

enum Status { newly_created, inProgress, completed }

enum Priority { low, medium, high }

class Requests {
  String? id; // Document ID từ firestore
  String? userId; // UID của user khi tạo request.
  String? staffId; // UID của staff (có thể null khi chưa assign)
  String content;
  Status status;
  Priority priority;
  DateTime submissionTime;

  Requests({
    this.id,
    required this.userId,
    this.staffId,
    required this.content,
    required this.status,
    required this.priority,
    required this.submissionTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'staffId': staffId,
      'content': content,
      'status': status.name,
      'priority': priority.name,
      'submissionTime': submissionTime,
    };
  }

  factory Requests.fromMap(Map<String, dynamic> map, String id) {
    return Requests(
      id: id,
      userId: map['userId'],
      staffId: map['staffId'],
      content: map['content'],
      status: Status.values.firstWhere(
        (status) => status.name == map['status'],
      ),
      priority: Priority.values.firstWhere(
        (priority) => priority.name == map['priority'],
      ),
      submissionTime: (map['submissionTime'] as Timestamp).toDate(),
    );
  }
}
