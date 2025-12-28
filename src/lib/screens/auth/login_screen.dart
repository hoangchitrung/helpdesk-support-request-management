import 'package:flutter/material.dart';
import 'package:src/screens/auth/register_screen.dart';
import 'package:src/screens/users/home_screen.dart';
import 'package:src/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  // loading state
  bool isLoading = false;

  // hide/show password
  bool _obsecurePassword = true;

  bool _validInput() {
    // Lấy giá trị từ controller
    String email = _emailInputController.text;
    String password = _passwordInputController.text;

    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please enter your email correctly"),
        ),
      );
      setState(() => isLoading = false);
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please enter your password correctly"),
        ),
      );
      setState(() => isLoading = false);
      return false;
    }
    return true;
  }

  Future<void> _login() async {
    setState(() => isLoading = true);

    if (!_validInput()) {
      return;
    }

    String email = _emailInputController.text;
    String password = _passwordInputController.text;

    try {
      final result = await AuthService().login(email, password);

      if (result == "Login successful") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Login successful"),
          ),
        );
        await Future.delayed(
          Duration(seconds: 3),
        ); // delay 3 giây trước khi redirect

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error at login: $e"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

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
              obscureText: _obsecurePassword,
              decoration: InputDecoration(
                label: Text("Password", style: TextStyle(fontSize: 20)),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obsecurePassword = !_obsecurePassword;
                    });
                  },
                  icon: _obsecurePassword
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                ),
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
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text("Login", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
