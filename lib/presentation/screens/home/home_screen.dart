import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripy_tropy/application/providers/saved_itinerary_provider.dart';
import 'package:tripy_tropy/application/providers/user_provider.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';
import 'package:tripy_tropy/core/routes/app_routes.dart';
import 'package:tripy_tropy/data/models/itinerary_model.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  final TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Refresh when user comes back to this screen
    ref.read(savedItineraryProvider.notifier).loadSaved();
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(userProvider);
    final savedTrips = ref.watch(savedItineraryProvider);

    final displayName = name.isEmpty
        ? "Guest"
        : name.contains('@')
            ? name.split('@').first
            : name;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hey $displayName 👋",
                    style: const TextStyle(fontSize: 24, color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.profile),
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
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              constraints: const BoxConstraints(maxHeight: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greenLight),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surface,
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
                      contentPadding: EdgeInsets.only(right: 48),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.mic, color: AppColors.greenAccent),
                      onPressed: () {
                        // Voice input logic (optional)
                      },
                    ),
                  )
                ],
              ),
            ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenAccent,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Create My Itinerary",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 34),
            const Center(
              child: Text("Offline Saved Itineraries",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            if (savedTrips.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Icon(Icons.travel_explore, size: 48, color: Colors.white30),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        "No itineraries saved yet.",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: savedTrips.map((trip) {
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading:
                          const Icon(Icons.map, color: AppColors.greenAccent),
                      title: Text(
                        trip.prompt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: const Text(
                        "Tap to view itinerary",
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_right,
                                color: Colors.white54),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.Itinerary,
                                arguments: trip.prompt,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Delete Itinerary"),
                                  content: const Text(
                                      "Are you sure you want to delete this itinerary?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Delete",
                                          style: TextStyle(
                                              color: Colors.redAccent)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                ref
                                    .read(savedItineraryProvider.notifier)
                                    .removeItinerary(trip);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Itinerary deleted")),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
