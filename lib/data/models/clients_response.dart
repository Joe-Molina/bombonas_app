class ClientsResponse {
  final int id;
  final String address;
  final String name;

  ClientsResponse({
    required this.id,
    required this.address,
    required this.name,
  });

  factory ClientsResponse.fromJson(Map<String, dynamic> json) {
    return ClientsResponse(
      id: json["id"],
      name: json["name"],
      address: json["address"],
    );
  }

  static List<ClientsResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ClientsResponse.fromJson(json)).toList();
  }
}
