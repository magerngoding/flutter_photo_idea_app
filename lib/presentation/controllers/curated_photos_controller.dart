import 'package:flutter_photo_idea_app/data/datasource/remote_photo_datasource.dart';
import 'package:flutter_photo_idea_app/data/models/photo_model.dart';
import 'package:get/get.dart';

import '../../common/enums.dart';

class CurratedPhotosController extends GetxController {
  final _state = CurratedPhotosState().obs;
  CurratedPhotosState get state => _state.value;
  set state(CurratedPhotosState n) => _state.value = n;

  Future<void> fetchRequest() async {
    state = state.copyWith(
      fetchtStatus: FetchStatus.loading,
    );

    final (success, message, list) = await RemotePhotoDatasource.fetchCurated(
      1,
      15,
    );

    state = state.copyWith(
      fetchtStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
      list: list,
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

  CurratedPhotosState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list,
  });

  CurratedPhotosState copyWith({
    FetchStatus? fetchtStatus,
    String? message,
    List<PhotoModel>? list,
  }) {
    return CurratedPhotosState(
      fetchStatus: fetchtStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
    );
  }
}
