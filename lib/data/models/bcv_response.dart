class BcvResponse {
  final double price;

  BcvResponse({required this.price});

  factory BcvResponse.fromJson(Map<String, dynamic> json) {
    return BcvResponse(price: json["promedio"]);
  }
}
