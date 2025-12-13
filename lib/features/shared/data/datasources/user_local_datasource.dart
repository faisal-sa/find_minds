import 'dart:convert';

import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


@injectable
class UserLocalDataSource {
  final SharedPreferences prefs;
  static const String _storageKey = 'user_entity_data';

  UserLocalDataSource(this.prefs);

  Future<UserEntity?> getLastUser() async {
    final jsonString = prefs.getString(_storageKey);
    print("getting last user");
    
    if (jsonString != null) {
      try {
        // Try to decode valid JSON
        print("decoding");
        return UserEntity.fromJson(jsonDecode(jsonString));
      } catch (e) {
        
        // If the data is corrupted (FormatException), clear it!
        print("Local data corrupted. Clearing cache. Error: $e");
        await prefs.remove(_storageKey); 
        return null;
      }
    }
    return null;
  }

  Future<void> cacheUser(UserEntity user) async {
    // ENSURE you use jsonEncode here
    await prefs.setString(_storageKey, jsonEncode(user.toJson()));
  }
}