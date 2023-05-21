import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header(
      {Key? key,
      this.navigateBack,
      this.leading,
      this.trailing,
      required this.title})
      : super(key: key);

  String title;
  Widget? leading;
  Widget? trailing;
  bool? navigateBack;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 12 / 100;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 2 / 100),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        (navigateBack != null && navigateBack == true
            ? IconButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                icon: const Icon(Icons.arrow_back))
            : SizedBox(width: width, child: leading)),
        // SizedBox(width: width, child: leading),
        Text(title,
            style: TextStyle(
                fontFamily: "AvenirLTStd", fontWeight: FontWeight.w500)),
        SizedBox(width: width, child: trailing)
        // IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.arrow_back, color: Colors.transparent)),
      ]),
    );
  }
}
