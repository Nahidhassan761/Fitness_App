import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forget Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your registered email',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              Text(
                'Enter your new password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _newPasswordController,
                hintText: 'Enter new password',
                labelText: 'New Password',
                obscureText: true,
              ),
              SizedBox(height: 16),
              Text(
                'Retype your new password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _retypePasswordController,
                hintText: 'Retype new password',
                labelText: 'Retype Password',
                obscureText: true,
              ),
              SizedBox(height: 32),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _resetPassword(context);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.black), // Set text color to black
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor:
                          Colors.transparent, // Set primary to transparent
                      shadowColor: Colors.transparent, // Remove shadow
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  // Reset password logic
  Future<void> _resetPassword(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? registeredEmail = prefs.getString('email');

    if (registeredEmail == _emailController.text) {
      // Check if new passwords match
      if (_newPasswordController.text.isEmpty ||
          _retypePasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields!')),
        );
        return;
      }
      if (_newPasswordController.text != _retypePasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }

      // Save the new password
      await prefs.setString('password', _newPasswordController.text);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successful!')),
      );

      // Optionally navigate back to the login screen
      Navigator.pop(context);
    } else {
      // Email not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email not registered!')),
      );
    }
  }
}
