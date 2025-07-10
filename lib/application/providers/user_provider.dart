import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final userProvider = StateNotifierProvider<UserNotifier, String>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<String> {
  UserNotifier() : super('') {
    _loadName();
  }

  void _loadName() async {
    final box = await Hive.openBox('userBox');
    final name = box.get('username', defaultValue: '');
    state = name;
  }

  void updateName(String name) {
    state = name;
  }
}
