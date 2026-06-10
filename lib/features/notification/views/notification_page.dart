// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/util/screen_size.dart';
// import '../../../../core/widgets/text/app_text.dart';
// import '../../../core/themes/theme_controller.dart';
// import '../../settings/controllers/notification_controller.dart';
// import '../controllers/notification_controller.dart' hide NotificationController;
//
// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     if (!Get.isRegistered<NotificationController>()) {
//       Get.put(NotificationController());
//     }
//     final controller = Get.find<NotificationController>();
//
//     return Obx(() {
//       final tc = GetInstance().isRegistered<ThemeController>()
//           ? Get.find<ThemeController>()
//           : null;
//       tc?.themeMode.value;
//       tc?.platformBrightness;
//
//       return Scaffold(
//         backgroundColor: AppColors.scaffoldBg,
//         body: SafeArea(
//           child: Column(
//             children: [
//               _NotificationHeader(),
//               SizedBox(height: context.h(16)),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: context.w(16)),
//                 child: _FilterToggle(controller: controller),
//               ),
//               SizedBox(height: context.h(16)),
//               Expanded(
//                 child: Obx(() {
//                   final items = controller.filtered;
//                   if (items.isEmpty) {
//                     return Center(
//                       child: AppText(
//                         data: 'No notifications',
//                         fontSize: 15,
//                         color: AppColors.textSecondary,
//                       ),
//                     );
//                   }
//                   return Container(
//                     margin: EdgeInsets.symmetric(horizontal: context.w(16)),
//                     decoration: BoxDecoration(
//                       color: AppColors.surface,
//                       borderRadius: BorderRadius.circular(context.w(16)),
//                       border: Border.all(color: AppColors.inputBorder),
//                     ),
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       padding: EdgeInsets.zero,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: items.length,
//                       separatorBuilder: (_, __) => Divider(
//                         color: AppColors.inputBorder,
//                         height: 1,
//                         indent: context.w(16),
//                         endIndent: context.w(16),
//                       ),
//                       itemBuilder: (_, i) => _NotificationRow(
//                         notification: items[i],
//                         isFirst: i == 0,
//                         isLast: i == items.length - 1,
//                         onTap: () => controller.markRead(items[i].id),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
//
//
// class _NotificationHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Get.back(),
//             child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: context.sp(22)),
//           ),
//           SizedBox(width: context.w(10)),
//           AppText(data: 'Notification', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// class _FilterToggle extends StatelessWidget {
//   final NotificationController controller;
//   const _FilterToggle({required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(context.w(12)),
//         border: Border.all(color: AppColors.inputBorder),
//       ),
//       child: Row(
//         children: [
//           _ToggleTab(
//             label: 'All',
//             selected: controller.activeFilter.value == NotificationFilter.all,
//             onTap: () => controller.setFilter(NotificationFilter.all),
//             isLeft: true,
//           ),
//           _ToggleTab(
//             label: 'Unread',
//             selected: controller.activeFilter.value == NotificationFilter.unread,
//             onTap: () => controller.setFilter(NotificationFilter.unread),
//             isLeft: false,
//           ),
//         ],
//       ),
//     ));
//   }
// }
//
// class _ToggleTab extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   final bool isLeft;
//   const _ToggleTab({required this.label, required this.selected, required this.onTap, required this.isLeft});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: EdgeInsets.symmetric(vertical: context.h(13)),
//           decoration: BoxDecoration(
//             color: selected ? AppColors.surface : Colors.transparent,
//             borderRadius: BorderRadius.only(
//               topLeft:     Radius.circular(isLeft ? context.w(11) : 0),
//               bottomLeft:  Radius.circular(isLeft ? context.w(11) : 0),
//               topRight:    Radius.circular(isLeft ? 0 : context.w(11)),
//               bottomRight: Radius.circular(isLeft ? 0 : context.w(11)),
//             ),
//             boxShadow: selected
//                 ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))]
//                 : null,
//           ),
//           alignment: Alignment.center,
//           child: AppText(
//             data: label,
//             fontSize: 15,
//             fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
//             color: selected ? AppColors.textPrimary : AppColors.textSecondary,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class _NotificationRow extends StatelessWidget {
//   final AppNotification notification;
//   final bool isFirst;
//   final bool isLast;
//   final VoidCallback onTap;
//   const _NotificationRow({
//     required this.notification,
//     required this.isFirst,
//     required this.isLast,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final bgColor   = NotificationController.bgColorFor(notification.type);
//     final iconColor = NotificationController.iconColorFor(notification.type);
//     final icon      = NotificationController.iconFor(notification.type);
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(16)),
//         decoration: BoxDecoration(
//           color: notification.isRead ? AppColors.surface : AppColors.primary.withOpacity(0.04),
//           borderRadius: BorderRadius.only(
//             topLeft:     Radius.circular(isFirst ? context.w(15) : 0),
//             topRight:    Radius.circular(isFirst ? context.w(15) : 0),
//             bottomLeft:  Radius.circular(isLast  ? context.w(15) : 0),
//             bottomRight: Radius.circular(isLast  ? context.w(15) : 0),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: context.w(46),
//               height: context.w(46),
//               decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
//               child: Icon(icon, color: iconColor, size: context.sp(22)),
//             ),
//             SizedBox(width: context.w(14)),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(
//                     data: notification.message,
//                     fontSize: 14,
//                     fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                   SizedBox(height: context.h(5)),
//                   AppText(data: notification.timeAgo, fontSize: 12, color: AppColors.textSecondary),
//                 ],
//               ),
//             ),
//             if (!notification.isRead) ...[
//               SizedBox(width: context.w(8)),
//               Container(
//                 width: context.w(8),
//                 height: context.w(8),
//                 margin: EdgeInsets.only(top: context.h(4)),
//                 decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
