import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:shnatter/src/widget/interests.dart';
import 'package:shnatter/src/widget/startedInput.dart';

import '../../../../widget/admin_list_text.dart';

class PageSettingsScreen extends StatefulWidget {
  Function onClick;
  PageSettingsScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => PageSettingsScreenState();
}

class PageSettingsScreenState extends mvc.StateMVC<PageSettingsScreen> {
  var userInfo = UserManager.userInfo;
  var pageSettingTab = 'Page Settings';
  var tabTitle = 'basic';
  var headerTab;
  List<Map> list = [
    {
      'text': 'Page Settings',
      'icon': Icons.settings,
    },
    {
      'text': 'Page Information',
      'icon': Icons.info_rounded,
    },
    {
      'text': 'Admins',
      'icon': Icons.groups,
    },
    {
      'text': 'Verification',
      'icon': Icons.check_circle,
    },
    {
      'text': 'Interests',
      'icon': Icons.heart_broken,
    },
    {
      'text': 'Delete Page',
      'icon': Icons.delete,
    },
  ];
  List<Map> GroupsDropDown = [
    {
      'value': 'public',
      'title': 'Public Group',
      'subtitle': 'Anyone can see the group, its members and their posts.',
      'icon': Icons.language
    },
    {
      'value': 'closed',
      'title': 'Closed Group',
      'subtitle': 'Only members can see posts.',
      'icon': Icons.lock_open_rounded
    },
    {
      'value': 'secret',
      'title': 'Secret Group',
      'subtitle': 'Only members can find the group and see posts.',
      'icon': Icons.lock_outline_rounded
    },
  ];
  var privacy = 'public';
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    headerTab = [
      {
        'icon': Icons.flag,
        'title': 'Basic',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.attractions,
        'title': 'Action Button',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.facebook,
        'title': 'Social Links',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
    ];
  }

