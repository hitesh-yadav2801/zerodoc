import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerodoc/shared/providers/shared_preferences_provider.dart';

/// Whether to keep original files after processing.
///
/// Defaults to `true`. Persisted via SharedPreferences.
final keepOriginalsProvider = NotifierProvider<KeepOriginalsNotifier, bool>(
  KeepOriginalsNotifier.new,
);

class KeepOriginalsNotifier extends Notifier<bool> {
  static const _key = 'keep_originals';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  bool build() => _prefs.getBool(_key) ?? true;

  Future<void> toggle() async {
    state = !state;
    await _prefs.setBool(_key, state);
  }
}
