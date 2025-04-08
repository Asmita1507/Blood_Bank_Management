import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    String fullName = _nameController.text.trim();
    String dob = _dobController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    // Fetch user based on Full Name & DOB
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('full_name', isEqualTo: fullName)
        .where('dob', isEqualTo: dob)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String userId = snapshot.docs.first.id;

      await _firestore.collection('users').doc(userId).update({
        'password': newPassword,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset successful!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User not found! Please check details."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Reset Password"), backgroundColor: Colors.red),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, "Full Name"),
              SizedBox(height: 15),
              _buildTextField(_dobController, "Date of Birth (DD/MM/YYYY)"),
              SizedBox(height: 15),
              _buildTextField(_newPasswordController, "New Password",
                  obscureText: true),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Reset Password",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? "Enter $hint" : null,
    );
  }
}