  late PostController con;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftSettingBar(),
          pageSettingTab == 'Page Settings'
              ? PageSettingsWidget()
              : pageSettingTab == 'Page Information'
                  ? PageInformationWidget()
                  : pageSettingTab == 'Admins'
                      ? PageAdminsWidget()
                      : pageSettingTab == 'Verification'
                          ? VerificationWidget()
                          : pageSettingTab == 'Interests'
                              ? GroupInterestsWidget()
                              : GroupDeleteWidget(),
        ],
      ),
    );
  }

  Widget LeftSettingBar() {
    return Container(
      padding: const EdgeInsets.only(top: 30, right: 20),
      // width: SizeConfig.leftBarAdminWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list
              .map(
                (e) => ListText(
                  onTap: () => {onClick(e['text'])},
                  label: SizeConfig(context).screenWidth >
                          SizeConfig.mediumScreenSize
                      ? e['text']
                      : '',
                  icon: Icon(
                    e['icon'],
                    color: pageSettingTab == e['text']
                        ? Color.fromARGB(255, 94, 114, 228)
                        : Colors.grey,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget PageSettingsWidget() {
    return Container(
      width: 600,
      child: Column(
        children: [
          headerWidget(Icon(Icons.settings), 'Page Settings'),
          Container(
            width: 430,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Name Your Page',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      width: 400,
                      child: input(validator: (value) async {
                        print(value);
                      }, onchange: (value) async {
                        con.page['pageName'] = value;
                        setState(() {});
                      }),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('Page Username',
                            style: TextStyle(
                                color: Color.fromARGB(255, 82, 95, 127),
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      width: 400,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Row(children: [
                          Container(
                            padding: EdgeInsets.only(top: 7),
                            alignment: Alignment.topCenter,
                            width: 240,
                            height: 30,
                            color: Colors.grey,
                            child: Text('https://test.shnatter.com/pages/'),
                          ),
                          Expanded(
                              child: Container(
                            width: 260,
                            height: 30,
                            child: TextFormField(
                              onChanged: (value) {
                                con.page['groupUserName'] = value;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 54, 54, 54),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                              onSaved: (String? value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                              },
                            ),
                          )),
                        ]),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 380,
                  child: const Text(
                    'Can only contain alphanumeric characters (A–Z, 0–9) and periods (\'.\')',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          footerWidget()
        ],
      ),
    );
  }

  Widget PageInformationWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.settings),
            pagename: 'Settings',
            button: const {'flag': false},
            headerTab: headerTab,
          ),
          tabTitle == 'basic'
              ? InfoBasic()
              : tabTitle == 'actionButton'
                  ? InfoButton()
                  : InfoSocialLink(),
          footerWidget()
        ],
      ),
    );
  }

  Widget InfoBasic() {
    return Container();
  }

  Widget InfoButton() {
    return Container();
  }

  Widget InfoSocialLink() {
    return Container();
  }

  Widget PageAdminsWidget() {
    return Container(
      width: 510,
      child: Column(
        children: [
          headerWidget(Icon(Icons.groups), 'Members'),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ADMINS (${con.page["pageAdmin"].length})'),
                SizedBox(
                  width: 450,
                  height: con.page['pageAdmin'].length * 45,
                  child: ListView.separated(
                    itemCount: con.page['pageAdmin'].length,
                    itemBuilder: (context, index) => Material(
                        child: ListTile(
                            onTap: () {
                              print("tap!");
                            },
                            hoverColor:
                                const Color.fromARGB(255, 243, 243, 243),
                            // tileColor: Colors.white,
                            enabled: true,
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://test.shnatter.com/content/themes/default/images/blank_profile_male.svg"),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        con.page['pageAdmin'][index]
                                            ['userName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(90, 35),
                                            maximumSize: const Size(90, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(125, 35),
                                            maximumSize: const Size(125, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove Admin',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                      endIndent: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ALL MEMBERS (${con.page["pageLiked"].length})'),
                SizedBox(
                  width: 450,
                  height: con.page['pageLiked'].length * 45,
                  child: ListView.separated(
                    itemCount: con.page['pageLiked'].length,
                    itemBuilder: (context, index) => Material(
                        child: ListTile(
                            onTap: () {
                              print("tap!");
                            },
                            hoverColor:
                                const Color.fromARGB(255, 243, 243, 243),
                            // tileColor: Colors.white,
                            enabled: true,
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://test.shnatter.com/content/themes/default/images/blank_profile_male.svg"),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        con.page['pageLiked'][index]
                                            ['userName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(90, 35),
                                            maximumSize: const Size(90, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(125, 35),
                                            maximumSize: const Size(125, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove Admin',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                      endIndent: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget VerificationWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.check_circle), 'Verification'),
          Container(
            width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                ? SizeConfig(context).screenWidth * 0.5
                : SizeConfig(context).screenWidth * 0.9 - 30,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      width: 100,
                      child: Text(
                        'Chat Message Sound',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      width: 230,
                      child: Column(
                        children: [
                          Container(
                            width: 230,
                            color: Color.fromARGB(255, 235, 235, 235),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt),
                                  Padding(padding: EdgeInsets.only(left: 20)),
                                  Expanded(
                                      child: Container(
                                    width: 100,
                                    child: Text(
                                      'Your Photo',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                                ]),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Stack(
                            children: [
                              Container(
                                width: 230,
                                height: 200,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(color: Colors.grey)),
                              ),
                              Container(
                                width: 26,
                                height: 26,
                                margin:
                                    const EdgeInsets.only(top: 150, left: 180),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: Colors.grey[400],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(4),
                                    backgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    minimumSize: const Size(26, 26),
                                    maximumSize: const Size(26, 26),
                                  ),
                                  onPressed: () {
                                    () => {};
                                  },
                                  child: const Icon(
                                      Icons.camera_enhance_rounded,
                                      color: Colors.black,
                                      size: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    const Padding(padding: EdgeInsets.only(left: 30)),
                    Expanded(
                        child: Container(
                      width: 230,
                      child: Column(
                        children: [
                          Container(
                            width: 230,
                            height: 30,
                            color: Color.fromARGB(255, 235, 235, 235),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.card_membership),
                                  Padding(padding: EdgeInsets.only(left: 20)),
                                  Expanded(
                                      child: Text(
                                    'Passport or National ID',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))
                                ]),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Stack(
                            children: [
                              Container(
                                width: 230,
                                height: 200,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(color: Colors.grey)),
                              ),
                              Container(
                                width: 26,
                                height: 26,
                                margin:
                                    const EdgeInsets.only(top: 150, left: 180),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: Colors.grey[400],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(4),
                                    backgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    minimumSize: const Size(26, 26),
                                    maximumSize: const Size(26, 26),
                                  ),
                                  onPressed: () {
                                    () => {};
                                  },
                                  child: const Icon(
                                      Icons.camera_enhance_rounded,
                                      color: Colors.black,
                                      size: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    Text(
                      'Chat Message Sound',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 60)),
                    Expanded(
                      child: Container(
                        width: 500,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 250, 250, 250),
                            border: Border.all(color: Colors.grey)),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 4,
                          onChanged: (value) async {
                            // setState(() {});
                          },
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: '',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          footerWidget()
        ],
      ),
    );
  }

  Widget GroupInterestsWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.heart_broken), 'Interests'),
          InterestsWidget(context: context, sendUpdate: () {}),
          footerWidget()
        ],
      ),
    );
  }

  Widget GroupDeleteWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.delete), 'Delete'),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 252, 124, 95),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 30)),
                            Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Container(
                                width: 200,
                                child: const Text(
                                  'Once you delete your group you will no longer can access it again',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          width: 145,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(3),
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 54, 92),
                                // elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0)),
                                minimumSize: const Size(140, 50),
                                maximumSize: const Size(140, 50),
                              ),
                              onPressed: () {
                                (() => {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.delete),
                                  Text('Delete Group',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                ],
                              ))),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerWidget(icon, pagename) {
    return Padding(
      padding: EdgeInsets.only(right: 20, top: 20),
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: Color.fromARGB(255, 220, 226, 237),
            width: 1,
          )),
          color: Color.fromARGB(255, 240, 243, 246),
          // borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        padding: const EdgeInsets.only(top: 5, left: 15),
        child: Row(
          children: [
            icon,
            const Padding(padding: EdgeInsets.only(left: 10)),
            Text(pagename),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget footerWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 20, top: 20),
      child: Container(
          height: 65,
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Color.fromARGB(255, 220, 226, 237),
              width: 1,
            )),
            color: Color.fromARGB(255, 240, 243, 246),
            // borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          padding: const EdgeInsets.only(top: 5, left: 15),
          child: Row(
            children: [
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(3),
                    backgroundColor: Colors.white,
                    // elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    minimumSize: const Size(120, 50),
                    maximumSize: const Size(120, 50),
                  ),
                  onPressed: () {
                    (() => {});
                  },
                  child: Text('Save Changes',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
              const Padding(padding: EdgeInsets.only(right: 30))
            ],
          )),
    );
  }

  Widget input({label, onchange, obscureText = false, validator}) {
    return Container(
      height: 28,
      child: StartedInput(
        validator: (val) async {
          validator(val);
        },
        obscureText: obscureText,
        onChange: (val) async {
          onchange(val);
        },
      ),
    );
  }

  Widget privacySelect(title, content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 30),
              width: SizeConfig(context).screenWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Color.fromRGBO(82, 95, 127, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(content,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            )),
        const Flexible(fit: FlexFit.tight, child: SizedBox()),
        SizedBox(
          height: 20,
          child: Transform.scale(
            scaleX: 1,
            scaleY: 1,
            child: CupertinoSwitch(
              thumbColor: Colors.white,
              activeColor: Colors.black,
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }

  onClick(String route) {
    pageSettingTab = route;
    setState(() {});
  }
}
