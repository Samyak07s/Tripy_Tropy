import 'package:flutter/material.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';


class ItineraryCreatingPage extends StatelessWidget {
  const ItineraryCreatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text("Home", style: TextStyle(color: AppColors.textPrimary)),
        actions: const [
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  CircularProgressIndicator(color: AppColors.greenAccent),
                  SizedBox(height: 20),
                  Text(
                    "Curating a perfect plan for you...",
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.tune),
                  label: const Text("Follow up to refine"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.download, color: Colors.grey),
                  label: const Text("Save Offline"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: Colors.grey),
                    foregroundColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            )
          ],
        ),
      ),
    );
  }
}
