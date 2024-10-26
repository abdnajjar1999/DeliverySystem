import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durub_ali/main.dart';
import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:easy_web_view/easy_web_view.dart';

class DeliveryMapScreen extends StatefulWidget {
  @override
  _DeliveryMapScreenState createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {


 final _controller = WebviewController();
  String src='https://www.google.com/maps/search/?api=1&query=37.7749,-122.4194';
  
  @override
  void initState() {
    super.initState();
     Future.delayed(Duration(seconds: 1), () {
              _controller.loadUrl('https://www.google.com/maps/search/?api=1&query=0,0');
     });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: Text('Drivers'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            // Navigate to DashboardScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          },
        ),
        actions: [
          DropdownButton<String>(
            value: 'All',
            items: <String>['All', 'Active', 'Completed']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Handle filter change
            },
          ),
        ],
      ),
      body: Stack(
        children: [
        EasyWebView(
  src: src,
  isMarkdown: false, // Use markdown syntax
  convertToWidgets: false, // Try to convert to flutter widgets
  // width: 100,
  // height: 100,
),
          Positioned(
            top: 10,
            right: 10,
            child: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator()); // Loading indicator while waiting for data
    }

    var driverDocs = snapshot.data!.docs; // Get list of documents
    return SizedBox(
      height: 300,
      width: 200,
      child: ListView.builder(
        itemCount: driverDocs.length,
        itemBuilder: (context, index) {
          var driver = driverDocs[index];

          // Fetch the driver data
          String username = driver['username'].toString();
          String address = driver['address'].toString();
          String email = driver['email'].toString();
         // String phoneNumber = driver['phone_number'].toString();
          String profileImage = driver['profileImage'].toString();
        //  String userId = driver['userId'].toString();
       // String activeOrders = driver['active_orders'].toString();
         String? location =driver["location"]??'';

          return InkWell(
            onTap: () {
              setState(() {
                src="https://www.google.com/maps/search/?api=1&query=$location";
              });
            //  _controller.loadUrl('https://www.google.com/maps/search/?api=1&query=$location');
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(profileImage),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text('Online', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Address
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(address),
                      ],
                    ),
                    SizedBox(height: 5),

                    // Email
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(email),
                      ],
                    ),
                    SizedBox(height: 5),

                    // Phone number
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey),
                        SizedBox(width: 5),
                       // Text(phoneNumber),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Active Orders
                  // Text('Active Orders: $activeOrders'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  },
)

          ),
        ],
      ),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }}