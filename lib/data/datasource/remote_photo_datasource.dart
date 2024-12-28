// ignore_for_file: prefer_const_declarations

import 'dart:convert';

import 'package:fd_log/fd_log.dart';
import 'package:flutter_photo_idea_app/core/api_keys.dart';
import 'package:flutter_photo_idea_app/core/apis.dart';
import 'package:flutter_photo_idea_app/core/di.dart';
import 'package:flutter_photo_idea_app/data/models/photo_model.dart';
import 'package:http/http.dart' as http;

class RemotePhotoDatasource {
  static Future<(bool, String, List<PhotoModel>?)> fetchCurated(
    int page,
    int perPage,
  ) async {
    final url = '${APIs.pexelsBaseURL}/curated?page=$page&per_page=$perPage';
    const headers = {
      'Authorization': APIKeys.pexels,
    };
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      sl<FDLog>().response(response);
      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        final rawPhotos = List.from(resBody['photos']);
        final photos = rawPhotos.map((json) {
          return PhotoModel.fromJson(json);
        }).toList();
        return (true, 'Fetch Success', photos);
      }

      return (false, 'Fetch Failed', null);
    } catch (e) {
      sl<FDLog>().basic(e.toString());
      return (false, 'Something went wrong', null);
    }
  }

  static Future<Record> search(
    String query,
    int page,
    int perPage,
  ) async {
    final url =
        '${APIs.pexelsBaseURL}/search?query=$query&page=$page&per_page=$perPage';

    const headers = {
      'Authorization': APIKeys.pexels,
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      sl<FDLog>().response(response);
      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);

        final rawPhotos = List.from(resBody['photos']);

        final photos = rawPhotos.map((json) {
          return PhotoModel.fromJson(json);
        }).toList();

        return (true, 'Search Success', photos);
      }

      if (response.statusCode == 404) {
        return (false, 'Not Found', null);
      }

      return (false, 'Search Failed', null);
    } catch (e) {
      sl<FDLog>().basic(e.toString());

      return (false, 'Something went wrong');
    }
  }

  static Future<Record> fetchById(int id) async {
    final url = '${APIs.pexelsBaseURL}/photos/id';

    const headers = {
      'Authorization': APIKeys.pexels,
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      sl<FDLog>().response(response);
      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);

        final photo = PhotoModel.fromJson(resBody);

        return (true, 'Fetch Success', photo);
      }

      if (response.statusCode == 404) {
        return (false, 'Not Found', null);
      }

      return (false, 'Search Failed', null);
    } catch (e) {
      sl<FDLog>().basic(e.toString());

      return (false, 'Something went wrong');
    }
  }
}
