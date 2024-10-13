import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitnessRegistrationScreen extends StatefulWidget {
  FitnessRegistrationScreen({super.key});

  @override
  _FitnessRegistrationScreenState createState() =>
      _FitnessRegistrationScreenState();
}

class _FitnessRegistrationScreenState extends State<FitnessRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  bool _termsAccepted = false;

  void _validateAndSave() async {
    // Check if all fields are filled
    if (_nameController.text.isEmpty) {
      _showSnackBar('Please fill in your name.');
      return;
    }
    if (_emailController.text.isEmpty) {
      _showSnackBar('Please fill in your email.');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Please fill in your password.');
      return;
    }
    if (_retypePasswordController.text.isEmpty) {
      _showSnackBar('Please retype your password.');
      return;
    }
    if (!_termsAccepted) {
      _showSnackBar('Please accept the terms & conditions.');
      return;
    }

    // Proceed to save user data if validation is successful
    await _saveUserData(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button
          onPressed: () {
            // Navigate back to the Login Page
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align the column
              children: [
                // Centering the registration title
                Center(
                  child: Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Welcome back! Please enter your details.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center, // Center the text
                  ),
                ),
                SizedBox(height: 32),

                // Google Sign Up Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Google Sign Up
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center align the row
                      children: [
                        Image.asset(
                          'images/google_icon.png', // Adjust the path as necessary
                          height: 24, // Set height as needed
                          width: 24, // Set width as needed
                        ),
                        SizedBox(
                            width: 5), // Add spacing between the image and text
                        Text(
                          'Sign up with Google',
                          style: TextStyle(
                              color: Colors.black), // Ensure text is readable
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32),

                // Input fields
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Enter your name',
                  labelText: 'Name',
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _retypePasswordController,
                  hintText: 'Retype your password',
                  labelText: 'Retype Password',
                  obscureText: true,
                ),
                SizedBox(height: 16),

                // Terms and Conditions Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the row
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      activeColor: Colors
                          .green, // Set the checkbox color to green when checked
                      onChanged: (bool? value) {
                        setState(() {
                          _termsAccepted = value!; // Update the state
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I accepted all terms & conditions.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                // Sign Up Button with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed:
                        _validateAndSave, // Call validation method on press
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.black), // Set text color
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Set to transparent
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom TextField Builder
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
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // Save registration data to shared_preferences
  Future<void> _saveUserData(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if an email already exists
    String? existingEmail = prefs.getString('email');

    if (existingEmail == _emailController.text) {
      // Email already exists, show an error message
      _showSnackBar('This email is already registered!');
    } else {
      // Proceed to save the new email and password
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);

      _showSnackBar('Registration successful!');

      // Navigate to LoginPage after registration
      Navigator.pop(context);
    }
  }
}
