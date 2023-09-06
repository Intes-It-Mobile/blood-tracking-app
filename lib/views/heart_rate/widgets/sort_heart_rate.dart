// import 'package:blood_sugar_tracking/constants/colors.dart';
// import 'package:blood_sugar_tracking/constants/font_family.dart';
// import 'package:blood_sugar_tracking/utils/device/size_config.dart';
// import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class SortHeartRate extends StatefulWidget {
//   SortHeartRate({super.key, required this.indicator, required this.onChangedIndicator, required this.back});
//   int indicator;
//   final Function(String?) onChangedIndicator;
//   bool back;
//   @override
//   State<SortHeartRate> createState() => _SortHeartRateState();
// }

// class _SortHeartRateState extends State<SortHeartRate> {
//   late BuildContext context;
//   TextEditingController? controller;
//   String? error;

//   @override
//   Widget build(BuildContext context) {
//     this.context = context;
//     controller ??= TextEditingController(text: widget.indicator.toString());
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration( 
//         borderRadius: BorderRadius.circular(5),
//         color: AppColors.AppColor3
//       ),
//       child: Column(
//         children: [
//           _showStatus(),
//           _showIndicator()
//         ],  
//       ),
//     );
//   }

//   Container _showStatus() {
//     return Container(
//       padding: const EdgeInsets.only(top: 7, left: 6, right: 9),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10)
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildStatusColor(color: AppColors.LowStt, check: widget.indicator<=60),
//           _buildStatusColor(color: AppColors.NormalStt, check: widget.indicator>60 && widget.indicator<=100),
//           _buildStatusColor(color: AppColors.DiabetesStt, check: widget.indicator>100),
//           const SizedBox(width: 10),
//           _buildStatusString(),
//           const Spacer(),
//           _buildStatusInt()
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusColor({required Color color, required bool check}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 2),
//       child: Column(
//         children: [
//           Container(
//             height: 20,
//             width: 28,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(5)
//             ),
//           ),
//           if (check)
//             const Icon(
//               Icons.arrow_drop_up_rounded, 
//               color: AppColors.AppColor4,
//             )
//         ]
//       ),
//     );
//   }

//   Widget _buildStatusString() {
//     return Text(
//       widget.indicator > 100
//         ? AppLocalizations.of(context).getTranslate("fast")
//         : widget.indicator > 60
//           ? AppLocalizations.of(context).getTranslate("normal")
//           : AppLocalizations.of(context).getTranslate("slow"),
//       style: TextStyle(
//         fontSize: TextSizeConfig.getAdjustedFontSize(12),
//         fontFamily: FontFamily.IBMPlexSans,
//         fontWeight: FontWeight.w700,
//         fontStyle: FontStyle.normal,
//         letterSpacing: 0.6,
//         color: widget.indicator > 100
//                   ? AppColors.DiabetesStt
//                   : widget.indicator > 60
//                     ? AppColors.NormalStt
//                     : AppColors.LowStt,
//       )
//     );
//   }

//   Widget _buildStatusInt() {
//     return Text(
//       widget.indicator > 100
//         ? ">100"
//         : widget.indicator > 60
//           ? "60~100"
//           : "1~60",
//       style: TextStyle(
//         fontSize: TextSizeConfig.getAdjustedFontSize(12),
//         fontFamily: FontFamily.IBMPlexSans,
//         fontWeight: FontWeight.w500,
//         fontStyle: FontStyle.normal,
//         letterSpacing: 0.6,
//         color: Colors.black,
//       )
//     );
//   }

//   Container _showIndicator() {
//     return Container(
//       padding: const EdgeInsets.only(left: 50, top: 9, bottom: 9, right: 76),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Expanded(
//             child: TextField(
//               controller: controller,
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//               cursorColor: AppColors.AppColor2,
//               readOnly: widget.back,
//               decoration:
//                 const InputDecoration(
//                   focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: AppColors.AppColor2)),
//                   enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: AppColors.AppColor2)),
//                 ),
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp('[0-9]')),
//                 LengthLimitingTextInputFormatter(3),
//               ],
//               style: TextStyle(
//                 fontSize: TextSizeConfig.getAdjustedFontSize(50),
//                 fontFamily: FontFamily.IBMPlexSans,
//                 fontWeight: FontWeight.w600,
//                 fontStyle: FontStyle.normal,
//                 color: Colors.black,
//               ),
//               onChanged: (value) {
//                 // if (value.length>3){
//                 //   value = value.substring(0, 3);
//                 //   controller!.text = value;
//                 // }
//                 int n = 0;
//                 if (value!="") {
//                   n = int.tryParse(value)??0;
//                 }
//                 setState(() {
//                   widget.indicator = n;
//                 });
//                 widget.onChangedIndicator(value);
//               },
//             ),
//           ),
//           const SizedBox(width: 25),
//           Text(
//             AppLocalizations.of(context).getTranslate("bpm"),
//             style: TextStyle(
//               fontSize: TextSizeConfig.getAdjustedFontSize(12),
//               fontFamily: FontFamily.IBMPlexSans,
//               fontWeight: FontWeight.w500,
//               fontStyle: FontStyle.normal,
//               color: Colors.black,
//             ),
//           )
//         ]
        
//       ),
//     );
//   }
// }