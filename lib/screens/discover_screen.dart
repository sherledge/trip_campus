import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_campus/screens/package_details_screen.dart';
import '../providers/package_provider.dart';
import '../models/package.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class DiscoverScreen extends ConsumerWidget {
  final String selectedFilter;

  DiscoverScreen({required this.selectedFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Discover Packages",
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'AmaticSC',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFunDivider(),
          Expanded(
            child: packagesAsync.when(
              data: (packages) {
                final filteredPackages = selectedFilter.isEmpty
                    ? packages
                    : packages.where((p) => p.dayType == selectedFilter).toList();

                return filteredPackages.isEmpty
                    ? Center(child: Text("No packages found"))
                    : ListView.builder(
                        itemCount: filteredPackages.length,
                        itemBuilder: (context, index) {
                          return _buildPackageCard(context, ref, filteredPackages[index]);
                        },
                      );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error loading packages")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 2, color: Color(0xFF052937))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.star, color: Colors.yellow[700], size: 20),
          ),
          Expanded(child: Divider(thickness: 2, color: Color(0xFF052937))),
        ],
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, WidgetRef ref, Package package) {
    final favoritePackages = ref.watch(favoritePackagesProvider);
    final isFavorite = favoritePackages.any((fav) => fav.id == package.id);

    void onPackageTap() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackageDetailsScreen(package: package),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPackageTap,
        child: Container(
          padding: EdgeInsets.all(12),
          width: 316,
          height: 233,
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.0,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: package.imageUrl.replaceFirst("export=view", "thumbnail") + "&sz=w200",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 160,
                      memCacheWidth: 200,
                      memCacheHeight: 160,
                      placeholder: (context, url) => _buildShimmerEffect(),
                      errorWidget: (context, url, error) => Icon(Icons.error, size: 40, color: Colors.red),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        ref.read(favoritePackagesProvider.notifier).toggleFavorite(package);
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.black, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        package.location,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'JosefinSans',
                          fontSize: 18,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 160,
        color: Colors.white,
      ),
    );
  }
}
