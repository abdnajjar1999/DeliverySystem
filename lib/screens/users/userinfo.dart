import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durub_ali/screens/users/fatorah.dart';
import 'package:durub_ali/screens/users/users.dart';

class UserInfoScreen extends StatefulWidget {
  final Users user;

  UserInfoScreen({required this.user});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
    final Color primaryColor = Color(0xFF2C3E50);
  final Color accentColor = Color(0xFF3498DB);

  int completedOrdersCount = 0;
  int totalOrdersCount = 0;
  List<Map<String, dynamic>> userOrders = [];
  List<Map<String, dynamic>> filteredOrders = []; // Store filtered orders
  String selectedStatus = 'All'; // Filter by status
  DateTime? startDate; // Filter by start date
  DateTime? endDate; // Filter by end date
  List<String> statusOptions = ['All', 'Completed', 'Pending', 'Cancelled']; // Status filter options

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  // Fetch orders from Firestore based on the user's ID
  Future<void> fetchOrderData() async {
    try {

      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: widget.user.userId)
          .get();

      int completedOrders = 0;
      int totalOrders = ordersSnapshot.docs.length;

      List<Map<String, dynamic>> allOrders = [];

      // Iterate over all documents and count the completed ones
      for (var doc in ordersSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime orderTimestamp = data['timestamp']?.toDate() ?? DateTime.now();

        if (data['status'] == 'Completed') {
          completedOrders++;
        }

        // Prepare order data
        Map<String, dynamic> orderData = {
  'رقم الطلب': data['رقم الطلب'] ?? data['رقم الطلب'] ?? '',
  'مواصفات الطلب': data['مواصفات الطلب'] ?? data['مواصفات الطلب'] ?? '',
  'المنطقة': data['المنطقة'] ?? data['المنطقة'] ?? '',
  'السعر': data['السعر'] ??data['السعر'] ?? 0, 
  'status': data['status'] ?? '',
  'timestamp': orderTimestamp,
  'الملاحظات': data['الملاحظات'] ?? data['الملاحظات'] ?? '',
  'اسم العميل': data['اسم العميل'] ?? data['اسم العميل'] ?? '',
  'deliveryCost': data['deliveryCost'] ?? 0,
  'driverName': data['driverName'] ?? '',
  'isDriverAssigned': data['isDriverAssigned'] ?? false,
  'profileImageUrl': data['profileImageUrl'] ?? '',
  'userId': data['userId'] ?? '',
  'username': data['username'] ?? '',
        };

        allOrders.add(orderData);
      }

      setState(() {
        completedOrdersCount = completedOrders;
        totalOrdersCount = totalOrders;
        userOrders = allOrders; // All orders
        filteredOrders = allOrders; // Initially, no filters applied
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  // Function to apply filters to userOrders
  void applyFilters() {
    setState(() {
      filteredOrders = userOrders.where((order) {
        // Apply status filter
        bool matchesStatus = (selectedStatus == 'All' || order['status'] == selectedStatus);

        // Apply date range filter
        bool matchesDate = true;
        if (startDate != null && endDate != null) {
          DateTime orderDate = order['timestamp'];
          matchesDate = orderDate.isAfter(startDate!) && orderDate.isBefore(endDate!.add(Duration(days: 1)));
        }

        return matchesStatus && matchesDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.95),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text('User Information', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton.icon(
              icon: Icon(Icons.receipt_long, size: 20),
              label: Text('اصدار كشف'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryReceipt(userOrders: filteredOrders),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfoCard(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(),
                  SizedBox(height: 16),
                  _buildOrdersSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: NetworkImage(widget.user.profileImage),
                    child: widget.user.profileImage.isEmpty
                        ? Icon(Icons.person, color: Colors.grey, size: 40)
                        : null,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.user.email,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn('Status', 'Active', Icons.check_circle, Colors.green),
                _buildInfoColumn('Role', 'User', Icons.person, accentColor),
                _buildInfoColumn('Orders', '$completedOrdersCount/$totalOrdersCount', Icons.shopping_bag, accentColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, IconData icon, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accentColor.withOpacity(0.5)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                dropdownColor: primaryColor,
                style: TextStyle(color: Colors.white),
                icon: Icon(Icons.arrow_drop_down, color: accentColor),
                isExpanded: true,
                items: statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                    applyFilters();
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  'Start Date',
                  startDate,
                  () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: accentColor,
                              onPrimary: Colors.white,
                              surface: primaryColor,
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        startDate = picked;
                        applyFilters();
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDateButton(
                  'End Date',
                  endDate,
                  () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: startDate ?? DateTime(2000),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: accentColor,
                              onPrimary: Colors.white,
                              surface: primaryColor,
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        endDate = picked;
                        applyFilters();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime? date, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: accentColor.withOpacity(0.5)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        date == null ? label : date.toLocal().toString().split(' ')[0],
        style: TextStyle(color: date == null ? Colors.white70 : Colors.white),
      ),
    );
  }

  Widget _buildOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        if (filteredOrders.isEmpty)
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: accentColor.withOpacity(0.5)),
                  SizedBox(height: 16),
                  Text(
                    'No Orders Found',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(filteredOrders[index]);
            },
          ),
      ],
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        children:[
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                   
                  'Order #${order['رقم الطلب']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order['status'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderInfoRow('Description', order['مواصفات الطلب']),
                _buildOrderInfoRow('Region', order['المنطقة']??""),
                _buildOrderInfoRow('Price', order['السعر'].toString()),
                _buildOrderInfoRow('Date', order['timestamp'].toLocal().toString().split(' ')[0]),
                if (order['الملاحظات'].isNotEmpty)
                  _buildOrderInfoRow('Notes', order['الملاحظات']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
