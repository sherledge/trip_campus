import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/package.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import jsonDecode

// Provider for fetching packages from Firebase Firestore
final packagesProvider = StreamProvider<List<Package>>((ref) {
  return FirebaseFirestore.instance
      .collection('packages')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Package.fromFirestore(doc)).toList());
});

// PackageNotifier to manage fetching and storing packages
class PackageNotifier extends StateNotifier<List<Package>> {
  PackageNotifier() : super([]) {
    fetchPackages(); // Fetch packages on initialization
  }

  Future<void> fetchPackages() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection("packages").get();
      final packages = snapshot.docs.map((doc) => Package.fromFirestore(doc)).toList();
      state = packages;
    } catch (e) {
      print("Error fetching packages: $e");
    }
  }
}

// FavoritePackagesNotifier to manage favorite packages with state persistence
final favoritePackagesProvider = StateNotifierProvider<FavoritePackagesNotifier, List<Package>>((ref) {
  return FavoritePackagesNotifier();
});

class FavoritePackagesNotifier extends StateNotifier<List<Package>> {
  FavoritePackagesNotifier() : super([]) {
    _loadFavorites(); // Load favorite packages from shared preferences when initialized
  }

  // Load favorite packages from shared preferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedFavorites = prefs.getString('favoritePackages');
    if (storedFavorites != null) {
      final List<dynamic> decodedList = jsonDecode(storedFavorites);
      final List<Package> loadedPackages = decodedList.map((item) => Package.fromJson(item)).toList();
      state = loadedPackages;
    }
  }

  // Save the current list of favorite packages to shared preferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> encodedList = state.map((package) => package.toJson()).toList();
    await prefs.setString('favoritePackages', jsonEncode(encodedList));
  }

  // Toggle favorite status for a package
  void toggleFavorite(Package package) async {
    // Check if the package is already in the favorites list
    if (state.any((p) => p.id == package.id)) {
      // If already favorited, remove it
      state = state.where((p) => p.id != package.id).toList();
    } else {
      // Otherwise, add it to the list
      state = [...state, package];
    }
    // Save the updated favorite packages list
    await _saveFavorites();
  }

  // Get whether a package is in the favorites list
  bool isFavorite(Package package) {
    return state.any((p) => p.id == package.id);
  }
}
