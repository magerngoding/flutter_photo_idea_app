// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_photo_idea_app/data/datasource/local_photo_datasource.dart';
import 'package:get/get.dart';

import '../../common/enums.dart';

class IsSavedController extends GetxController {
  final _state = IsSavedState().obs;
  IsSavedState get state => _state.value;
  set state(IsSavedState n) => _state.value = n;

  Future<void> executeRequest(int id) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (
      success,
      message,
      isSaved,
    ) = await LocalPhotoDatasource.checkIsSave(id);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
      status: isSaved,
    );
  }

  static delete() {
    Get.delete<IsSavedController>(force: true);
  }
}

class IsSavedState {
  final FetchStatus fetchStatus;
  final String message;
  final bool status;

  IsSavedState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.status = false,
  });

  IsSavedState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    bool? status,
  }) {
    return IsSavedState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
