import 'package:flutter/material.dart';

class Forest extends StatelessWidget {
  Forest({Key? key}) : super(key: key);

  // double heightWidth = 200;

  @override
  Widget build(BuildContext context) {
    double heightWidth = MediaQuery.of(context).size.width * 50 / 100;
    return Transform.scale(
      scale: 1,
      child: Stack(
        children: [
          Container(
            // color: Color.fromRGBO(158, 158, 158, 0.63),
            child: Image.asset(
                // "assets/images/sprites/forest/forest_guidelines.png",
                "assets/images/sprites/forest/forest_land.png",
                height: heightWidth,
                width: heightWidth),
          ),
          Positioned(
            //!1
            bottom: 0,
            right: heightWidth * 0.2875,
            child: Image.asset("assets/images/sprites/forest/t03.png",
                height: heightWidth, width: heightWidth),
          ),
          Positioned(
            //!2
            bottom: heightWidth * 0.085,
            right: heightWidth * 0.145,
            child: Image.asset("assets/images/sprites/forest/t01.png",
                height: heightWidth, width: heightWidth),
          ),
          Positioned(
            //!3
            bottom: heightWidth * 0.165,
            child: Image.asset("assets/images/sprites/forest/t02.png",
                height: heightWidth, width: heightWidth),
          ),
          Positioned(
            //!4
            top: heightWidth * 0.085,
            right: heightWidth * 0.145,
            child: Image.asset("assets/images/sprites/forest/t02.png",
                height: heightWidth, width: heightWidth),
          ),
          Positioned(
            //!5
            child: Image.asset("assets/images/sprites/forest/t01.png",
                height: heightWidth, width: heightWidth),
          ),
          Positioned(
            //!6
            bottom: heightWidth * 0.085,
            left: heightWidth * 0.145,
            child: Image.asset("assets/images/sprites/forest/t01.png",
                height: heightWidth, width: heightWidth),
          ),
          Positioned(
            //!7
            bottom: -heightWidth * 0.1675,
            child: Image.asset("assets/images/sprites/forest/t03.png",
                height: heightWidth, width: heightWidth),
          ),
          Positioned(
            //!8
            top: heightWidth * 0.085,
            left: heightWidth * 0.145,
            child: Image.asset("assets/images/sprites/forest/t02.png",
                height: heightWidth, width: heightWidth),
          ),
          Positioned(
            //!9
            bottom: 0,
            left: heightWidth * 0.2875,
            child: Image.asset("assets/images/sprites/forest/t01.png",
                height: heightWidth, width: heightWidth),
          ),
        ],
      ),
    );
  }
}
