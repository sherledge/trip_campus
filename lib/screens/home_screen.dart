import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_campus/screens/discover_screen.dart';
import 'package:trip_campus/screens/package_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/search_screen.dart';
import '../providers/package_provider.dart';
import '../models/package.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

// Provider to store visited packages locally
final visitedPackagesProvider = StateProvider<List<String>>((ref) => []);

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedFilter = "";

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(packagesProvider);
    final visitedPackages = ref.watch(visitedPackagesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildSideMenu(context),
      body: Column(
        children: [
          // Custom Header
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                SizedBox(
                  width: 70,
                ),
// Custom Header
// Custom Header
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the Row content
                    children: [
                      // Center the title in the middle of the row
                      GestureDetector(
                        onTap: () => _openGoogleMaps(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "TRIP CAMPUS",
                              style: TextStyle(
                                  fontFamily: 'AmaticSC',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisSize:
                                  MainAxisSize.min, // Ensure Row fits content
                              children: [
                                Icon(Icons.location_on,
                                    color: Color(0xFF052937), size: 18),
                                SizedBox(width: 4),
                                Text(
                                  "Edappal",
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF052937)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar acting as a Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SearchScreen())),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF8CAEBC),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Search Locations",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'JosefinSans',
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter Options
          _buildFilterOptions(),

          // Package List
          Expanded(
            child: packagesAsync.when(
              data: (packages) =>
                  _buildContent(context, packages, visitedPackages),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text("Error loading packages"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    List<Map<String, dynamic>> filters = [
      {"name": "1 Day", "icon": "assets/images/icon1.png"},
      {"name": "1 Day 2 Nights", "icon": "assets/images/icon2.png"},
      {"name": "2 Days 3 Nights", "icon": "assets/images/icon3.png"},
      {"name": "3 Days 4 Nights", "icon": "assets/images/icon4.png"},
      {"name": "4 Days 5 Nights", "icon": "assets/images/icon5.png"},
      {"name": "5 Days 6 Nights", "icon": "assets/images/icon6.png"},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: filters.map((filter) {
          bool isSelected = selectedFilter == filter["name"];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10.0), // Rounded corners for the Container
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF052937).withOpacity(0.5),
                    blurRadius: 4.0,
                    offset: Offset(3.0, 3.0),
                  ),
                ],
              ),
              child: ChoiceChip(
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(
                      10.0), // Same radius as the Container
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      filter["icon"],
                      width: 32,
                      height: 32,
                    ),
                    SizedBox(width: 6),
                    Text(
                      filter["name"],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF051A37),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                onSelected: (isSelected) {
                  setState(() {
                    selectedFilter = isSelected ? filter["name"] : "";
                  });
                },
                selectedColor: Color(0xFF052937),
                backgroundColor: Colors.white,
                showCheckmark: false,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Package> packages,
      List<String> visitedPackages) {
    final filteredPackages = selectedFilter.isEmpty
        ? packages
        : packages.where((p) => p.dayType == selectedFilter).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommended Packages Section
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: Text("Recommended",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AmaticSC')),
          ),

          // Divider between Recommended text and its packages
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            indent: 12,
            endIndent: 12,
          ),

          _buildRecommendedPackages(context, filteredPackages, visitedPackages),

          // Plan Your IV Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Plan Your IV",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AmaticSC')),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DiscoverScreen(selectedFilter: selectedFilter),
                      ),
                    );
                  },
                  child: Text("Discover",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF052937),
                          fontFamily: 'JosefinSans',
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),

          // Divider between Plan Your IV text and its packages
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            indent: 12,
            endIndent: 12,
          ),

          _buildPlanYourIV(context, filteredPackages),
        ],
      ),
    );
  }

  Widget _buildRecommendedPackages(BuildContext context, List<Package> packages,
      List<String> visitedPackages) {
    // Get the most recent package from visited packages (if any)
    final recentVisitedPackage = visitedPackages.isNotEmpty
        ? packages.firstWhere(
            (p) =>
                p.location ==
                visitedPackages.first, // Getting the most recent one
            orElse: () => Package(
              id: 'placeholder_id', // Placeholder ID
              location: 'Placeholder',
              imageUrl: '',
              dayType: '',
              description: '',
              priority: 0,
              route: [],
              inclusions: [],
              imageUrls: [],
            ), // Return a placeholder package
          )
        : null;

    // Filter out the recently selected package and others that are already visited
    final recommendedPackages = recentVisitedPackage != null
        ? [recentVisitedPackage] +
            visitedPackages
                .skip(1) // Skip the first element, as it's already included
                .map((location) => packages.firstWhere(
                      (p) => p.location == location,
                      orElse: () => Package(
                        id: 'placeholder_id', // Placeholder ID
                        location: 'Placeholder',
                        imageUrl: '',
                        dayType: '',
                        description: '',
                        priority: 0,
                        route: [],
                        inclusions: [],
                        imageUrls: [],
                      ), // Return a placeholder package
                    ))
                .where((package) =>
                    package.location !=
                    'Placeholder') // Remove placeholder packages
                .toList()
        : [];

    // Filter out visited packages from the full list of available packages
    final remainingPackages = packages
        .where((package) => !visitedPackages.contains(package.location))
        .toList();

    final displayPackages = recommendedPackages + remainingPackages;

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayPackages.length,
        itemBuilder: (context, index) {
          return _buildPackageCard(context, displayPackages[index]);
        },
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, Package package) {
    return Consumer(
      builder: (context, ref, child) {
        final favoritePackages = ref.watch(favoritePackagesProvider);
        final visitedPackages = ref.watch(visitedPackagesProvider);
        final isFavorite = favoritePackages.any((fav) => fav.id == package.id);

        // When a package is tapped, mark it as visited
        void onPackageTap() {
          ref.read(visitedPackagesProvider.notifier).state = [
            ...visitedPackages,
            package.location // or package.id based on your needs
          ];
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
            onTap: onPackageTap, // Update visited packages on tap
            child: Container(
              padding: EdgeInsets.all(12),
              width: 316,
              height: 233,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black, // Black border around the card
                  width: 2.0, // Width of the border
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7), // White shadow effect
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                        child: CachedNetworkImage(
                          imageUrl: package.imageUrl
                                  .replaceFirst("export=view", "thumbnail") +
                              "&sz=w200", // Request lower size
                          fit: BoxFit.cover,
                          width: 290,
                          height: 160,
                          memCacheWidth: 200, // Resize before caching
                          memCacheHeight: 160,
                          placeholder: (context, url) => _buildShimmerEffect(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(favoritePackagesProvider.notifier)
                                .toggleFavorite(package);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
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
                          child: Baseline(
                            baseline: 20,
                            baselineType: TextBaseline.alphabetic,
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Create shimmer effect for image placeholder
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

  Widget _buildSideMenu(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Center(
              child: Text(
                "Menu",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.orange),
            title: Text("Rate Our App"),
            onTap: () {
              _openPlayStore();
            },
          ),
        ],
      ),
    );
  }

  void _openPlayStore() async {
    final String playStoreUrl =
        "https://play.google.com/store/apps/details?id=com.yourcompany.yourapp"; // Replace with your app's package name
    if (await canLaunch(playStoreUrl)) {
      await launch(playStoreUrl);
    } else {
      throw "Could not open Play Store";
    }
  }

  Widget _buildPlanYourIV(BuildContext context, List<Package> packages) {
    final ivPackages = packages.where((p) => p.priority > 4).toList();

    return ivPackages.isEmpty
        ? Center(child: Text("No IV packages found"))
        : SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ivPackages.length,
              itemBuilder: (context, index) {
                return _buildPackageCard(context, ivPackages[index]);
              },
            ),
          );
  }


void _openGoogleMaps() async {
  final Uri googleMapsUrl = Uri.parse("https://maps.app.goo.gl/hXVRRjjsfsTF3mAV8");
  
  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not open Google Maps";
  }
}

}
