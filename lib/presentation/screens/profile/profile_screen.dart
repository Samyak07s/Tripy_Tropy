

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';
import 'package:tripy_tropy/application/providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(userProvider);
    final controller = TextEditingController(text: name);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Update Your Name",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: "Enter your name",
                hintStyle: const TextStyle(color: Colors.white60),
                focusedBorder: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final updated = controller.text.trim();
                if (updated.isNotEmpty) {
                  final box = await Hive.openBox('userBox');
                  await box.put('username', updated);
                  ref.read(userProvider.notifier).updateName(updated);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Name updated")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
