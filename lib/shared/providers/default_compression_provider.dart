import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerodoc/core/constants/compression_level.dart';
import 'package:zerodoc/shared/providers/shared_preferences_provider.dart';

/// The user's preferred default compression level.
///
/// Defaults to [CompressionLevel.medium]. Persisted via SharedPreferences.
final defaultCompressionProvider =
    NotifierProvider<DefaultCompressionNotifier, CompressionLevel>(
  DefaultCompressionNotifier.new,
);

class DefaultCompressionNotifier extends Notifier<CompressionLevel> {
  static const _key = 'default_compression';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  CompressionLevel build() {
    final index = _prefs.getInt(_key);
    if (index == null || index < 0 || index >= CompressionLevel.values.length) {
      return CompressionLevel.medium;
    }
    return CompressionLevel.values[index];
  }

  Future<void> setLevel(CompressionLevel level) async {
    state = level;
    await _prefs.setInt(_key, level.index);
  }
}
