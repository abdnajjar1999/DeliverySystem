import 'package:cloud_firestore/cloud_firestore.dart';

class Order1 {
  String profileImageUrl;
  DateTime timestamp;
  String userId;
  String username;
  String customerName;
  String price;
  String notes;
  String region;
  String orderNumber;
  String orderSpecifications;
  bool isDriverAssigned;
  double deliveryCost;
  bool isCompleted;
  String? driverName; 
  String? phone; 
String location;
  Order1({
     this.phone,
    required this.profileImageUrl,
    required this.timestamp,
    required this.userId,
    required this.username,
    required this.customerName,
    required this.price,
    required this.notes,
    required this.region,
    required this.orderNumber,
    required this.orderSpecifications,
    required this.isDriverAssigned,
    required this.deliveryCost,
    this.isCompleted = false,
    this.driverName,
    required this.location
  });

  // Create an Order1 object from Firestore data (fromMap)
  factory Order1.fromMap(Map<String, dynamic> data) {
    return Order1(
      profileImageUrl: data['profileImageUrl'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      customerName: data['اسم العميل'] ?? '',
      price: data['السعر'].toString() ?? "",
      notes: data['الملاحظات'] ?? '',
      region: data['المنطقة'] ?? '',
      orderNumber: data['رقم الطلب'] ?? '',
      orderSpecifications: data['مواصفات الطلب'] ?? '',
      isDriverAssigned: data['isDriverAssigned'] ?? false,
      deliveryCost: data['deliveryCost']?.toDouble() ?? 0.0,
      isCompleted: data['isCompleted'] ?? false,
      driverName: data['driverName'] ?? null,  // Retrieve driverName if available
      phone: data['رقم الهاتف'] ?? null, 
      location: data['رابط خريطة جوجل'] ?? '',
    );
  }

  // Convert the Order1 object to a map to store it in Firestore (toMap)
  Map<String, dynamic> toMap() {
    return {
      'profileImageUrl': profileImageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
      'username': username,
      'اسم العميل': customerName,
      'السعر': price,
      'الملاحظات': notes,
      'المنطقة': region,
      'رقم الطلب': orderNumber,
      'مواصفات الطلب': orderSpecifications,
      'isDriverAssigned': isDriverAssigned,
      'deliveryCost': deliveryCost,
      'isCompleted': isCompleted,
      'driverName': driverName,  // Add driverName to the map if not null
      'رقم الهاتف': phone, 
      'رابط خريطة جوجل': location 
    };
  }
}
