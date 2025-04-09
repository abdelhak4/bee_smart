import 'package:flutter/material.dart';
import '../utils/mock_data.dart';

class ApiaryProvider extends ChangeNotifier {
  List<String> _locations = [];
  String _activeLocation = '';
  
  ApiaryProvider() {
    // Initialize with mock data
    _locations = MockData.locations;
    _activeLocation = _locations.isNotEmpty ? _locations[0] : '';
  }
  
  List<String> get locations => _locations;
  String get activeLocation => _activeLocation;
  
  void setActiveLocation(String location) {
    if (_locations.contains(location) && _activeLocation != location) {
      _activeLocation = location;
      notifyListeners();
    }
  }
  
  void addLocation(String name) {
    if (!_locations.contains(name)) {
      _locations.add(name);
      notifyListeners();
    }
  }
  
  void removeLocation(String name) {
    if (_locations.contains(name) && _locations.length > 1) {
      _locations.remove(name);
      
      if (_activeLocation == name) {
        _activeLocation = _locations[0];
      }
      
      notifyListeners();
    }
  }
}