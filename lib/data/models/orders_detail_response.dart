class OrdersDetailResponse {
  final int id;
  final int kg10;
  final int kg18;
  final int kg21;
  final int kg27;
  final int kg43;

  OrdersDetailResponse({
    required this.id,
    required this.kg10,
    required this.kg18,
    required this.kg21,
    required this.kg27,
    required this.kg43,
  });

  factory OrdersDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrdersDetailResponse(
      id: json["id"],
      kg10: json["kg10"],
      kg18: json["kg18"],
      kg21: json["kg21"],
      kg27: json["kg27"],
      kg43: json["kg43"],
    );
  }
}

class ClientResponse {
  final int id;
  final String address;
  final String name;

  ClientResponse({required this.id, required this.address, required this.name});

  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      id: json["id"],
      name: json["name"],
      address: json["address"],
    );
  }
}
