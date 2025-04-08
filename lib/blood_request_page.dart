import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequestPage extends StatefulWidget {
  @override
  _BloodRequestPageState createState() => _BloodRequestPageState();
}

class _BloodRequestPageState extends State<BloodRequestPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  String _selectedBloodGroup = 'A+'; // Default blood group
  String _selectedUrgency = 'Urgent'; // Default urgency

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Blood'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(Icons.bloodtype, size: 80, color: Colors.red),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Request Blood for a Patient',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),

                // Patient Name Field
                buildStyledTextField(_nameController, 'Patient Name',
                    'Enter patient’s full name'),

                SizedBox(height: 15),

                // Blood Group Dropdown
                buildDropdownField(
                  'Blood Group',
                  _selectedBloodGroup,
                  ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                  (value) => setState(() => _selectedBloodGroup = value!),
                ),

                SizedBox(height: 15),

                // Urgency Level Dropdown
                buildDropdownField(
                  'Urgency Level',
                  _selectedUrgency,
                  ['Urgent', 'Within 24 hrs', 'Within 2 days'],
                  (value) => setState(() => _selectedUrgency = value!),
                ),

                SizedBox(height: 15),

                // Hospital Name Field
                buildStyledTextField(_hospitalController, 'Hospital Name',
                    'Enter hospital name'),

                SizedBox(height: 15),

                // Contact Number Field
                buildStyledTextField(_contactController, 'Contact Number',
                    'Enter contact number',
                    keyboardType: TextInputType.phone),

                SizedBox(height: 30),

                // Request Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitBloodRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 50.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Request Blood',
                      style: TextStyle(fontSize: 18),
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

  // Function to create a text field
  Widget buildStyledTextField(
      TextEditingController controller, String labelText, String hintText,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $labelText";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }

  // Function to create a dropdown field
  Widget buildDropdownField(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  // Function to Submit Blood Request
  void _submitBloodRequest() async {
    if (!_formKey.currentState!.validate()) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('blood_requests').add({
      'patient_name': _nameController.text,
      'blood_group': _selectedBloodGroup,
      'hospital_name': _hospitalController.text,
      'contact': _contactController.text,
      'urgency': _selectedUrgency, // ✅ Now stored in Firebase
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Blood request submitted successfully!")),
    );
  }
}
