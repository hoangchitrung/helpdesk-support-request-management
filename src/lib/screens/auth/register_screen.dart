import 'package:flutter/material.dart';
import 'package:src/screens/auth/login_screen.dart';
import 'package:src/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameInputController =
      TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();
  final TextEditingController _emailInputController = TextEditingController();

  // loading state
  bool isLoading = false;

  // show/hide password
  bool _obsecurePassword = true;

  Future<void> _register() async {
    setState(() => isLoading = true);
    // kiểm tra input trước khi ấn đăng nhập.
    if (!_validateInput()) {
      return;
    }

    // lấy giá trị từ phần nhập
    String username = _usernameInputController.text;
    String email = _emailInputController.text;
    String password = _passwordInputController.text;

    try {
      final result = await AuthService().register(username, password, email);

      if (result == "Register successful") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Register successful"),
          ),
        );
        await Future.delayed(Duration(seconds: 3));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error at register: $e"),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _validateInput() {
    // lấy giá trị từ TextEditingController
    String username = _usernameInputController.text;
    String email = _emailInputController.text;
    String password = _passwordInputController.text;

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter a username")));
      setState(() => isLoading = false);
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a password and at least 6 length"),
        ),
      );
      setState(() => isLoading = false);
      return false;
    }

    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter an email and make sure it correct format",
          ),
        ),
      );
      setState(() => isLoading = false);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          "Register Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameInputController,
              decoration: InputDecoration(
                label: Text("Username", style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailInputController,
              decoration: InputDecoration(
                label: Text("Email", style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordInputController,
              obscureText: _obsecurePassword,
              decoration: InputDecoration(
                label: Text("Password", style: TextStyle(fontSize: 20)),
                suffixIcon: IconButton(
                  icon: _obsecurePassword
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obsecurePassword = !_obsecurePassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Login Here",
                    style: TextStyle(fontSize: 18, color: Colors.blue[400]),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: isLoading ? null : _register,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text("Register", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
