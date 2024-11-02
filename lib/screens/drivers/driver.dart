import 'package:durub_ali/auth/login.dart';
import 'package:durub_ali/screens/dashbord.dart';
import 'package:durub_ali/screens/drivers/Driversmap.dart';
import 'package:durub_ali/main.dart';
import 'package:durub_ali/screens/OrderHistoryScreen.dart';
import 'package:durub_ali/screens/add.dart';
import 'package:durub_ali/screens/drivers/driverinfo.dart';
import 'package:durub_ali/screens/users/fatorah.dart';
import 'package:durub_ali/screens/oders.dart';
import 'package:durub_ali/screens/users/userinfo.dart';
import 'package:durub_ali/screens/users/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class Drivers extends StatefulWidget {
  @override
  State<Drivers> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<Drivers> {
  @override
  String selectedValue = 'Drivers';
  String selectedValue1 = 'Order Management';


  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final isMediumScreen = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;
          final isLargeScreen = constraints.maxWidth >= 1200;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSmallScreen)
          Container(
            width: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2C3E50),
                  Color(0xFF3498DB),
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Icon(Icons.store, color: Colors.white, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'Yelpos',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
children: [
  _buildNavItem(context, 'Dashboard', Icons.dashboard, DashboardScreen()),
  _buildNavItem(context, 'Users', Icons.people, UserDashboard()),

  _buildNavItem(
    context,
    '',
    Icons.shopping_cart,
    OrderManagementScreen(),
    dropdownItems: ['Order Management', 'Order History', 'Add Order'], // Dropdown options
    selectedItem: selectedValue1, // Currently selected item
    onChanged: (String? newValue) {
      setState(() {
        selectedValue1 = newValue!;
        // Navigate based on selected item
        if (selectedValue1 == 'Order Management') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderManagementScreen()),
          );
        } else if (selectedValue1 == 'Order History') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
          );
        } else if (selectedValue1 == 'Add Order') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homescreen()),
          );
        }
      });
    },
  ),

  _buildNavItem(
    context,
    '',
    Icons.local_shipping,
    OrderManagementScreen(),
    dropdownItems: ['Drivers', 'Drivers Location'], // Dropdown options
    selectedItem: selectedValue, // Currently selected item
    onChanged: (String? newValue) {
      setState(() {
        selectedValue = newValue!;
        // Navigate based on selected item
        if (selectedValue == 'Drivers') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Drivers()),
          );
        } else if (selectedValue == 'Drivers Location') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DeliveryMapScreen()),
          );
        }
      });
    },
  ),
  _buildNavItem(context, 'Logout', Icons.logout, LoginScreen()),

],
                  ),
                ),
              ],
            ),
          ),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back, Ali',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 24 : 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[900],
                                  ),
                                ),
                                Text(
                                  'Manage your Drivers and track their orders',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.notifications_none, size: 28),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.all(24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Drivers Management',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(child: CircularProgressIndicator());
                                    }

                                    final users = snapshot.data!.docs
                                        .map((doc) => Users.fromMap(doc.data() as Map<String, dynamic>))
                                        .toList();

                                    return ListView.separated(
                                      padding: EdgeInsets.symmetric(horizontal: 24),
                                      itemCount: users.length,
                                      separatorBuilder: (context, index) => Divider(),
                                      itemBuilder: (context, index) {
                                        final user = users[index];
                                        return Card(
                                          elevation: 0,
                                          color: index.isEven ? Colors.grey[50] : Colors.white,
                                          child: ListTile(
                                            contentPadding: EdgeInsets.all(16),
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(user.profileImage),
                                            ),
                                            title: Text(
                                              user.username,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            subtitle: !isSmallScreen
                                                ? Row(
                                                    children: [
                                                      Icon(Icons.email, size: 16, color: Colors.grey),
                                                      SizedBox(width: 4),
                                                      Text(user.email),
                                                      SizedBox(width: 16),
                                                      Icon(Icons.phone, size: 16, color: Colors.grey),
                                                      SizedBox(width: 4),
                                                      Text(user.phoneNumber),
                                                      SizedBox(width: 16),
                                                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                                                      SizedBox(width: 4),
                                                      Expanded(child: Text(user.address, overflow: TextOverflow.ellipsis)),
                                                    ],
                                                  )
                                                : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.email, size: 16, color: Colors.grey),
                                                          SizedBox(width: 4),
                                                          Text(user.email),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.phone, size: 16, color: Colors.grey),
                                                          SizedBox(width: 4),
                                                          Text(user.phoneNumber),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[100],
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    'Active',
                                                    style: TextStyle(
                                                      color: Colors.green[700],
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                IconButton(
                                                  icon: Icon(Icons.more_vert),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => driverInfoScreen(user: user),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.white.withOpacity(0.1),
      selected: title == 'Users',
      selectedTileColor: Colors.white.withOpacity(0.1),
    );
}
 }


 
 Widget _buildNavItem(BuildContext context, String title, IconData icon, Widget destination, {List<String>? dropdownItems, String? selectedItem, ValueChanged<String?>? onChanged}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
    leading: Icon(icon, color: Colors.white70),
    title: Text(
    title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: dropdownItems != null && dropdownItems.isNotEmpty
          ? DropdownButton<String>(
              value: selectedItem,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
              dropdownColor: Colors.grey[800],
              underline: Container(),
              items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: onChanged,
            )
          : null,
           onTap: dropdownItems == null
          ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            }
          : null, // No navigation if there's a dropdown
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      hoverColor: Colors.white.withOpacity(0.1),
    ),
  );
}
