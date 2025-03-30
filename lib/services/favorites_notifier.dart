import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_campus/models/package.dart';

// Provider for managing favorites
final favoritePackagesProvider = StateNotifierProvider<FavoritePackagesNotifier, List<Package>>(
  (ref) => FavoritePackagesNotifier(),
);

// FavoritePackagesNotifier class
// FavoritePackagesNotifier class
class FavoritePackagesNotifier extends StateNotifier<List<Package>> {
  FavoritePackagesNotifier() : super([]) {
    _loadFavorites();
  }

  // Load favorites from shared preferences
  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedFavorites = prefs.getStringList('favorites');

    if (storedFavorites != null) {
      // Assuming that Package has a method to load from ID or directly from some data source
      // You may need to fetch the full Package details from your database
      List<Package> loadedPackages = await Future.wait(storedFavorites.map((id) async {
        // Here, load the full package details using the id.
        return await fetchPackageDetailsById(id);
      }));

      state = loadedPackages; // Update the state with the full Package data
    }
  }

  // Toggle favorite status for a package
  void toggleFavorite(Package package) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = List<String>.from(prefs.getStringList('favorites') ?? []);

    if (currentFavorites.contains(package.id)) {
      currentFavorites.remove(package.id); // Remove from favorites
    } else {
      currentFavorites.add(package.id); // Add to favorites
    }

    await prefs.setStringList('favorites', currentFavorites); // Save favorites list

    // Update the state
    List<Package> updatedPackages = await Future.wait(currentFavorites.map((id) async {
      // Fetch the full Package details from your data source
      return await fetchPackageDetailsById(id);
    }));

    state = updatedPackages; // Update state with the new list of favorites
  }

  // Placeholder function to fetch package details by ID
  Future<Package> fetchPackageDetailsById(String id) async {
    // Replace with your logic to fetch Package details (e.g., from Firebase or local DB)
    return Package(id: id, location: 'Sample Location', dayType: '1 Day', description: 'Sample Description', priority: 1, route: [], inclusions: [], imageUrl: '', imageUrls: []);
  }
}
