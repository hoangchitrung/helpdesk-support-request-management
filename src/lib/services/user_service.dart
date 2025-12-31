import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/models/users.dart';

class UserService {
  Future<void> createUser(Users user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .set(user.toMap());
    } catch (e) {
      throw Exception("Error creating user: $e");
    }
  }

  Future<Users?> getUserById(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return Users.fromMap(
          snapshot.data() as Map<String, dynamic>,
          snapshot.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception("Error getting user: $e");
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception("Error deleting user: $e");
    }
  }
}
