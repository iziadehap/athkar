import 'dart:math';
import 'dart:ui';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:athkar/models/dhikr_item.dart';
import 'package:athkar/presentation/controllers/dhikr_controller.dart';
import 'package:athkar/var.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // طبقة الفيديو
          GetBuilder<AppController>(
            builder: (controller) {
              if (!controller.isVideoInitialized.value) {
                return Container(
                    color: Theme.of(context).scaffoldBackgroundColor);
              }
              return Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.videoController.value.size.width,
                    height: controller.videoController.value.size.height,
                    child: VideoPlayer(controller.videoController),
                  ),
                ),
              );
            },
          ),
          // طبقة التعتيم للفيديو
          Obx(() => controller.isVideoPlaying.value
              ? Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: 0.3,
                    duration: const Duration(milliseconds: 300),
                    child: Container(color: Colors.black),
                  ),
                )
              : const SizedBox.shrink()),
          // محتوى التطبيق
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildDhikrSelector(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: _buildCounter(context),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: AutoSizeText(
                      'Tasbeeh Counter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      minFontSize: 16,
                      stepGranularity: 1,
                      overflowReplacement: Text(
                        'Counter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withValues(alpha: 0.2),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Text(
                  //     DateFormat('dd.MM.yyyy').format(DateTime.now()),
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () => _showSettingsDialog(),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    final controller = Get.find<AppController>();
    Get.dialog(
      AlertDialog(
        title: const Text('الإعدادات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('الوضع المظلم'),
              trailing: Obx(() => Switch(
                    value: controller.isDarkMode.value,
                    onChanged: (value) {
                      controller.toggleTheme();
                      Get.back();
                    },
                  )),
            ),
            // يمكنك إضافة المزيد من الإعدادات هنا

            // إضافة مسافة
            const SizedBox(height: 20),

            // إضافة النص في الأسفل
            const Text(
              'Made with ❤️ by Axon',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrSelector() {
    final controller = Get.find<AppController>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _showDhikrList(),
                        child: Obx(() => Text(
                              controller.selectedDhikr.value?.text ??
                                  'اختر الذكر',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () => _showAddDhikrDialog(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.white),
                          onPressed: () => _showDhikrList(),
                        ),
                      ],
                    ),
                  ],
                ),
                Obx(
                  () => controller.selectedDhikr.value != null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedFlipCounter(
                                    value: controller.clickerCounter.value,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' / ${controller.selectedDhikr.value!.target}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  tween: Tween<double>(
                                    begin: 0,
                                    end:
                                        controller.selectedDhikr.value!.target >
                                                0
                                            ? controller.clickerCounter.value /
                                                controller
                                                    .selectedDhikr.value!.target
                                            : 0,
                                  ),
                                  builder: (context, value, _) =>
                                      LinearProgressIndicator(
                                    value: value,
                                    minHeight: 6,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.2),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(value == 0
                                            ? Colors.black
                                            : value <= 0.33
                                                ? const Color(0xFF2E7D32)
                                                : value <= 0.66
                                                    ? const Color(0xFF388E3C)
                                                    : const Color(0xFF43A047)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDhikrDialog() {
    final textController = TextEditingController();
    final targetController = TextEditingController();
    final controller = Get.find<AppController>();

    Get.dialog(
      AlertDialog(
        title: const Text('إضافة ذكر جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'نص الذكر',
                hintText: 'ادخل نص الذكر',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'عدد المرات',
                hintText: 'ادخل عدد المرات',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isEmpty &&
                  targetController.text.isEmpty) {
                Get.snackbar(
                  'تنبيه',
                  'الرجاء إدخال نص الذكر وعدد المرات',
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }

              if (textController.text.isEmpty) {
                Get.snackbar(
                  'تنبيه',
                  'الرجاء إدخال نص الذكر',
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }

              if (targetController.text.isEmpty) {
                Get.snackbar(
                  'تنبيه',
                  'الرجاء إدخال ع��د المرات',
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }

              final target = int.tryParse(targetController.text);
              if (target == null || target <= 0) {
                Get.snackbar(
                  'تنبيه',
                  'الرجاء إدخال عدد صحيح موجب',
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }

              controller.addDhikr(DhikrItem(
                text: textController.text,
                target: target,
                current: 0,
                lastUpdated: DateTime.now(),
              ));

              Get.back();
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showDhikrList() {
    final controller = Get.find<AppController>();
    Get.dialog(
      AlertDialog(
        title: const Text('قائمة الأذكار'),
        content: Obx(() {
          if (controller.dhikrList.isEmpty) {
            return Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.note_alt_outlined,
                    size: 50,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا يوجد أذكار حالياً',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _showAddDhikrDialog();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة ذكر جديد'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // عرض القائمة العادية إذا كان هناك أذكار
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: controller.dhikrList.asMap().entries.map((entry) {
                final dhikr = entry.value;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                  child: ListTile(
                    title: Text(
                      dhikr.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: LinearProgressIndicator(
                      value:
                          dhikr.target > 0 ? dhikr.current / dhikr.target : 0,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${dhikr.current}/${dhikr.target}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.back();
                            Get.dialog(
                              AlertDialog(
                                title: const Text('أكيد الحذف'),
                                content:
                                    const Text('هل أنت متأكد من ذف هذا الكر؟'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('إلغاء'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.removeDhikr(entry.key);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('حذف'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      controller.selectDhikr(dhikr);
                      Get.back();
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    final controller = Get.find<AppController>();
    final screenWidth = MediaQuery.of(context).size.width;
    const double smallIconSize = 50;
    const double smallIconHorizontalMargins = 32; // 16 left + 16 right
    final double availableForCircle =
        screenWidth - 2 * (smallIconSize + smallIconHorizontalMargins);
    final double circleSize = max(120.0, min(280.0, availableForCircle));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSmallCounterIcons(() => controller.setClickerImageIndex(),
            'assets/images/colors.png'),
        ClipRRect(
          borderRadius: BorderRadius.circular(circleSize / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: GestureDetector(
              onTap: () {
                controller.setClickerCounter();
                HapticFeedback.mediumImpact();
              },
              child: Container(
                height: circleSize,
                width: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(() => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return RotationTransition(
                              turns: Tween<double>(
                                begin: 0.5,
                                end: 1.0,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Image.asset(
                            clickerImages[controller.clickerImageIndex.value],
                            key: ValueKey<int>(
                                controller.clickerImageIndex.value),
                            width: circleSize * 0.86,
                            height: circleSize * 0.86,
                          ),
                        )),
                    Obx(() => AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: circleSize * 0.22),
                            child: Text(
                              '${controller.clickerCounter.value}',
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildSmallCounterIcons(
            () => controller.clickerCounterReset(), 'assets/images/replay.png'),
      ],
    );
  }

  Widget _buildSmallCounterIcons(onTap, image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withValues(alpha: 0.2),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: onTap,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
