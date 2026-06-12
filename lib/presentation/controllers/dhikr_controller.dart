import 'dart:async';
import 'dart:math' show Random, pi;

import 'package:athkar/data/datasources/local_storage.dart';
import 'package:athkar/models/dhikr_item.dart';
import 'package:athkar/var.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AppController extends GetxController {
  final _storage = Get.find<LocalStorage>();
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  final dhikrList = <DhikrItem>[].obs;
  final selectedDhikr = Rxn<DhikrItem>();
  final clickerCounter = 0.obs;
  final clickerImageIndex = 0.obs;

  // إضافة متغير للخلفية الحالية
  final currentBackground = 0.obs;

  // إضافة متغير للوضع المظلم
  final isDarkMode = false.obs;

  late VideoPlayerController videoController;
  final isVideoInitialized = false.obs;
  final isVideoPlaying = false.obs;

  // وقت آخر تغيير للثيم
  final lastThemeChangeTime = Rxn<DateTime>();

  static const String themeTransitionVideo =
      'assets/videos/theme_transition.mp4';

  bool get isNightTime {
    final now = DateTime.now();
    // اعتبار الليل من 6 مساءً حتى 6 صباحاً
    return now.hour >= 18 || now.hour < 6;
  }

  @override
  void onInit() async {
    super.onInit();
    await loadThemeMode();
    await initializeVideo();
    await loadDhikrs();
    await checkAndUpdateDayNightTheme();
  }

  Future<void> initializeVideo() async {
    try {
      videoController = VideoPlayerController.asset(themeTransitionVideo);
      await videoController.initialize();

      // تحديد نقطة البداية الصحيحة للوضع المظلم
      if (isDarkMode.value) {
        // إذا كان الوضع مظلم، نضع الفيديو عند الثانية 5
        await videoController.seekTo(const Duration(seconds: 5));
      } else {
        // إذا كان الوضع عادي، نضع الفيديو عند البداية
        await videoController.seekTo(Duration.zero);
      }

      isVideoInitialized.value = true;
      videoController.addListener(_videoListener);
      update();
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _videoListener() {
    if (!videoController.value.isPlaying) return;

    final position = videoController.value.position;

    if (!isDarkMode.value && position >= const Duration(seconds: 5)) {
      // إيقاف عند الثانية 5 للوضع المظلم
      videoController.pause();
      videoController.seekTo(const Duration(seconds: 5));
      isVideoPlaying.value = false;
      isDarkMode.value = true;
      _storage.saveDarkMode(true);
      Get.changeThemeMode(ThemeMode.dark);
      update();
    } else if (isDarkMode.value && position >= const Duration(seconds: 10)) {
      // إيقاف عند الثانية 10 للوضع العادي
      videoController.pause();
      videoController.seekTo(const Duration(seconds: 10));
      isVideoPlaying.value = false;
      isDarkMode.value = false;
      _storage.saveDarkMode(false);
      Get.changeThemeMode(ThemeMode.light);
      update();
    }
  }

  // دالة لتغيير الخلفية عشوائياً
  void changeBackground() {
    final random = Random();
    int newIndex;
    do {
      newIndex = random.nextInt(backgroundImages.length);
    } while (
        newIndex == currentBackground.value && backgroundImages.length > 1);
    currentBackground.value = newIndex;
  }

  Future<void> loadDhikrs() async {
    final items = await _storage.getDhikrs();

    // إذا كانت القائمة فارغة (أول تنزيل)، نضيف أذكار افتراضية
    if (items.isEmpty) {
      final defaultDhikrs = [
        DhikrItem(
          text: 'سبحان الله وبحمده',
          target: 33,
          current: 0,
          lastUpdated: DateTime.now(),
        ),
        DhikrItem(
          text: 'لا إله إلا الله',
          target: 33,
          current: 0,
          lastUpdated: DateTime.now(),
        ),
        DhikrItem(
          text: 'الله أكبر',
          target: 33,
          current: 0,
          lastUpdated: DateTime.now(),
        ),
        DhikrItem(
          text: 'أستغفر الله',
          target: 33,
          current: 0,
          lastUpdated: DateTime.now(),
        ),
      ];

      items.addAll(defaultDhikrs);
      await _storage.saveDhikrs(items);
    }

    _resetExpiredDhikrs(items);
    dhikrList.value = items;

    // تحديد الذكر الافتراضي كذكر مختار
    if (selectedDhikr.value == null && items.isNotEmpty) {
      selectedDhikr.value = items.first;
    }
  }

  void _resetExpiredDhikrs(List<DhikrItem> items) {
    final now = DateTime.now();
    for (var dhikr in items) {
      if (dhikr.lastUpdated != null &&
          now.difference(dhikr.lastUpdated!).inDays >= 1) {
        dhikr.current = 0;
        dhikr.lastUpdated = null;
      }
    }
  }

  void setClickerImageIndex() {
    if (clickerImageIndex.value < clickerImages.length - 1) {
      clickerImageIndex.value++;
    } else {
      clickerImageIndex.value = 0;
    }
  }

  void setClickerCounter() {
    if (selectedDhikr.value == null) {
      final uncompletedDhikr =
          dhikrList.firstWhereOrNull((dhikr) => dhikr.current < dhikr.target);

      if (uncompletedDhikr != null) {
        selectDhikr(uncompletedDhikr);
        return;
      } else {
        Get.snackbar(
          'تنبيه',
          'الرجاء إضافة ذكر جديد',
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );
        return;
      }
    }

    if (selectedDhikr.value!.current >= selectedDhikr.value!.target) {
      final nextDhikr = dhikrList.firstWhereOrNull((dhikr) =>
          dhikr.current < dhikr.target && dhikr != selectedDhikr.value);

      if (nextDhikr != null) {
        selectDhikr(nextDhikr);
        return;
      }
    }

    if (clickerCounter.value < selectedDhikr.value!.target) {
      clickerCounter.value++;
      selectedDhikr.value!.current = clickerCounter.value;
      selectedDhikr.value!.lastUpdated = DateTime.now();

      _storage.saveDhikrs(dhikrList);

      if (clickerCounter.value == selectedDhikr.value!.target) {
        _showCelebration();
      }
    }
  }

  void clickerCounterReset() {
    if (selectedDhikr.value != null) {
      Get.dialog(
        AlertDialog(
          title: const Text('تأكيد إعادة التعيين'),
          content: const Text('هل أنت متأكد من إعادة تعيين العداد؟'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                clickerCounter.value = 0;
                selectedDhikr.value!.current = 0;
                _storage.saveDhikrs(dhikrList);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('إعادة تعيين'),
            ),
          ],
        ),
      );
    }
  }

  void selectDhikr(DhikrItem dhikr) {
    selectedDhikr.value = dhikr;
    clickerCounter.value = dhikr.current;
    update();
  }

  void _showCelebration() {
    final isDarkMode = Get.isDarkMode;
    confettiController.play();
    Get.dialog(
      Stack(
        alignment: Alignment.center,
        children: [
          // قصاصات من اليسار
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          // قصاصات من الوسط
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          // قصاصت من اليمين
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          // قصاصات من اليسار الأوسط
          Align(
            alignment: const Alignment(-0.5, -1),
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          // قصاصات من اليمين الأوسط
          Align(
            alignment: const Alignment(0.5, -1),
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          AlertDialog(
            backgroundColor: isDarkMode
                ? Colors.black.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'مبروك!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'لقد أكملت الذكر',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 18,
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void addDhikr(DhikrItem dhikr) {
    dhikrList.add(dhikr);
    _storage.saveDhikrs(dhikrList);
  }

  void removeDhikr(int index) {
    if (selectedDhikr.value == dhikrList[index]) {
      selectedDhikr.value = null;
      clickerCounter.value = 0;
    }
    dhikrList.removeAt(index);
    _storage.saveDhikrs(dhikrList);
  }

  void confirmRemoveDhikr(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الذكر؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              removeDhikr(index);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void confirmReset() {
    if (selectedDhikr.value == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد إعادة التعيين'),
        content: const Text('هل أنت مأكد من إعادة تيين العداد؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              clickerCounterReset();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  // تحميل حالة الثيم
  Future<void> loadThemeMode() async {
    isDarkMode.value = await _storage.getDarkMode();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  // تحديث الثيم يدوياً من الإعدادات
  Future<void> toggleTheme() async {
    try {
      if (isDarkMode.value) {
        // التحول للوضع العادي (من 5 إلى 10)
        await videoController.seekTo(const Duration(seconds: 5));
      } else {
        // التحول للوضع المظلم (من 0 إلى 5)
        await videoController.seekTo(Duration.zero);
      }

      isVideoPlaying.value = true;
      await videoController.play();
      update();
    } catch (e) {
      print('Error in toggleTheme: $e');
      isVideoPlaying.value = false;
      update();
    }
  }

  Future<void> checkAndUpdateDayNightTheme() async {
    final lastChange = await _storage.getLastThemeChangeTime();
    final now = DateTime.now();
    final isNight = now.hour >= 18 || now.hour < 6;

    // تحقق مما إذا كان آخر تغيير في نفس اليوم ونفس الفترة (ليلاً أو نهاراً)
    bool shouldChange = false;

    if (lastChange == null) {
      shouldChange = true;
    } else {
      final sameDay = lastChange.day == now.day &&
          lastChange.month == now.month &&
          lastChange.year == now.year;
      final wasNight = lastChange.hour >= 18 || lastChange.hour < 6;

      // تغيير الثيم إذا:
      // 1. يوم مختلف، أو
      // 2. نفس اليوم ولكن تغيرت الفترة (من نهار لليل أو العكس)
      shouldChange = !sameDay || (wasNight != isNight);
    }

    if (shouldChange) {
      if (isNight && !isDarkMode.value) {
        // التحول للوضع المظلم
        await videoController.seekTo(Duration.zero);
        isVideoPlaying.value = true;
        await videoController.play();
      } else if (!isNight && isDarkMode.value) {
        // التحول للوضع العادي
        await videoController.seekTo(const Duration(seconds: 5));
        isVideoPlaying.value = true;
        await videoController.play();
      }

      // حفظ وقت آخر تغيير
      await _storage.saveLastThemeChangeTime(now);
    }
  }

  @override
  void onClose() {
    videoController.removeListener(_videoListener);
    videoController.dispose();
    confettiController.dispose();
    super.onClose();
  }
}
