import 'dart:math';

import 'package:Kahani_App/Dairy/AllDiaries.dart';
import 'package:Kahani_App/Dairy/Password.dart';
import 'package:Kahani_App/other/Search.dart';
import 'package:Kahani_App/Story/User/Explore.dart';
import 'package:Kahani_App/User/SettingPage.dart';
import 'package:Kahani_App/Widgets/FBuilder.dart';
import 'package:Kahani_App/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

final controller = NativeAdmobController();
List<String> RandomTag = [];

CollectionReference stories = firestore.collection('Stories');

class StoryApp extends StatefulWidget {
  @override
  _StoryAppState createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  String UserEmail;
  String UserID;
  String UserName;
  String UserPhoto;
  bool AskToSetPassword;
  bool DiaryHasPassword;

  @override
  void initState() {
    LoadUserData();
    super.initState();
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    AskToSetPassword = UserData.get('AskToSetPassword');
    DiaryHasPassword = UserData.get('DiaryHasPassword');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller =
        PersistentTabController(initialIndex: 0);
    List<Widget> _buildScreens() {
      return [
        StoryPosts(),
        StoryExplore(),
        if (AskToSetPassword == true)
          SetPassword()
        else
          DiaryHasPassword == true ? AskForPassword() : AllDiaries(),
        SettingsPage(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          opacity: 0.7,
          icon: Icon(Icons.home_sharp),
          title: ("Home"),
          activeColorPrimary: Colors.green[800],
          inactiveColorPrimary: Colors.black,
          contentPadding: 5,
        ),
        PersistentBottomNavBarItem(
          opacity: 0.7,
          icon: Icon(Icons.explore),
          title: ("Explore"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          opacity: 0.7,
          icon: Icon(Icons.add),
          title: ("Write"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          opacity: 0.7,
          icon: Icon(Icons.settings),
          title: ("Settings"),
          activeColorPrimary: Color(0xFFA3EBB1),
          inactiveColorPrimary: Colors.black,
        ),
      ];
    }

    return PersistentTabView(
      context,
      navBarHeight: 58,
      padding: NavBarPadding.all(0),
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: false,
      backgroundColor: Colors.white70,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          false, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 10),
        curve: Curves.bounceIn,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.bounceInOut,
        duration: Duration(milliseconds: 10),
      ),
      navBarStyle:
          NavBarStyle.style12, // Choose the nav bar style with this property.
    );
  }
}

class StoryPosts extends StatefulWidget {
  StoryPosts({this.UserEmail, this.UserID, this.UserName, this.UserPhoto});

  final String UserEmail;
  final String UserID;
  final String UserName;
  final String UserPhoto;

  @override
  _StoryPostsState createState() => _StoryPostsState();
}

