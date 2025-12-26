import 'package:flutter/material.dart';
import 'package:src/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailInputController =
      TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  @override
  void dispose() {
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailInputController,
              decoration: InputDecoration(
                label: Text("Email", style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordInputController,
              decoration: InputDecoration(
                label: Text("Password", style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have account?", style: TextStyle(fontSize: 18)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    "Click here",
                    style: TextStyle(fontSize: 18, color: Colors.blue[700]),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Login", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
