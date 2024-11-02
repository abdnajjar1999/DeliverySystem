import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:durub_ali/auth/login.dart';
import 'package:durub_ali/fillters/costomername.dart';
import 'package:durub_ali/fillters/ordersnumber.dart';
import 'package:durub_ali/fillters/price.dart';
import 'package:durub_ali/fillters/weight.dart';
import 'package:durub_ali/screens/dashbord.dart';
import 'package:durub_ali/screens/drivers/Driversmap.dart';
import 'package:durub_ali/main.dart';
import 'package:durub_ali/screens/OrderHistoryScreen.dart';
import 'package:durub_ali/screens/add.dart';
import 'package:durub_ali/screens/detaels.dart';
import 'package:durub_ali/screens/drivers/driver.dart';
import 'package:durub_ali/screens/manegment.dart';
import 'package:durub_ali/screens/riders%20repory.dart';
import 'package:durub_ali/screens/users/users.dart';
import 'package:durub_ali/widget/DropdownButton.dart';
import 'package:durub_ali/widget/scrollbar2D.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:durub_ali/models/models.dart';
import 'package:durub_ali/fillters/phone.dart';
final GlobalKey buttonKey = GlobalKey();

final Color primaryColor = Color(0xFF1A237E); // Darker blue
final Color secondaryColor = Color(0xFF2196F3); // Brighter blue
final Color accentColor = Color(0xFF3F51B5); // Indigo
final Color backgroundColor = Color(0xFFF5F7FA); // Light gray background

String? selectedUsername;
String? selectedstatus;
String? selectedpaymentmethod;
String? selectedRegion;
String? selectedOrderNumber;
String? selectedPhoneNumber;
String? selectedDriverName;
String? selectedStatus;
// Change from _orderNumberController to _priceController
final TextEditingController _priceController = TextEditingController();

String? selectedPrice;
String? selectedWeight;
final TextEditingController _weightController = TextEditingController();

DateTimeRange? selectedDateRange;
RangeValues? selectedTotalRange;
bool? selectedDriverAssigned;
String? selectedCustomerName;

final TextEditingController _searchController = TextEditingController();
final TextEditingController _phoneNumberController = TextEditingController();
final TextEditingController _orderNumberController = TextEditingController();
final TextEditingController _costomernameController = TextEditingController();

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
  final OverlayPortalController _tooltipController = OverlayPortalController();

  Set<String> selectedOrders = {};
  String? selectedBatchDriver;
  bool isDisposed = false;
  bool showlist = false;
  @override
  // void dispose() {
  //   _horizontalScrollController.dispose();
  //   _verticalScrollController.dispose();
  //   _searchController.dispose();
  //   _phoneNumberController.dispose();
  //   super.dispose();
  // }
final LayerLink _layerLink = LayerLink();
OverlayEntry? _overlayEntry;

// Add this method to create the overlay
void _showOverlay(BuildContext context) {
  _overlayEntry?.remove();
  _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      width: 300,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0.0, 40.0), // Adjust this to control distance below button
        child: Material(
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: ArabicForm(onChanged: (String? value) { 
    setState(() { 
      selectedCustomerName = value;
      if (value == null) {
        _costomernameController.clear();
      }
    }); 
              
              
              
               }, customerNameController: _costomernameController,),
          ),            

        ),
      ),
    ),
  );
  
  Overlay.of(context).insert(_overlayEntry!);
}

  @override
void initState() {
  super.initState();
  _phoneNumberController.addListener(_handlePhoneSearchChange);
  _orderNumberController.addListener(_handleordernumberSearchChange);
  _priceController.addListener(_handlepriceSearchChange);
  _weightController.addListener(_handleWeightSearchChange); // Add this line
  _weightController.addListener(_handlecostomernameSearchChange); // Add this line
}
  void _handlePhoneSearchChange() {
    if (!isDisposed) {
      setState(() {
        selectedPhoneNumber = _phoneNumberController.text;
      });
    }
  }

  void _handlecostomernameSearchChange() {
    if (!isDisposed) {
      setState(() {
        selectedCustomerName = _costomernameController.text;
      });
    }
  }
