/// Farmer / App user profile
class UserModel {
  final String id;
  final String fullName;
  final String farmerId; // Government issued farmer ID
  final String mobileNumber;
  final String district;
  final String state;
  final String? avatarUrl;
  final int totalFields;
  final int verifiedFields;
  final DateTime joinedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.farmerId,
    required this.mobileNumber,
    required this.district,
    required this.state,
    this.avatarUrl,
    required this.totalFields,
    required this.verifiedFields,
    required this.joinedAt,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'F';
  }

  int get pendingFields => totalFields - verifiedFields;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      farmerId: json['farmer_id'] as String,
      mobileNumber: json['mobile_number'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      avatarUrl: json['avatar_url'] as String?,
      totalFields: json['total_fields'] as int,
      verifiedFields: json['verified_fields'] as int,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }
}
