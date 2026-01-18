import 'package:flutter/material.dart';

class CardBtn extends StatelessWidget {
  String image;
  String title;
  Function() onTap;
  Color? bgColor;
  List<Color> gradient;
  CardBtn(
      {Key? key,
      required this.title,
      required this.image,
      required this.onTap,
      required this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //color: bgColor,
            gradient: LinearGradient(
              colors: gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0.6,
                blurRadius: 10,
                offset: const Offset(7, 10),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Image.asset(
              image,
              scale: 0.4,
              width: 95,
              height: 95,
            )),
            Flexible(
              child: Text(
                title.toUpperCase(),
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Trattatello',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
