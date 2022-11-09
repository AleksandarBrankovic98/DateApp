// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/helper.dart';
import '../managers/relysia_manager.dart';
import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/route_names.dart';
import 'package:time_elapsed/time_elapsed.dart';

enum EmailType { emailVerify, googleVerify }

class UserController extends ControllerMVC {
  factory UserController([StateMVC? state]) =>
      _this ??= UserController._(state);
  UserController._(StateMVC? state) : super(state);
  static UserController? _this;
  String token = '';
  String email = '';
  String relysiaEmail = '';
  String relysiaPassword = '';
  String password = '';
  String paymail = '';
  String walletAddress = '';
  int balance = 0;
  bool isSendRegisterInfo = false;
  bool isSendLoginedInfo = false;
  bool isStarted = false;
  bool isVerify = false;
  bool isSendResetPassword = false;
  bool isLogined = false;
  String failLogin = '';
  String failRegister = '';
  var resData = {};
  var userInfo = {};
  // ignore: prefer_typing_uninitialized_variables
  var responseData;
  var context;
  var signUpUserInfo = {};

  @override
  Future<bool> initAsync() async {
    //
    Helper.authdata = FirebaseFirestore.instance
        .collection(Helper.userField)
        .withConverter<TokenLogin>(
          fromFirestore: (snapshots, _) =>
              TokenLogin.fromJSON(snapshots.data()!),
          toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
        );
    return true;
  }

  String createRandNumber() {
    var rng = Random();
    int randomNumber = rng.nextInt(100);
    return randomNumber.toString();
  }

  String createRandEmail() {
    String code = ""; // Timestamp.now.toString();
    for (int i = 0; i < 13; i++) {
      code = code + createRandNumber();
    }
    return "relysia$code@shnatter.com";
  }

  void validate(cont, info) async {
    isSendRegisterInfo = true;
    setState(() {});
    var fill = true;
    var validation = [
      'userName',
      'firstName',
      'lastName',
      'email',
      'password',
    ];
    for (var i = 0; i < validation.length; i++) {
      if (info[validation[i]] == null) {
        fill = false;
        break;
      }
    }
    if (!fill) {
      failRegister = 'You must fill all field';
      isSendRegisterInfo = false;
      setState(() {});
      return;
    }
    context = cont;
    signUpUserInfo = info;
    email = signUpUserInfo['email'];
    password = signUpUserInfo['password'];
    var check = email.contains('@gmail.com'); //return true if contains
    if (!check) {
      failRegister = 'Invalid Email';
      isSendRegisterInfo = false;
      setState(() {});
      return;
    }
    if (password.length < 9) {
      failRegister = 'Password length should be 8 over';
      isSendRegisterInfo = false;
      setState(() {});
      return;
    }
    QuerySnapshot<TokenLogin> querySnapshot =
        await Helper.authdata.where('email', isEqualTo: email).get();
    if (querySnapshot.size > 0) {
      failRegister =
          'Sorry, it looks like $email belongs to an existing account';
      isSendRegisterInfo = false;
      setState(() {});
      return;
    }
    if (failRegister == '') createRelysiaAccount();
  }

  String createActivationCode() {
    String code = ""; // Timestamp.now.toString();
    for (int i = 0; i < 13; i++) {
      code = code + createRandNumber();
    }
    return code;
  }

  String createPassword() {
    String password = "";
    for (int i = 0; i < 6; i++) {
      password = password + createRandNumber();
    }
    return password;
  }

  Future<void> registerUserInfo() async {
    var uuid = await sendEmailVeryfication();
    await FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(uuid)
        .set({
      ...signUpUserInfo,
      'paymail': paymail,
      'walletAddress': walletAddress,
      'relysiaEmail': relysiaEmail,
      'relysiaPassword': relysiaPassword,
      'isStarted': false,
    });
    await Helper.saveJSONPreference(Helper.userField, {
      ...signUpUserInfo,
      'paymail': paymail,
      'walletAddress': walletAddress,
      'relysiaEmail': relysiaEmail,
      'relysiaPassword': relysiaPassword,
      'isStarted': 'false',
      'isVerify': 'false',
      'isRememberme': 'false',
      'expirationPeriod': DateTime.now().toString()
    });
  }

  void getBalance() {
    RelysiaManager.getBalance(token).then((res) => {
          print('balance is $res'),
          balance = res,
          Helper.balance = balance,
          setState(() {})
        });
  }

