import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/package.dart';
import 'media_viewer_screen.dart'; // Import the Media Viewer Screen
import 'package:shimmer/shimmer.dart'; // Add this import at the top

class PackageDetailsScreen extends StatelessWidget {
  final Package package;

  PackageDetailsScreen({required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Clickable Background Image
          GestureDetector(
            onTap: () {
              _openMediaViewer(
                  context, 0); // Open Media Viewer on the first image
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              child: CachedNetworkImage(
                imageUrl: package.imageUrls.first
                        .replaceFirst("export=view", "thumbnail") +
                    "&sz=w400",
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white, // Placeholder color
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context), // Navigate back
              ),
            ),
          ),

          // Image Previews with Faded Background (Centered)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4 - 30,
            left: 30,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildImagePreviews(context),
              ),
            ),
          ),

          // Draggable Details Section
          _buildDraggableSheet(),

          // Floating "Book Now" Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26.0, 8.0, 26.0, 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF052937), width: 3),
                ),
                child: Container(
                  height: 80,
                  // Wrap ElevatedButton in a Container for custom styling
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.transparent, width: 10 // Outer border
                          )),
                  child: ElevatedButton(
                    onPressed: () async {
                      String contactNumber = '+919895229727';
                      String packageName =
                          package.location; // Assuming package has a name field
                      String url =
                          'whatsapp://send?phone=$contactNumber&text=${Uri.encodeComponent("Hello, I am interested in the '$packageName' package. Could you please provide more details?")}';
                      await launchUrl(Uri.parse(url));
                    },
                    child: Text(
                      "BOOK NOW", // Match the image text
                      style: TextStyle(
                        fontFamily: 'AmaticSC',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF052937),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Square corners
                      ),
                      elevation: 0, // Remove default elevation
                    ).copyWith(
                      side: MaterialStateProperty.all(BorderSide(
                          color: Colors.transparent,
                          width: 3)), // Inner white border
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Image Previews with Navigation
  Widget _buildImagePreviews(BuildContext context) {
    int totalImages = package.imageUrls.length;
    int previewCount = 4;
    bool hasMore = totalImages > previewCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        hasMore ? previewCount : totalImages,
        (index) {
          bool isLast = hasMore && index == previewCount - 1;
          return GestureDetector(
            onTap: () {
              _openMediaViewer(context, index);
            },
            child: Stack(
              children: [
                // Image Container
                Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      //Corrected here.
                      image: CachedNetworkImageProvider(
                        package.imageUrls[index]
                                .replaceFirst("export=view", "thumbnail") +
                            "&sz=w200",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Black Overlay for "+X" (Only on last preview image)
                if (isLast)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 70,
                      height: 70,
                      color: Colors.black.withOpacity(0.3),
                      alignment: Alignment.center,
                      child: Text(
                        "+${totalImages - previewCount + 1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Open Media Viewer with Selected Image
  void _openMediaViewer(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaViewerScreen(
          imageUrls: package.imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildDraggableSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 160,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Overview
                _buildSectionTitle("Overview"),
                _buildDescription(package.description),

                // Route Details with Stop-Dot-Dot Effect
                _buildSectionTitle("Route Details"),
                _buildRouteDetails(),

                // Perks & Inclusions
                _buildSectionTitle("Perks & Inclusions"),
                _buildDescription(package.inclusions.join("\n")),
// Duration (Hide if International)
                if (package.dayType != "International") ...[
                  _buildSectionTitle("Duration"),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      package.dayType,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRouteDetails() {
    List<String> stops = package.route;
    return Column(
      children: List.generate(stops.length, (index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Indicator (Dot + Line)
            Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Icon(Icons.circle, size: 16, color: Colors.blue),
                ),
                if (index != stops.length - 1)
                  Container(height: 25, width: 2, color: Colors.blue),
              ],
            ),

            SizedBox(width: 12),

            // Stop Name (Vertically Centered)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    stops[index],
                    style: TextStyle(fontSize: 16, fontFamily: 'JosefinSans'),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          fontFamily: 'AmaticSC',
        ),
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontFamily: 'JosefinSans'),
      ),
    );
  }
}
