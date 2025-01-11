import 'package:flutter_photo_idea_app/common/enums.dart';
import 'package:flutter_photo_idea_app/data/datasource/local_photo_datasource.dart';
import 'package:flutter_photo_idea_app/data/models/photo_model.dart';
import 'package:get/get.dart';

class SavePhotoController extends GetxController {
  final _state = SavePhotoState().obs;
  SavePhotoState get state => _state.value;
  set state(SavePhotoState n) => _state.value = n;

  Future<SavePhotoState> save(PhotoModel photo) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message) = await LocalPhotoDatasource.savePhoto(photo);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
    );

    return state;
  }

  Future<SavePhotoState> unsave(int id) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message) = await LocalPhotoDatasource.unsavePhoto(id);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
    );

    return state;
  }

  static delete() {
    Get.delete<SavePhotoController>(force: true);
  }
}

class SavePhotoState {
  final FetchStatus fetchStatus;
  final String message;

  SavePhotoState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
  });

  SavePhotoState copyWith({
    FetchStatus? fetchStatus,
    String? message,
  }) {
    return SavePhotoState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
    );
  }
}
