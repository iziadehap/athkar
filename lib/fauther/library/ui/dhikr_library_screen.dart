import 'package:athkar/core/app_shell/app_shell_controller.dart';
import 'package:athkar/core/constants/app_theme.dart';
import 'package:athkar/core/model.dart';
import 'package:athkar/core/widgets/atmospheric_background.dart';
import 'package:athkar/core/widgets/athkar_app_bar.dart';
import 'package:athkar/fauther/home/controller/tasbeeh_controller.dart';
import 'package:athkar/fauther/library/controller/library_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DhikrLibraryScreen extends StatelessWidget {
  const DhikrLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TasbeehController tasbeehController = Get.find<TasbeehController>();
    final LibraryController libraryController = Get.find<LibraryController>();
    final NavigationController navController = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AtmosphericBackground(
        showShader: false,
        child: SafeArea(
          child: Column(
            children: [
              NurAppBar(onStreakTap: tasbeehController.resetAll),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerLow
                                  .withValues(alpha: 0.4),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.roundedLg),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: TextField(
                              style: const TextStyle(color: AppTheme.onSurface),
                              onChanged: libraryController.updateSearch,
                              decoration: InputDecoration(
                                hintText: 'Search adhkar...',
                                hintStyle: TextStyle(
                                  color: AppTheme.onSurfaceVariant
                                      .withValues(alpha: 0.4),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppTheme.onSurfaceVariant,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _showAddEditBottomSheet(
                              context, tasbeehController),
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer
                                  .withValues(alpha: 0.4),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.roundedLg),
                              border: Border.all(
                                color: AppTheme.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child:
                                const Icon(Icons.add, color: AppTheme.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: LibraryController.categories.length,
                        itemBuilder: (context, index) {
                          final category = LibraryController.categories[index];
                          return Obx(() {
                            final isSelected =
                                libraryController.selectedCategory.value ==
                                    category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (_) =>
                                    libraryController.selectCategory(category),
                                selectedColor: AppTheme.primaryContainer,
                                backgroundColor: AppTheme.surfaceContainerLow
                                    .withValues(alpha: 0.4),
                                labelStyle: AppTheme.labelSm.copyWith(
                                  color: isSelected
                                      ? AppTheme.tertiary
                                      : AppTheme.onSurfaceVariant,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.roundedFull),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppTheme.primary
                                            .withValues(alpha: 0.3)
                                        : Colors.white10,
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  final filteredList =
                      tasbeehController.athkarList.where((item) {
                    final matchesCategory = item.groupName.toLowerCase() ==
                        libraryController.selectedCategory.value.toLowerCase();
                    final query =
                        libraryController.searchQuery.value.toLowerCase();
                    final matchesSearch =
                        item.enThekr.toLowerCase().contains(query) ||
                            item.arThekr
                                .contains(libraryController.searchQuery.value);
                    return matchesCategory && matchesSearch;
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        "No entries found in '${libraryController.selectedCategory.value}'",
                        style: TextStyle(
                          color:
                              AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final globalIndex =
                          tasbeehController.athkarList.indexOf(item);

                      return Obx(() {
                        final isCurrentActive =
                            tasbeehController.selectedAthkar.value == item ||
                                (tasbeehController.selectedAthkar.value ==
                                        null &&
                                    globalIndex == 0);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow
                                .withValues(alpha: 0.4),
                            borderRadius:
                                BorderRadius.circular(AppTheme.roundedLg * 2),
                            border: Border.all(
                              color: isCurrentActive
                                  ? AppTheme.primary.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.05),
                            ),
                            boxShadow: isCurrentActive
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryContainer
                                          .withValues(alpha: 0.2),
                                      blurRadius: 20,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.enThekr,
                                          style: AppTheme.titleMd.copyWith(
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.enThekrMean,
                                          style: TextStyle(
                                            color: AppTheme.onSurfaceVariant
                                                .withValues(alpha: 0.7),
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryContainer
                                              .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${item.reps} reps',
                                          style: AppTheme.labelSm.copyWith(
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: AppTheme.onSurfaceVariant,
                                          size: 20,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        color: AppTheme.surfaceContainer,
                                        surfaceTintColor: Colors.transparent,
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _showAddEditBottomSheet(
                                              context,
                                              tasbeehController,
                                              item: item,
                                              index: globalIndex,
                                            );
                                          } else if (value == 'delete') {
                                            _confirmDelete(
                                              context,
                                              tasbeehController,
                                              globalIndex,
                                            );
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    size: 16,
                                                    color: AppTheme.onSurface),
                                                SizedBox(width: 8),
                                                Text('Edit',
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .onSurface)),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    size: 16,
                                                    color: AppTheme.error),
                                                SizedBox(width: 8),
                                                Text('Delete',
                                                    style: TextStyle(
                                                        color: AppTheme.error)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  item.arThekr,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    // fontFamily: AppTheme.fontAmiri,
                                    fontSize: 24,
                                    color: AppTheme.tertiary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isCurrentActive
                                        ? AppTheme.primaryContainer
                                        : AppTheme.surfaceContainerHighest
                                            .withValues(alpha: 0.5),
                                    foregroundColor: isCurrentActive
                                        ? AppTheme.primary
                                        : AppTheme.onSurfaceVariant,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: isCurrentActive
                                          ? BorderSide.none
                                          : const BorderSide(
                                              color: Colors.white10,
                                            ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    tasbeehController.selectThekr(globalIndex);
                                    navController.animateToPage(0);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('SELECT', style: AppTheme.labelSm),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, TasbeehController controller, int index) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text('Delete Dhikr?',
            style: TextStyle(color: AppTheme.onSurface)),
        content: const Text(
          'Are you sure you want to remove this dhikr from your library?',
          style: TextStyle(color: AppTheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removeAthkar(index);
              Get.back();
              Get.snackbar(
                'Dhikr Removed',
                'The dhikr has been deleted.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.surfaceContainerHigh,
                colorText: AppTheme.onSurface,
              );
            },
            child:
                const Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  void _showAddEditBottomSheet(
    BuildContext context,
    TasbeehController controller, {
    Model? item,
    int? index,
  }) {
    final isEdit = item != null;
    final enTitleCtrl = TextEditingController(text: item?.enThekr ?? '');
    final arTitleCtrl = TextEditingController(text: item?.arThekr ?? '');
    final enMeanCtrl = TextEditingController(text: item?.enThekrMean ?? '');
    final arMeanCtrl = TextEditingController(text: item?.arThekrMean ?? '');
    final repsCtrl = TextEditingController(text: item?.reps.toString() ?? '33');
    final selectedCategory = (item?.groupName ?? 'Daily').obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: const Border(
            top: BorderSide(color: Colors.white10),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEdit ? 'Edit Dhikr' : 'Add New Dhikr',
                    style: const TextStyle(
                      // fontFamily: AppTheme.fontInter,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppTheme.onSurfaceVariant),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildField('English Phrase', enTitleCtrl,
                  hint: 'e.g. SubhanAllah'),
              const SizedBox(height: 12),
              _buildField('Arabic Phrase', arTitleCtrl,
                  hint: 'e.g. سُبْحَانَ اللَّهِ', alignRight: true),
              const SizedBox(height: 12),
              _buildField('Translation / Meaning', enMeanCtrl,
                  hint: 'e.g. Glory be to Allah'),
              const SizedBox(height: 12),
              _buildField('Arabic Explanation (Optional)', arMeanCtrl,
                  hint: 'e.g. سبحان الله وبحمده', alignRight: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildField('Target Reps', repsCtrl,
                        hint: '33', keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(() => Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCategory.value,
                                  dropdownColor: const Color(0xFF191F31),
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: AppTheme.primary),
                                  style: const TextStyle(
                                      color: AppTheme.onSurface),
                                  items:
                                      ['Daily', 'Morning', 'Evening', 'Travel']
                                          .map((cat) => DropdownMenuItem(
                                                value: cat,
                                                child: Text(cat),
                                              ))
                                          .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      selectedCategory.value = val;
                                    }
                                  },
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (enTitleCtrl.text.isEmpty || arTitleCtrl.text.isEmpty) {
                      Get.snackbar(
                        'Required Fields Missing',
                        'Please fill in at least the English and Arabic phrases.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppTheme.errorContainer,
                        colorText: AppTheme.onErrorContainer,
                      );
                      return;
                    }
                    final reps = int.tryParse(repsCtrl.text) ?? 33;
                    final newModel = Model(
                      groupName: selectedCategory.value,
                      arThekr: arTitleCtrl.text,
                      arThekrMean: arMeanCtrl.text.isEmpty
                          ? arTitleCtrl.text
                          : arMeanCtrl.text,
                      enThekr: enTitleCtrl.text,
                      enThekrMean: enMeanCtrl.text,
                      reps: reps,
                    );

                    if (isEdit && index != null) {
                      controller.editAthkar(index, newModel);
                    } else {
                      controller.addAthkar(newModel);
                    }

                    Get.back();
                    Get.snackbar(
                      isEdit ? 'Dhikr Updated' : 'Dhikr Added',
                      'The dhikr has been saved successfully.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppTheme.surfaceContainerHigh,
                      colorText: AppTheme.onSurface,
                    );
                  },
                  child: Text(isEdit ? 'SAVE CHANGES' : 'ADD DHIKR',
                      style:
                          AppTheme.labelSm.copyWith(color: AppTheme.onPrimary)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    String? hint,
    bool alignRight = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppTheme.onSurface),
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            textDirection: alignRight ? TextDirection.rtl : TextDirection.ltr,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
