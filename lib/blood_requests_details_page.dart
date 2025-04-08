import 'package:flutter/material.dart';

class BloodRequestDetailsPage extends StatelessWidget {
  final Map<String, dynamic> requestData;

  BloodRequestDetailsPage({required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Blood Group: ${requestData['blood_group'] ?? 'Unknown'}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Hospital: ${requestData['hospital_name'] ?? 'Not Specified'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Urgency: ${requestData['urgency'] ?? 'Not Specified'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                "Contact Name: ${requestData['patient_name'] ?? 'Not Available'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Contact Number: ${requestData['contact'] ?? 'Not Available'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                "Additional Notes: ${requestData['notes'] ?? 'No additional information'}",
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
