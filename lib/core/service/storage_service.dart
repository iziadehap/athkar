import 'dart:convert';

import 'package:athkar/core/model.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:get_storage/get_storage.dart';
// import 'model.dart'; // Make sure to import your Model class

class TasbeehStorage {
  static final _box = GetStorage();
  static const _key = 'user_athkar_list';

  static List<Model> load() {
    final raw = _box.read<String>(_key);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((item) => Model.fromJson(item)).toList();
  }

  static void save(List<Model> list) {
    final String encoded =
        jsonEncode(list.map((item) => item.toJson()).toList());
    _box.write(_key, encoded);
  }

  // static Future<void> reset() async {
  //   await _box.erase();
  // }
}
