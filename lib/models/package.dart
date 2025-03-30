import 'package:cloud_firestore/cloud_firestore.dart';

class Package {
  final String id;
  final String location;
  final String dayType;
  final String description;
  final int priority;
  final List<String> route;
  final List<String> inclusions;
  final String imageUrl;
  final List<String> imageUrls;

  Package({
    required this.id,
    required this.location,
    required this.dayType,
    required this.description,
    required this.priority,
    required this.route,
    required this.inclusions,
    required this.imageUrl,
        required this.imageUrls,

  });

  // Convert Firestore document to Package object
  factory Package.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Package(
      id: doc.id, // Firestore document ID
      location: data["location"] ?? "",
      dayType: data["dayType"] ?? "",
      description: data["description"] ?? "",
      priority: data["priority"] ?? 0,
      route: List<String>.from(data["route"] ?? []),
      inclusions: List<String>.from(data["inclusions"] ?? []),

      imageUrls: List<String>.from(data["imageUrls"] ?? []),
      imageUrl: data["imageUrl"] ?? "",
    );
  }

    // ✅ Use this when you only have a `Map<String, dynamic>` (like in `InternationalPackagesScreen`)
  factory Package.fromMap(Map<String, dynamic> data, String documentId) {
    return Package(
      id: documentId,
      location: data["location"] ?? "",
      dayType: data["dayType"] ?? "",
      description: data["description"] ?? "",
      priority: data["priority"] ?? 0,
      route: List<String>.from(data["route"] ?? []),
      inclusions: List<String>.from(data["inclusions"] ?? []),
      imageUrls: List<String>.from(data["imageUrls"] ?? []),
      imageUrl: data["imageUrl"] ?? "",
    );
  }

  // You can add a factory constructor for loading from shared preferences
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      location: json['location'],
      dayType: json['dayType'],
      description: json['description'],
      priority: json['priority'],
      route: List<String>.from(json['route']),
      inclusions: List<String>.from(json['inclusions']),
      imageUrl: json['imageUrl'],
      imageUrls: List<String>.from(json['imageUrls']),
    );
  }

  // Convert to JSON for saving in shared preferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'dayType': dayType,
      'description': description,
      'priority': priority,
      'route': route,
      'inclusions': inclusions,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
    };
  }

  
}
