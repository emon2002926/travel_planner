import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/app_text_filed.dart';
import '../controllers/enter_otp_controller.dart';
import '../widgets/auth_shared_widgets.dart';

class EnterOtpScreen extends StatelessWidget {
  final bool isFromSignUp;
   EnterOtpScreen({super.key, required this.isFromSignUp});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EnterOtpController());

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: context.h(32)),
                const Center(child: AuthTripNestWordmark()),
                 SizedBox(height: context.h(32)),
                AppText(
                  data: 'Enter Your OTP',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: context.h(24)),
                AppText(
                  data: 'Enter Code',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
                 SizedBox(height: context.h(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                        (index) => SizedBox(
                      width: context.w(60),
                      child: AppTextField(
                        controller: controller.otpControllers[index],
                        focusNode: controller.focusNodes[index],
                        hintText: '-',
                        keyboardType: TextInputType.number,
                        isHintTextInMiddle: true,
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: context.h(28)),
                AppButton(
                  buttonText: 'Submit',
                  onPressed: (){controller.onSubmit(isFromSignUp);},
                  buttonHeight: context.h(54),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}