import 'package:flutter/material.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';

class FollowUpChatScreen extends StatelessWidget {
  const FollowUpChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userMessage = "7 days in Bali next April, 3 people, mid-range budget...";
    final aiResponse = '''
**Day 1: Arrival in Bali & Settle in Ubud**
- Morning: Arrive at **Bali, Denpasar Airport**  
- Transfer: Private driver to **Ubud** (~1.5 hrs)  
- Check-in at **Ubud Aura Retreat**  
- Explore **Ubud local area**, including **Tegalalang rice terraces**  
- Dinner at **Locavore** (known for 5-star dishes)  
[Open in maps](https://maps.google.com/?q=Bali)

*Mumbai to Bali, Indonesia | 11hrs 5mins*
''';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text("7 days in Bali...", style: TextStyle(color: Colors.white)),
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // User message
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.greenAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(userMessage, style: const TextStyle(color: Colors.white)),
                  ),
                ),

                // AI Message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Optional: Markdown rendering or RichText parsing here
                      Text(aiResponse, style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.copy, color: Colors.white70),
                            label: const Text("Copy", style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.save_alt, color: Colors.white70),
                            label: const Text("Save Offline", style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.refresh, color: Colors.white70),
                            label: const Text("Regenerate", style: TextStyle(color: Colors.white70)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Follow up to refine",
                      hintStyle: TextStyle(color: Colors.white60),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.greenAccent),
                  onPressed: () {
                    // Send follow-up logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
