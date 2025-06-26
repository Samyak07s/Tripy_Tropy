import 'package:flutter/material.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';


class ItineraryCreatedPage extends StatelessWidget {
  const ItineraryCreatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text("Home", style: TextStyle(color: AppColors.textPrimary)),
        actions:const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: Text('S', style: TextStyle(color: AppColors.textPrimary)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Itinerary Created 🐍",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "• Day 1: Arrival in Bali & Settle in Ubud\n"
                    "• Morning: Arrive in Bali, Denpasar Airport.\n"
                    "• Transfer: Private driver to Ubud (around 1.5 hours).\n"
                    "• Accommodation: Check-in at a peaceful boutique hotel or villa in Ubud (e.g., Ubud Aura Retreat).\n"
                    "• Afternoon: Explore Ubud’s local area, walk around the tranquil rice terraces at Tegallalang.\n"
                    "• Evening: Dinner at Locavore (known for farm-to-table dishes in peaceful setting)",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.map, color: AppColors.greenAccent, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "Open in maps",
                        style: TextStyle(
                          color: AppColors.greenAccent,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                  label: const Text("Follow up to refine"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.greenAccent,
                    foregroundColor: AppColors.background,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text("Save Offline"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: AppColors.greenAccent),
                    foregroundColor: AppColors.greenAccent,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
