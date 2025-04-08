import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String fullName = "";
  String email = "";
  String contact = "";
  bool isLoading = true; // ✅ Show loader while fetching

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          fullName = userDoc['full_name'] ?? "";
          email = userDoc['email'] ?? "";
          contact = userDoc['contact'] ?? "";
          isLoading = false; // ✅ Stop loader after fetching
        });
      }
    }
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'full_name': fullName,
          'contact': contact,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile Updated!")),
        );
      }
    }
  }

  void _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account Deleted")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // ✅ Show loader
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: fullName,
                      decoration: InputDecoration(labelText: "Full Name"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter your name" : null,
                      onChanged: (value) => fullName = value,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: email,
                      decoration: InputDecoration(labelText: "Email"),
                      readOnly: true, // ✅ Email can't be edited
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: contact,
                      decoration: InputDecoration(labelText: "Contact"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter contact number" : null,
                      onChanged: (value) => contact = value,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text("Update Profile"),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: _deleteAccount,
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: Text("Delete Account"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
