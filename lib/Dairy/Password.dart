import 'package:Kahani_App/Dairy/AllDiaries.dart';
import 'package:Kahani_App/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SetPassword extends StatefulWidget {
  final String UserName;
  final String UserID;
  final String UserEmail;
  final String UserPhoto;

  SetPassword({this.UserEmail, this.UserID, this.UserName, this.UserPhoto});

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  List EnteredPassword = [];
  List EnteredPassword2 = [];
  bool ReEntering = false;
  bool wrong = false;
  String UserName;
  String UserID;
  String UserPhoto;
  String UserEmail;

  @override
  void initState() {
    if (widget.UserID == null) {
      LoadUserData();
    } else {
      UserName = widget.UserName;
      UserEmail = widget.UserEmail;
      UserID = widget.UserID;
      UserPhoto = widget.UserPhoto;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1557683316-973673baf926?ixlib=rb-1.2.1&w=1000&q=80'),
            fit: BoxFit.fill),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReEntering == false
                ? Text(
                    'Set Pin For Diary',
                    style: TextStyle(color: Colors.white, fontSize: 21),
                  )
                : Text(
                    'Re-Enter Your Pin',
                    style: TextStyle(color: Colors.white, fontSize: 21),
                  ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReEntering == true ? PasswordShow2(0) : PasswordShow1(0),
                SizedBox(
                  width: 15,
                ),
                ReEntering == true ? PasswordShow2(1) : PasswordShow1(1),
                SizedBox(
                  width: 15,
                ),
                ReEntering == true ? PasswordShow2(2) : PasswordShow1(2),
                SizedBox(
                  width: 15,
                ),
                ReEntering == true ? PasswordShow2(3) : PasswordShow1(3),
              ],
            ),
            SizedBox(height: 100),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberWidget(1),
                    SizedBox(
                      width: 35,
                    ),
                    NumberWidget(2),
                    SizedBox(
                      width: 35,
                    ),
                    NumberWidget(3),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberWidget(4),
                    SizedBox(
                      width: 35,
                    ),
                    NumberWidget(5),
                    SizedBox(
                      width: 35,
                    ),
                    NumberWidget(6),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberWidget(7),
                    SizedBox(
                      width: 35,
                    ),
                    NumberWidget(8),
                    SizedBox(
                      width: 35,
                    ),
                    NumberWidget(9),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 35,
                    ),
                    NumberWidget(0),
                    SizedBox(
                      width: 35,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (ReEntering == false) {
                          setState(() {
                            EnteredPassword.removeLast();
                          });
                        } else {
                          setState(() {
                            EnteredPassword2.removeLast();
                          });
                        }
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Icon(
                          Icons.backspace,
                          color: Colors.white,
                          size: 39,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget NumberWidget(int no) {
    return GestureDetector(
      onTap: () {
        if (ReEntering == false) {
          if (EnteredPassword.length >= 4) {}
          if (EnteredPassword.length == 3) {
            setState(() {
              EnteredPassword.add(no);
              ReEntering = true;
            });
          } else if (EnteredPassword.length < 3) {
            setState(() {
              EnteredPassword.add(no);
            });
          }
        } else if (ReEntering == true) {
          if (EnteredPassword2.length >= 4) {}
          if (EnteredPassword2.length == 3) {
            setState(() {
              EnteredPassword2.add(no);
              if (((EnteredPassword.asMap()[0] != EnteredPassword2.asMap()[0] ||
                      EnteredPassword.asMap()[1] !=
                          EnteredPassword2.asMap()[1]) ||
                  (EnteredPassword.asMap()[2] != EnteredPassword2.asMap()[2] ||
                      EnteredPassword.asMap()[3] !=
                          EnteredPassword2.asMap()[3]))) {
                setState(() {
                  wrong = true;
                  EnteredPassword2.clear();
                });
              } else if (((EnteredPassword.asMap()[0] ==
                          EnteredPassword2.asMap()[0] &&
                      EnteredPassword.asMap()[1] ==
                          EnteredPassword2.asMap()[1]) &&
                  (EnteredPassword.asMap()[2] == EnteredPassword2.asMap()[2] &&
                      EnteredPassword.asMap()[3] ==
                          EnteredPassword2.asMap()[3]))) {
                Box DiaryPassword = Hive.box('DiaryPassword');
                DiaryPassword.addAll([
                  EnteredPassword.asMap()[0],
                  EnteredPassword.asMap()[1],
                  EnteredPassword.asMap()[2],
                  EnteredPassword.asMap()[3]
                ]);
                Box UserData = Hive.box('UserData');
                UserData.put('DiaryHasPassword', true);
                UserData.put('AskToSetPassword', false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contxet) => AllDiaries(
                              UserID: UserID,
                              UserName: UserName,
                              UserEmail: UserEmail,
                              UserPhoto: UserPhoto,
                            )));
              }
            });
          } else if (EnteredPassword2.length < 3) {
            setState(() {
              EnteredPassword2.add(no);
              wrong = false;
            });
          }
        }
      },
      child: Container(
        height: 70,
        width: 70,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
        child: Center(
            child: Text(
          '$no',
          style: TextStyle(color: Colors.white, fontSize: 29),
        )),
      ),
    );
  }

  Widget PasswordShow1(int index) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: EnteredPassword.asMap()[index] != null ? Colors.white : null,
        shape: BoxShape.circle,
        border: Border.all(
            color: wrong == true ? Colors.red : Colors.white, width: 2),
      ),
    );
  }

  Widget PasswordShow2(int index) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: EnteredPassword2.asMap()[index] != null ? Colors.white : null,
        shape: BoxShape.circle,
        border: Border.all(
            color: wrong == true ? Colors.red : Colors.white, width: 2),
      ),
    );
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }
}

