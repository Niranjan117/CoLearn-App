import '../models/field_model.dart';
import '../models/disease_result_model.dart';
import '../models/capture_metadata_model.dart';
import '../models/user_model.dart';
import '../models/verification_model.dart';

/// All Phase 1 mock data — replace progressively with real API calls in Phase 2.
class MockDataService {
  MockDataService._();

  // ─── Farmer Profile ──────────────────────────────────────────
  static UserModel get currentUser => UserModel(
        id: 'farmer_001',
        fullName: 'Ramesh Kumar Patil',
        farmerId: 'KA-DWD-2024-04891',
        mobileNumber: '+91 98765 43210',
        district: 'Dharwad',
        state: 'Karnataka',
        totalFields: 6,
        verifiedFields: 4,
        joinedAt: DateTime(2024, 3, 15),
      );

  // ─── Field Polygons ──────────────────────────────────────────
  // Realistic coordinates near Dharwad, Karnataka agricultural region
  static List<FieldModel> get fields => [
        FieldModel(
          polygonId: 'POLY-KA-DWD-001',
          ownerName: 'Ramesh Kumar Patil',
          bhoomiLandId: 'KA-DWD-001-2024',
          cropType: 'Rice',
          fieldLabel: 'North Paddy Field',
          areHectares: 2.4,
          status: FieldStatus.verified,
          confidenceScore: 0.94,
          groundTruthVerified: true,
          district: 'Dharwad',
          state: 'Karnataka',
          centerLatitude: 15.4589,
          centerLongitude: 75.0078,
          lastVerifiedAt: DateTime(2024, 8, 20),
          coordinates: [
            const PolygonCoordinate(latitude: 15.4600, longitude: 75.0065),
            const PolygonCoordinate(latitude: 15.4610, longitude: 75.0090),
            const PolygonCoordinate(latitude: 15.4580, longitude: 75.0095),
            const PolygonCoordinate(latitude: 15.4570, longitude: 75.0070),
          ],
        ),
        FieldModel(
          polygonId: 'POLY-KA-DWD-002',
          ownerName: 'Ramesh Kumar Patil',
          bhoomiLandId: 'KA-DWD-002-2024',
          cropType: 'Cotton',
          fieldLabel: 'South Cotton Plot',
          areHectares: 1.8,
          status: FieldStatus.verified,
          confidenceScore: 0.88,
          groundTruthVerified: true,
          district: 'Dharwad',
          state: 'Karnataka',
          centerLatitude: 15.4540,
          centerLongitude: 75.0120,
          lastVerifiedAt: DateTime(2024, 8, 10),
          coordinates: [
            const PolygonCoordinate(latitude: 15.4550, longitude: 75.0105),
            const PolygonCoordinate(latitude: 15.4558, longitude: 75.0132),
            const PolygonCoordinate(latitude: 15.4530, longitude: 75.0138),
            const PolygonCoordinate(latitude: 15.4522, longitude: 75.0110),
          ],
        ),
        FieldModel(
          polygonId: 'POLY-KA-DWD-003',
          ownerName: 'Ramesh Kumar Patil',
          bhoomiLandId: 'KA-DWD-003-2024',
          cropType: 'Sugarcane',
          fieldLabel: 'East Sugarcane Field',
          areHectares: 3.1,
          status: FieldStatus.pending,
          confidenceScore: 0.72,
          groundTruthVerified: false,
          district: 'Dharwad',
          state: 'Karnataka',
          centerLatitude: 15.4620,
          centerLongitude: 75.0160,
          lastVerifiedAt: null,
          coordinates: [
            const PolygonCoordinate(latitude: 15.4635, longitude: 75.0145),
            const PolygonCoordinate(latitude: 15.4645, longitude: 75.0175),
            const PolygonCoordinate(latitude: 15.4605, longitude: 75.0180),
            const PolygonCoordinate(latitude: 15.4600, longitude: 75.0148),
          ],
        ),
        FieldModel(
          polygonId: 'POLY-KA-DWD-004',
          ownerName: 'Suresh Naik',
          bhoomiLandId: 'KA-DWD-004-2024',
          cropType: 'Wheat',
          fieldLabel: 'West Wheat Field',
          areHectares: 2.0,
          status: FieldStatus.unverified,
          confidenceScore: 0.51,
          groundTruthVerified: false,
          district: 'Dharwad',
          state: 'Karnataka',
          centerLatitude: 15.4500,
          centerLongitude: 75.0050,
          lastVerifiedAt: null,
          coordinates: [
            const PolygonCoordinate(latitude: 15.4515, longitude: 75.0035),
            const PolygonCoordinate(latitude: 15.4520, longitude: 75.0065),
            const PolygonCoordinate(latitude: 15.4490, longitude: 75.0068),
            const PolygonCoordinate(latitude: 15.4485, longitude: 75.0038),
          ],
        ),
        FieldModel(
          polygonId: 'POLY-KA-DWD-005',
          ownerName: 'Laxmi Devi Hosamani',
          bhoomiLandId: 'KA-DWD-005-2024',
          cropType: 'Maize',
          fieldLabel: 'Central Maize Plot',
          areHectares: 1.5,
          status: FieldStatus.verified,
          confidenceScore: 0.91,
          groundTruthVerified: true,
          district: 'Dharwad',
          state: 'Karnataka',
          centerLatitude: 15.4570,
          centerLongitude: 75.0200,
          lastVerifiedAt: DateTime(2024, 9, 1),
          coordinates: [
            const PolygonCoordinate(latitude: 15.4580, longitude: 75.0188),
            const PolygonCoordinate(latitude: 15.4585, longitude: 75.0212),
            const PolygonCoordinate(latitude: 15.4558, longitude: 75.0218),
            const PolygonCoordinate(latitude: 15.4555, longitude: 75.0192),
          ],
        ),
        FieldModel(
          polygonId: 'POLY-KA-DWD-006',
          ownerName: 'Ramesh Kumar Patil',
          bhoomiLandId: 'KA-DWD-006-2024',
          cropType: 'Groundnut',
          fieldLabel: 'Groundnut Plot B',
          areHectares: 0.9,
          status: FieldStatus.pending,
          confidenceScore: 0.68,
          groundTruthVerified: false,
          district: 'Dharwad',
          state: 'Karnataka',
          centerLatitude: 15.4648,
          centerLongitude: 75.0075,
          lastVerifiedAt: null,
          coordinates: [
            const PolygonCoordinate(latitude: 15.4655, longitude: 75.0062),
            const PolygonCoordinate(latitude: 15.4660, longitude: 75.0088),
            const PolygonCoordinate(latitude: 15.4638, longitude: 75.0091),
            const PolygonCoordinate(latitude: 15.4635, longitude: 75.0065),
          ],
        ),
      ];

