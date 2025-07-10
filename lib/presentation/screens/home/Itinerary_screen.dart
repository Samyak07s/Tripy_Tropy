import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';
import 'package:tripy_tropy/application/providers/itinerary_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tripy_tropy/core/routes/app_routes.dart';
import 'package:tripy_tropy/data/models/itinerary_model.dart';
import 'package:url_launcher/url_launcher.dart';

final saveOfflineProvider = StateProvider<bool>((ref) => false);

class ItineraryScreen extends ConsumerWidget {
  final String prompt;
  const ItineraryScreen({super.key, required this.prompt});

  Future<void> launchUrl(Uri url) async {
    if (!await canLaunchUrl(url)) {
      throw 'Could not launch $url';
    }
    await launchUrl(url);
  }

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
          loading: () => _buildLoadingUI(ref, context),
          error: (err, _) => _buildErrorUI(err.toString()),
          data: (itinerary) => _buildItineraryUI(ref, context, itinerary),
        ),
      ),
    );
  }

  Widget _buildLoadingUI(WidgetRef ref, BuildContext context) {
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
          followUpButton(context, '', disabled: true),
          const SizedBox(height: 12),
          saveOfflineCheckbox(ref, prompt, ""),
        ],
      ),
    );
  }

  Widget _buildItineraryUI(WidgetRef ref, BuildContext context, String itinerary) {
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
                  a: const TextStyle(
                    color: Colors.lightBlueAccent,
                    //decoration: TextDecoration.underline,
                  ),
                ),
                onTapLink: (text, href, title) {
                  if (href != null) {
                    launchUrl(Uri.parse(href));
                  }
                },
              )),
          const SizedBox(height: 24),
          followUpButton(context, itinerary),
          const SizedBox(height: 12),
          saveOfflineCheckbox(ref, prompt, itinerary),
        ],
      ),
    );
  }

  Widget _buildErrorUI(String error) {
    return Center(
        child:
            Text("Error: $error", style: const TextStyle(color: Colors.red)));
  }

  Widget followUpButton(BuildContext context, String itinerary,
      {bool disabled = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.followUpChat,
                  arguments: {
                    'prompt': prompt,
                    'response': itinerary,
                  },
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenAccent,
          foregroundColor: Colors.black,
        ),
        child: const Text("Follow up to refine"),
      ),
    );
  }

  Widget saveOfflineCheckbox(WidgetRef ref, String prompt, String response) {
    final isChecked = ref.watch(saveOfflineProvider);

    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (val) async {
            if (val == true) {
              final box = Hive.box<ItineraryModel>('itineraries');
              final alreadySaved = box.values.any(
                  (item) => item.prompt == prompt && item.response == response);

              if (!alreadySaved) {
                await box
                    .add(ItineraryModel(prompt: prompt, response: response));
                ref.read(saveOfflineProvider.notifier).state = true;
                ScaffoldMessenger.of(ref.context).showSnackBar(
                  const SnackBar(content: Text("✅ Saved for offline use")),
                );
              } else {
                ref.read(saveOfflineProvider.notifier).state = true;
                ScaffoldMessenger.of(ref.context).showSnackBar(
                  const SnackBar(content: Text("ℹ️ Already saved")),
                );
              }
            }
          },
        ),
        const Text("Save Offline", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