void _handlepriceSearchChange() {
  if (!isDisposed) {
    setState(() {
      selectedPrice = _priceController.text;
    });
  }
}
void _handleordernumberSearchChange() {
  if (!isDisposed) {
    setState(() {
      selectedOrderNumber = _orderNumberController.text; // Fix: was selectedPhoneNumber
    });
  }
}
void _handleWeightSearchChange() {
  if (!isDisposed) {
    setState(() {
      selectedWeight = _weightController.text;
    });
  }
}
  Stream<List<String>> getDriverNamesStream() {
    return FirebaseFirestore.instance.collection('drivers').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => doc['username'] as String)
            .toSet()
            .toList());
  }

  Stream<List<String>> getPaymentmethodStream() {
    return FirebaseFirestore.instance.collection('orders').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => doc['طريقة الدفع'] as String)
            .toSet()
            .toList());
  }

  Stream<List<String>> getStatusStream() {
    return FirebaseFirestore.instance.collection('orders').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => doc['status'] as String)
            .toSet()
            .toList());
  }

  Stream<List<String>> getUsernamesStream() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => doc['username'] as String).toList());
  }

  Stream<List<String>> getCustomerNamesStream() {
    return FirebaseFirestore.instance.collection('orders').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => doc['اسم العميل'] as String)
            .toSet()
            .toList());
  }

  Stream<List<String>> getRegionsStream() {
    return FirebaseFirestore.instance.collection('orders').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => doc['المنطقة'] as String)
            .toSet()
            .toList());
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> getDriversStream() {
    return FirebaseFirestore.instance.collection('drivers').snapshots();
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
                      _buildScrollableOrderList(),
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
                  MaterialPageRoute(
                      builder: (context) => OrderManagementScreen()),
                );
              } else if (selectedValue1 == 'Order History') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
                );}
                else if (selectedValue1 == ' location') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LocationManagementScreen()),
                );
              } else if (selectedValue1 == 'Add Order') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DriversTrackingTable()),
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
          
          _buildDateRangePicker(),
          _buildDriverAssignedFilter(),
