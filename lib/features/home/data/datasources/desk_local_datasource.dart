import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerodoc/core/utils/app_logger.dart';
import 'package:zerodoc/features/home/data/models/desk_file_model.dart';

class DeskLocalDatasource {
  DeskLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'desk_files';

  List<DeskFileModel> getAll() {
    try {
      final raw = _prefs.getString(_key);
      if (raw == null) return [];

      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => DeskFileModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception catch (e, st) {
      log.w('Failed to parse desk files, resetting', error: e, stackTrace: st);
      return [];
    }
  }

  Future<void> save(List<DeskFileModel> files) async {
    final json = jsonEncode(files.map((f) => f.toJson()).toList());
    await _prefs.setString(_key, json);
  }
}
