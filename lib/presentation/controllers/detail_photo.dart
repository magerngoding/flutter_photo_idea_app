import 'package:flutter_photo_idea_app/data/datasource/remote_photo_datasource.dart';
import 'package:get/get.dart';

import '../../common/enums.dart';
import '../../data/models/photo_model.dart';

class DetailPhotoController extends GetxController {
  final _state = DetailPhotoState().obs;
  DetailPhotoState get state => _state.value;
  set state(DetailPhotoState n) => _state.value = n;

  Future<void> fetchRequest(int id) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    // kirim id
    final (success, message, data) = await RemotePhotoDatasource.fetchById(id);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
      data: data,
    );
  }

  static delete() {
    Get.delete<DetailPhotoController>(force: true);
  }
}

class DetailPhotoState {
  final FetchStatus fetchStatus;
  final String message;
  final PhotoModel? data;

  DetailPhotoState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.data,
  });

  DetailPhotoState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    PhotoModel? data,
  }) {
    return DetailPhotoState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
