import 'package:blood_sugar_tracking/models/goal/goal_amount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/information/information_provider.dart';
import '../../utils/locale/appLocalizations.dart';

class EditGoalMol extends StatefulWidget {
  const EditGoalMol({Key? key}) : super(key: key);

  @override
  State<EditGoalMol> createState() => _EditGoalMolState();
}

class _EditGoalMolState extends State<EditGoalMol> {
  SugarInfoStore? sugarInfoStore;
  int? currentFirstValue = 0;
  int? currentSecondValue = 0;
  double? currentAmount = 0;
  String errorText = "";
  bool? isFirst = true;
  FixedExtentScrollController controllerWC = FixedExtentScrollController();

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    sugarInfoStore!.fetchGoalAmountFromSharedPreferences();
    // controllerWC = FixedExtentScrollController(
    //     initialItem: sugarInfoStore!.goalAmount!.amount!.toInt());
    // currentFirstValue = sugarInfoStore!.goalAmount!.amount!.toInt();

    super.didChangeDependencies();
  }

  // setCurrentAmount(){
  //   currentAmount
  // }
  checkValidate() {
    if (double.parse("$currentFirstValue.$currentSecondValue") > 35) {
      setState(() {
        errorText =
            "${AppLocalizations.of(context)!.getTranslate("err_correct_value")}";
      });
    } else {
      setState(() {
        errorText = "";
      });
    }
  }

  void initState() {
    super.initState();
  }

  List<int> splitStringToIntegers(String inputStr) {
    // Tách chuỗi thành hai phần
    List<String> parts = inputStr.split('.');

    // Chuyển các phần đã tách thành số nguyên
    int firstValue = int.parse(parts[0]);
    int secondValue = int.parse(parts[1]);

    // Trả về hai số nguyên đã tách dưới dạng một List<int>
    return [firstValue, secondValue];
  }

  String formatNumber(
      String inputStr, int precisionBeforeDot, int precisionAfterDot) {
    List<String> parts = inputStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : "";
    String formattedDecimal = decimalPart.length > precisionAfterDot
        ? decimalPart.substring(0, precisionAfterDot)
        : decimalPart.padRight(precisionAfterDot, '0');
    return "$integerPart.${formattedDecimal.padLeft(precisionBeforeDot + precisionAfterDot + 1, '0')}";
  }

  List<int> extractDigits(double inputNumber) {
    // Chuyển số thành chuỗi để dễ xử lý
    String inputStr = inputNumber.toString();

    // Tìm vị trí của dấu "."
    int dotIndex = inputStr.indexOf(".");

    // Lấy số ký tự trước dấu "."
    String digitsBeforeDot = inputStr.substring(0, dotIndex);

    // Lấy 1 ký tự sau dấu "."
    int digitAfterDot =
        int.parse(inputStr.substring(dotIndex + 1, dotIndex + 2));

    // Chuyển chuỗi thành danh sách các số nguyên
    List<int> result = [int.parse(digitsBeforeDot), digitAfterDot];

    return result;
  }

  @override
  Widget build(BuildContext context) {
    GoalAmount tempGoalAmount =
        GoalAmount.fromGoalAmount(sugarInfoStore!.goalAmount!);
    InformationNotifier informationNotifier =
        Provider.of<InformationNotifier>(context);
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    if (isFirst == true) {
      currentFirstValue = extractDigits(tempGoalAmount.amount!)[0];
      currentSecondValue = extractDigits(tempGoalAmount.amount!)[1];
      setState(() {
        isFirst = false;
      });
    }
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          '${AppLocalizations.of(context)!.getTranslate('declare_your_goal')}',
          style: AppTheme.edit20Text,
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: WheelChooser.integer(
                  onValueChanged: (value) {
                    currentFirstValue = value;
                  },
                  maxValue: 35,
                  minValue: 1,
                  initValue: currentFirstValue,
                  selectTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                  unSelectTextStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 80,
                child: WheelChooser.integer(
                  onValueChanged: (value) {
                    currentSecondValue = value;
                  },
                  maxValue: 9,
                  minValue: 0,
                  initValue: currentSecondValue,
                  selectTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                  unSelectTextStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'mmol/L',
                style: AppTheme.unit20Text,
              )
            ],
          ),
        ),
        const Spacer(),
        Observer(builder: (_) {
          return Text(
            "$errorText",
            style: AppTheme.errorText,
          );
        }),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(left: 15, right: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFCFF3FF),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        '${AppLocalizations.of(context)!.getTranslate('cancel')}',
                        style: AppTheme.Headline16Text.copyWith(
                            color: AppColors.AppColor2),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    checkValidate();
                    if (errorText == "") {
                      sugarInfoStore!.setGoalAmount(double.parse(
                          "$currentFirstValue.$currentSecondValue"));
                      sugarInfoStore!.saveGoalAmountToSharedPreferences();
                      Navigator.pop(context);
                      //informationNotifier.saveUserData('information_key', updatedItem);
                    } else {}
                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(left: 12, right: 15),
                    decoration: BoxDecoration(
                        color: AppColors.AppColor2,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                          '${AppLocalizations.of(context)!.getTranslate('done')}',
                          style: AppTheme.Headline16Text),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