//todo
        ],
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
        color: isLogout
            ? Colors.red.withOpacity(0.1)
            : Colors.white.withOpacity(0.1),
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
    return Column(
      children: [
        SizedBox(height: 16),
        _buildFilterHeader(),
      ],
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
    return Expanded(
      child:Scrollbar2D(
            verticalScrollController: _verticalScrollController,
            horizontalScrollController: _horizontalScrollController,
        child: SizedBox(
          height: 1000,
          width: 2000,
          child: _buildFilteredOrderList(),
        ),
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Row(
      children:[
          SizedBox(
          width: 100,
          child: _buildFilterDropdown(
          stream: getUsernamesStream(),
          value: selectedUsername,
          hint: 'Username',
          onChanged: (value) => setState(() => selectedUsername = value),
        ),
        ),

        SizedBox(width: 16),
        SizedBox(
          width: 150, 
          child: _buildOrderNumberSearch(),
        ),
        SizedBox(width: 16),
        SizedBox(
          width: 150, // Set a fixed width as needed
          child: _buildPriceSearch(),
        ),

        SizedBox(width: 16),
        SizedBox(width: 150,
        child: Text("COD",textAlign: TextAlign.center,),
        ),
        SizedBox(
          width: 150, // Set a fixed width as needed
          child: _buildWeightSearch(),
        ),

        SizedBox(width: 16),
        SizedBox(
        width: 150, // Set a fixed width as needed
        child: _buildPhoneNumberSearch(),
        ),

     // todo


        SizedBox(width: 16),

          SizedBox(
          width: 100,
          child: _buildFilterDropdown(
          stream: getStatusStream(),
          value: selectedstatus,
          hint: 'الحاله',
          onChanged: (value) => setState(() => selectedstatus = value),
        ),
        ),

        SizedBox(width: 16),
Container(
  width: 150,
  child: CompositedTransformTarget(
    link: _layerLink,
    child: TextButton(
      onPressed: () {
        setState(() {
          if (_overlayEntry == null) {
            _showOverlay(context);
          } else {
            _overlayEntry?.remove();
            _overlayEntry = null;
          }
        });
      },
      child: const Text('المستقبل'
      ,textAlign: TextAlign.center,
      ),
    ),
  ),
),        

SizedBox(width: 16),
        SizedBox(
          width: 100, // Set a fixed width as needed
          child: _buildFilterDropdown(
            stream: getPaymentmethodStream(),
            value: selectedpaymentmethod,
            hint: 'paymentmethod',
            onChanged: (value) => setState(() => selectedpaymentmethod = value),
          ),
        ),

        SizedBox(width: 16),
        SizedBox(
          width: 100, // Set a fixed width as needed
          child: _buildFilterDropdown(
            stream: getDriverNamesStream(),
            value: selectedDriverName,
            hint: 'Driver',
            onChanged: (value) => setState(() => selectedDriverName = value),
          ),
        ),

      ],
    );
  }

  Widget _buildOrderCard(Order1 order, String orderId) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: order.isDriverAssigned
              ? secondaryColor.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderDetailsScreen(order: order, orderId: orderId),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox for selection
              Checkbox(
                value: selectedOrders.contains(order.orderNumber),
                onChanged: (bool? value) {
                  setState(() {
                    if (value ?? false) {
                      selectedOrders.add(order.orderNumber);
                    } else {
                      selectedOrders.remove(order.orderNumber);
                      selectAll = false;
                    }
                  });
                },
              ),
              // Profile Image
              SizedBox(
                width: 50, // Fixed width for Profile Image
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildProfileImage(order.profileImageUrl),
                ),
              ),
              // Username
              SizedBox(
                width: 150, // Fixed width for Username
                child: Text(
                  order.username,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
SizedBox(
  width: 150, // Fixed width for Order Number
  child: Row(
    children: [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: IconButton(
          icon: Icon(
            Icons.copy,
            size: 16,
            color: secondaryColor,
          ),
          constraints: BoxConstraints(
            minWidth: 20,
            minHeight: 20,
          ),
          padding: EdgeInsets.zero,
          tooltip: 'Copy Order Number',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: order.orderNumber)).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Order number copied to clipboard',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
            ),
           ),
            );
            }
            );
            },
            ),
      ),
            SizedBox(
              width: 100,
        child: Text(
          order.orderNumber,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        
      ),

    ],
  ),
),          

              SizedBox(
                width: 150, // Fixed width for Username
                child: Text(
                  order.price.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
                          SizedBox(
              width: 150,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: Text(
            order.COD.toString(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
      ),

            SizedBox(
              width: 150,
        child: Text(
          order.weight,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        
      ),
              SizedBox(
                width: 170, // Fixed width for Phone Number
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0), // Adjusted padding(),
                  child: Text(
                    order.phone.toString(),
                    style: GoogleFonts.poppins(),textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(
                width: 150, // Fixed width for Username
                child: Text(
                  order.status,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

    SizedBox(
                width: 150, // Fixed width for Customer Name
                child: Text(
                  
                  order.customerName,
                  style: GoogleFonts.poppins(),textAlign: TextAlign.center,
                ),
              ),
              // Phone Number
              // Region
              SizedBox(
                width: 150, // Fixed width for Region
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Text(
                    order.PaymentMethod,
                    style: GoogleFonts.poppins(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(
                width: 80, // Fixed width for Driver Dropdown
                child: _buildEnhancedDriverDropdown(order),
              ),
              // Action Buttons
              SizedBox(
                width: 80, // Fixed width for Action Buttons
                child: Row(
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
                        child: Icon(Icons.check_circle,
                            color: secondaryColor, size: 20),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
    return Container(
      child: CircleAvatar(
        backgroundImage:
            NetworkImage(imageUrl ?? 'https://via.placeholder.com/150'),
        radius: 20,
        onBackgroundImageError: (error, stackTrace) {
          // Handle image load errors
        },
      ),
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
                                    child:
                                        Icon(Icons.person, color: Colors.white),
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
                                  selected:
                                      selectedBatchDriver == driver['userid'],
                                  selectedTileColor:
                                      secondaryColor.withOpacity(0.1),
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
                        content: Text(
                            'Successfully assigned ${selectedOrders.length} orders to driver'),
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
  Widget _buildWeightSearch() {
  return Container(
    height: 48,
    child: WeightSearchWidget(
      label: "الوزن",
      onChanged: (value) {
        setState(() {
          selectedWeight = value;
        });
      },
      weightController: _weightController,
    ),
  );
}

Widget _buildPriceSearch() {
  return Container(
    height: 48,
    child: PriceSearchWidget(
        label: "السعر", // Add your label here

      onChanged: (value) {
        setState(() {
          selectedPrice = value; // You'll need to add this variable to your state
        });
      },
      priceController: _priceController, // Rename your controller variable
    ),
  );
}

  Widget _buildPhoneNumberSearch(){
    return Container(
      height: 48,
      child: PhoneNumberSearchWidget(
        label: "هاتف المستلم",

        onChanged: (value) {
          setState(() {
            selectedPhoneNumber = value;
          });
        },
        phoneNumberController: _phoneNumberController,
      ),
    );
  }
//todo

  Widget _buildOrderNumberSearch(){
    
    return Container(
      height: 48,
      child: OrderNumberSearchWidget(
        label: "رقم الطرد",

        onChanged: (value) {
          setState(() {
            selectedOrderNumber = value;
          });
        },
        orderNumberController: _orderNumberController,
      ),
    );
  }
  Widget _buildcostmernameSearch(){
    
    return Container(
      height: 48,
      child: CustomerNameSearchWidget(
        label: "رقم الطرد",

        onChanged: (value) {
          setState(() {
            selectedOrderNumber = value;
          });
        },
          customerNameController: _costomernameController,
      ),
    );
  }


// Update your _buildFilteredOrderList method to include the assign button
  Widget _buildFilteredOrderList() {
    return Column(
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
        if (selectedOrders.isNotEmpty) _buildAssignToDriverButton(),
        StreamBuilder<QuerySnapshot>(
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
                .map(
                    (doc) => Order1.fromMap(doc.data() as Map<String, dynamic>))
                .toList();
            var orderDocs = snapshot.data!.docs;

            orders = _applyFilters(orders);

            if (orders.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                        ],
                      ),
                    ),
                    _buildEnhancedFilters(),
                  ],
                ),

                // Enhanced Filters moved here, under Select All

                // Order list
                ...orders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final order = entry.value;
                  final orderId = orderDocs[index].id;
                  return _buildOrderCard(order, orderId);
                }).toList(),
              ],
            );
          },
        ),
      ],
    );
  }
  // Action Buttons Widget
void _clearAllFilters() {
  setState(() {
        selectedCustomerName = null;
    _costomernameController.clear();

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
    selectedPrice = null;
    selectedWeight = null;  // Add this line
    _searchController.clear();
    _phoneNumberController.clear();
    _orderNumberController.clear();
    _priceController.clear();
    _weightController.clear();  // Add this line
    selectedDrivers.clear();
    selectedOrders.clear();
    selectAll = false;
    selectedBatchDriver = null;
  });
}
List<Order1> _applyFilters(List<Order1> orders) {
  return orders.where((order) {
        bool matchesCustomer = selectedCustomerName == null || 
        selectedCustomerName!.isEmpty ||
        order.customerName.toLowerCase().contains(selectedCustomerName!.toLowerCase());

    bool matchesPrice = selectedPrice == null || 
        order.price.toString().contains(selectedPrice!);
    bool matchesWeight = selectedWeight == null || 
        order.weight.toString().contains(selectedWeight!);  // Add this line

    bool matchesUsername =
        selectedUsername == null || order.username == selectedUsername;
    bool matchesRegion =
        selectedRegion == null || order.region == selectedRegion;
    bool matchesOrderNumber = selectedOrderNumber == null ||
        order.orderNumber.toLowerCase().contains(selectedOrderNumber!.toLowerCase());
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
        matchesPrice &&
        matchesWeight &&  // Add this line
        matchesRegion &&
        matchesOrderNumber &&
        matchesPhoneNumber &&
        matchesDate &&
        matchesDriverAssigned;
  }).toList();
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
  if (selectedPrice != null) count++; // Add this line
  if (_searchController.text.isNotEmpty) count++;
  if (_phoneNumberController.text.isNotEmpty) count++;
  if (_orderNumberController.text.isNotEmpty) count++;
  if (_priceController.text.isNotEmpty) count++; // Add this line
    if (selectedWeight != null) count++;
  if (_weightController.text.isNotEmpty) count++;

  return count;
}

  bool _hasActiveFilters() {
    return _getActiveFilterCount() > 0;
  }
}
