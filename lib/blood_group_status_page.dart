import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodGroupStatsPage extends StatefulWidget {
  @override
  _BloodGroupStatsPageState createState() => _BloodGroupStatsPageState();
}

class _BloodGroupStatsPageState extends State<BloodGroupStatsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, int> donorCount = {};
  Map<String, int> receiverCount = {};

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  @override
  void initState() {
    super.initState();
    _fetchBloodStats();
  }

  Future<void> _fetchBloodStats() async {
    for (String bloodType in bloodGroups) {
      // Count donors for each blood type
      QuerySnapshot donorSnapshot = await _firestore
          .collection('donors')
          .where('blood_type', isEqualTo: bloodType)
          .get();

      // Count receivers for each blood type
      QuerySnapshot receiverSnapshot = await _firestore
          .collection('blood_requests')
          .where('blood_group', isEqualTo: bloodType)
          .get();

      setState(() {
        donorCount[bloodType] = donorSnapshot.size;
        receiverCount[bloodType] = receiverSnapshot.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blood Group Status")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Blood Group Status",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Displaying Stats in ListView
            Expanded(
              child: ListView.builder(
                itemCount: bloodGroups.length,
                itemBuilder: (context, index) {
                  String bloodType = bloodGroups[index];
                  int donors = donorCount[bloodType] ?? 0;
                  int receivers = receiverCount[bloodType] ?? 0;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(
                          bloodType,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text("Blood Group: $bloodType"),
                      subtitle: Text(
                          "🩸 Donors: $donors   |   🚑 Receivers: $receivers"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
