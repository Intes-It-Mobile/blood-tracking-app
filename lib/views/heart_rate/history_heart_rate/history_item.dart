// import 'package:blood_sugar_tracking/constants/assets.dart';
// import 'package:blood_sugar_tracking/constants/colors.dart';
// import 'package:blood_sugar_tracking/constants/font_family.dart';
// import 'package:blood_sugar_tracking/models/heart_rate/heart_rate_info.dart';
// import 'package:blood_sugar_tracking/routes.dart';
// import 'package:blood_sugar_tracking/utils/device/size_config.dart';
// import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';

// class HistoryHeartRateRecord extends StatelessWidget {
//   HistoryHeartRateRecord({super.key, required this.info, required this.onClick});
//   final Function() onClick;
//   final HeartRateInfo info;
//   late BuildContext context;

//   @override
//   Widget build(BuildContext context) {
//     this.context = context;
//     return InkWell(
//       onTap: onClick,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//         decoration: BoxDecoration(
//           color: AppColors.AppColor3,
//           borderRadius: BorderRadius.circular(5)
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildDatetimeCustom(),
//                       _buildIndicatorCustom(),
//                     ],
//                   )
//                 ),
//                 const SizedBox(width: 4),
//                 SvgPicture.asset(Assets.iconEditRecord),
//               ]
//             ),
//             _buildStatusCustom()
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDatetimeCustom() {
//     TextStyle textStyle = TextStyle(
//       fontSize: TextSizeConfig.getAdjustedFontSize(10),
//       fontFamily: FontFamily.IBMPlexSans,
//       fontWeight: FontWeight.w500,
//       fontStyle: FontStyle.normal,
//       color: Colors.black
//     );
//     return Text(
//       DateFormat('yyyy/MM/dd  HH:mm').format(info.date??DateTime.now()),
//       maxLines: 1,
//       style: textStyle,
//       overflow: TextOverflow.ellipsis,
//     );
//   }

//   Widget _buildIndicatorCustom() {
//     TextStyle textStyle = TextStyle(
//       fontSize: TextSizeConfig.getAdjustedFontSize(32),
//       fontFamily: FontFamily.IBMPlexSans,
//       fontWeight: FontWeight.w700,
//       fontStyle: FontStyle.normal,
//       color: AppColors.AppColor4,
//     );
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Text(
//           info.indicator.toString(),
//           style: textStyle,
//         ),
//         const SizedBox(width: 2),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Text(
//             AppLocalizations.of(context).getTranslate("bpm"),
//             style: textStyle.copyWith(
//               fontSize: 12,
//               fontWeight: FontWeight.w600
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildStatusCustom() {
//     info.indicator ??= 0;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           "${AppLocalizations.of(context).getTranslate("status")} : ",
//           style: TextStyle(
//             fontSize: TextSizeConfig.getAdjustedFontSize(12),
//             fontFamily: FontFamily.IBMPlexSans,
//             fontWeight: FontWeight.w500,
//             fontStyle: FontStyle.normal,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(width: 2),
//         Expanded(
//           child: Text(
//             info.indicator! > 100
//               ? AppLocalizations.of(context).getTranslate("fast")
//               : info.indicator! > 60
//                 ? AppLocalizations.of(context).getTranslate("normal")
//                 : AppLocalizations.of(context).getTranslate("slow"),
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: TextSizeConfig.getAdjustedFontSize(12),
//               fontFamily: FontFamily.IBMPlexSans,
//               fontWeight: FontWeight.w700,
//               fontStyle: FontStyle.normal,
//               color: info.indicator! > 100
//                         ? AppColors.DiabetesStt
//                         : info.indicator! > 60
//                           ? AppColors.NormalStt
//                           : AppColors.LowStt,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }