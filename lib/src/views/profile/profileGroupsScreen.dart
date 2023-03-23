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
import 'model/friends.dart';

// ignore: must_be_immutable
class ProfileGroupsScreen extends StatefulWidget {
  Function onClick;
  ProfileGroupsScreen(
      {Key? key, required this.onClick, required this.routerChange})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  Function routerChange;
  @override
  State createState() => ProfileGroupsScreenState();
}

class ProfileGroupsScreenState extends mvc.StateMVC<ProfileGroupsScreen> {
  var userInfo = UserManager.userInfo;
  var myGroups = [];
  bool getFlag = true;
  Friends friendModel = Friends();
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;
    friendModel.getFriends(con.viewProfileUserName).then((value) {
      setState(() {});
    });
    getGroupNow();
  }

  void getGroupNow() {
    PostController().getGroup('manage', con.viewProfileUid).then((value) => {
          myGroups = [...value],
          myGroups.where((group) =>
              group['data']['groupAdmin'][0]['uid'] ==
              UserManager.userInfo['uid']),
          getFlag = false,
          setState(() {})
        });
  }

  bool isMyFriend() {
    //profile selected is my friend?
    String friendUserName;
    for (var item in friendModel.friends) {
      friendUserName = item['requester'].toString();
      if (friendUserName == UserManager.userInfo['userName']) {
        return true;
      }
      if (item['receiver'] == UserManager.userInfo['userName']) {
        return true;
      }
    }
    return false;
  }

  late ProfileController con;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 30, top: 30, bottom: 30, left: 20),
      child: Column(children: [
        mainTabs(),
        isMyFriend() || con.viewProfileUid == UserManager.userInfo['uid']
            ? likesData()
            : Text("You can see the friends data only if you are friends.")
      ]),
    );
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(3),
      ),
      margin: const EdgeInsets.only(left: 10),
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
                                : screenWidth > 210
                                    ? 2
                                    : 1,
                        childAspectRatio: 2 / 3,
                        padding: const EdgeInsets.all(4.0),
                        mainAxisSpacing: 4.0,
                        shrinkWrap: true,
                        crossAxisSpacing: 4.0,
                        children: myGroups
                            .map(
                              (group) => GroupCell(
                                groupData: group,
                                refreshFunc: () {
                                  getGroupNow();
                                },
                                routerChange: widget.routerChange,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
  }
}
