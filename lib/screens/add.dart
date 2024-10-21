import 'package:durub_ali/screens/oders.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homescreen extends StatefulWidget {
  static const screenRoute = '/home';

  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? username;
  String? profileImageUrl;
  String? selectedUserId;
  String? selectedUsername;
  String? selectedProfileImage;

  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Function to fetch users from Firestore
  Future<void> _fetchUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    setState(() {
      users = snapshot.docs
          .map((doc) => {
                'userId': doc.id,
                'username': doc['username'],
                'profileImage': doc['profileImage'] ?? 'https://via.placeholder.com/150',
              })
          .toList();
    });
  }

  // Function to save order to Firestore
  Future<void> saveOrder() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        double? price = double.tryParse(priceController.text);

        if (price == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid price')),
          );
          return;
        }

        await _firestore.collection('orders').add({
          'رقم الطلب': orderNumberController.text,
          'اسم العميل': customerNameController.text,
          'المنطقة': regionController.text,
          'السعر': price,
          'مواصفات الطلب': descriptionController.text,
          'الملاحظات': notesController.text,
          'رقم الهاتف': phoneController.text,
          'userId': selectedUserId, // Store selected user ID
          'username': selectedUsername, // Store selected username
          'profileImageUrl': selectedProfileImage, // Store selected profile image
          'status': 'null',
          'deliveryCost': 0.0,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear the form after saving
        orderNumberController.clear();
        customerNameController.clear();
        regionController.clear();
        priceController.clear();
        descriptionController.clear();
        notesController.clear();
        phoneController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
appBar: AppBar(
  elevation: 0,
  title: Text(
    'Order Details',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'تفاصيل الطلب',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        const SizedBox(height: 20),

                        // User selection dropdown
                        DropdownButtonFormField<String>(
                          value: selectedUserId,
                          hint: Text('اختر المستخدم'),
                          items: users.map((user) {
                            return DropdownMenuItem<String>(
                              value: user['userId'],
                              child: Text(user['username']),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedUserId = newValue;
                              selectedUsername = users
                                  .firstWhere((user) => user['userId'] == newValue)['username'];
                              selectedProfileImage = users
                                  .firstWhere((user) => user['userId'] == newValue)['profileImage'];
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                        _buildFormField(width, 'رقم الطلب', Icons.assignment_outlined, orderNumberController),
                        _buildFormField(width, 'اسم العميل', Icons.person_outline, customerNameController),
                        _buildFormField(width, 'المنطقة', Icons.location_on_outlined, regionController),
                        _buildFormField(width, 'رقم الهاتف', Icons.phone_outlined, phoneController),
                        _buildFormField(width, 'السعر', Icons.attach_money_outlined, priceController),
                        _buildFormField(width, 'مواصفات الطلب', Icons.description_outlined, descriptionController, maxLines: 2),
                        _buildFormField(width, 'الملاحظات', Icons.notes_outlined, notesController, maxLines: 4),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: saveOrder,
                          child: Text('احفظ الطلب'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(double width, String label, IconData icon, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
