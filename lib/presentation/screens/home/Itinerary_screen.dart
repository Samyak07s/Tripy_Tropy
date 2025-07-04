import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';
import 'package:tripy_tropy/application/providers/itinerary_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tripy_tropy/core/routes/app_routes.dart';

class ItineraryScreen extends ConsumerWidget {
  final String prompt;
  const ItineraryScreen({super.key, required this.prompt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(itineraryProvider(prompt));
    //print(result);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.greenAccent,
              child: Text("S", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: result.when(
          loading: () => _buildLoadingUI(context),
          error: (err, _) => _buildErrorUI(err.toString()),
          data: (itinerary) => _buildItineraryUI(context, itinerary),
        ),
      ),
    );
  }

  Widget _buildLoadingUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.greenAccent),
                SizedBox(height: 16),
                Text("Curating a perfect plan for you...",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          followUpButton(context, disabled: true),
          const SizedBox(height: 12),
          saveOfflineCheckbox(),
        ],
      ),
    );
  }

  Widget _buildItineraryUI(BuildContext context, String itinerary) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Itinerary Created 🧳",
              style: TextStyle(
                  color: AppColors.greenAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: MarkdownBody(
              data: itinerary,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(color: Colors.white),
                strong: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 24),
          followUpButton(context),
          const SizedBox(height: 12),
          saveOfflineCheckbox(),
        ],
      ),
    );
  }

  Widget _buildErrorUI(String error) {
    return Center(
        child:
            Text("Error: $error", style: const TextStyle(color: Colors.red)));
  }

  Widget followUpButton(BuildContext context, {bool disabled = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled
            ? null
            : () {
                Navigator.pushNamed(context, AppRoutes.followUpChat);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenAccent,
          foregroundColor: Colors.black,
        ),
        child: const Text("Follow up to refine"),
      ),
    );
  }

  Widget saveOfflineCheckbox() {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (val) {}),
        const Text("Save Offline", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
