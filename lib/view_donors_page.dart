import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewDonorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Donors"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Blood Donors",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Fetch donors from Firebase Firestore in real-time
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('donors') // Fetch donors from Firestore
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No donors available."));
                  }

                  var donors = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: donors.length,
                    itemBuilder: (context, index) {
                      var donorData =
                          donors[index].data() as Map<String, dynamic>?;

                      return _buildDonorCard(donorData, context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a donor card
  Widget _buildDonorCard(
      Map<String, dynamic>? donorData, BuildContext context) {
    if (donorData == null) return SizedBox();

    String name = donorData['name'] ?? 'Unknown';
    String bloodType = donorData['blood_type'] ?? 'Unknown';
    String location = donorData['location'] ?? 'Unknown';
    String contact = donorData['contact'] ?? 'Not Provided';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 25,
          child: Text(
            bloodType,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12, // Reduce font size to fit inside the avatar
            ),
            textAlign: TextAlign.center,
          ),
        ),
        title: Text(name),
        subtitle: Text("Location: $location"),
        trailing: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Calling $contact...")),
            );
          },
          child: Text("Contact"),
        ),
      ),
    );
  }
}