  // ─── Disease Results ─────────────────────────────────────────
  static List<DiseaseResult> get diseaseResults => [
        DiseaseResult(
          id: 'disease_001',
          diseaseName: 'Brown Leaf Spot',
          scientificName: 'Helminthosporium oryzae',
          cropType: 'Rice',
          severity: DiseaseSeverity.moderate,
          confidenceScore: 0.87,
          description:
              'Brown leaf spot is a fungal disease caused by Helminthosporium oryzae. '
              'It produces oval to circular brown spots on leaves, which can lead to '
              'significant yield loss if left untreated.',
          affectedAreaPercent: 35.0,
          analyzedAt: DateTime(2024, 9, 5, 10, 30),
          isHealthy: false,
          treatments: const [
            TreatmentRecommendation(
              title: 'Apply Fungicide',
              description: 'Spray Tricyclazole or Iprodione-based fungicide at recommended dosage',
              iconCode: 'e7e1',
              isUrgent: true,
            ),
            TreatmentRecommendation(
              title: 'Improve Drainage',
              description: 'Ensure proper water drainage to reduce field humidity',
              iconCode: 'e798',
            ),
            TreatmentRecommendation(
              title: 'Balanced Fertilization',
              description: 'Reduce nitrogen, increase potassium and phosphorus',
              iconCode: 'ebdc',
            ),
          ],
        ),
        DiseaseResult(
          id: 'disease_002',
          diseaseName: 'Healthy Plant',
          scientificName: '—',
          cropType: 'Cotton',
          severity: DiseaseSeverity.healthy,
          confidenceScore: 0.95,
          description:
              'The plant appears healthy with no visible signs of disease or stress. '
              'Continue current crop management practices.',
          affectedAreaPercent: 0.0,
          analyzedAt: DateTime(2024, 8, 28, 14, 20),
          isHealthy: true,
          treatments: [],
        ),
        DiseaseResult(
          id: 'disease_003',
          diseaseName: 'Powdery Mildew',
          scientificName: 'Erysiphe graminis',
          cropType: 'Wheat',
          severity: DiseaseSeverity.mild,
          confidenceScore: 0.79,
          description:
              'Powdery mildew appears as white powdery patches on leaves and stems. '
              'Early-stage infection is manageable with proper fungicide application.',
          affectedAreaPercent: 15.0,
          analyzedAt: DateTime(2024, 8, 15, 9, 0),
          isHealthy: false,
          treatments: const [
            TreatmentRecommendation(
              title: 'Apply Sulphur-based Fungicide',
              description: 'Use wettable sulphur at 3g/litre of water',
              iconCode: 'e7e1',
            ),
            TreatmentRecommendation(
              title: 'Remove Infected Parts',
              description: 'Prune and destroy heavily infected leaves',
              iconCode: 'e872',
              isUrgent: false,
            ),
          ],
        ),
      ];

