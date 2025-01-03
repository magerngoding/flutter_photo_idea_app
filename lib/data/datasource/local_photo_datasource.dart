import 'package:flutter_photo_idea_app/data/db/database_helper.dart';
import 'package:flutter_photo_idea_app/data/models/photo_model.dart';

import '../../core/di.dart';

class LocalPhotoDatasource {
  static Future<(bool, String, List<PhotoModel>?)> fetchAll() async {
    try {
      final database = await sl<DatabaseHelper>().database;
      final list = await database.query('saved');
      final photos = list.map((e) => PhotoModel.fromJsonSaved(e)).toList();

      return (true, 'Fetch Success', photos);
    } catch (e) {
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, bool?)> checkIsSave(int id) async {
    try {
      final database = await sl<DatabaseHelper>().database;
      final list = await database.query(
        'saved',
        where: 'id=?',
        whereArgs: [id],
      );
      return (true, 'Success Check', list.isNotEmpty);
    } catch (e) {
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> savePhoto(PhotoModel photo) async {
    try {
      final database = await sl<DatabaseHelper>().database;
      final rowAffected = await database.insert(
        'saved',
        photo.toJsonSaved(),
      );
      if (rowAffected != 0) {
        return (true, 'Photo has saved!');
      }
      return (true, 'Photo has not saved!');
    } catch (e) {
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String)> unSavedPhoto(int id) async {
    try {
      final database = await sl<DatabaseHelper>().database;
      final rowAffected = await database.delete(
        'saved',
        // pakai dibawah ini agar data tidak kehapus semua, karena menghapus berdasarkan ID
        where: 'id=?',
        whereArgs: [id],
      );
      if (rowAffected != 0) {
        return (true, 'Removed from saved!');
      }
      return (true, 'Failed to unsaved!');
    } catch (e) {
      return (false, 'Something went wrong');
    }
  }
}
