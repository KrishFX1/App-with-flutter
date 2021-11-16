import 'package:Kahani_App/Story/User/AllPosts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  final String UserName;
  final String UserID;
  final String UserEmail;
  final String UserPhoto;

  SettingsPage({this.UserEmail, this.UserID, this.UserName, this.UserPhoto});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 17,
              ),
              Row(
                children: [
                  // Container(
                  //   height: 120,
                  //   width: 120,
                  //   decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //           image: NetworkImage(UserPhoto), fit: BoxFit.fill)),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(UserPhoto),
                      radius: 50,
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserName,
                        style: GoogleFonts.robotoCondensed(fontSize: 20),
                        softWrap: true,
                      ),
                      SizedBox(height: 3),
                      Container(
                        height: 50,
                        width: 240,
                        child: Text(
                            'An App Developer , A Passionate Writer . #Living For Life . I am Happy with my life , tell yours'),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: Text(
                              'Edit',
                              style: TextStyle(fontSize: 17),
                            ),
                            onTap: () {},
                            onDoubleTap: () {},
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'Your Recent Reads',
                  style: TextStyle(fontSize: 19),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllPosts(
                                UserEmail: UserEmail,
                                UserName: UserName,
                                UserID: UserID,
                                UserPhoto: UserPhoto,
                                future: AllUserPosts(),
                                AllPosts1: true,
                              )));
                },
                leading: Icon(Icons.notifications),
                title: Text(
                  'Your Posts',
                  style: TextStyle(fontSize: 19),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'Your Purchase History',
                  style: TextStyle(fontSize: 19),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'Your Recent Reads',
                  style: TextStyle(fontSize: 19),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'Your Recent Reads',
                  style: TextStyle(fontSize: 19),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app_rounded),
                title: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 19),
                ),
                // trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');

    UserID = UserData.get('UserID');
    UserEmail = UserData.get('UserEmail');
    UserName = UserData.get('UserName');
    UserPhoto = UserData.get('UserPhoto');
  }

  Future<QuerySnapshot> AllUserPosts() async {
    return await firestore
        .collection('Stories')
        .where('UserID', isEqualTo: UserID)
        .get();
  }
}
