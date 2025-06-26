import 'package:flutter/material.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';

class ItineraryScreen extends StatefulWidget {
  final String prompt;
  const ItineraryScreen({super.key, required this.prompt});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  bool _loading = true;
  String _itinerary = "";

  @override
  void initState() {
    super.initState();
    _generateItinerary();
  }

  Future<void> _generateItinerary() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate API call
    setState(() {
      _loading = false;
      _itinerary = """
Day 1: Arrival in Bali, check into hotel, beach walk\n
Day 2: Ubud Monkey Forest & local market\n
Day 3: Nusa Penida day trip, snorkeling\n
Day 4: Mount Batur sunrise hike\n
Day 5: Relax, spa & café hopping\n
Day 6: Temple visits & cultural show\n
Day 7: Shopping & Departure\n
"""; // You can replace this with actual AI response
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Your Trip Itinerary",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _loading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.greenAccent),
                    SizedBox(height: 16),
                    Text("Creating itinerary...",
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Prompt:",
                        style: TextStyle(color: AppColors.textSecondary)),
                    Text(widget.prompt,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    const Text("Generated Plan:",
                        style: TextStyle(
                            color: AppColors.greenAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(
                      _itinerary,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenAccent,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text("Back to Home"),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
