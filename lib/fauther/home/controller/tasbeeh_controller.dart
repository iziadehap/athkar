import 'package:athkar/core/model.dart';
import 'package:athkar/core/service/storage_service.dart';
import 'package:athkar/fauther/settings/controller/settings_controller.dart';
import 'package:athkar/fauther/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TasbeehController extends GetxController {
  var athkarList = <Model>[].obs;
  Rx<Model?> selectedAthkar = Rxn<Model>();
  var currentCount = 0.obs;
  final completionEvent = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final cachedData = TasbeehStorage.load();
    if (cachedData.isEmpty) {
      athkarList.assignAll(getDefaultAthkar());
    } else {
      athkarList.assignAll(cachedData);
    }

    if (athkarList.isNotEmpty) {
      selectedAthkar.value = athkarList.first;
    }

    ever(athkarList, (List<Model> updatedList) {
      TasbeehStorage.save(updatedList);
    });
  }

  void tap() {
    final activeItem =
        selectedAthkar.value ?? (athkarList.isNotEmpty ? athkarList[0] : null);

    if (activeItem == null) return;

    _triggerHaptic();

    final wasComplete = currentCount.value >= activeItem.reps;

    if (currentCount.value < activeItem.reps) {
      currentCount.value++;
    } else {
      currentCount.value = 1;
    }

    if (Get.isRegistered<StatisticsController>()) {
      Get.find<StatisticsController>().recordTap();
    }

    if (!wasComplete && currentCount.value >= activeItem.reps) {
      _triggerSound();

      // ✅ Fire the completion event ONLY once
      completionEvent.value++;
    } else if (currentCount.value % 33 == 0) {
      _triggerSound();
    }
  }

  void _triggerHaptic() {
    if (!Get.isRegistered<SettingsController>()) return;
    if (Get.find<SettingsController>().settings.value.hapticEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  void _triggerSound() {
    if (!Get.isRegistered<SettingsController>()) return;
    if (Get.find<SettingsController>().settings.value.soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  List<Model> get allAthkar => athkarList;

  void selectThekr(int index) {
    if (index >= 0 && index < athkarList.length) {
      selectedAthkar.value = athkarList[index];
      currentCount.value = 0;
    }
  }

  void addAthkar(Model newItem) {
    athkarList.add(newItem);
  }

  void removeAthkar(int index) {
    if (index >= 0 && index < athkarList.length) {
      if (selectedAthkar.value == athkarList[index]) {
        selectedAthkar.value = athkarList.isNotEmpty ? athkarList.first : null;
        currentCount.value = 0;
      }
      athkarList.removeAt(index);
    }
  }

  void editAthkar(int index, Model updatedItem) {
    if (index >= 0 && index < athkarList.length) {
      athkarList[index] = updatedItem;
    }
  }

  List<Model> getDefaultAthkar() {
    return [
      Model(
        groupName: 'Daily',
        arThekr: 'سُبْحَانَ اللَّهِ',
        arThekrMean: 'سبحان الله وبحمده سبحان الله العظيم',
        enThekr: 'SubhanAllah',
        enThekrMean: 'Glory be to Allah',
        reps: 33,
      ),
      Model(
        groupName: 'Daily',
        arThekr: 'الْحَمْدُ لِلَّهِ',
        arThekrMean: 'الحمد لله رب العالمين',
        enThekr: 'Alhamdulillah',
        enThekrMean: 'Praise be to Allah',
        reps: 33,
      ),
      Model(
        groupName: 'Daily',
        arThekr: 'اللَّهُ أَكْبَرُ',
        arThekrMean: 'الله أكبر كبيراً',
        enThekr: 'Allahu Akbar',
        enThekrMean: 'Allah is the Greatest',
        reps: 34,
      ),
      Model(
        groupName: 'Daily',
        arThekr: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
        arThekrMean: 'لا إله إلا الله وحده لا شريك له',
        enThekr: 'La ilaha illa Allah',
        enThekrMean: 'There is no god but Allah',
        reps: 10,
      ),
      Model(
        groupName: 'Daily',
        arThekr: 'أَسْتَغْفِرُ اللَّهَ',
        arThekrMean: 'أستغفر الله العظيم',
        enThekr: 'Astaghfirullah',
        enThekrMean: 'I seek forgiveness from Allah',
        reps: 25,
      ),
      Model(
        groupName: 'Morning',
        arThekr: 'اللَّهُمَّ بِكَ أَصْبَحْنَا',
        arThekrMean: 'اللهم بك أصبحنا وبك أمسينا',
        enThekr: 'Allahumma bika asbahna',
        enThekrMean: 'O Allah, by You we enter the morning',
        reps: 1,
      ),
      Model(
        groupName: 'Morning',
        arThekr: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        arThekrMean: 'سبحان الله وبحمده عدد خلقه',
        enThekr: 'SubhanAllahi wa bihamdihi',
        enThekrMean: 'Glory be to Allah and praise Him',
        reps: 100,
      ),
      Model(
        groupName: 'Evening',
        arThekr: 'اللَّهُمَّ بِكَ أَمْسَيْنَا',
        arThekrMean: 'اللهم بك أمسينا وبك أصبحنا',
        enThekr: 'Allahumma bika amsayna',
        enThekrMean: 'O Allah, by You we enter the evening',
        reps: 1,
      ),
      Model(
        groupName: 'Evening',
        arThekr: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ',
        arThekrMean: 'أعوذ بكلمات الله التامات من شر ما خلق',
        enThekr: 'A\'udhu bi kalimatillah',
        enThekrMean: 'I seek refuge in the perfect words of Allah',
        reps: 3,
      ),
      Model(
        groupName: 'Travel',
        arThekr: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا',
        arThekrMean: 'سبحان الذي سخر لنا هذا وما كنا له مقرنين',
        enThekr: 'Subhan alladhi sakhkhara lana',
        enThekrMean: 'Glory to Him who has subjected this to us',
        reps: 1,
      ),
      Model(
        groupName: 'Travel',
        arThekr: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ',
        arThekrMean: 'اللهم إنا نسألك في سفرنا هذا البر والتقوى',
        enThekr: 'Allahumma inna nas\'aluka',
        enThekrMean: 'O Allah, we ask You in this journey',
        reps: 1,
      ),
    ];
  }

  void resetAll() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF191F31),
        title: const Text(
          'Reset Dhikr Library?',
          style: TextStyle(color: Color(0xFFDCE1FB)),
        ),
        content: const Text(
          'This will restore the default dhikr list. Your statistics will be kept.',
          style: TextStyle(color: Color(0xFFBFC9C3)),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              athkarList.assignAll(getDefaultAthkar());
              selectedAthkar.value =
                  athkarList.isNotEmpty ? athkarList.first : null;
              currentCount.value = 0;
              Get.back();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
