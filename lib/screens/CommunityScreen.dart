import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:social_share/social_share.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

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
                              "We're currently hard at work bringing it to you.",
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
              GlassCard(
                  height: MediaQuery.of(context).size.height * 25 / 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 75 / 100,
                          child: Text(
                              "In the meantime, invite your friends to join the movement!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width *
                                      4 /
                                      100))),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.twitter),
                            onPressed: () async {
                              SocialShare.shareTwitter(
                                  "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!",
                                  url: "https://getrestartapp.com/");
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.instagram),
                            onPressed: () async {
                              SocialShare.shareInstagramStory(
                                  attributionURL: "https://getrestartapp.com/",
                                  appId: '1625671387879237',
                                  imagePath: '');
                            },
                          ),
                          IconButton(
                              onPressed: () async {
                                SocialShare.shareFacebookStory(
                                    attributionURL: "https://deep-link-url",
                                    appId: '1625671387879237',
                                    imagePath: '');
                              },
                              icon: FaIcon(FontAwesomeIcons.facebook)),
                          IconButton(
                              onPressed: () async {
                                SocialShare.shareWhatsapp(
                                    "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!\n\n https://getrestartapp.com/");
                              },
                              icon: FaIcon(FontAwesomeIcons.whatsapp)),
                          IconButton(
                              onPressed: () async {
                                SocialShare.shareTelegram(
                                    "Join me in recycling with RE:start – the app that makes it fun, easy, and rewarding to save the planet!\n\n https://getrestartapp.com/");
                              },
                              icon: FaIcon(FontAwesomeIcons.telegram)),
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
                              icon: FaIcon(FontAwesomeIcons.ellipsisH))
                        ],
                      ),
                    ],
                  ))
            ]));
  }
}
