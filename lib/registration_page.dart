import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _dobController =
      TextEditingController(); // ✅ DOB Controller

  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'A+';
  bool _isDonor = false;
  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "full_name": _nameController.text.trim(),
        "gender": _selectedGender,
        "dob": _dobController.text.trim(),
        "address": _addressController.text.trim(),
        "blood_group": _selectedBloodGroup,
        "contact": _contactController.text.trim(),
        "email": _emailController.text.trim(),
        "is_donor": _isDonor,
        "uid": userCredential.user!.uid,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed. Please try again.";

      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already registered.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password should be at least 6 characters.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Color(0xFFB71C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.app_registration, color: Colors.white, size: 80),
                    SizedBox(height: 30),
                    Text(
                      'Create Account',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                        _nameController, 'Full Name', 'Enter your full name'),
                    SizedBox(height: 20),

                    // ✅ Gender Dropdown
                    _buildDropdownField(
                      label: 'Gender',
                      value: _selectedGender,
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (value) =>
                          setState(() => _selectedGender = value!),
                    ),
                    SizedBox(height: 20),

                    _buildTextField(
                        _addressController, 'Address', 'Enter your address'),
                    SizedBox(height: 20),

                    // ✅ Date of Birth Field (Manual Entry with Grey Placeholder)
                    _buildTextField(
                        _dobController, 'Date of Birth', 'DD/MM/YYYY',
                        keyboardType: TextInputType.datetime),
                    SizedBox(height: 20),

                    // ✅ Blood Group Dropdown
                    _buildDropdownField(
                      label: 'Blood Group',
                      value: _selectedBloodGroup,
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                      onChanged: (value) =>
                          setState(() => _selectedBloodGroup = value!),
                    ),
                    SizedBox(height: 20),

                    _buildTextField(_contactController, 'Contact No.',
                        'Enter your contact number',
                        keyboardType: TextInputType.phone),
                    SizedBox(height: 20),
                    _buildTextField(
                        _emailController, 'Email Address', 'Enter your email',
                        keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 20),
                    _buildTextField(
                        _passwordController, 'Password', 'Enter your password',
                        obscureText: true),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _isDonor,
                          onChanged: (newValue) {
                            setState(() {
                              _isDonor = newValue!;
                            });
                          },
                        ),
                        Text('Be a donor',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 30),
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 50.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Text('Create Account',
                                style: TextStyle(fontSize: 18)),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your $label";
        }
        if (label == 'Date of Birth' &&
            !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
          return "Enter DOB in format DD/MM/YYYY";
        }
        return null;
      },
    );
  }

  // ✅ Fixed `_buildDropdownField` Method
  Widget _buildDropdownField(
      {required String label,
      required String value,
      required List<String> items,
      required Function(String?) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.white),
        ),
        dropdownColor: Colors.redAccent,
        items: items
            .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: TextStyle(color: Colors.white))))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
