import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // lấy instance của firebase
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // hàm register
  Future<String> register(
    String username,
    String password,
    String email,
    String role,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Lấy uuid
      String uuid = userCredential.user!.uid;

      // lưu uuid vào firestore
      // dùng _firestore để tạo document
      /** Document  nên chứa username,email, role, password */
      await _firestore.collection('users').doc(uuid).set({
        'username': username,
        'password': password,
        'email': email,
        'role': role,
      });
      return "Register successful";
    } catch (e) {
      throw Exception("Error at register: $e");
    }
  }
}
