class Address {
  final String? countryName;
  final String? state;
  final String? countryCode;
  final String? city;
  final String? fullAdress;

  Address({
    this.countryName,
    this.state,
    this.countryCode,
    this.city,
    this.fullAdress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      countryName: json['countryName'],
      state: json['state'],
      countryCode: json['countryCode'],
      city: json['city'],
      fullAdress: json['fullAdress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryName': countryName,
      'state': state,
      'countryCode': countryCode,
      'city': city,
      'fullAdress': fullAdress,
    };
  }
}