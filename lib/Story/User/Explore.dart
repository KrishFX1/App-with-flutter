import 'package:Kahani_App/Widgets/FBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import '../../main.dart';

class StoryExplore extends StatefulWidget {
  StoryExplore({this.UserEmail, this.UserID, this.UserName, this.UserPhoto});

  final String UserEmail;
  final String UserID;
  final String UserName;
  final String UserPhoto;

  @override
  _StoryExploreState createState() => _StoryExploreState();
}

class _StoryExploreState extends State<StoryExplore> {
  String UserEmail;
  String UserID;
  String UserName;
  String UserPhoto;
  List Followings = [];

  @override
  void initState() {
    LoadFollowings();
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

  LoadFollowings() async {
    print('UserID : :: : :: : : : : : : ::: :: : :  : : :$UserID');
    DocumentSnapshot data =
        await firestore.collection('Users').doc(UserID.trim()).get();
    Followings = List.castFrom(
      data.data()['Following'],
    );
    print(Followings);
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  Future<QuerySnapshot> FromFollowings() async {
    await LoadFollowings();

    return await firestore
        .collection('Stories')
        .where('UserID', whereIn: Followings)
        .get();
  }

  Future<QuerySnapshot> UsersFollowing() async {
    await LoadFollowings();
    return await firestore
        .collection('Users')
        // .where('UserID')
        .where('UserID', whereIn: Followings)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          FlatButton(
            padding: EdgeInsets.all(0),
            child: SvgPicture.asset('Icons/Facebook.svg'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    // builder: (context) => Explore(),
                    ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: LegendaryExploration(UsersFollowing, FromFollowings,
                      UserID, UserName, UserEmail, UserPhoto),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
