
import 'package:durub_ali/auth/login.dart';
import 'package:durub_ali/firebase_options.dart';
import 'package:durub_ali/screens/Driversmap.dart';
import 'package:durub_ali/screens/OrderHistoryScreen.dart';
import 'package:durub_ali/screens/add.dart';
import 'package:durub_ali/screens/drivers/driver.dart';
import 'package:durub_ali/screens/oders.dart';
import 'package:durub_ali/screens/users/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Widget> _initialRouteFuture;

  @override
  void initState() {
    super.initState();
    _initialRouteFuture = _determineInitialRoute();
  }

  Future<Widget> _determineInitialRoute() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return DashboardScreen();
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard App',
      theme: ThemeData.light(),
      home: FutureBuilder<Widget>(
        future: _initialRouteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data ?? LoginScreen();
          }
          // You can show a loading screen here while checking the auth state
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/ordersdashbord': (context) => OrderManagementScreen(),
        '/dashbord': (context) => DashboardScreen(),
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Enhanced Side Navigation
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
                        'BTech',
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
          // Enhanced Main Content
          Expanded(
            child: Container(
              color: Color(0xFFF5F7FA),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, BTech Owner 👋',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),
                        _buildProfileCard(),
                      ],
                    ),
                    SizedBox(height: 24),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.5,
                        children: [
                          _buildEnhancedStatCard(
                            'In Progress Orders',
                            '12',
                            Icons.pending_actions,
                            Color(0xFF3498DB),
                            '+24% from last month',
                          ),
                          _buildEnhancedStatCard(
                            'Cancelled Orders',
                            '3',
                            Icons.cancel,
                            Color(0xFFE74C3C),
                            '-12% from last month',
                          ),
                          _buildEnhancedStatCard(
                            'Delivered Orders',
                            '145',
                            Icons.check_circle,
                            Color(0xFF2ECC71),
                            '+18% from last month',
                          ),
                          _buildEnhancedStatCard(
                            'Out of Stock Products',
                            '8',
                            Icons.inventory,
                            Color(0xFFE67E22),
                            '2 items critical',
                          ),
                          _buildEnhancedStatCard(
                            'Total Products',
                            '454',
                            Icons.shopping_bag,
                            Color(0xFF9B59B6),
                            '+6 new this month',
                          ),
                          _buildEnhancedStatCard(
                            'Shop Reviews',
                            '4.8',
                            Icons.star,
                            Color(0xFFF1C40F),
                            '26 new reviews',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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


  Widget _buildProfileCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFF3498DB),
              child: Text(
                'YO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BTech Owner',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Admin',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(width: 12),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
