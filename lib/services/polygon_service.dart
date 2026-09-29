import '../config/app_config.dart';
import '../models/field_model.dart';
import 'api_service.dart';

/// Service responsible for fetching agricultural field polygon data.
/// ============================================================
/// INTEGRATION POINT (Phase 2)
/// Replace mock data with real Supabase REST API calls.
/// Supabase table: 'field_polygons'
/// GET ${AppConfig.supabaseUrl}/rest/v1/field_polygons
/// Headers: apikey, Authorization (supabase anon key)
/// ============================================================
class PolygonService {
  PolygonService._();
  static final PolygonService instance = PolygonService._();

  /// Fetch all available field polygons
  Future<List<FieldModel>> fetchAllPolygons() async {
    return _fetchFromSupabase();
  }

  /// Fetch polygons belonging to a specific user
  Future<List<FieldModel>> fetchUserPolygons(String userId) async {
    final all = await fetchAllPolygons();
    return all.where((f) => f.assignedByUserId == userId).toList();
  }

  /// Fetch a single polygon by ID
  Future<FieldModel?> fetchPolygonById(String polygonId) async {
    final all = await fetchAllPolygons();
    try {
      return all.firstWhere((f) => f.polygonId == polygonId);
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // INTEGRATION POINT (Phase 2)
  // Real Supabase polygon fetch implementation
  // ============================================================
  Future<List<FieldModel>> _fetchFromSupabase() async {
    final url =
        '${AppConfig.supabaseUrl}/rest/v1/Polygons'
        '?select=*&limit=60&offset=0';
    final response = await ApiService.instance.get(url, useSupabase: true);
    if (response is! List) return const [];

    final fields = <FieldModel>[];
    for (final row in response.whereType<Map>()) {
      try {
        final field = FieldModel.fromJson(Map<String, dynamic>.from(row));
        if (field.coordinates.length >= 3) fields.add(field);
      } on FormatException {
        // A row without drawable geometry cannot be rendered on the map.
      }
    }
    return fields;
  }

  Future<void> markGroundTruth({
    required String polygonId,
    required String cropType,
    required double confidence,
  }) async {
    if (!AppConfig.enableLiveMaps) return;
    final url =
        '${AppConfig.supabaseUrl}/rest/v1/Polygons'
        '?polygon_id=eq.${Uri.encodeComponent(polygonId)}';
    await ApiService.instance.patch(url, {
      'ground_truth': true,
      'crop_type': cropType,
      'confidence_mean': confidence,
    }, useSupabase: true);
  }
}
