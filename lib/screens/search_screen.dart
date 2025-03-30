import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/package_provider.dart';
import '../models/package.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trip_campus/screens/package_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Package> _filteredPackages = [];

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(packagesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Search Packages",
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
      body: packagesAsync.when(
        data: (packages) {
          return Column(
            children: [
              _buildFunDivider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) => _filterSearchResults(query, packages),
                  decoration: InputDecoration(
                    hintText: "Search by location...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Expanded(
                child: _filteredPackages.isEmpty && _searchController.text.isNotEmpty
                    ? Center(child: Text("No results found"))
                    : ListView.builder(
                        itemCount: _filteredPackages.length,
                        itemBuilder: (context, index) {
                           return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10), // Add vertical padding between cards
              child: _buildPackageCard(context, _filteredPackages[index]),
            );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error loading packages")),
      ),
    );
  }

  void _filterSearchResults(String query, List<Package> packages) {
    setState(() {
      _filteredPackages = query.isEmpty
          ? []
          : packages.where((p) => p.location.toLowerCase().contains(query.toLowerCase())).toList();
    });
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

  Widget _buildPackageCard(BuildContext context, Package package) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PackageDetailsScreen(package: package)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildCachedImage(package.imageUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      package.location,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      package.dayType,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
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

  Widget _buildCachedImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(width: 80, height: 80, color: Colors.white),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error_outline),
    );
  }
}
