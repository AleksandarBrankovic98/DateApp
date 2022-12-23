import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/groups/widget/groupcell.dart';
import '../../helpers/helper.dart';
import '../../utils/size_config.dart';
import '../../controllers/ProfileController.dart';

// ignore: must_be_immutable
class ProfileGroupsScreen extends StatefulWidget {
  Function onClick;
  ProfileGroupsScreen({Key? key, required this.onClick})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  @override
  State createState() => ProfileGroupsScreenState();
}

class ProfileGroupsScreenState extends mvc.StateMVC<ProfileGroupsScreen> {
  var userInfo = UserManager.userInfo;
  var myGroups = [];
  bool getFlag = true;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;
    getGroupNow();
  }

  void getGroupNow() {
    PostController()
        .getGroup('manage', UserManager.userInfo['userName'])
        .then((value) => {
              myGroups = [...value],
              myGroups.where((group) =>
                  group['data']['groupAdmin'][0]['userName'] ==
                  UserManager.userInfo['id']),
              getFlag = false,
              print(myGroups),
              setState(() {})
            });
  }

  late ProfileController con;
  @override
  Widget build(BuildContext context) {
    return Column(children: [mainTabs(), likesData()]);
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth,
      height: 70,
      margin: const EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: const [
                  Icon(
                    Icons.groups,
                    size: 15,
                  ),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                    'Groups',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget likesData() {
    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return getFlag
        ? Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(top: 100),
            child: const CircularProgressIndicator(
              color: Colors.grey,
            ),
          )
        : myGroups.isEmpty
            ? Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                height: 200,
                color: Colors.white,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.network(Helper.emptySVG, width: 90),
                      Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          width: 140,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const Text(
                            'No data to show',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(108, 117, 125, 1)),
                          ))
                    ]))
            : Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: screenWidth > 800
                            ? 4
                            : screenWidth > 600
                                ? 3
                                : screenWidth > 450
                                    ? 2
                                    : 1,
                        childAspectRatio: 2 / 3,
                        padding: const EdgeInsets.all(4.0),
                        mainAxisSpacing: 4.0,
                        shrinkWrap: true,
                        crossAxisSpacing: 4.0,
                        children: myGroups
                            .map((group) => GroupCell(
                                groupTap: () {
                                  Navigator.pushReplacementNamed(context,
                                      '/groups/${group['data']['groupUserName']}');
                                },
                                buttonFun: () {
                                  PostController()
                                      .joinedGroup(group['id'])
                                      .then((value) {
                                    getGroupNow();
                                  });
                                },
                                picture: group['data']['groupPicture'],
                                status: false,
                                joins: group['data']['groupJoined'].length,
                                header: group['data']['groupName'],
                                joined: group['joined']))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
  }
}
