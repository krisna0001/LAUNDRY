class Order {
  final String? id;
  final String customerName;
  final String serviceType; // cuci baju, sepatu, bedcover, dll
  final double totalCost;
  final String address;
  final DateTime orderDate;
  final String status; // pending, pickup, washing, ready, completed
  final String? notes;

  Order({
    this.id,
    required this.customerName,
    required this.serviceType,
    required this.totalCost,
    required this.address,
    required this.orderDate,
    this.status = 'pending',
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'customer_name': customerName,
      'service_type': serviceType,
      'total_cost': totalCost,
      'address': address,
      'order_date': orderDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, String docId) {
    return Order(
      id: docId,
      customerName: map['customer_name'] ?? '',
      serviceType: map['service_type'] ?? '',
      totalCost: (map['total_cost'] ?? 0).toDouble(),
      address: map['address'] ?? '',
      orderDate: DateTime.parse(
        map['order_date'] ?? DateTime.now().toIso8601String(),
      ),
      status: map['status'] ?? 'pending',
      notes: map['notes'],
    );
  }
}
