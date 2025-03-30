import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shared_prefs_service.dart';

final sharedPrefsProvider = Provider<SharedPrefsService>((ref) {
  return SharedPrefsService();
});

// AsyncProvider to fetch intro screen status
final introSeenProvider = FutureProvider<bool>((ref) async {
  final sharedPrefs = ref.watch(sharedPrefsProvider);
  return await sharedPrefs.getSeenIntro();
});
