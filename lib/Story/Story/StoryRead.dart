import 'package:Kahani_App/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart'; //TODO
import 'package:hive/hive.dart';

ScrollController control = ScrollController();
NativeAdmobController controller;
String adUnitID = 'ca-app-pub-4144128581194892/8591658542';
bool AdFree;

bool FiftyPercentAdFree;

int index = 0;
int length;

class StoryRead extends StatefulWidget {
  final String UserID;
  final String UserEmail;
  final String UserName;
  final String UserPhoto;
  final String Title;
  final String TitleImage;
  final String Author;
  final String Characters;
  final List Story;
  final String StoryUserID;
  final String StoryUserPhoto;
  final String DocID;

  StoryRead({
    this.UserEmail,
    this.UserPhoto,
    this.UserID,
    this.UserName,
    this.Title,
    this.TitleImage,
    this.Author,
    this.StoryUserID,
    this.StoryUserPhoto,
    this.Characters,
    this.Story,
    this.DocID,
  });
  @override
  _StoryReadState createState() => _StoryReadState();
}

class _StoryReadState extends State<StoryRead> {
  String Story;
  String UserID;
  String UserEmail;
  String UserPhoto;
  String UserName;
  String Comment;
  List<String> Comments = [];
  List CommentsOfStory = [];
  @override
  void initState() {
    qaa();
    // FlutterStatusbarManager.setNetworkActivityIndicatorVisible(false);
    CommmentsFromFirestore();
    SystemChrome.setEnabledSystemUIOverlays([]);
    print(Story);
    length = widget.Story.length;
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

  qaa() async {
    DocumentSnapshot a =
        await firestore.collection('Test').doc('Document').get();
    print(a.data());
    setState(() {
      Story = a.data()['Story'];
    });
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      persistentFooterButtons: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (index == 0)
              Container()
            else
              FlatButton(
                  onPressed: () {
                    setState(() {
                      index--;
                    });
                    control.animateTo(0,
                        duration: Duration(microseconds: 5),
                        curve: Curves.bounceOut);
                    // controller.reloadAd();
                  },
                  child: Text(
                    'PREVIOUS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )),
            // Container(
            //   child: index == length - 1
            // ?
            FlatButton(
                onPressed:
                    // () {
                    index == length - 1
                        ? () {}
                        : () {
                            control.animateTo(0,
                                duration: Duration(seconds: 2),
                                curve: Curves.bounceIn);

                            setState(() {
                              index++;
                            });
                          }
                // }
                ,
                child: Text(
                  index == length - 1 ? 'REVIEW' : 'NEXT',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                )),
            // : FlatButton(
            //     // padding: EdgeInsets.all(11),
            //     onPressed: () {

            //     },
            //     child: Text(
            //       ,
            //       style: TextStyle(
            //           fontSize: 21, fontWeight: FontWeight.w600),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: control,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (index == 0)
                Container(
                  width: double.infinity,
                  height: 280,
                  child: Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.TitleImage),
                  ),
                )
              else
                Container(),
              if (index == 0)
                SizedBox(
                  height: 5,
                )
              else
                SizedBox(
                  height: 50,
                ),
              if (index == 0)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('GeoEnginring : A Boon Or A Curse For Humanity',
                      strutStyle:
                          StrutStyle(forceStrutHeight: true, height: 2.334),
                      style: GoogleFonts.newsCycle(
                          wordSpacing: 2,
                          fontSize: 25,
                          fontWeight: FontWeight.w600)),
                )
              else
                Container(),
              if (index == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('~ By ${widget.Author}',
                        style: GoogleFonts.abel(
                            // letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                            fontSize: 19)),
                    SizedBox(
                      width: 3,
                    )
                  ],
                )
              else
                Container(),
              if (index == 0) SizedBox(height: 20) else Container(),

              // Container(
              //   height: 733,
              //   width: 360,
              //   child: ZefyrView(document: document)),

              Padding(
                padding: const EdgeInsets.all(8.0),
                // child: HtmlWidget(
                //   Story,
                //   textStyle: GoogleFonts.openSans(
                //       fontSize: 16, fontWeight: FontWeight.w600),
                // ),
              ),
              SizedBox(
                height: 15,
              ),
              if (index == widget.Story.length - 1)
                Column(
                  children: [
                    SizedBox(height: 18),
                    Center(
                        child: Text(
                      '  THE END  ',
                      style: GoogleFonts.architectsDaughter(fontSize: 28),
                    )),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(widget.StoryUserPhoto),
                            radius: 44),
                        Column(
                          children: [Text(widget.Author), Text('data')],
                        )
                      ],
                    )
                  ],
                )
              else
                Container(),
              SizedBox(height: 15),
              if (AdFree == true) Container() else ConditionalAd(),
              SizedBox(height: 25),

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              // CircleAvatar(
              //   backgroundImage: NetworkImage(UserPhoto),
              //   radius: 45,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width/1.5,
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       hintText: 'Add Your Comment',
              //     ),
              //     onChanged: (value) {
              //       Comment = value;
              //     },
              //   ),
              // ),
              // GestureDetector(
              //   child: Icon(Icons.send),
              //   onTap: () {
              //     if (Comment == null) {
              //     } else {
              //       Comments.add(Comment);
              //       firestore
              //           .collection('Stories')
              //           .doc(widget.DocID)
              //           .collection('Comments')
              //           .doc('Comments')
              //           .update({
              //         'Comments': FieldValue.arrayUnion([Comment])
              //       });
              //       Comment = '';
              //     }
              //   },
              // ),
              //   ],
              // ),
              // Comments.length >= 1
              //     ? Container(
              //         height: 250,
              //         child: ListView.builder(
              //           itemCount: Comments.length,
              //           itemBuilder: (BuildContext context, int index) {
              //             return Column(
              //               crossAxisAlignment: CrossAxisAlignment.end,
              //               children: [
              //                 PopupMenuButton(
              //                     itemBuilder: (context) => [
              //                           PopupMenuItem(
              //                               value: 1,
              //                               child: GestureDetector(
              //                                 child: Row(
              //                                   children: [
              //                                     Icon(Icons.delete),
              //                                     Text('Delete')
              //                                   ],
              //                                 ),
              //                                 onTap: () {},
              //                               )),
              //                           PopupMenuItem(
              //                               value: 2,
              //                               child: GestureDetector(
              //                                 child: Row(
              //                                   children: [
              //                                     Icon(Icons.edit),
              //                                     Text('Edit')
              //                                   ],
              //                                 ),
              //                                 onTap: () {},
              //                               )),
              //                         ]),
              //                 Row(
              //                   children: [
              //                     Text(Comments[index]),
              //                     Spacer(),
              //                   ],
              //                 ),
              //               ],
              //             );
              //           },
              //         ),
              //       )
              //     : Container(),
              // SizedBox(height: 58),
              // FlatButton(
              //   onPressed: () {
              //     print(CommentsOfStory.asMap()[0]);
              //     print(CommentsOfStory.asMap().length);
              //   },
              //   child: Text('HERE'),
              //   padding: EdgeInsets.all(150),
              // ),
              // CommentsOfStory.asMap()[0] != null
              // ?
              // Container(
              //   height: 250,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: CommentsOfStory.asMap().length,
              //     itemBuilder: (BuildContext context, int indexNO) {
              //       print(CommentsOfStory.asMap()[0]);

              //       if (indexNO == 0) {
              //         return Text("Hello");
              //       }
              //       return Container(
              //         height: 50,
              //         child: Row(
              //           children: [
              //             Text(CommentsOfStory.asMap()[indexNO]),
              //             // Spacer(),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              // : Container(),
              // SizedBox(height: 158),
            ],
          ),
        ),
      ),
    );
  }

  CommmentsFromFirestore() async {
    // DocumentSnapshot data1 =
    //     await firestore.collection('Users').doc(UserID).get();
    // AdFree = data1.data()['AdFree'];
    // FiftyPercentAdFree = data1.data()['50%AdFree'];
    print('Doc : :: : :: : : : :: : : : :  ${widget.DocID}');
    DocumentSnapshot data = await firestore
        .collection('Stories')
        .doc(widget.DocID.trim())
        .collection('Comments')
        .doc('Comments')
        .get();
    CommentsOfStory = data.data()['Comments'];
  }
}

Widget ConditionalAd() {
  return FiftyPercentAdFree == false
      ? NormalAd()
      : index != 0
          ? index % 1 == 0
              ? NormalAd()
              : Container()
          : Container();
}

Widget NormalAd() {
  return Container(
    height: 340,
    width: double.infinity,
    child: Card(
      child: NativeAdmob(
        type: NativeAdmobType.full,
        options: NativeAdmobOptions(
            storeTextStyle: NativeTextStyle(color: Colors.green),
            callToActionStyle: NativeTextStyle(backgroundColor: Colors.green),
            headlineTextStyle: NativeTextStyle(fontSize: 19),
            bodyTextStyle: NativeTextStyle(fontSize: 22),
            advertiserTextStyle: NativeTextStyle(fontSize: 20)),
        adUnitID: adUnitID,
        controller: controller,
      ),
    ),
  );
}
