import 'package:durub_ali/auth/login.dart';
import 'package:durub_ali/screens/Driversmap.dart';
import 'package:durub_ali/main.dart';
import 'package:durub_ali/screens/OrderHistoryScreen.dart';
import 'package:durub_ali/screens/add.dart';
import 'package:durub_ali/screens/detaels.dart';
import 'package:durub_ali/screens/drivers/driver.dart';
import 'package:durub_ali/screens/users/users.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:durub_ali/models/models.dart';

  final Color primaryColor = Color(0xFF2C3E50);
  final Color secondaryColor = Color(0xFF3498DB);
  final Color accentColor = Color(0xFF34495E);

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  String? selectedUsername;
  DateTime? selectedDate;
  Map<String, String?> selectedDrivers = {};
    String selectedValue = 'Drivers';
  String selectedValue1 = 'Order Management';

  // Stream to get usernames
  Stream<List<String>> getUsernamesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc['username'] as String).toList());
  }

  // Stream to get drivers

  Stream<QuerySnapshot<Map<String, dynamic>>> getDriversStream() {
    var data=  FirebaseFirestore.instance
        .collection('drivers')
        .snapshots();
       
return data;

  }

  // Function to save order with driver info
Future<void> saveOrderWithDriver(Order1 order, String? driver, String id) async {
  DocumentReference orderRef = FirebaseFirestore.instance.collection('orders').doc(id);

  await orderRef.update({
    'driverName': driver,       // Storing driver information
    'isDriverAssigned': true,   // Storing that a driver has been assigned
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final isLargeScreen = constraints.maxWidth >= 1200;

          return Row(
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

Column(
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
)
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
                      _buildFilters(),
                      _buildTableHeader(isSmallScreen),
                      Expanded(
                        child: _buildOrderList(),
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

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildUsernameDropdown(),
          _buildDatePicker(),
          if (selectedUsername != null || selectedDate != null)
            ElevatedButton.icon(
              icon: Icon(Icons.clear),
              label: Text('Clear Filters'),
              onPressed: () {
                setState(() {
                  selectedUsername = null;
                  selectedDate = null;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUsernameDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: StreamBuilder<List<String>>(
          stream: getUsernamesStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
            );

            return DropdownButton<String>(
              value: selectedUsername,
              hint: Text('Filter by Username'),
              style: TextStyle(color: primaryColor),
              onChanged: (String? newValue) {
                setState(() {
                  selectedUsername = newValue;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Usernames'),
                ),
                ...snapshot.data!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return ElevatedButton.icon(
      icon: Icon(Icons.calendar_today),
      label: Text(
        selectedDate == null
            ? 'Filter by Date'
            : 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: secondaryColor,
        elevation: 2,
      ),
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: secondaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: primaryColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
    );
  }

  Widget _buildOrderCard(Order1 order, String orderId) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: order.isDriverAssigned ? secondaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(order: order, orderId: orderId),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildProfileImage(order.profileImageUrl)),
              Expanded(
                flex: 2,
                child: Text(
                  order.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              Expanded(flex: 2, child: Text(order.customerName)),
              Expanded(flex: 2, child: Text(order.region)),
              Expanded(
                flex: 2,
                child: Text(
                  order.orderNumber,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
              ),
              Expanded(flex: 2, child: _buildDriverDropdown(order)),
              Expanded(flex: 2, child: _buildActionButtons(order, orderId)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    return CircleAvatar(
      backgroundImage: NetworkImage(imageUrl ?? 'https://via.placeholder.com/150'),
      radius: 20,
      onBackgroundImageError: (error, stackTrace) {
        // Handle image load errors
      },
    );
  }

  Widget _buildDriverDropdown(Order1 order) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getDriversStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final drivers = snapshot.data!.docs.map((doc) => doc['username'] as String).toList();
        var driversDoc = snapshot.data!.docs;

        return DropdownButton<String>(
          isExpanded: true,
          value: selectedDrivers[order.orderNumber],
          hint: Text('Assign Driver'),
          onChanged: (String? newValue) {
            setState(() {
              selectedDrivers[order.orderNumber] = newValue;
            });
          },
          items: List.generate(
            drivers.length,
            (index) => DropdownMenuItem<String>(
              value: driversDoc[index].data()['userid'],
              child: Text(drivers[index]),
            ),
          ).toList(),
        );
      },
    );
  }

  Widget _buildActionButtons(Order1 order, String orderId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.save, color: secondaryColor),
          onPressed: () {
            saveOrderWithDriver(order, selectedDrivers[order.orderNumber], orderId);
          },
        ),
        if (order.isDriverAssigned)
          Icon(Icons.check_circle, color: secondaryColor, size: 20),
      ],
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


Widget _buildTableHeader(bool isSmallScreen) {
  if (isSmallScreen) return SizedBox.shrink();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          primaryColor.withOpacity(0.1),
          secondaryColor.withOpacity(0.1),
        ],
      ),
      border: Border(
        bottom: BorderSide(
          color: primaryColor.withOpacity(0.2),
        ),
      ),
    ),
    child: Row(
      children: [
        _buildHeaderCell('Photo', flex: 2),
        _buildHeaderCell('Marketname', flex: 2),
        _buildHeaderCell('Customer', flex: 2),
        _buildHeaderCell('Region', flex: 2),
        _buildHeaderCell('Order #', flex: 2),
        _buildHeaderCell('Driver', flex: 2),
        _buildHeaderCell('Actions', flex: 2),
      ],
    ),
  );
}

Widget _buildHeaderCell(String text, {int flex = 1}) {
  return Expanded(
    flex: flex,
    child: Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: primaryColor,
        fontSize: 14,
      ),
    ),
  );
}

  Widget _buildOrderList() {
   return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
      .collection('orders')
      .where('status', isNotEqualTo: 'Completed')
      .snapshots(),

    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
          ),
        );
      }

      var orders = snapshot.data!.docs
          .map((doc) => Order1.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
          orders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      var orderDocs = snapshot.data!.docs;
      orderDocs.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

      // Apply filters if necessary
      if (selectedUsername != null) {
        orders = orders.where((order) => order.username == selectedUsername).toList();
      }
      if (selectedDate != null) {
        orders = orders.where((order) =>
            order.timestamp.year == selectedDate!.year &&
            order.timestamp.month == selectedDate!.month &&
            order.timestamp.day == selectedDate!.day).toList();
      }

      if (orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: primaryColor.withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                'No orders found',
                style: GoogleFonts.poppins(
                  color: primaryColor.withOpacity(0.5),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: orders.length,
        padding: EdgeInsets.only(top: 8, bottom: 24),
        itemBuilder: (context, index) {
          final order = orders[index];
          final orderId = orderDocs[index].id;

          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: order.isDriverAssigned ? secondaryColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsScreen(
                        order: order,
                        orderId: orderId,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            order.profileImageUrl.isNotEmpty
                                ? order.profileImageUrl
                                : 'https://via.placeholder.com/150',
                          ),
                          backgroundColor: primaryColor.withOpacity(0.1),
                          radius: 20,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          order.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          order.customerName,
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          order.region,
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          order.orderNumber,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildDriverDropdown(order),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.save,
                                color: secondaryColor,
                              ),
                              onPressed: () {
                                saveOrderWithDriver(
                                  order,
                                  selectedDrivers[order.orderNumber],
                                  orderId,
                                );
                              },
                              tooltip: 'Save Changes',
                            ),
                            if (order.isDriverAssigned)
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.check_circle,
                                  color: secondaryColor,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
}