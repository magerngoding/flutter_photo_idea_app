// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

import 'package:flutter_photo_idea_app/data/datasource/remote_photo_datasource.dart';
import 'package:flutter_photo_idea_app/data/models/photo_model.dart';

import '../../common/enums.dart';

class CurratedPhotosController extends GetxController {
  final _state = CurratedPhotosState().obs;
  CurratedPhotosState get state => _state.value;
  set state(CurratedPhotosState n) => _state.value = n;

  void reset() {
    _state.value = CurratedPhotosState();
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    // jika tidak ada data selanjutnya
    if (!state.hasMore) return;

    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
      currentPage: state.currentPage + 1,
    );

    // await Future.delayed(Duration(seconds: 2));

    final (success, message, newList) =
        await RemotePhotoDatasource.fetchCurated(
      state.currentPage,
      10,
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
      list: [...?state.list, ...newList!],
      hasMore: newList.isNotEmpty,
    );
  }

  static delete() {
    Get.delete<CurratedPhotosController>(force: true);
  }
}

class CurratedPhotosState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel>? list;
  final int currentPage;
  final bool hasMore;

  CurratedPhotosState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list = const [],
    this.currentPage = 0,
    this.hasMore = true,
  });

  CurratedPhotosState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
    int? currentPage,
    bool? hasMore,
  }) {
    return CurratedPhotosState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
