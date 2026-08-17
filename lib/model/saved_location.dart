class SavedLocation {
  final String type;
  final String name;

  double? latitude;
  double? longitude;
  String? address;

  SavedLocation({
    required this.type,
    required this.name,
    this.latitude,
    this.longitude,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory SavedLocation.fromJson(
    Map<String, dynamic> json,
  ) {
    return SavedLocation(
      type: json['type'] ?? 'Khác',
      name: json['name'] ?? '',
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      address: json['address'],
    );
  }
}