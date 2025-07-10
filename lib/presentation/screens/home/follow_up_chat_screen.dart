import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';
import 'package:tripy_tropy/application/providers/followup_chat_provider.dart';
import 'package:tripy_tropy/data/models/chat_message.dart';
import 'package:tripy_tropy/data/models/itinerary_model.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowUpChatScreen extends ConsumerStatefulWidget {
  const FollowUpChatScreen({super.key});

  @override
  ConsumerState<FollowUpChatScreen> createState() => _FollowUpChatScreenState();
}

class _FollowUpChatScreenState extends ConsumerState<FollowUpChatScreen> {
  late final Map<String, String> chatArgs;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    if (args == null ||
        !args.containsKey('prompt') ||
        !args.containsKey('response')) {
      // navigate back or handle error
      return;
    }

    chatArgs = {
      'prompt': args['prompt']!,
      'response': args['response']!,
    };
  }

  Future<void> launchUrl(Uri url) async {
    if (!await canLaunchUrl(url)) {
      throw 'Could not launch $url';
    }
    await launchUrl(url);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider(chatArgs));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          chatArgs['prompt']!.length > 25
              ? "${chatArgs['prompt']!.substring(0, 25)}..."
              : chatArgs['prompt']!,
          style: const TextStyle(color: Colors.white),
        ),
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.sender == "user";
                return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.greenAccent.withOpacity(0.15)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: isUser
                          ? Text(msg.message,
                              style: const TextStyle(color: Colors.white))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MarkdownBody(
                                  data: msg.message,
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(color: Colors.white),
                                    strong: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    a: const TextStyle(
                                        color: Colors.lightBlueAccent),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    _actionButton(
                                      icon: Icons.copy,
                                      label: "Copy",
                                      onPressed: () {
                                        Clipboard.setData(
                                            ClipboardData(text: msg.message));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "✅ Copied to clipboard")),
                                        );
                                      },
                                    ),
                                    _actionButton(
                                      icon: Icons.save_alt,
                                      label: "Save",
                                      onPressed: () async {
                                        final box = Hive.box<ItineraryModel>(
                                            'itineraries');
                                        final prompt = chatArgs['prompt']!;
                                        final alreadySaved = box.values.any(
                                            (item) =>
                                                item.prompt == prompt &&
                                                item.response == msg.message);
                                        if (!alreadySaved) {
                                          await box.add(ItineraryModel(
                                              prompt: prompt,
                                              response: msg.message));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text("✅ Saved offline")),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text("ℹ️ Already saved")),
                                          );
                                        }
                                      },
                                    ),
                                    _actionButton(
                                      icon: Icons.refresh,
                                      label: "Retry",
                                      onPressed: () {
                                        final prompt = chatArgs['prompt']!;
                                        ref
                                            .read(chatProvider({
                                              'prompt': prompt,
                                              'response': ''
                                            }).notifier)
                                            .sendMessage(prompt);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ));
              },
            ),
          ),
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Follow up to refine...",
                        hintStyle: const TextStyle(color: Colors.white60),
                        filled: true,
                        fillColor: AppColors.surface.withOpacity(0.4),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.greenAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () {
                      final msg = controller.text.trim();
                      if (msg.isNotEmpty) {
                        ref
                            .read(chatProvider(chatArgs).notifier)
                            .sendMessage(msg);
                        controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white70),
      label: Text(label, style: const TextStyle(color: Colors.white70)),
      style: TextButton.styleFrom(
        minimumSize: const Size(80, 36),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}
