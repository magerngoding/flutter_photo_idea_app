import 'package:fd_log/fd_log.dart';
import 'package:flutter_photo_idea_app/data/db/database_helper.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;
// service locator
initInjection() {
  FDLog fdLog = FDLog(
    bodyColorCode: 49,
    titleColorCode: 50,
    maxCharPerRow: 70,
    maxRow: 5,
    prefix: '>',
  );
  sl.registerLazySingleton(() => fdLog);
  sl.registerLazySingleton(() => DatabaseHelper());

  // final log1 = FDLog();
  // final log2 = FDLog();
  // final log3 = sl<FDLog>();
  // final log4 = sl<FDLog>();

  // // print(log1 == log2);
  // // print(log1.bodyColorCode == log2.bodyColorCode);
  // // print(identical(log1, log2));

  // print(log3 == log4);
  // print(log3.bodyColorCode == log4.bodyColorCode);
  // print(identical(log3, log4));

  // Fungsi DI untuk menghemat remory
}
