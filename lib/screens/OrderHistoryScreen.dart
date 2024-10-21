import 'package:durub_ali/screens/oders.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:durub_ali/models/models.dart';
import 'package:durub_ali/screens/detaels.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final Color primaryColor = Color(0xFF2C3E50);
  final Color secondaryColor = Color(0xFF3498DB);
  final Color accentColor = Color(0xFF34495E);

  String? selectedUsername;
  DateTime? selectedDate;

  Future<List<String>> getUsernames() {
    return FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.map((doc) => doc['username'] as String).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  elevation: 0,
  title: Text(
    'Order History',
    style: TextStyle(fontWeight: FontWeight.w600),
  ),
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderManagementScreen()),
      );
    },
  ),
),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _buildOrderList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildUsernameDropdown()),
          SizedBox(width: 16),
          Expanded(child: _buildDatePicker()),
        ],
      ),
    );
  }

  Widget _buildUsernameDropdown() {
    return FutureBuilder<List<String>>(
      future: getUsernames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No usernames available');
        }

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Filter by Username',
            border: OutlineInputBorder(),
          ),
          value: selectedUsername,
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
    );
  }

  Widget _buildDatePicker() {
    return ElevatedButton(
      child: Text(
        selectedDate == null
            ? 'Filter by Date'
            : 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
      ),
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
    );
  }

Widget _buildOrderList() {
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: "Completed")
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No completed orders found'));
      }

      var orders = snapshot.data!.docs
          .map((doc) => Order1.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Apply filters
      if (selectedUsername != null) {
        orders = orders.where((order) => order.username == selectedUsername).toList();
      }
      if (selectedDate != null) {
        final startOfDay = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);
        final endOfDay = startOfDay.add(Duration(days: 1));
        orders = orders.where((order) => 
          order.timestamp.isAfter(startOfDay) && order.timestamp.isBefore(endOfDay)
        ).toList();
      }

      if (orders.isEmpty) {
        return Center(child: Text('No matching orders found'));
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      );
    },
  );
}
  Widget _buildOrderCard(Order1 order) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(order.profileImageUrl),
        ),
        title: Text(order.customerName),
        subtitle: Text('Order #: ${order.orderNumber}'),
        trailing: Text(DateFormat('yyyy-MM-dd').format(order.timestamp)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(order: order, orderId: order.orderNumber),
            ),
          );
        },
      ),
    );
  }
}
