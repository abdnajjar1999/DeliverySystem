import 'package:durub_ali/auth/login.dart';
import 'package:durub_ali/screens/drivers/Driversmap.dart';
import 'package:durub_ali/main.dart';
import 'package:durub_ali/screens/OrderHistoryScreen.dart';
import 'package:durub_ali/screens/add.dart';
import 'package:durub_ali/screens/detaels.dart';
import 'package:durub_ali/screens/drivers/driver.dart';
import 'package:durub_ali/screens/users/users.dart';
import 'package:durub_ali/widget/drowe.dart';
import 'package:durub_ali/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:durub_ali/models/models.dart';
import 'package:durub_ali/fillters/phone.dart';

final Color primaryColor = Color(0xFF1A237E); // Darker blue
final Color secondaryColor = Color(0xFF2196F3); // Brighter blue
final Color accentColor = Color(0xFF3F51B5); // Indigo
final Color backgroundColor = Color(0xFFF5F7FA); // Light gray background

String? selectedUsername;
String? selectedCustomerName;
String? selectedRegion;
String? selectedOrderNumber;
String? selectedPhoneNumber;
String? selectedDriverName;
String? selectedStatus;
DateTimeRange? selectedDateRange;
RangeValues? selectedTotalRange;
bool? selectedDriverAssigned;
final TextEditingController _searchController = TextEditingController();
final TextEditingController _phoneNumberController = TextEditingController();

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  DateTime? selectedDate;
  Map<String, String?> selectedDrivers = {};
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
bool selectAll = false;
Set<String> selectedOrders = {};
String? selectedBatchDriver;
  bool isDisposed = false;
  @override
  // void dispose() {
  //   _horizontalScrollController.dispose();
  //   _verticalScrollController.dispose();
  //   _searchController.dispose();
  //   _phoneNumberController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_handlePhoneSearchChange);
  }

  void _handlePhoneSearchChange() {
    if (!isDisposed) {
      setState(() {
        selectedPhoneNumber = _phoneNumberController.text;
      });
    }
  }



  Stream<List<String>> getDriverNamesStream() {
    return FirebaseFirestore.instance
        .collection('drivers')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc['username'] as String)
            .toSet()
            .toList());
  }

  Stream<List<String>> getUsernamesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['username'] as String).toList());
  }

  Stream<List<String>> getCustomerNamesStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc['اسم العميل'] as String)
            .toSet()
            .toList());
  }

  Stream<List<String>> getRegionsStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['المنطقة'] as String).toSet().toList());
  }

  Stream<List<String>> getOrderNumbersStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc['رقم الطلب'] as String)
            .toSet()
            .toList());
  }

  Stream<List<String>> getphoneNumbersStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc['رقم الهاتف'] as String)
            .toSet()
            .toList());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDriversStream() {
    return FirebaseFirestore.instance.collection('drivers').snapshots();
  }

  Stream<List<String>> getStatusesStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc['status'] as String)
            .toSet()
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          return Row(
            children: [
              if (!isSmallScreen) _buildSidebar(),
              Expanded(
                child: Container(
                  color: backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      _buildEnhancedFilters(),
                      Expanded(
                        child: _buildScrollableOrderList(),
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

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            accentColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLogo(),
          Expanded(
            child: _buildNavigation(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.store, color: Colors.white, size: 28),
          ),
          SizedBox(width: 16),
          Text(
            'BTech',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      children: [
        _buildNavItem(
          icon: Icons.dashboard,
          title: 'Dashboard',
          destination: DashboardScreen(),
        ),
        _buildNavItem(
          icon: Icons.people,
          title: 'Users',
          destination: UserDashboard(),
        ),
        _buildDropdownNavItem(
          icon: Icons.shopping_cart,
          items: ['Order Management', 'Order History', 'Add Order'],
          selectedItem: selectedValue1,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue1 = newValue!;
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
        _buildDropdownNavItem(
          icon: Icons.local_shipping,
          items: ['Drivers', 'Drivers Location'],
          selectedItem: selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
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
        _buildNavItem(
          icon: Icons.logout,
          title: 'Logout',
          destination: LoginScreen(),
          isLogout: true,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Order Management',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Spacer(),
          _buildHeaderAction(Icons.refresh, 'Refresh', () {}),
          SizedBox(width: 16),
          _buildHeaderAction(Icons.help_outline, 'Help', () {}),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(icon, color: primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required Widget destination,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isLogout ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.1),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red[300] : Colors.white,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isLogout ? Colors.red[300] : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDropdownNavItem({
    required IconData icon,
    required List<String> items,
    required String? selectedItem,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: accentColor,
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            selectedItem ?? items[0],
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: items.map((item) {
            return ListTile(
              title: Text(
                item,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () => onChanged(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEnhancedFilters() {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        children: [
          if (_hasActiveFilters())
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.clear),
                  label: Text('Clear All Filters'),
                  onPressed: _clearAllFilters,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Active Filters: ${_getActiveFilterCount()}',
                    style: GoogleFonts.poppins(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 16),
          _buildFilterHeader(),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      width: 1500,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildDateRangePicker(),
          SizedBox(width: 16),
          _buildDriverAssignedFilter(),
          SizedBox(width: 16),
          Expanded(
            child: _buildFilterDropdown(
              stream: getUsernamesStream(),
              value: selectedUsername,
              hint: 'Username',
              onChanged: (value) => setState(() => selectedUsername = value),
            ),
          ),
          SizedBox(width: 16),
Expanded(
            child: _buildFilterDropdown(
              stream: getCustomerNamesStream(),
              value: selectedCustomerName,
              hint: 'Customer',
              onChanged: (value) => setState(() => selectedCustomerName = value),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildFilterDropdown(
              stream: getRegionsStream(),
              value: selectedRegion,
              hint: 'Region',
              onChanged: (value) => setState(() => selectedRegion = value),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildFilterDropdown(
              stream: getOrderNumbersStream(),
              value: selectedOrderNumber,
              hint: 'Order #',
              onChanged: (value) => setState(() => selectedOrderNumber = value),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildPhoneNumberSearch(),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildFilterDropdown(
              stream: getDriverNamesStream(),
              value: selectedDriverName,
              hint: 'Driver',
              onChanged: (value) => setState(() => selectedDriverName = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return ElevatedButton.icon(
      icon: Icon(Icons.calendar_today, size: 20),
      label: Text(
        selectedDate == null
            ? 'Filter by Date'
            : 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
        style: GoogleFonts.poppins(),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: secondaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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

  Widget _buildDriverAssignedFilter() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<bool?>(
          value: selectedDriverAssigned,
          hint: Text('Driver Assignment',
              style: GoogleFonts.poppins(color: primaryColor)),
          isExpanded: true,
          items: [
            DropdownMenuItem(value: null, child: Text('All')),
            DropdownMenuItem(value: true, child: Text('Assigned')),
            DropdownMenuItem(value: false, child: Text('Unassigned')),
          ],
          onChanged: (value) => setState(() => selectedDriverAssigned = value),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required Stream<List<String>> stream,
    required String? value,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return StreamBuilder<List<String>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                ),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint, style: GoogleFonts.poppins(color: primaryColor)),
              isExpanded: true,
              items: [
                DropdownMenuItem(value: null, child: Text('All')),
                ...snapshot.data!.map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    )),
              ],
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }

  Widget _buildScrollableOrderList() {
    return Theme(
      data: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          radius: Radius.circular(8),
          thickness: MaterialStatePropertyAll(8),
          trackVisibility: MaterialStatePropertyAll<bool>(true),
          thumbColor: MaterialStateProperty.all(primaryColor.withOpacity(0.6)),
          trackColor: MaterialStateProperty.all(Colors.grey[200]),
          thumbVisibility: MaterialStatePropertyAll<bool>(true),
        ),
      ),
      child: Scrollbar(
        controller: _horizontalScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1400,
            child: Scrollbar(
              controller: _verticalScrollController,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.right,
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                child: _buildFilteredOrderList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

Widget _buildBatchAssignmentHeader() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    color: Colors.white,
    child: Row(
      children: [
        Checkbox(
          value: selectAll,
          onChanged: (bool? value) {
            setState(() {
              selectAll = value ?? false;
              if (selectAll) {
                // Add all visible order numbers to selectedOrders
                FirebaseFirestore.instance
                    .collection('orders')
                    .where('status', isNotEqualTo: 'Completed')
                    .get()
                    .then((snapshot) {
                  selectedOrders = snapshot.docs
                      .map((doc) => doc['رقم الطلب'] as String)
                      .toSet();
                });
              } else {
                selectedOrders.clear();
              }
            });
          },
        ),
        Text(
          'Select All',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 16),
        if (selectedOrders.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${selectedOrders.length} orders selected',
              style: GoogleFonts.poppins(
                color: secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 200,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getDriversStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    ),
                  );
                }

                final drivers = snapshot.data!.docs;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: secondaryColor.withOpacity(0.3)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedBatchDriver,
                      hint: Text('Select Driver',
                          style: GoogleFonts.poppins(color: primaryColor)),
                      isExpanded: true,
                      items: drivers.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc['userid'],
                          child: Text(doc['username']),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedBatchDriver = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.assignment_turned_in),
            label: Text('Assign Selected'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: selectedBatchDriver == null
                ? null
                : () async {
                    try {
                      final batch = FirebaseFirestore.instance.batch();
                      final querySnapshot = await FirebaseFirestore.instance
                          .collection('orders')
                          .where('رقم الطلب', whereIn: selectedOrders.toList())
                          .get();

                      for (var doc in querySnapshot.docs) {
                        batch.update(doc.reference, {
                          'driverID': selectedBatchDriver,
                          'isDriverAssigned': true,
                        });
                      }

                      await batch.commit();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Successfully assigned orders to driver'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      setState(() {
                        selectedOrders.clear();
                        selectAll = false;
                        selectedBatchDriver = null;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error assigning orders: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
          ),
        ],
      ],
    ),
  );
}


Widget _buildEnhancedDriverDropdown(Order1 order) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: secondaryColor.withOpacity(0.3)),
    ),
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getDriversStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ),
            ),
          );
        }

        final drivers = snapshot.data!.docs;

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedDrivers[order.orderNumber],
            hint: Text('Assign Driver',
                style: GoogleFonts.poppins(color: primaryColor)),
            onChanged: (String? newValue) {
              setState(() {
                selectedDrivers[order.orderNumber] = newValue;
              });
            },
            items: drivers.map((doc) {
              return DropdownMenuItem<String>(
                value: doc['userid'],
                child: Text(
                  doc['username'],
                  style: GoogleFonts.poppins(),
                ),
              );
            }).toList(),
          ),
        );
      },
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



  Widget _buildEmptyState() {
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

  Widget _buildPhoneNumberSearch() {
    return Container(
      height: 48,
      child: PhoneNumberSearchWidget(
        onChanged: (value) {
          setState(() {
            selectedPhoneNumber = value;
          });
        },
        phoneNumberController: _phoneNumberController,
      ),
    );
  }

  List<Order1> _applyFilters(List<Order1> orders) {
    return orders.where((order) {
      bool matchesUsername =
          selectedUsername == null || order.username == selectedUsername;
      bool matchesCustomer = selectedCustomerName == null ||
          order.customerName == selectedCustomerName;
      bool matchesRegion =
          selectedRegion == null || order.region == selectedRegion;
      bool matchesOrderNumber =
          selectedOrderNumber == null || order.orderNumber == selectedOrderNumber;
      bool matchesPhoneNumber = selectedPhoneNumber == null ||
          order.phone.toString().contains(selectedPhoneNumber!);
      bool matchesDate = selectedDate == null ||
          (order.timestamp.year == selectedDate!.year &&
              order.timestamp.month == selectedDate!.month &&
              order.timestamp.day == selectedDate!.day);
      bool matchesDriverAssigned = selectedDriverAssigned == null ||
          order.isDriverAssigned == selectedDriverAssigned;

      return matchesUsername &&
          matchesCustomer &&
          matchesRegion &&
          matchesOrderNumber &&
          matchesPhoneNumber &&
          matchesDate &&
          matchesDriverAssigned;
    }).toList();
  }

  void _clearAllFilters() {     
    setState(() {       
      selectedUsername = null;       
      selectedCustomerName = null;       
      selectedRegion = null;       
      selectedOrderNumber = null;       
      selectedPhoneNumber = null;       
      selectedDriverName = null;       
      selectedStatus = null;
      selectedDateRange = null;
      selectedTotalRange = null;
      selectedDriverAssigned = null;
      selectedDate = null;
      _searchController.clear();
      _phoneNumberController.clear();
      selectedDrivers.clear();
      selectedOrders.clear();
      selectAll = false;
      selectedBatchDriver = null;
    });     
  }
Widget _buildAssignToDriverButton() {
  if (selectedOrders.isEmpty) return SizedBox.shrink();

  return Container(
    padding: EdgeInsets.all(16),
    child: ElevatedButton.icon(
      icon: Icon(Icons.person_add),
      label: Text('Assign to Driver (${selectedOrders.length} orders)'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        _showDriverSelectionDialog();
      },
    ),
  );
}

// Add this method to show the driver selection dialog
void _showDriverSelectionDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Select Driver',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getDriversStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                );
              }

              final drivers = snapshot.data!.docs;

              return StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${selectedOrders.length} orders selected',
                          style: GoogleFonts.poppins(
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 300,
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: drivers.length,
                          itemBuilder: (context, index) {
                            final driver = drivers[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                                title: Text(
                                  driver['username'],
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  'Driver ID: ${driver['userid']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                  ),
                                ),
                                selected: selectedBatchDriver == driver['userid'],
                                selectedTileColor: secondaryColor.withOpacity(0.1),
                                onTap: () {
                                  setState(() {
                                    selectedBatchDriver = driver['userid'];
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text(
              'Assign Orders',
              style: GoogleFonts.poppins(),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (selectedBatchDriver != null) {
                try {
                  // Create a batch
                  final batch = FirebaseFirestore.instance.batch();
                  
                  // Get all selected orders
                  final querySnapshot = await FirebaseFirestore.instance
                      .collection('orders')
                      .where('رقم الطلب', whereIn: selectedOrders.toList())
                      .get();

                  // Update each order in the batch
                  for (var doc in querySnapshot.docs) {
                    batch.update(doc.reference, {
                      'driverID': selectedBatchDriver,
                      'isDriverAssigned': true,
                    });
                  }

                  // Commit the batch
                  await batch.commit();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Successfully assigned ${selectedOrders.length} orders to driver'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Clear selections
                  setState(() {
                    selectedOrders.clear();
                    selectAll = false;
                    selectedBatchDriver = null;
                  });

                  // Close dialog
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error assigning orders: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      );
    },
  );
}

// Update your _buildFilteredOrderList method to include the assign button
Widget _buildFilteredOrderList() {
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
      var orderDocs = snapshot.data!.docs;

      orders = _applyFilters(orders);

      if (orders.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        children: [
          // Add select all checkbox
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: selectAll,
                  onChanged: (bool? value) {
                    setState(() {
                      selectAll = value ?? false;
                      if (selectAll) {
                        selectedOrders = orders
                            .map((order) => order.orderNumber)
                            .toSet();
                      } else {
                        selectedOrders.clear();
                      }
                    });
                  },
                ),
                Text(
                  'Select All',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16),
                if (selectedOrders.isNotEmpty)
                  _buildAssignToDriverButton(),
              ],
            ),
          ),
          ...orders.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            final orderId = orderDocs[index].id;
            return _buildOrderCard(order, orderId);
          }).toList(),
        ],
      );
    },
  );
}

  // Action Buttons Widget
  Widget _buildActionButtons(Order1 order, String orderId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.save, color: secondaryColor),
          onPressed: () async {
            if (selectedDrivers[order.orderNumber] != null) {
              try {
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(orderId)
                    .update({
                  'driverID': selectedDrivers[order.orderNumber],
                  'isDriverAssigned': true,
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Driver assigned successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error assigning driver: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select a driver first'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          tooltip: 'Save changes',
        ),
        if (order.isDriverAssigned)
          Tooltip(
            message: 'Driver Assigned',
            child: Icon(Icons.check_circle, color: secondaryColor, size: 20),
          ),
      ],
    );
  }


  int _getActiveFilterCount() {
    int count = 0;
    if (selectedUsername != null) count++;
    if (selectedCustomerName != null) count++;
    if (selectedRegion != null) count++;
    if (selectedOrderNumber != null) count++;
    if (selectedPhoneNumber != null) count++;
    if (selectedDriverName != null) count++;
    if (selectedStatus != null) count++;
    if (selectedDateRange != null) count++;
    if (selectedTotalRange != null) count++;
    if (selectedDriverAssigned != null) count++;
    if (selectedDate != null) count++;
    if (_searchController.text.isNotEmpty) count++;
    if (_phoneNumberController.text.isNotEmpty) count++;
    return count;
  }

  bool _hasActiveFilters() {
    return _getActiveFilterCount() > 0;
  }

}