class AskForPassword extends StatefulWidget {
  @override
  _AskForPasswordState createState() => _AskForPasswordState();
}

class _AskForPasswordState extends State<AskForPassword> {
  TextEditingController c2 = TextEditingController();
  List Password = [];
  String EnteredPassword;
  String UserName;
  String UserID;
  String UserPhoto;
  String UserEmail;
  TextEditingController c1 = TextEditingController();
  List PasswordEntered = [];
  @override
  void initState() {
    LoadUserData();
    super.initState();
  }

  Color Error = Colors.red;
  bool wrong = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1557683316-973673baf926?ixlib=rb-1.2.1&w=1000&q=80'),
              fit: BoxFit.fill),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                wrong == true ? 'PIN DOESN\'T MATCH' : 'ENTER YOUR PIN',
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PasswordShow(0),
                  SizedBox(
                    width: 15,
                  ),
                  PasswordShow(1),
                  SizedBox(
                    width: 15,
                  ),
                  PasswordShow(2),
                  SizedBox(
                    width: 15,
                  ),
                  PasswordShow(3),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberWidget(1),
                      SizedBox(
                        width: 35,
                      ),
                      NumberWidget(2),
                      SizedBox(
                        width: 35,
                      ),
                      NumberWidget(3),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberWidget(4),
                      SizedBox(
                        width: 35,
                      ),
                      NumberWidget(5),
                      SizedBox(
                        width: 35,
                      ),
                      NumberWidget(6),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberWidget(7),
                      SizedBox(
                        width: 35,
                      ),
                      NumberWidget(8),
                      SizedBox(
                        width: 35,
                      ),
                      NumberWidget(9),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(
                        width: 35,
                      ),
                      NumberWidget(0),
                      SizedBox(
                        width: 35,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            PasswordEntered.removeLast();
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Icon(
                            Icons.backspace,
                            color: Colors.white,
                            size: 39,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 28,
              ),
              Text(
                'Forgot Password',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
    Box DiaryPassword = Hive.box('DiaryPassword');
    Password.addAll([
      DiaryPassword.getAt(0),
      DiaryPassword.getAt(1),
      DiaryPassword.getAt(2),
      DiaryPassword.getAt(3)
    ]);
  }

  Widget PasswordShow(int index) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: PasswordEntered.asMap()[index] != null ? Colors.white : null,
        shape: BoxShape.circle,
        border:
            Border.all(color: wrong == true ? Error : Colors.white, width: 2),
      ),
    );
  }

  Widget NumberWidget(int no) {
    return GestureDetector(
      onTap: () {
        if (PasswordEntered.length >= 4) {}
        if (PasswordEntered.length == 3) {
          setState(() {
            PasswordEntered.add(no);
          });

          if ((PasswordEntered[0] != Password[0] ||
                  PasswordEntered[1] != Password[1]) ||
              (PasswordEntered[2] != Password[2] ||
                  PasswordEntered[3] != Password[3])) {
            Future.delayed(
                Duration(milliseconds: 180),
                () => {
                      setState(() {
                        wrong = true;
                      }),
                      // print('Wrong');
                      PasswordEntered.clear()
                    });
          } else if ((PasswordEntered[0] == Password[0] &&
                  PasswordEntered[1] == Password[1]) &&
              (PasswordEntered[2] == Password[2] &&
                  PasswordEntered[3] == Password[3])) {
            Future.delayed(
                Duration(milliseconds: 120),
                () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllDiaries())),
                      PasswordEntered.clear(),
                    });
          }
        } else if (PasswordEntered.length < 3) {
          setState(() {
            PasswordEntered.add(no);
            wrong = false;
          });
        }
      },
      child: Container(
        height: 70,
        width: 70,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
        child: Center(
            child: Text(
          '$no',
          style: TextStyle(color: Colors.white, fontSize: 29),
        )),
      ),
    );
  }
}
