import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/mainRouter.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/panel/mainpanel.dart';
import 'package:shnatter/src/views/panel/rightpanel.dart';
import 'package:shnatter/src/views/whiteFooter.dart';

import '../utils/size_config.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  final UserController con;
  Function routerChange;

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends mvc.StateMVC<HomeScreen>
    with SingleTickerProviderStateMixin {
  late UserController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    // print(UserManager.userInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizeConfig(context).screenWidth >
                SizeConfig.mediumScreenSize + 300
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: MainPanel(
                      routerChange: widget.routerChange,
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            width: SizeConfig.rightPaneWidth,
                            child:
                                RightPanel(routerChange: widget.routerChange),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: rightFootbar(),
                          )
                        ],
                      ))
                ],
              )
            : Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MainPanel(
                      routerChange: widget.routerChange,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: RightPanel(routerChange: widget.routerChange),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: footbar(),
                    )
                  ],
                ),
              ));
  }
}
