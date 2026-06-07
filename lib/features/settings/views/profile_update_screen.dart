import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/profile_update_controller.dart';


class ProfileUpdateScreen extends StatelessWidget {
  const ProfileUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileUpdateController());

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(16)),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: context.sp(22)),
                    ),
                    SizedBox(width: context.w(12)),
                    AppText(
                      data: 'Profile Update',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
                SizedBox(height: context.h(24)),
                Center(
                  child: ClipOval(
                    child: controller.selectedImage.value != null
                        ? Image.file(
                      controller.selectedImage.value!,
                      width: context.w(110),
                      height: context.w(110),
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      'https://i.pravatar.cc/150',
                      width: context.w(110),
                      height: context.w(110),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: context.h(28)),
                AppTextField(
                  label: 'Name',
                  controller: controller.nameController,
                  hintText: 'Full Name',
                ),
                SizedBox(height: context.h(16)),
                AppTextField(
                  label: 'Address',
                  controller: controller.addressController,
                  hintText: 'Type here.....',
                ),
                SizedBox(height: context.h(16)),
                AppText(
                  data: 'Upload Image',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: context.h(8)),
                GestureDetector(
                  // onTap: controller.onPickImage,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: context.w(16), vertical: context.h(14)),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(context.w(10)),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.w(12),
                              vertical: context.h(6)),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(context.w(6)),
                            border: Border.all(color: AppColors.inputBorder),
                          ),
                          child: AppText(
                            data: 'Choose your image',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.h(16)),
                AppText(
                  data: 'Currency',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: context.h(8)),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: context.w(16)),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(context.w(10)),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedCurrency.value,
                      isExpanded: true,
                      dropdownColor: AppColors.cardBg,
                      icon: Icon(Icons.arrow_drop_down,
                          color: AppColors.textPrimary),
                      style: GoogleFonts.nunito(
                        fontSize: context.sp(14),
                        color: AppColors.textPrimary,
                      ),
                      items: controller.currencies
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            AppText(
                              data: '\$ ',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            AppText(
                              data: c,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ))
                          .toList(),
                      onChanged: controller.onCurrencyChanged,
                    ),
                  ),
                ),
                SizedBox(height: context.h(28)),
                AppButton(
                  buttonText: 'Save',
                  onPressed: controller.onSave,
                  buttonHeight: 54,
                ),
                SizedBox(height: context.h(24)),
              ],
            ),
          ),
        ),
      );
    });
  }
}