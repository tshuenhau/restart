import 'package:flutter/material.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:get/get.dart';

class Forest extends StatelessWidget {
  Forest({Key? key}) : super(key: key);
  // double heightWidth = 200;
  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    double heightWidth = MediaQuery.of(context).size.width * 50 / 100;
    return Transform.scale(
      scale: 1,
      child: Stack(
        children: <Widget>[
              Image.asset(
                  // "assets/images/sprites/forest/forest_guidelines.png",
                  "assets/images/sprites/forest/forest_land.png",
                  height: heightWidth,
                  width: heightWidth),
            ] +
            (user.forest.length == 9
                ? buildTrees(heightWidth, user.forest)
                : []),
      ),
    );
  }

  List<Widget> buildTrees(double heightWidth, List<int> trees) {
    //TODO: Variable length for trees
    List treesSprites = [
      Positioned(
        //!1
        bottom: 0,
        right: heightWidth * 0.2875,
        child: Image.asset("assets/images/sprites/forest/t${trees[0]}.png",
            height: heightWidth, width: heightWidth),
      ),
      Positioned(
        //!2
        bottom: heightWidth * 0.085,
        right: heightWidth * 0.145,
        child: Image.asset("assets/images/sprites/forest/t${trees[1]}.png",
            height: heightWidth, width: heightWidth),
      ),
      Positioned(
        //!3
        bottom: heightWidth * 0.165,
        child: Image.asset("assets/images/sprites/forest/t${trees[2]}.png",
            height: heightWidth, width: heightWidth),
      ),
      Positioned(
        //!4
        top: heightWidth * 0.085,
        right: heightWidth * 0.145,
        child: Image.asset("assets/images/sprites/forest/t${trees[3]}.png",
            height: heightWidth, width: heightWidth),
      ),
      Positioned(
        //!5
        child: Image.asset("assets/images/sprites/forest/t${trees[4]}.png",
            height: heightWidth, width: heightWidth),
      ),
      Positioned(
        //!6
        bottom: heightWidth * 0.085,
        left: heightWidth * 0.145,
        child: Image.asset("assets/images/sprites/forest/t${trees[5]}.png",
            height: heightWidth, width: heightWidth),
      ),
      Positioned(
        //!7
        bottom: -heightWidth * 0.1675,
        child: Image.asset("assets/images/sprites/forest/t${trees[6]}.png",
            height: heightWidth, width: heightWidth),
      ),
      Positioned(
        //!8
        top: heightWidth * 0.085,
        left: heightWidth * 0.145,
        child: Image.asset("assets/images/sprites/forest/t${trees[7]}.png",
            height: heightWidth, width: heightWidth),
      ),
      Positioned(
        //!9
        bottom: 0,
        left: heightWidth * 0.2875,
        child: Image.asset("assets/images/sprites/forest/t${trees[8]}.png",
            height: heightWidth, width: heightWidth),
      ),
    ];

    List<Widget> treesWidgets = [];

    for (int i = 0; i < trees.length; i++) {
      if (trees[i] != 0) {
        treesWidgets.add(treesSprites[i]);
      }
    }

    return treesWidgets;
  }
}
