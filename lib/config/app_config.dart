// CoLearn App Configuration
// ============================================================
// National Council for Cooperative Training (NCCT)
// Ministry of Cooperation, Government of India
// ============================================================

class AppConfig {
  AppConfig._();

  // App Metadata
  static const String appName = 'CoLearn';
  static const String appTagline = 'National Cooperative Learning Ecosystem';
  static const String appMinistry = 'Ministry of Cooperation • Government of India';
  static const String councilName = 'National Council for Cooperative Training (NCCT)';
  static const String appVersion = '2.4.0';

  // Apex Institute and Regional Institutes
  static const String apexInstitute = 'Vaikunth Mehta National Institute of Cooperative Management (VAMNICOM), Pune';
  static const List<String> regionalInstitutes = [
    'VAMNICOM, Pune (Apex National)',
    'RICM Bengaluru, Karnataka',
    'RICM Gandhinagar, Gujarat',
    'RICM Chandigarh, Punjab & Haryana',
    'RICM Kalyani, West Bengal',
    'RICM Patna, Bihar',
    'ICM Lucknow, Uttar Pradesh',
    'ICM Bhopal, Madhya Pradesh',
    'ICM Chennai, Tamil Nadu',
    'ICM Hyderabad, Telangana',
    'ICM Jaipur, Rajasthan',
    'ICM Guwahati, Assam',
    'ICM Thiruvananthapuram, Kerala',
    'ICM Dehradun, Uttarakhand',
  ];

  // Verification Portal URL
  static const String verificationBaseUrl = 'https://ncct.gov.in/verify';

  // Feature Flags
  static const bool enableVR360 = true;
  static const bool enableCardboardMode = true;
  static const bool enableWebXR = true;
  static const bool enableQuizzes = true;
  static const bool enableCertificates = true;
  static const bool enableJobBoard = true;
  static const bool enableGeoAttendance = true;
}
