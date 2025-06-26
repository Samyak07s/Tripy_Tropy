import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';
import 'package:tripy_tropy/core/routes/app_routes.dart';

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
                      const BoxConstraints(maxHeight: 150), // Limit growth
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greenLight),
                    borderRadius: BorderRadius.circular(12),
                    color:
                        AppColors.surface, // Optional: background for contrast
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        controller: controller,
                        maxLines: 5,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText:
                              "I want a 5-day relaxing trip to Goa in December with my friends",

                          hintStyle: TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(right: 48), // leave space for mic
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.mic,
                              color: AppColors.greenAccent),
                          onPressed: () {
                            // Voice input logic
                          },
                        ),
                      )
                    ],
                  )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final prompt = controller.text.trim();
                    if (prompt.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter your trip idea")),
                      );
                      return;
                    }
                    Navigator.pushNamed(
                      context,
                      AppRoutes.Itinerary,
                      arguments: prompt,
                    );
                  },
                  child: const Text(
                    "Create My Itinerary",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  "Offline Saved Itineraries",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
