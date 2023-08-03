import 'package:flutter/material.dart';

class ItemPersonalData extends StatefulWidget {
 final String name;
   ItemPersonalData({super.key, required this.name});

  @override
  State<ItemPersonalData> createState() => _ItemPersonalDataState();
}

class _ItemPersonalDataState extends State<ItemPersonalData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: Text(widget.name),
      ),
    );
  }
}
