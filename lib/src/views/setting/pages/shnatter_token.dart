import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:badges/badges.dart' as badges;
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class SettingShnatterTokenScreen extends StatefulWidget {
  SettingShnatterTokenScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingShnatterTokenScreenState();
}

// class Employee {
//   /// Creates the employee class with required details.
//   Employee(this.id, this.sender, this.recipient, this.sendTime, this.note,
//       this.balance, this.paymail, this.to
//       // this.actions,
//       );

//   /// Id of an employee.
//   final int id;

//   /// name of an employee.
//   final String sender;

//   /// username of an employee.
//   final String recipient;

//   /// joined of an employee.
//   final String sendTime;

//   // activated of an employee.
//   final String note;

//   /// balance of an employee.
//   final String balance;

//   // // actions of an employee.
//   final String paymail;

//   final String to;
// }

// class EmployeeDataSource extends DataGridSource {
//   int i = 1;

//   /// Creates the employee data source class with required details.
//   EmployeeDataSource({required List<Employee> employeeData}) {
//     _employeeData = employeeData
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//               DataGridCell<int>(columnName: 'id', value: i++),
//               DataGridCell<Widget>(
//                   columnName: 'Sender',
//                   value: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(left: 2),
//                         child: Text(e.sender),
//                       )
//                     ],
//                   )),
//               DataGridCell<String>(columnName: 'Recipient', value: e.recipient),
//               DataGridCell<String>(columnName: 'Send Time', value: e.sendTime),
//               DataGridCell<String>(columnName: 'Note', value: e.note),
//               DataGridCell<Widget>(
//                 columnName: 'balance',
//                 value: badges.Badge(
//                   toAnimate: false,
//                   shape: badges.BadgeShape.square,
//                   badgeColor: Colors.teal,
//                   borderRadius: BorderRadius.circular(16),
//                   badgeContent: UserManager.userInfo['paymail'] != e.paymail
//                       ? Text(
//                           '+${e.balance.toString()}',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 13),
//                         )
//                       : Text(
//                           '-${e.balance.toString()}',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 13),
//                         ),
//                 ),
//               ),
//             ]))
//         .toList();
//   }

//   List<DataGridRow> _employeeData = [];

