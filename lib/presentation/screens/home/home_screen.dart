import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = "Shubham"; // You can get this from authProvider later
    final savedTrips = [
      "Japan Trip, 20 days vacation, explore kyoto",
      "India Trip, 7 days work visit, suggest affordable places",
      "Europe trip, includes Paris, Berlin, Dortmund...",
      "Two days weekend getaway to somewhere peaceful"
    ];

    final controller = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hey $name 👋",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundColor: AppColors.greenAccent,
                      child: Text(
                        name[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "What’s your vision for this trip?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints:
                    const BoxConstraints(maxHeight: 200), // Limit growth
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greenLight),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surface, // Optional: background for contrast
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: 5, // Makes it grow with content
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText:
                              "7 days in Bali next April, 3 people, mid-range budget...",
                          hintStyle: TextStyle(color: Colors.white60),
                          border: InputBorder.none,// Seamless
                          focusedBorder: InputBorder.none, 
                          isDense: true,
                          contentPadding:
                              EdgeInsets.zero, // Remove inner padding
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.mic, color: AppColors.greenAccent),
                      onPressed: () {
                        // Handle voice input
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to ChatScreen with prompt from `controller.text`
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Create My Itinerary"),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Offline Saved Itineraries",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...savedTrips.map((trip) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(trip),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Open itinerary view
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
