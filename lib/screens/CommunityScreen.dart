import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:social_share/social_share.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Future<File> backgroundImage =
  //     getImageFileFromAssets("images/background9.png");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseAnalytics.instance.setCurrentScreen(
        screenName: 'Community Screen',
        screenClassOverride: 'Screens',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.width,
        child: ListView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 1.5 / 100,
                bottom: MediaQuery.of(context).size.height * 3 / 100),
            children: [
              GlassCard_header(
                  height: MediaQuery.of(context).size.height * 35 / 100,
                  header: Header(title: "Coming Soon!"),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 75 / 100,
                          child: Text(
                              "Sorry, the community feature is not yet ready.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.width *
                                      4 /
                                      100))),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 75 / 100,
                          child: Text(
                              "We're currently working hard to bring it to you as soon as possible!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.width *
                                      4 /
                                      100))),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                    ],
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              SocialSharingLinks(),
              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              // SocialSharingLinksLevel(backgroundImage: backgroundImage),
              // SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              GlassCard(
                  height: MediaQuery.of(context).size.height * 20 / 100,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 75 / 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("contact@getrestartapp.com",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width *
                                      4 /
                                      100)),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 2 / 100),
                          Text("We welcome all feedback and suggestions.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.width *
                                      4 /
                                      100)),
                        ],
                      ),
                    ),
                  ))
            ]));
  }
}

class SocialSharingLinks extends StatelessWidget {
  const SocialSharingLinks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
        height: MediaQuery.of(context).size.height * 25 / 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 75 / 100,
                child: Text("Get your friends to join the movement!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * 4 / 100))),
            SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(),
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAnalytics.instance.logEvent(name: 'share');
                      SocialShare.shareOptions(
                          "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!\n\n https://getrestartapp.com/");
                    },
                    child: Text("Invite"))
              ],
            )
          ],
        ));
  }
}

class SocialSharingLinksLevel extends StatelessWidget {
  const SocialSharingLinksLevel({
    Key? key,
    required this.backgroundImage,
  }) : super(key: key);

  final Future<File> backgroundImage;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
        height: MediaQuery.of(context).size.height * 25 / 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 75 / 100,
                child: Text("Invite your friends to join the movement!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * 4 / 100))),
            SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
            FutureBuilder<File>(
                future: backgroundImage,
                builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                  print(snapshot);
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.twitter,
                              color: Theme.of(context).primaryColor),
                          onPressed: () async {
                            SocialShare.shareTwitter(
                                "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!",
                                url: "https://getrestartapp.com/");
                          },
                        ),
                        // IconButton(
                        //   icon: FaIcon(FontAwesomeIcons.instagram,
                        //       color: Theme.of(context).primaryColor),
                        //   onPressed: () async {
                        //     SocialShare.shareInstagramStory(
                        //         attributionURL:
                        //             "https://getrestartapp.com/",
                        //         appId: '1625671387879237',
                        //         imagePath: snapshot.data!.path);
                        //   },
                        // ),
                        IconButton(
                            onPressed: () async {
                              SocialShare.shareFacebookStory(
                                  attributionURL: "https://deep-link-url",
                                  appId: '1625671387879237',
                                  imagePath: '');
                            },
                            icon: FaIcon(FontAwesomeIcons.facebook,
                                color: Theme.of(context).primaryColor)),
                        IconButton(
                            onPressed: () async {
                              SocialShare.shareWhatsapp(
                                  "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!\n\n https://getrestartapp.com/");
                            },
                            icon: FaIcon(FontAwesomeIcons.whatsapp,
                                color: Theme.of(context).primaryColor)),
                        IconButton(
                            onPressed: () async {
                              SocialShare.shareTelegram(
                                  "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!\n\n https://getrestartapp.com/");
                            },
                            icon: FaIcon(FontAwesomeIcons.telegram,
                                color: Theme.of(context).primaryColor)),
                        // IconButton(
                        //     onPressed: () async {
                        //       SocialShare.copyToClipboard(
                        //           text:
                        //               "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!\n\n https://getrestartapp.com/");
                        //     },
                        //     icon: FaIcon(FontAwesomeIcons.copy)),
                        IconButton(
                            onPressed: () async {
                              SocialShare.shareOptions(
                                  "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!\n\n https://getrestartapp.com/");
                            },
                            icon: FaIcon(FontAwesomeIcons.ellipsisH,
                                color: Theme.of(context).primaryColor))
                      ],
                    );
                  }
                }),
          ],
        ));
  }
}