// ignore: camel_case_types
class _StoryPostsState extends State<StoryPosts> {
  List<String> TagSelected;
  String UserEmail;
  String UserID;
  String UserName;
  String UserPhoto;
  List<String> Categories = [
    'Sports',
    'Programming',
    'Technology',
    'Scence',
    'Space',
    'Science Fiction',
    'Politics',
    ''
  ];
  bool ArticleInterestDone;
  bool AskToSetPassword;
  bool DiaryHasPassword;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    LoadUserData();
    super.initState();
  }

  Future<QuerySnapshot> LoadStories() async {
    var random = Random();
    int randomIndex = random.nextInt(10); // ? Till 10 ( 0 -9 )
    return await firestore
        .collection('Stories')
        .where('randomIndex', arrayContains: randomIndex)
        .get();
  }

  Future<QuerySnapshot> LoadUsers() async {
    return await firestore.collection('Users').get();
    // if (DateTime.now().day <= 5) {
    //   return await firestore
    //       .collection('Users')
    //       // .where('TotalViews', isGreaterThanOrEqualTo: 10000)
    //       .get();
    // } else if (DateTime.now().day < 15 && DateTime.now().day > 5) {
    //   return await firestore
    //       .collection('Users')
    //       // .where('TotalMonthlyViews', isGreaterThanOrEqualTo: 1000)
    //       .get();
    // } else {
    //   return await firestore
    //       .collection('Users')
    //       // .where('MontlyPosts', isGreaterThanOrEqualTo: 1)
    //       // .where('MonthlyViews', isGreaterThanOrEqualTo: 2500)
    //       .get();
    // }
  }

  Future<QuerySnapshot> FilterStory(String tag) async {
    return await firestore
        .collection('Story')
        .where('Tag', arrayContains: tag)
        .get();
  }

  Future<QuerySnapshot> TrendingStories() async {
    return await firestore
        .collection('Stories')
        //  .where('Tag', arrayContains: StoryTags[index])
        // .where(
        //   'Time',
        //   isGreaterThanOrEqualTo: DateTime.now().subtract(
        //     Duration(hours: 1200),
        //   ),
        // )
        // .orderBy('Views')
        .get();
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    AskToSetPassword = UserData.get('AskToSetPassword');
    DiaryHasPassword = UserData.get('DiaryHasPassword');
    ArticleInterestDone = UserData.get('ArticleInterestsSelected');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        actions: [
          Row(
            children: [
              // TextButton.icon(
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Search()));
              //   },
              //   icon: Icon(Icons.search),
              //   label: Text('Search'),
              // ),
              // TextButton(
              //   child: SvgPicture.asset(
              //     'Icons/Microsoft.svg',
              //     height: 45,
              //   ),
              //   onPressed: () {
              //     ArticleInterestDone == true
              //         ? Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //                 // builder: (context) => Articles(),
              //                 ),
              //           )
              //         : AskInterest();
              //   },
              // ),
              // GestureDetector(
              //   child: Text('Diary'),
              //   onTap: () {
              //     if (AskToSetPassword == true)
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => SetPassword()));
              //     else
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => DiaryHasPassword == true
              //                 ? AskForPassword()
              //                 : AllDiaries(),
              //           ));
              //   },
              // )
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: LegendaryStories(LoadUsers, FilterStory, LoadStories,
                      FirsTwos(), UserID, UserName, UserEmail, UserPhoto),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AskInterestOrNot() async {
  //   DocumentSnapshot data =
  //       await firestore.collection('Users').doc(UserID).get();
  //   ArticleInterestDone = data.data()['AskedForInterestOrNot'];
  // }

  Widget AskInterest() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              elevation: 0,
              title: Center(child: Text('Choose Your Interests')),
              content: ListBody(
                children: <Widget>[
                  // ChipsChoice<String>.multiple(
                  //   itemConfig: ChipsChoiceItemConfig(),
                  //   value: TagSelected,
                  //   options: ChipsChoiceOption.listFrom<String, String>(
                  //     source: Categories,
                  //     value: (i, v) => v,
                  //     label: (i, v) => v,
                  //   ),
                  //   onChanged: (List<String> value) {
                  //     // TagSelected.add(value);
                  //     // print(TagSelected);
                  //   },
                  //   isWrapped: true,
                  // ),
                ],
              ),
              actions: [
                GestureDetector(
                    onTap: () async {
                      // await firestore
                      //     .collection('Users')
                      //     .doc(UserID)
                      //     .update({'ArticleTagsSelected': TagSelected});
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            // builder: (context) => Articles(                          ),
                            ),
                      );
                    },
                    child: Text('Done!!'))
              ],
            ),
          ),
        );
      },
    );
  }

  List FirsTwos() {
    List allTags = [
      'Adventure and Action',
      'Science Fiction',
      'Fantasy',
      'Horror',
      'Comedy',
      'Supense And Thriller'
    ];
    var random = Random();
    int randomNo = random.nextInt(6);
    return [allTags[randomNo], allTags[randomNo + 1]];
  }
}
