import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:durub_ali/widget/buildtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:durub_ali/models/models.dart';




class OrderDetailsScreen extends StatefulWidget {
  final Order1 order;
  final String orderId;

  const OrderDetailsScreen({Key? key, required this.order, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late TextEditingController usernameController;
  late TextEditingController customerNameController;
  late TextEditingController priceController;
  late TextEditingController notesController;
  late TextEditingController regionController;
  late TextEditingController orderNumberController;
  late TextEditingController orderSpecificationsController;
  late TextEditingController deliveryCostController;
  late DateTime selectedDate;
  late TextEditingController phoneController; // Phone controller added
  late TextEditingController LocationController; // Phone controller added

  @override
  void initState() {
    super.initState();
    LocationController=TextEditingController(text: widget.order.location);
    phoneController = TextEditingController(text: widget.order.phone); // Initialize phone controller
    usernameController = TextEditingController(text: widget.order.username);
    customerNameController = TextEditingController(text: widget.order.customerName);
    priceController = TextEditingController(text: widget.order.price.toString());
    notesController = TextEditingController(text: widget.order.notes);
    regionController = TextEditingController(text: widget.order.region);
    orderNumberController = TextEditingController(text: widget.order.orderNumber);
    orderSpecificationsController = TextEditingController(text: widget.order.orderSpecifications);
    deliveryCostController = TextEditingController(text: widget.order.deliveryCost.toString());
    selectedDate = widget.order.timestamp;
  }

  @override
  void dispose() {
    usernameController.dispose();
    customerNameController.dispose();
    priceController.dispose();
    notesController.dispose();
    regionController.dispose();
    orderNumberController.dispose();
    orderSpecificationsController.dispose();
    deliveryCostController.dispose();
    phoneController.dispose(); // Dispose phone controller
    LocationController.dispose(); // Dispose location controller
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveOrder() {
    cloud_firestore.FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({

      'رقم الهاتف': phoneController.text, // Save phone number
      'username': usernameController.text,
      'اسم العميل': customerNameController.text,
      'السعر': double.parse(priceController.text),
      'الملاحظات': notesController.text,
      'المنطقة': regionController.text,
      'رقم الطلب': orderNumberController.text,
      'مواصفات الطلب': orderSpecificationsController.text,
      'deliveryCost': double.parse(deliveryCostController.text),
      'timestamp': cloud_firestore.Timestamp.fromDate(selectedDate), 
            'رابط خريطة جوجل': LocationController.text, 

    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order updated successfully!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update order: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
        elevation: 0,
        title: Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2C3E50),
                Color(0xFF3498DB),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: _saveOrder,
            tooltip: 'Save Order',
          ),
        ],

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C3E50),
              Color(0xFF3498DB),
            ],
            stops: [0.0, 0.3],
          ),
        ), 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[900],
                          ),
                        ),
                        SizedBox(height: 20),
                        buildFormSection(),
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

  Widget buildFormSection() {
    return Column(
      children: [
        BuildTextFormField(
          width: MediaQuery.of(context).size.width,
          hintText: "Username",
          label: "Username",
          iconData: Icons.person,
          enabled: true,
          controller: usernameController,
          decorationType: FormFieldDecorationType.outlined,
        ),
        SizedBox(height: 16),
        BuildTextFormField(
          width: MediaQuery.of(context).size.width,
          hintText: "Customer Name",
          label: "Customer Name",
          iconData: Icons.person_outline,
          enabled: true,
          controller: customerNameController,
          decorationType: FormFieldDecorationType.outlined,
        ),
        SizedBox(height: 16),
        BuildTextFormField(
          width: MediaQuery.of(context).size.width,
          hintText: "Phone Number", // Field to display phone number
          label: "Phone Number",
          iconData: Icons.phone,
          enabled: true,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decorationType: FormFieldDecorationType.outlined,
        ),
                SizedBox(height: 16),

        BuildTextFormField(
          width: MediaQuery.of(context).size.width,
          hintText: "location", // Field to display phone number
          label: "location",
          iconData: Icons.location_on,
          enabled: true,
          controller: LocationController,
          keyboardType: TextInputType.emailAddress,
          decorationType: FormFieldDecorationType.outlined,
        ),
        
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BuildTextFormField(
                width: MediaQuery.of(context).size.width,
                hintText: "Price",
                label: "Price",
                iconData: Icons.attach_money,
                enabled: true,
                controller: priceController,
                keyboardType: TextInputType.number,
                decorationType: FormFieldDecorationType.outlined,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: BuildTextFormField(
                width: MediaQuery.of(context).size.width,
                hintText: "Delivery Cost",
                label: "Delivery Cost",
                iconData: Icons.local_shipping,
                enabled: true,
                controller: deliveryCostController,
                keyboardType: TextInputType.number,
                decorationType: FormFieldDecorationType.outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        BuildTextFormField(
          width: MediaQuery.of(context).size.width,
          hintText: "Region",
          label: "Region",
          iconData: Icons.location_on,
          enabled: true,
          controller: regionController,
          decorationType: FormFieldDecorationType.outlined,
        ),
        SizedBox(height: 16),
        BuildTextFormField(
          width: MediaQuery.of(context).size.width,
          hintText: "Order Number",
          label: "Order Number",
          iconData: Icons.confirmation_number,
          enabled: true,
          controller: orderNumberController,
          decorationType: FormFieldDecorationType.outlined,
        ),
        SizedBox(height: 16),
        BuildTextFormField(
          width: MediaQuery.of(context).size.width,
          hintText: "Order Specifications",
          label: "Order Specifications",
          iconData: Icons.description,
          enabled: true,
          controller: orderSpecificationsController,
          maxLines: 3,
          decorationType: FormFieldDecorationType.outlined,
        ),
        SizedBox(height: 16),
        BuildTextFormField(
          width: MediaQuery.of(context).size.width,
          hintText: "Notes",
          label: "Notes",
          iconData: Icons.note,
          enabled: true,
          controller: notesController,
          maxLines: 3,
          decorationType: FormFieldDecorationType.outlined,
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: BuildTextFormField(
            width: MediaQuery.of(context).size.width,
            hintText: "Select Date",
            label: "Order Date",
            iconData: Icons.calendar_today,
            enabled: false,
            initialValue: DateFormat('yyyy-MM-dd').format(selectedDate),
            decorationType: FormFieldDecorationType.outlined,
          ),
        ),
      ],
    );
  }
}