  void getWalletFromPref(context) async {}

  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      isSendResetPassword = true;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void loginWithEmail(context, em, pass, isRememberme) async {
    if (em == '' || pass == '') {
      failLogin = 'You must fill all field';
      setState(() {});
      return;
    }
    email = em;
    password = pass;
    try {
      isSendLoginedInfo = true;
      setState(() {});
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      failLogin = '';
      setState(() {});
      QuerySnapshot<TokenLogin> querySnapshot =
          await Helper.authdata.where('email', isEqualTo: email).get();
      if (querySnapshot.size > 0) {
        TokenLogin user = querySnapshot.docs[0].data();
        relysiaEmail = user.relysiaEmail;
        relysiaPassword = user.relysiaPassword;
        isStarted = user.isStarted;
        isVerify = userCredential.user!.emailVerified;
        userInfo = {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'userName': user.userName,
          'password': password,
          'relysiaEmail': user.relysiaEmail,
          'relysiaPassword': user.relysiaPassword,
          'paymail': user.paymail,
          'walletAddress': user.walletAddress,
          'isStarted': user.isStarted.toString(),
          'isVerify': isVerify.toString(),
          'isRememberme': isRememberme.toString(),
          'expirationPeriod': isRememberme ? '' : DateTime.now().toString()
        };
        await Helper.saveJSONPreference(Helper.userField, {...userInfo});
        loginRelysia(context);
      } else {
        Helper.showToast(
            'The email you entered does not belong to any account');
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        failLogin = 'The username you entered does not belong to any account';
        setState(
          () {},
        );
      } else if (e.code == 'wrong-password') {
        failLogin = 'wrong-password';
        setState(() {});
      }
      isSendLoginedInfo = false;
      setState(() {});
    }
  }

  void loginRelysia(context) {
    print("try to login user....");
    RelysiaManager.authUser(relysiaEmail, relysiaPassword).then((res) async => {
          if (res['data'] != null)
            {
              if (res['statusCode'] == 200)
                {
                  token = res['data']['token'],
                  getBalance(),
                  RelysiaManager.getPaymail(token).then((response) async => {
                        setState(() {}),
                        if (response['paymail'] != null)
                          {
                            paymail = response['paymail'],
                            walletAddress = response['address'],
                            isSendLoginedInfo = false,
                            isLogined = true,
                            Navigator.pushReplacementNamed(
                                context,
                                isStarted
                                    ? RouteNames.homePage
                                    : RouteNames.started),
                            setState(() {})
                          }
                      }),
                  setState(() {})
                }
              else
                {
                  resData = res['data'],
                  if (resData['msg'] == 'INVALID_EMAIL')
                    {
                      Helper.showToast('You didn\'t sign up in Relysia!'),
                    }
                  else if (resData['msg'] == 'EMAIL_NOT_FOUND')
                    {
                      Helper.showToast('Email Not Found!'),
                    }
                  else
                    {
                      Helper.showToast(resData['msg']),
                    }
                }
            }
          else
            {isSendLoginedInfo = true, setState(() {})}
        });
  }

  Future<String> sendEmailVeryfication() async {
    setState(() {});
    var uuid = '';
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      uuid = userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        uuid = userCredential.user!.uid;
      } else {}
    } catch (e) {
      rethrow;
    }

    ActionCodeSettings acs = ActionCodeSettings(
        url:
            " https://us-central1-shnatter-a69cd.cloudfunctions.net/emailVerification",
        handleCodeInApp: true);
    await FirebaseAuth.instance.currentUser?.sendEmailVerification(acs);
    return uuid;
  }

  void createRelysiaAccount() async {
    relysiaEmail = createRandEmail();
    relysiaPassword = createPassword();
    responseData =
        await RelysiaManager.createUser(relysiaEmail, relysiaPassword);
    if (responseData['data'] != null) {
      if (responseData['statusCode'] == 200) {
        createEmail();
      } else {
        createRelysiaAccount();
      }
    } else {
      createRelysiaAccount();
    }
  }

  void createEmail() async {
    token = responseData['data']['token'];
    RelysiaManager.createWallet(token).then((rr) => {
          if (rr == 0)
            {
              Helper.showToast("error occurs while create wallet"),
              isSendRegisterInfo = false,
              setState(() {}),
            }
          else
            {
              print('relysiaPassword$relysiaPassword'),
              RelysiaManager.authUser(relysiaEmail, relysiaPassword)
                  .then((responseData) => {
                        if (responseData['data'] != null)
                          {
                            if (responseData['statusCode'] == 200)
                              {
                                token = responseData['data']['token'],
                                RelysiaManager.getPaymail(token)
                                    .then((response) async => {
                                          if (response['paymail'] != null)
                                            {
                                              paymail = response['paymail'],
                                              walletAddress =
                                                  response['address'],
                                              await registerUserInfo(),
                                              isSendRegisterInfo = false,
                                              isLogined = true,
                                              Navigator.pushReplacementNamed(
                                                  context, RouteNames.homePage),
                                              setState(() {}),
                                            }
                                        })
                              }
                            else
                              {
                                resData = responseData['data'],
                                if (resData['msg'] == 'INVALID_EMAIL')
                                  {
                                    Helper.showToast(
                                        'You didn\'t sign up in Relysia!'),
                                  }
                                else if (resData['msg'] == 'EMAIL_NOT_FOUND')
                                  {
                                    Helper.showToast('Email Not Found!'),
                                  }
                                else
                                  {
                                    Helper.showToast(resData['msg']),
                                    setState(() {})
                                  },
                                isSendRegisterInfo = false,
                                setState(() {}),
                              }
                          }
                        else
                          {
                            isSendRegisterInfo = false,
                            setState(() {}),
                          },
                      })
            },
        });
  }
}