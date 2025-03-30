import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPackagesScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addDummyPackages() async {
    List<Map<String, dynamic>> packages = [
      {
        "location": "Maldives",
        "dayType": "International",
        "description":
            "A luxurious escape to the pristine beaches, crystal-clear waters, and overwater villas of the Maldives.",
        "priority": 5,
        "route": [
          "Arrival in Maldives – Resort Check-in & Relaxation",
          "Snorkeling & Marine Life Exploration",
          "Water Sports – Jet Skiing, Parasailing, Banana Boat Ride",
          "Island Hopping & Dolphin Watching",
          "Spa & Leisure at Overwater Villas",
          "Shopping & Departure"
        ],
        "inclusions": [
          "Luxury Resort Stay",
          "Daily Breakfast & Dinner",
          "Airport Transfers",
          "Water Activities & Island Hopping",
          "Snorkeling & Dolphin Watching",
          "Private Beach Access",
          "Visa Assistance"
        ],
        "imageUrl":
            "https://drive.google.com/uc?export=view&id=1gon71HeyOUWiofprBAXRVGqVa4ZQxayh",
        "imageUrls": [
          "https://drive.google.com/uc?export=view&id=1gon71HeyOUWiofprBAXRVGqVa4ZQxayh",
          "https://drive.google.com/uc?export=view&id=1YV9Ox-8pbpCSMLobHysKz61F3bJU5pdt",
          "https://drive.google.com/uc?export=view&id=1fRmbBQ9wWX4s6AoZ6Vtxb-TKOFYWL9s4",
          "https://drive.google.com/uc?export=view&id=1WGh2e1OeolZkXYwiRHohr4tJL0NN-uIm",
          "https://drive.google.com/uc?export=view&id=1lIkDxR6uhNzJtEmJCa1-i18fK-Qr72cE",
          "https://drive.google.com/uc?export=view&id=1i5KmJk7OKHdEMyi8V7t45DssOfwWEix_",
        ]
      },
      {
        "location": "Dubai",
        "dayType": "International",
        "description":
            "Experience the luxury, adventure, and iconic landmarks of Dubai, a city of dreams.",
        "priority": 5,
        "route": [
          "Arrival in Dubai – Check-in & Relaxation",
          "Burj Khalifa & Dubai Mall Exploration",
          "Desert Safari with Dune Bashing & BBQ Dinner",
          "Palm Jumeirah & Atlantis Tour",
          "Dubai Marina Cruise & Shopping",
          "Departure from Dubai"
        ],
        "inclusions": [
          "Luxury Hotel Stay",
          "Daily Breakfast",
          "Airport Transfers",
          "Burj Khalifa Entry",
          "Desert Safari with Dune Bashing & BBQ Dinner",
          "Dubai Marina Cruise",
          "City Tour & Shopping Experience",
          "Visa Assistance"
        ],
        "imageUrl":
            "https://drive.google.com/uc?export=view&id=1i4iDAAeoLFQsG3hTVWtpjjLQG4rLAdLw",
        "imageUrls": [
          "https://drive.google.com/uc?export=view&id=1i4iDAAeoLFQsG3hTVWtpjjLQG4rLAdLw",
          "https://drive.google.com/uc?export=view&id=1jYiqt1JlSm1heQWJ1yR8Vn2QdOgDz7w7",
          "https://drive.google.com/uc?export=view&id=1vmX_ce5gSI1tOBtyqPcnWPUUpf5TKkxQ",
          "https://drive.google.com/uc?export=view&id=1TTOHiV1895olbD_-w_kJGodoQMyYO7Y6",
          "https://drive.google.com/uc?export=view&id=1qOGP3iwX9uMEL62ne2mMSGcnFDHiXbf4",
          "https://drive.google.com/uc?export=view&id=171BSadbcyx-UoIo4Zgtxy4vrDlfmZvI4",
          "https://drive.google.com/uc?export=view&id=1y3XIQxDDax9G1aO5FA473x0DuqEm6Azl"
        ]
      },
      {
        "location": "Bali",
        "dayType": "International",
        "description":
            "Discover the tropical paradise of Bali, filled with stunning beaches, lush forests, and rich culture.",
        "priority": 5,
        "route": [
          "Arrival in Bali – Check-in & Beach Relaxation",
          "Ubud & Tegalalang Rice Terraces Tour",
          "Kuta Beach & Water Sports Adventure",
          "Uluwatu Temple & Sunset Cliff Views",
          "Nusa Penida Island Tour",
          "Shopping & Departure"
        ],
        "inclusions": [
          "Luxury Resort Stay",
          "Daily Breakfast",
          "Airport Transfers",
          "Ubud & Rice Terrace Tour",
          "Water Sports Activities",
          "Temple Visits & Cultural Shows",
          "Nusa Penida Island Tour",
          "Visa Assistance"
        ],
        "imageUrl":
            "https://drive.google.com/uc?export=view&id=1j5q0N-QmtkexizCri3ORRxoa9Ni4VokV",
        "imageUrls": [
          "https://drive.google.com/uc?export=view&id=1j5q0N-QmtkexizCri3ORRxoa9Ni4VokV",
          "https://drive.google.com/uc?export=view&id=1GnZILLoaPZEnzMTpQRkd1Vf88ZN3NF97",
          "https://drive.google.com/uc?export=view&id=1HxafiCGu90gSyo9Z6exz2osClJ4QcLUH",
          "https://drive.google.com/uc?export=view&id=1knZKW1RgRIdOFaAV2E98oB5lIEek7VxV",
          "https://drive.google.com/uc?export=view&id=1uBns3-vC_RYb4v99huzr_mtrBI1MO75m",
          "https://drive.google.com/uc?export=view&id=1lrF3fhAqjXqRU15xBAqDKU0xdP23l3JN",
        ]
      },
      {
        "location": "Thailand",
        "dayType": "International",
        "description":
            "Explore the vibrant culture, exotic islands, and bustling nightlife of Thailand.",
        "priority": 5,
        "route": [
          "Arrival in Bangkok – Check-in & Relaxation",
          "Bangkok City Tour & Grand Palace Visit",
          "Pattaya Coral Island & Beach Adventure",
          "Phi Phi Islands & Snorkeling Experience",
          "Shopping & Floating Market Tour",
          "Departure from Thailand"
        ],
        "inclusions": [
          "Luxury Hotel Stay",
          "Daily Breakfast",
          "Airport Transfers",
          "Bangkok City Tour",
          "Grand Palace Entry",
          "Coral Island Tour with Water Sports",
          "Phi Phi Island Snorkeling Tour",
          "Shopping & Nightlife Experience",
          "Visa Assistance"
        ],
        "imageUrl":
            "https://drive.google.com/uc?export=view&id=1cNsHvMtjEKxzEnI7-inawnt-TjjjHfwh",
        "imageUrls": [
          "https://drive.google.com/uc?export=view&id=1cNsHvMtjEKxzEnI7-inawnt-TjjjHfwh",
          "https://drive.google.com/uc?export=view&id=10_iBY6e0dRSM2i3cHZfu-fxnYhZEK7J4",
          "https://drive.google.com/uc?export=view&id=1Kn5NPZAkG_zeJ_4p4LfU12NmJqnhD2f2",
          "https://drive.google.com/uc?export=view&id=1l3irg6KbLtRliiZQXB9HnfWH7xmLVkMy",
          "https://drive.google.com/uc?export=view&id=1P3Kx0sZ88_EeWW-UFQ5PQ9sYL3ZtJ1Dt",
          "https://drive.google.com/uc?export=view&id=1jBfxUN249cTyTEfN--bOnQMEboFF5X8B",
        ]
      },
      {
        "location": "Malaysia",
        "dayType": "International",
        "description":
            "Experience the perfect blend of modern skyscrapers, cultural heritage, and tropical landscapes in Malaysia.",
        "priority": 5,
        "route": [
          "Arrival in Kuala Lumpur – Check-in & City Exploration",
          "Petronas Towers & KL Tower Skydeck",
          "Genting Highlands & Batu Caves Tour",
          "Langkawi Island Tour & Beach Activities",
          "Shopping & Street Food Experience",
          "Departure from Malaysia"
        ],
        "inclusions": [
          "Luxury Hotel Stay",
          "Daily Breakfast",
          "Airport Transfers",
          "Kuala Lumpur City Tour",
          "Petronas Towers & KL Tower Entry",
          "Genting Highlands Cable Car Ride",
          "Langkawi Island Tour & Beach Activities",
          "Batu Caves Visit",
          "Visa Assistance"
        ],
        "imageUrl":
            "https://drive.google.com/uc?export=view&id=13I8mi74RdYqs11qTVWH-f9JneNG41z04",
        "imageUrls": [
          "https://drive.google.com/uc?export=view&id=13I8mi74RdYqs11qTVWH-f9JneNG41z04",
          "https://drive.google.com/uc?export=view&id=10i776TlVnYGkBWgR4iOoFaOp1XmI0ZZz",
          "https://drive.google.com/uc?export=view&id=1csiiTTuPQjSJS8Mx8WmSayWVjrLei27M",
          "https://drive.google.com/uc?export=view&id=1-n7vdwtaulOLa5ZWLt-Vyn1ZRyRyu5Wy",
          "https://drive.google.com/uc?export=view&id=18WRnDg5YNTnclyF9ssQ-tvYPmbZbcVw6",
          "https://drive.google.com/uc?export=view&id=12RkkUTnT-7ktxItCLOgMkQK3eh6HNgHF",
        ]
      }
    ];

    for (var package in packages) {
      await _firestore.collection("packages").add({
        ...package,
        "id": _firestore.collection("packages").doc().id, // Generate unique ID
      });
    }

    print("Packages added to Firestore!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Packages")),
      body: Center(
        child: ElevatedButton(
          onPressed: _addDummyPackages,
          child: Text("Add Dummy Packages to Firebase"),
        ),
      ),
    );
  }
}
