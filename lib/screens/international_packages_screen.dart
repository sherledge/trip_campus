import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trip_campus/screens/package_details_screen.dart';
import '../models/package.dart';

class InternationalPackagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text(
          "International Packages",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, fontFamily: 'AmaticSC'),
        ),
        centerTitle: true,
        elevation: 0, // No shadow for a modern look
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('packages')
            .where('dayType', isEqualTo: 'International')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading packages"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No international packages available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          List<Package> packages = snapshot.data!.docs.map((doc) {
            return Package.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                // Fun divider between sections
                _buildFunDivider(),

                // Grid of international packages
                Expanded(
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: packages.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.75, // Better aspect ratio for a clean design
                    ),
                    itemBuilder: (context, index) {
                      return _buildPackageCard(context, packages[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Fun Divider with Icon
  Widget _buildFunDivider() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Expanded(child: Divider(color: Colors.black, thickness: 1.5)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.airplanemode_active, // Airplane icon to fit the international theme
                  size: 30,
                  color: Colors.blue,
                ),
              ),
              Expanded(child: Divider(color: Colors.black, thickness: 1.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard(BuildContext context, Package package) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailsScreen(package: package),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black, width: 2.0), // Black border around the card
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image with Hero animation
            Hero(
              tag: package.id, // Unique hero tag for smooth transition
              child: CachedNetworkImage(
                imageUrl: package.imageUrls.first,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error, size: 50),
              ),
            ),

            // Dark Gradient Overlay for better readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // Package details (title & dayType)
            Positioned(
              bottom: 15,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.location,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      package.dayType,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
