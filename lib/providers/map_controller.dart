import 'package:flutter/foundation.dart';
import '../models/field_model.dart';
import '../services/polygon_service.dart';

/// State for the map screen — polygon data, selection, filters
class MapController extends ChangeNotifier {
  List<FieldModel> _allFields = [];
  List<FieldModel> get allFields => _allFields;

  FieldModel? _selectedField;
  FieldModel? get selectedField => _selectedField;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  FieldStatus? _filterStatus;
  FieldStatus? get filterStatus => _filterStatus;

  String? _filterCrop;
  String? get filterCrop => _filterCrop;

  List<FieldModel> get filteredFields {
    var result = _allFields;
    if (_filterStatus != null) {
      result = result.where((f) => f.status == _filterStatus).toList();
    }
    if (_filterCrop != null && _filterCrop!.isNotEmpty) {
      result = result.where((f) => f.cropType.toLowerCase() == _filterCrop!.toLowerCase()).toList();
    }
    return result;
  }

  Future<void> loadPolygons() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allFields = await PolygonService.instance.fetchAllPolygons();
    } catch (e) {
      _error = 'Failed to load field data. Please check your connection.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectField(FieldModel? field) {
    _selectedField = field;
    notifyListeners();
  }

  void clearSelection() {
    _selectedField = null;
    notifyListeners();
  }

  void setStatusFilter(FieldStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setCropFilter(String? crop) {
    _filterCrop = crop;
    notifyListeners();
  }

  void clearFilters() {
    _filterStatus = null;
    _filterCrop = null;
    notifyListeners();
  }
}
