import 'package:blood_sugar_tracking/controllers/stores/edit_range_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../utils/locale/appLocalizations.dart';

class UpdateVersionDialog extends StatefulWidget {
  UpdateVersionDialog({
    super.key,
  });

  @override
  State<UpdateVersionDialog> createState() => _UpdateVersionDialogState();
}

class _UpdateVersionDialogState extends State<UpdateVersionDialog> {
  bool? isMol;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onButtonPressed() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        insetPadding: EdgeInsets.symmetric(horizontal: 7),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: StatefulBuilder(builder: (context, setModalState) {
          return Container();
        }),
      ),
    );
  }
}
