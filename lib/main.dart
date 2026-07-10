import 'package:athkar/core/app_shell/app_shell_ui.dart';
import 'package:athkar/core/constants/app_constants.dart';
import 'package:athkar/core/constants/app_theme.dart';
import 'package:athkar/fauther/home/controller/tasbeeh_controller.dart';
import 'package:athkar/fauther/settings/controller/settings_controller.dart';
import 'package:athkar/fauther/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(SettingsController(), permanent: true);
  Get.put(StatisticsController(), permanent: true);
  Get.put(TasbeehController(), permanent: true);

  runApp(const NurTasbeehApp());
}

class NurTasbeehApp extends StatelessWidget {
  const NurTasbeehApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Obx(
      () => GetMaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightThemeData,
        darkTheme: AppTheme.themeData.copyWith(
          textTheme: GoogleFonts.interTextTheme(AppTheme.themeData.textTheme),
        ),
        themeMode: settingsController.materialThemeMode,
        home: const AppShell(),
      ),
    );
  }
}
