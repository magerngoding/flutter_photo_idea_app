// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

import 'package:flutter_photo_idea_app/data/datasource/remote_photo_datasource.dart';
import 'package:flutter_photo_idea_app/data/models/photo_model.dart';

import '../../common/enums.dart';

class RecommendationhotosController extends GetxController {
  final _state = RecommendationPhotosState().obs;
  RecommendationPhotosState get state => _state.value;
  set state(RecommendationPhotosState n) => _state.value = n;

  Future<void> fetchRequest(String query) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    // await Future.delayed(Duration(seconds: 2));
    final (success, message, newList) = await RemotePhotoDatasource.search(
      query,
      1,
      20,
    );

    // ketika gagal
    if (!success) {
      state = state.copyWith(
        fetchStatus: FetchStatus.failed,
        message: message,
      );
      return;
    }

    // Kode dibawah ini adalah sukses
    state = state.copyWith(
      fetchStatus: FetchStatus.success,
      message: message,
      list: newList,
    );
  }

  static delete() {
    Get.delete<RecommendationhotosController>(force: true);
  }
}

class RecommendationPhotosState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel>? list;

  RecommendationPhotosState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list = const [],
  });

  RecommendationPhotosState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
  }) {
    return RecommendationPhotosState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
    );
  }
}