//   @override
//   List<DataGridRow> get rows => _employeeData;

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((dataGridCell) {
//       return Container(
//           alignment: Alignment.center,
//           child: dataGridCell.columnName == 'activated'
//               ? LayoutBuilder(
//                   builder: (BuildContext context, BoxConstraints constraints) {
//                   return dataGridCell.value;
//                 })
//               : dataGridCell.columnName == 'balance'
//                   ? LayoutBuilder(builder:
//                       (BuildContext context, BoxConstraints constraints) {
//                       return dataGridCell.value;
//                     })
//                   : dataGridCell.columnName == 'note'
//                       ? LayoutBuilder(builder:
//                           (BuildContext context, BoxConstraints constraints) {
//                           return dataGridCell.value;
//                         })
//                       : dataGridCell.columnName == 'Sender'
//                           ? LayoutBuilder(builder: (BuildContext context,
//                               BoxConstraints constraints) {
//                               return dataGridCell.value;
//                             })
//                           : Text(dataGridCell.value.toString()));
//     }).toList());
//   }
// }

// ignore: must_be_immutable
class SettingShnatterTokenScreenState
    extends mvc.StateMVC<SettingShnatterTokenScreen> {
  var setting_security = {};

  late final PlutoGridStateManager stateManager;
  // List<Employee> employees = [];
  // late EmployeeDataSource employeeDataSource;
  late UserController con;
  late List transactionData = [];
  late ScrollController _scrollController;
  // late List<Employee> emData = [];
  @override
  void initState() {
    add(widget.con);
    super.initState();
    con = controller as UserController;
    _scrollController = ScrollController();
    con.getTransactionHistory(con.nextPageTokenCount).then(
          (resData) => {
            print(resData),
            if (resData != [])
              {
                transactionData = resData,
                setState(() {}),
              },
          },
        );
    UserController().getBalance();
  }

  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingHeader(
              routerChange: widget.routerChange,
              icon: const Icon(Icons.attach_money,
                  color: Color.fromRGBO(76, 175, 80, 1)),
              pagename: 'Shnatter Token',
              button: const {'flag': false},
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              width: SizeConfig(context).screenWidth > 800
                  ? SizeConfig(context).screenWidth * 0.85
                  : SizeConfig(context).screenWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              width: 330,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.attach_money, color: Colors.black),
                                  Text(
                                    'Balance',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 330,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    Color.fromARGB(255, 94, 114, 228),
                                    Color.fromARGB(255, 130, 94, 228),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    con.balance.toString(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              width: 330,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.attach_money, color: Colors.black),
                                  Text(
                                    'Reserved Balance',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 330,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    Color.fromARGB(255, 94, 114, 228),
                                    Color.fromARGB(255, 130, 94, 228),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    '0.00',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const Padding(padding: EdgeInsets.only(top: 15)),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(3),
                          backgroundColor:
                              const Color.fromARGB(255, 251, 99, 64),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)),
                          minimumSize: const Size(720, 40),
                          maximumSize: const Size(720, 40),
                        ),
                        onPressed: () {
                          (() => {});
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Buy Tokens',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Blockchain Address',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(3),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            minimumSize: const Size(330, 50),
                            maximumSize: const Size(330, 50),
                          ),
                          onPressed: () {
                            (() => {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                UserManager.userInfo['paymail'],
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              const Flexible(
                                  fit: FlexFit.tight, child: SizedBox()),
                              const Icon(
                                Icons.file_copy,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  transList()
                  // generalWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transList() {
    print("$transactionData dafdfqewqwere3frswdfa");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SizeConfig(context).screenWidth > 800
              ? SizeConfig(context).screenWidth * 0.67
              : SizeConfig(context).screenWidth < 450
                  ? SizeConfig(context).screenWidth * 0.8
                  : SizeConfig(context).screenWidth * 0.78,
          height: 200,
          margin: const EdgeInsets.only(top: 30, bottom: 15),
          child: Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFffffff),
                borderRadius: BorderRadius.all(Radius.circular(7)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0, // soften the shadow
                    spreadRadius: 3.0, //extend the shadow
                    offset: Offset(
                      1.0, // Move to right 5  horizontally
                      3.0, // Move to bottom 5 Vertically
                    ),
                  )
                ],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 30),
                itemCount: transactionData.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = transactionData[index];
                  var userName = data['from'] != UserManager.userInfo['paymail']
                      ? data['sender']
                      : data['recipient'];
                  print(userName);
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 3),
                                padding: const EdgeInsets.all(12),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 0.0, // soften the shadow
                                      offset: Offset(
                                        0.0, // Move to right 5  horizontally
                                        1.0, // Move to bottom 5 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 150,
                                        alignment: Alignment.center,
                                        child: Text(
                                          data['sender'].toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 150,
                                        alignment: Alignment.center,
                                        child: Text(
                                          data['recipient'].toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 200,
                                        alignment: Alignment.center,
                                        child: Text(
                                          data['sendtime'].toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 300,
                                        alignment: Alignment.center,
                                        child: Text(
                                          data['notes'].toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 90,
                                        alignment: Alignment.center,
                                        child: Text(
                                          data['balance'].toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   verticalDirection: VerticalDirection.down,
              //   children: [
              //     // Row(
              //     //   verticalDirection: VerticalDirection.up,
              //     //   children: [
              //     //     Container(
              //     //       margin: const EdgeInsets.only(top: 7, bottom: 7),
              //     //       // alignment: Alignment.center,
              //     //       child: Row(
              //     //         children: [
              //     //           Container(
              //     //             width: 100,
              //     //             alignment: Alignment.center,
              //     //             child: const Text(
              //     //               'Sender',
              //     //               style: TextStyle(
              //     //                 fontSize: 20,
              //     //               ),
              //     //             ),
              //     //           ),
              //     //           Container(
              //     //             width: 100,
              //     //             alignment: Alignment.center,
              //     //             child: const Text(
              //     //               'Recipient',
              //     //               style: TextStyle(
              //     //                 fontSize: 20,
              //     //               ),
              //     //             ),
              //     //           ),
              //     //           Container(
              //     //             width: 100,
              //     //             alignment: Alignment.center,
              //     //             child: const Text(
              //     //               'Time',
              //     //               style: TextStyle(
              //     //                 fontSize: 20,
              //     //               ),
              //     //             ),
              //     //           ),
              //     //           Container(
              //     //             width: 100,
              //     //             alignment: Alignment.center,
              //     //             child: const Text(
              //     //               'Note',
              //     //               style: TextStyle(
              //     //                 fontSize: 20,
              //     //               ),
              //     //             ),
              //     //           ),
              //     //           Container(
              //     //             width: 100,
              //     //             alignment: Alignment.center,
              //     //             child: const Text(
              //     //               'Balance',
              //     //               style: TextStyle(
              //     //                 fontSize: 20,
              //     //               ),
              //     //             ),
              //     //           )
              //     //         ],
              //     //       ),
              //     //     ),
              //     //   ],
              //     // ),

              //   ],
              // ),
            ),
          ),
        ),
      ],
    );
    // ListView.builder(
    //   padding: const EdgeInsets.only(top: 50),
    //   itemCount: transactionData.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     var data = transactionData[index];
    //     var userName = data['from'] != UserManager.userInfo['paymail']
    //         ? data['sender']
    //         : data['recipient'];
    //     print(userName);
    //     return const ListTile(
    //       title: Text('123123123123123'),
    //     );
    //   },
    // );
  }

  // Widget button({url, text}) {
  //   return Expanded(
  //     flex: 1,
  //     child: Container(
  //       width: 90,
  //       height: 90,
  //       margin: EdgeInsets.all(5),
  //       child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           padding: EdgeInsets.all(3),
  //           backgroundColor: Colors.white,
  //           elevation: 3,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(3.0)),
  //           minimumSize: const Size(90, 90),
  //           maximumSize: const Size(90, 90),
  //         ),
  //         onPressed: () {
  //           (() => {});
  //         },
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: 40,
  //               height: 40,
  //               decoration: const BoxDecoration(
  //                   // color: Colors.grey,
  //                   borderRadius: BorderRadius.all(Radius.circular(20))),
  //               child: SvgPicture.network(url),
  //             ),
  //             Text(
  //               text,
  //               style: const TextStyle(
  //                   fontSize: 11,
  //                   color: Colors.grey,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildProgressIndicator() {
  //   return Container(
  //       height: 60.0,
  //       alignment: Alignment.center,
  //       width: double.infinity,
  //       decoration: const BoxDecoration(
  //         color: Color(0xFFFFFFFF),
  //         border: BorderDirectional(
  //           top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.26)),
  //         ),
  //       ),
  //       child: Container(
  //           width: 40,
  //           height: 40,
  //           alignment: Alignment.center,
  //           child: const CircularProgressIndicator(
  //             backgroundColor: Colors.transparent,
  //           )));
  // }

  // Widget _buildLoadMoreView(BuildContext context, LoadMoreRows loadMoreRows) {
  //   Future<String> loadRows() async {
  //     // Call the loadMoreRows function to call the
  //     // DataGridSource.handleLoadMoreRows method. So, additional
  //     // rows can be added from handleLoadMoreRows method.
  //     await loadMoreRows();
  //     return Future<String>.value('Completed');
  //   }

  //   return FutureBuilder<String>(
  //     initialData: 'Loading',
  //     future: loadRows(),
  //     builder: (BuildContext context, AsyncSnapshot<String> snapShot) {
  //       print(snapShot.data);
  //       return snapShot.data == 'Loading'
  //           ? _buildProgressIndicator()
  //           : SizedBox.fromSize(size: Size.zero);
  //     },
  //   );
  // }

  // List<GridColumn> _getColumns() {
  //   return <GridColumn>[
  //     GridColumn(
  //         columnName: 'ID',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'ID',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     GridColumn(
  //         columnName: 'Sender',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Sender',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     GridColumn(
  //         columnName: 'Recipient',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Recipient',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     GridColumn(
  //         columnName: 'Send Time',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Send Time',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     GridColumn(
  //         columnName: 'Note',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Note',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     // GridColumn(
  //     //     columnName: 'Activated',
  //     //     columnWidthMode: ColumnWidthMode.lastColumnFill,
  //     //     label: Container(
  //     //         padding: const EdgeInsets.all(8),
  //     //         alignment: Alignment.centerRight,
  //     //         child: const Text(
  //     //           'Activated',
  //     //           overflow: TextOverflow.ellipsis,
  //     //         ))),
  //     GridColumn(
  //         columnName: 'Balance',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Balance',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  // GridColumn(
  //     columnName: 'Actions',
  //     columnWidthMode: ColumnWidthMode.lastColumnFill,
  //     label: Container(
  //         padding: const EdgeInsets.all(8),
  //         alignment: Alignment.centerRight,
  //         child: const Text(
  //           'Actions',
  //           overflow: TextOverflow.ellipsis,
  //         )))
  //   ];
  // }

  // Widget generalWidget() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         SizeConfig(context).screenWidth > 800
  //             ? Container(
  //                 width: SizeConfig(context).screenWidth > 800
  //                     ? SizeConfig(context).screenWidth * 0.85
  //                     : SizeConfig(context).screenWidth,
  //                 padding: const EdgeInsets.all(15),
  //                 alignment: Alignment.center,
  //                 child: Container(
  //                   width: SizeConfig(context).screenWidth > 800
  //                       ? SizeConfig(context).screenWidth * 0.85
  //                       : SizeConfig(context).screenWidth,
  //                   // height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight,
  //                   padding: const EdgeInsets.all(15),
  //                   child: SfDataGrid(
  //                     allowSorting: true,
  //                     allowFiltering: true,
  //                     loadMoreViewBuilder: _buildLoadMoreView,
  //                     source: employeeDataSource,
  //                     columns: _getColumns(),
  //                     gridLinesVisibility: GridLinesVisibility.both,
  //                     headerGridLinesVisibility: GridLinesVisibility.both,
  //                   ),
  //                 ),
  //               )
  //             : Container(
  //                 width: SizeConfig(context).screenWidth < 800
  //                     ? SizeConfig(context).screenWidth * 0.85
  //                     : SizeConfig(context).screenWidth,
  //                 // height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight,
  //                 padding: const EdgeInsets.all(15),
  //                 child: SfDataGrid(
  //                   allowSorting: true,
  //                   allowFiltering: true,
  //                   loadMoreViewBuilder: _buildLoadMoreView,
  //                   source: employeeDataSource,
  //                   columns: _getColumns(),
  //                   gridLinesVisibility: GridLinesVisibility.both,
  //                   headerGridLinesVisibility: GridLinesVisibility.both,
  //                 ),
  //               ),
  //       ],
  //     ),
  //   );
  // }
}
