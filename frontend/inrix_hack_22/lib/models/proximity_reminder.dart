const String tableProximity = 'proximity';

class ProximityFields {
  static final List<String> values = [
    id,
    longitude,
    latitude,
    proximity,
    phoneNumber,
    phoneNumberName
  ];

  static const String id = '_id';
  static const String longitude = 'longitude';
  static const String latitude = 'latitude';
  static const String proximity = 'proximity';
  static const String phoneNumber = 'phoneNumber';
  static const String phoneNumberName = 'phoneNumberName';
}

class ProximityReminder {
  final int? id;
  final double longitude;
  final double latitude;
  final double proximity;
  final String phoneNumber;
  final String phoneNumberName;

  const ProximityReminder({
    this.id,
    required this.longitude,
    required this.latitude,
    required this.proximity,
    required this.phoneNumber,
    required this.phoneNumberName,
  });

  ProximityReminder copy({
    int? id,
    double? longitude,
    double? latitude,
    double? proximity,
    String? phoneNumber,
    String? phoneNumberName,
  }) =>
      ProximityReminder(
        id: id ?? this.id,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        proximity: proximity ?? this.proximity,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        phoneNumberName: phoneNumberName ?? this.phoneNumberName,
      );

  Map<String, Object?> toJson() => {
        ProximityFields.id: id,
        ProximityFields.longitude: longitude,
        ProximityFields.latitude: latitude,
        ProximityFields.proximity: proximity,
        ProximityFields.phoneNumber: phoneNumber,
        ProximityFields.phoneNumberName: phoneNumberName
      };

  static ProximityReminder fromJson(Map<String, Object?> json) =>
      ProximityReminder(
        id: json[ProximityFields.id] as int?,
        longitude: json[ProximityFields.longitude] as double,
        latitude: json[ProximityFields.latitude] as double,
        proximity: json[ProximityFields.proximity] as double,
        phoneNumber: json[ProximityFields.phoneNumber] as String,
        phoneNumberName: json[ProximityFields.phoneNumberName] as String,
      );
}
