import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'blood_request_page.dart';
import 'donate_blood_page.dart';
import 'view_donors_page.dart';
import 'profile_page.dart'; // ✅ Profile Page
import 'blood_group_status_page.dart'; // ✅ Blood Group Status Page
import 'blood_request_details_page.dart'; // ✅ Blood Request Details Page

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userName = "User"; // Default name

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['full_name'] ?? "User";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blood Bank"),
        actions: [
          // 🔴 Updated Blood Group Status Icon with Border
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 1.5), // Red border
              ),
              child: Icon(Icons.people, color: Colors.red), // Blood Status Icon
            ),
            tooltip: "Blood Group Status",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BloodGroupStatsPage()),
              );
            },
          ),
          // 🔵 Profile Icon with Border
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.black, width: 1.5), // Black border
              ),
              child: Icon(Icons.person, color: Colors.black), // Profile Icon
            ),
            tooltip: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, $userName!", // ✅ Displays the registered user's name
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                    "Request Blood", Icons.bloodtype, Colors.red, context),
                _buildActionButton("Donate Blood", Icons.volunteer_activism,
                    Colors.green, context),
                _buildActionButton(
                    "View Donors", Icons.list, Colors.blue, context),
              ],
            ),
            SizedBox(height: 24),

            Text(
              "Recent Blood Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('blood_requests')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Error loading requests",
                            style: TextStyle(color: Colors.red)));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No recent blood requests."),
                    );
                  }

                  var requests = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      var requestData =
                          requests[index].data() as Map<String, dynamic>?;

                      return _buildRequestCard(requestData, context);
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

  Widget _buildActionButton(
      String title, IconData icon, Color color, BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: color,
          onPressed: () {
            if (title == "Request Blood") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BloodRequestPage()),
              );
            } else if (title == "Donate Blood") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DonateBloodPage()),
              );
            } else if (title == "View Donors") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewDonorsPage()),
              );
            }
          },
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildRequestCard(
      Map<String, dynamic>? requestData, BuildContext context) {
    if (requestData == null) return SizedBox(); // If no data, show nothing

    String bloodType = requestData['blood_group'] ?? 'Unknown';
    String hospital = requestData['hospital_name'] ?? 'Not Specified';
    String urgency = requestData['urgency'] ?? 'Not Specified';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: Text(
            bloodType,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text("Hospital: $hospital"),
        subtitle: Text("Urgency: $urgency"),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BloodRequestDetailsPage(requestData: requestData),
              ),
            );
          },
          child: Text("Details"),
        ),
      ),
    );
  }
}