  // ─── Verification Records ─────────────────────────────────────
  static List<VerificationRecord> get verificationHistory => [
        VerificationRecord(
          id: 'ver_001',
          userId: 'farmer_001',
          metadata: CaptureMetadata(
            userLat: 15.4595,
            userLng: 75.0082,
            gpsScore: 4.2,
            compassDeg: 12.0,
            inputCropType: 'Rice',
            capturedAt: DateTime(2024, 9, 5, 10, 28),
          ),
          status: VerificationStatus.matched,
          matchedPolygonId: 'POLY-KA-DWD-001',
          matchConfidence: 0.94,
          matchedField: fields[0],
          diseaseResultId: 'disease_001',
          createdAt: DateTime(2024, 9, 5, 10, 30),
        ),
        VerificationRecord(
          id: 'ver_002',
          userId: 'farmer_001',
          metadata: CaptureMetadata(
            userLat: 15.4542,
            userLng: 75.0118,
            gpsScore: 6.8,
            compassDeg: 195.0,
            inputCropType: 'Cotton',
            capturedAt: DateTime(2024, 8, 28, 14, 18),
          ),
          status: VerificationStatus.matched,
          matchedPolygonId: 'POLY-KA-DWD-002',
          matchConfidence: 0.88,
          matchedField: fields[1],
          diseaseResultId: 'disease_002',
          createdAt: DateTime(2024, 8, 28, 14, 20),
        ),
        VerificationRecord(
          id: 'ver_003',
          userId: 'farmer_001',
          metadata: CaptureMetadata(
            userLat: 15.4650,
            userLng: 75.0078,
            gpsScore: 15.3,
            compassDeg: 88.0,
            inputCropType: 'Groundnut',
            capturedAt: DateTime(2024, 8, 20, 8, 45),
          ),
          status: VerificationStatus.pending,
          matchedPolygonId: 'POLY-KA-DWD-006',
          matchConfidence: 0.68,
          matchedField: fields[5],
          createdAt: DateTime(2024, 8, 20, 8, 47),
        ),
        VerificationRecord(
          id: 'ver_004',
          userId: 'farmer_001',
          metadata: CaptureMetadata(
            userLat: 15.4380,
            userLng: 74.9950,
            gpsScore: 22.1,
            compassDeg: 270.0,
            inputCropType: 'Wheat',
            capturedAt: DateTime(2024, 8, 15, 9, 0),
          ),
          status: VerificationStatus.failed,
          createdAt: DateTime(2024, 8, 15, 9, 2),
          notes: 'Location too far from any registered polygon',
        ),
      ];

  // ─── Stats ───────────────────────────────────────────────────
  static VerificationStats get stats => const VerificationStats(
        totalAnalyses: 24,
        matchedFields: 19,
        pendingReviews: 3,
        failedMatches: 2,
        thisMonthAnalyses: 7,
      );
}
