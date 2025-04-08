import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonateBloodPage extends StatefulWidget {
  @override
  _DonateBloodPageState createState() => _DonateBloodPageState();
}

class _DonateBloodPageState extends State<DonateBloodPage> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String age = "";
  String bloodType = "A+";
  String location = "";
  String contact = "";

  // List of Blood Groups
  final List<String> bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extends the body behind AppBar
      appBar: AppBar(
        title: Text("Donate Blood"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.redAccent,
              Colors.pinkAccent
            ], // Gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Register as a Blood Donor",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 20),

                      _buildTextField("Full Name", Icons.person, (value) {
                        name = value;
                      }, "Please enter your name"),
                      SizedBox(height: 12),

                      _buildTextField("Age", Icons.calendar_today, (value) {
                        age = value;
                      }, "Please enter your age",
                          keyboardType: TextInputType.number),
                      SizedBox(height: 12),

                      _buildDropdownField(),
                      SizedBox(height: 12),

                      _buildTextField("Location", Icons.location_on, (value) {
                        location = value;
                      }, "Please enter your location"),
                      SizedBox(height: 12),

                      _buildTextField("Contact Number", Icons.phone, (value) {
                        contact = value;
                      }, "Please enter a valid 10-digit contact number",
                          keyboardType: TextInputType.phone),
                      SizedBox(height: 20),

                      // Submit Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                          onPressed:
                              _submitDonorDetails, // ✅ Calls Firebase function
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Text Field with Icon
  Widget _buildTextField(String label, IconData icon,
      Function(String) onChanged, String validationMessage,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
      onChanged: (value) => onChanged(value),
    );
  }

  // Dropdown Field for Blood Type
  Widget _buildDropdownField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: "Blood Type",
        prefixIcon: Icon(Icons.bloodtype, color: Colors.red),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      value: bloodType,
      items: bloodGroups.map((group) {
        return DropdownMenuItem(
          value: group,
          child: Text(group),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          bloodType = value.toString();
        });
      },
    );
  }

  // ✅ Function to Store Donor Details in Firebase
  void _submitDonorDetails() async {
    if (!_formKey.currentState!.validate()) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to submit donor details.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('donors').add({
        'name': name,
        'age': age,
        'blood_type': bloodType,
        'location': location,
        'contact': contact,
        'donor_id': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Donor registered successfully!")),
      );

      // Clear form fields after submission
      setState(() {
        name = "";
        age = "";
        location = "";
        contact = "";
        bloodType = "A+"; // Reset blood group
      });
    } catch (e) {
      print("Error storing donor details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting donor details. Try again.")),
      );
    }
  }
}
