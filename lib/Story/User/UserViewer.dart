import 'package:Kahani_App/Story/Story/StoryRead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import 'AllPosts.dart';

CollectionReference stories = firestore.collection('Stories');

CollectionReference follow;
var Viewers;
int AverageTime;
bool ChatEnabled;

class UserViewer extends StatefulWidget {
  UserViewer(
      {this.UserEmail,
      this.UserID,
      this.UserName,
      this.UserPhoto,
      this.StoryUserID,
      this.StoryUserName,
      this.StoryUserPhoto});

  /// DETAILS OF USER WHOSE PROFILE YOU ARE SEEING
  final String StoryUserID;
  final String StoryUserName;
  final String StoryUserPhoto;
  final String UserEmail;
  final String UserID;
  final String UserName;
  final String UserPhoto;

  @override
  _UserViewerState createState() => _UserViewerState();
}

class _UserViewerState extends State<UserViewer> {
  int AverageTime; //*IN SECONDS
  var follower;
  String FollowText = 'Follow';
  int NoOfFollowers;
  String UserEmail;
  String UserID;
  String UserName;
  String UserPhoto;
  String Bio;
  @override
  void initState() {
    super.initState();

    // follow = firestore
    //     .collection('Users')
    //     .doc(widget.StoryUserID)
    //     .collection('Followers');
    LoadUserData();

    firestore
        .collection('Users')
        .doc(widget.StoryUserID)
        .get()
        .then((value) async {
      int NoOfFollowers2 = await value.data()['Followers'];
      String bio = await value.data()['bio'];
      setState(() {
        NoOfFollowers = NoOfFollowers2;
        Bio = bio;
      });
    });
    firestore
        .collection('Users')
        .doc(widget.StoryUserID)
        .collection('Followers')
        .doc(UserID)
        .get()
        .then((value) {
      if (value.exists == false) {
        setState(() {
          FollowText = 'Follow';
        });
      }
      if (value.exists == true) {
        setState(() {
          FollowText = 'Following';
        });
      }
    });
  }

  ChangeText() {
    if (FollowText == 'Following') {
      setState(() {
        FollowText = 'Follow';
      });
    } else {
      setState(() {
        FollowText = 'Following';
      });
    }
  }

  Future<QuerySnapshot> LoadPopular() async {
    return await firestore
        .collection('Story')
        .where('UserID', isEqualTo: 'TBBLwUBwOVYRpPH4b4oL1Edi35a2')
        .orderBy('Views', descending: true)
        // .limit(10)
        .get();
  }

  Future<QuerySnapshot> LoadRecent() async {
    return await firestore
        .collection('Story')
        .where('UserID', isEqualTo: 'TBBLwUBwOVYRpPH4b4oL1Edi35a2')
        // .limit(10)
        .get();
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  // ChatEnabling() async {
  //   DocumentSnapshot chatenable =
  //       await firestore.collection('Users').doc(UserID).get();
  //   ChatEnabled = chatenable.data()['ChatEnabled'];
  // }

  @override
  Widget build(BuildContext context) {
    String Views;
    String FollowersCount = '100M';
    List Description;
    int Rating;
    String Title;
    if (NoOfFollowers != null) {
      FollowersCount = NumberFormat.compactCurrency(
        decimalDigits: 0,
        symbol:
            '', // if you want to add currency symbol then pass that in this else leave it empty.
      ).format(NoOfFollowers);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait([
              LoadRecent(),
              LoadPopular(),
            ]),
            builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
              double height = MediaQuery.of(context).size.height;
              if (snapshot.connectionState == ConnectionState.done) {
                // print(snapshot.data[2].docs[0].data()['TitlePhoto']);
                return SingleChildScrollView(
                  child: Container(
                    height: height,
                    child: ListView.builder(
                      itemCount: 1,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          child: Container(
                            height: height,
                            child: SingleChildScrollView(
                              child: Column(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(9),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              widget.StoryUserPhoto),
                                        ),
                                        SizedBox(width: 5),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 24),
                                            Container(
                                              child: Text(
                                                widget.StoryUserName,
                                                style: TextStyle(fontSize: 20),
                                                softWrap: true,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    '$FollowersCount Followers'),
                                                SizedBox(width: 5),
                                                FlatButton(
                                                  color: Colors.grey[200],
                                                  padding: EdgeInsets.all(8),
                                                  onPressed: () async {
                                                    if (FollowText ==
                                                        'Following') {
                                                      await firestore
                                                          .collection('Users')
                                                          .doc(UserID)
                                                          .collection(
                                                              'Following')
                                                          .doc(widget
                                                              .StoryUserID)
                                                          .delete();
                                                      follow
                                                          .doc(UserID)
                                                          .delete()
                                                          .then((value) {
                                                        ChangeText();
                                                      });
                                                      follow
                                                          .doc(widget
                                                              .StoryUserID)
                                                          .get()
                                                          .then((value) {
                                                        int Followers = value
                                                                    .data()[
                                                                'Followers'] -
                                                            1;
                                                        follow
                                                            .doc(widget
                                                                .StoryUserID)
                                                            .update({
                                                          'Followers': Followers
                                                        });
                                                      });
                                                    } else {
                                                      await firestore
                                                          .collection('Users')
                                                          .doc(UserID)
                                                          .collection(
                                                              'Following')
                                                          .doc(widget
                                                              .StoryUserID)
                                                          .set({
                                                        'UserID':
                                                            widget.StoryUserID
                                                      });
                                                      follow.doc(UserID).set({
                                                        'UserID': UserID
                                                      }).then((value) =>
                                                          ChangeText());
                                                      follow
                                                          .doc(widget
                                                              .StoryUserID)
                                                          .update({
                                                        'Followers': FieldValue
                                                            .increment(1)
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    '$FollowText',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        PopupMenuButton<int>(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Text(
                                                  'More About ${widget.StoryUserName}'),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Text(
                                                  "Some Stats of The Channel"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.all(7),
                                  //   child: Row(
                                  //     children: [
                                  //       Column(
                                  //         children: [
                                  //           Card(
                                  //                                                         child: Container(
                                  //               decoration: BoxDecoration(
                                  //                   image: DecorationImage(
                                  //                       image: NetworkImage(
                                  //                           snapshot.data[2]
                                  //                                   .docs[0]
                                  //                                   .data()[
                                  //                               'TitleImage']),
                                  //                       fit: BoxFit.fill)),
                                  //               height: 160,
                                  //               width: 180,
                                  //             ),
                                  //           ),
                                  //           Card(
                                  //                                                         child: Container(
                                  //                 child: Text(snapshot
                                  //                     .data[2].docs[0]
                                  //                     .data()['Title'])),
                                  //           )
                                  //         ],
                                  //       ),
                                  //       Container(
                                  //           width: MediaQuery.of(context)
                                  //                   .size
                                  //                   .width -
                                  //               194,
                                  //           child: Text(
                                  //             Bio,
                                  //             softWrap: true,
                                  //           )),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 13, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Recent Posts ",
                                          style: GoogleFonts.robotoCondensed(
                                              fontSize: 24),
                                        ),
                                        Spacer(),
                                        snapshot.data[1].docs.isEmpty
                                            ? Container()
                                            : GestureDetector(
                                                child: Icon(Icons
                                                    .arrow_forward_ios_sharp),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AllPosts(
                                                                future:
                                                                    AllRecent(),
                                                                UserEmail:
                                                                    UserEmail,
                                                                UserPhoto:
                                                                    UserPhoto,
                                                                UserID: UserID,
                                                                UserName:
                                                                    UserName,
                                                                StoryUserID: widget
                                                                    .StoryUserID,
                                                                StoryUserName:
                                                                    widget
                                                                        .StoryUserName,
                                                                StoryUserPhoto:
                                                                    widget
                                                                        .StoryUserPhoto,
                                                                AllPosts1:
                                                                    false,
                                                              )));
                                                },
                                              )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 29),
                                  snapshot.data[0].docs.isEmpty
                                      ? Text('No Posts Yet')
                                      : Container(
                                          height: 375,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              print(snapshot);
                                              double Rating = snapshot
                                                  .data[0].docs[index]
                                                  .get('Rating');
                                              print(
                                                  'RATING :::: : : ::::: ::: :::::: ::: ::::: :::: :::: : $Rating');
                                              String Views =
                                                  NumberFormat.compactCurrency(
                                                decimalDigits: 0,
                                                symbol:
                                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                                              ).format(snapshot
                                                      .data[0].docs[index]
                                                      .data()['Views']);
                                              AverageTime = snapshot
                                                  .data[0].docs[index]
                                                  .data()['Average Time'];
                                              List Description = snapshot
                                                  .data[0].docs[index]
                                                  .data()['Description'];

                                              return FlatButton(
                                                onPressed: () async {
                                                  String Story = snapshot
                                                      .data[0].docs[index]
                                                      .data()['Story'];

                                                  DocumentReference doc =
                                                      stories.doc(snapshot
                                                          .data[0]
                                                          .docs[index]
                                                          .id);
                                                  String doc2 = doc.id;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          StoryRead(
                                                        TitleImage: snapshot
                                                                .data[0]
                                                                .docs[index]
                                                                .data()[
                                                            'TitleImage'],
                                                        StoryUserPhoto: snapshot
                                                                .data[0]
                                                                .docs[index]
                                                                .data()[
                                                            'UserPhoto'],
                                                        DocID: doc2,
                                                        Title: snapshot
                                                            .data[0].docs[index]
                                                            .data()['Title']
                                                            .toString(),
                                                        Author: snapshot
                                                            .data[0].docs[index]
                                                            .data()['UserName']
                                                            .toString(),
                                                        Story: Story.split(
                                                            '< NEW PART BEGINS >'),
                                                        Characters: snapshot
                                                                .data[0]
                                                                .docs[index]
                                                                .data()[
                                                            'Characters'],
                                                        StoryUserID: snapshot
                                                            .data[0].docs[index]
                                                            .data()['UserID'],
                                                      ),
                                                    ),
                                                  );
                                                  DocumentSnapshot viewers =
                                                      await firestore
                                                          .collection('Stories')
                                                          .doc(doc2)
                                                          .collection(
                                                              'UsersViewed')
                                                          .doc(UserID)
                                                          .get();

                                                  // setState(() {
                                                  //   Viewers = viewers;
                                                  // });

                                                  if (viewers.exists == false) {
                                                    firestore.runTransaction(
                                                        (transaction) async {
                                                      // Get the document

                                                      DocumentSnapshot
                                                          snapshot =
                                                          await transaction
                                                              .get(doc);

                                                      if (!snapshot.exists) {
                                                        throw Exception(
                                                            "User does not exist!");
                                                      }

                                                      // Update the follower count based on the current count
                                                      int views = snapshot
                                                              .data()['Views'] +
                                                          1;

                                                      // Perform an update on the document
                                                      transaction.update(doc,
                                                          {'Views': views});
                                                    }).then((value) => () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Stories')
                                                              .doc(doc2)
                                                              .collection(
                                                                  'UsersViewed')
                                                              .doc(UserID)
                                                              .set({
                                                            'UserID': UserID,
                                                            'Attempted': true,
                                                            "Completed": false,
                                                            "Time":
                                                                DateTime.now()
                                                          });
                                                        });
                                                  }
                                                },
                                                child: Card(
                                                  margin: EdgeInsets.all(0),
                                                  child: Container(
                                                    height: 452,
                                                    width: 252,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 175,
                                                          width: 252,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      snapshot
                                                                          .data[
                                                                              0]
                                                                          .docs[
                                                                              index]
                                                                          .data()['TitleImage'],
                                                                    ),
                                                                    fit: BoxFit
                                                                        .fill),
                                                          ),
                                                        ),
                                                        SizedBox(height: 7),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8),
                                                          child: Text(
                                                              snapshot.data[0]
                                                                      .docs[index]
                                                                      .data()[
                                                                  'Title'],
                                                              style: GoogleFonts
                                                                  .ptSansNarrow(
                                                                      fontSize:
                                                                          19,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                        ),
                                                        SizedBox(height: 3.5),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8),
                                                          child: Row(
                                                            // mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '$Views Views',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Ebrima',
                                                                    color: Color(
                                                                        0xff707070),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                  )),
                                                              Spacer(),
                                                              Text(
                                                                  '5 mins read',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Ebrima',
                                                                    color: Color(
                                                                        0xff707070),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                  )),
                                                              Spacer(),
                                                              Row(
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                children: [
                                                                  Text(
                                                                      '$Rating',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Ebrima',
                                                                        color: Color(
                                                                            0xff707070),
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                      )),
                                                                  Icon(Icons
                                                                      .star_rate_rounded),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4.5,
                                                                    bottom: 3,
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Text(
                                                                Description
                                                                    .join(' '),
                                                                style: GoogleFonts.ptSerif(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: snapshot.data[0].size,
                                          ),
                                        ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 13, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Popular Posts ",
                                          style: GoogleFonts.robotoCondensed(
                                              fontSize: 24),
                                        ),
                                        Spacer(),
                                        snapshot.data[1].docs.isEmpty
                                            ? Container()
                                            : GestureDetector(
                                                child: Icon(Icons
                                                    .arrow_forward_ios_sharp),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AllPosts(
                                                                future:
                                                                    AllPopular(),
                                                                UserEmail:
                                                                    UserEmail,
                                                                UserPhoto:
                                                                    UserPhoto,
                                                                UserID: UserID,
                                                                UserName:
                                                                    UserName,
                                                                StoryUserID: widget
                                                                    .StoryUserID,
                                                                StoryUserName:
                                                                    widget
                                                                        .StoryUserName,
                                                                StoryUserPhoto:
                                                                    widget
                                                                        .StoryUserPhoto,
                                                              )));
                                                },
                                              )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  snapshot.data[1].docs.isEmpty
                                      ? Text('Nothing Here')
                                      : Container(
                                          height: 410,
                                          child: ListView.builder(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              int Rating = snapshot
                                                  .data[1].docs[index]
                                                  .data()['Rating'];
                                              String Views =
                                                  NumberFormat.compactCurrency(
                                                decimalDigits: 0,
                                                symbol:
                                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                                              ).format(snapshot
                                                      .data[1].docs[index]
                                                      .data()['Views']);
                                              AverageTime = snapshot
                                                  .data[1].docs[index]
                                                  .data()['Average Time'];
                                              List Description = snapshot
                                                  .data[1].docs[index]
                                                  .data()['Description'];
                                              return FlatButton(
                                                onPressed: () async {
                                                  String Story = snapshot
                                                      .data[1].docs[index]
                                                      .data()['Story'];

                                                  DocumentReference doc =
                                                      stories.doc(snapshot
                                                          .data[1]
                                                          .docs[index]
                                                          .id);
                                                  String doc2 = doc.id;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          StoryRead(
                                                        TitleImage: snapshot
                                                                .data[1]
                                                                .docs[index]
                                                                .data()[
                                                            'TitleImage'],
                                                        StoryUserPhoto: snapshot
                                                                .data[1]
                                                                .docs[index]
                                                                .data()[
                                                            'UserPhoto'],
                                                        DocID: doc2,
                                                        Title: snapshot
                                                            .data[1].docs[index]
                                                            .data()['Title']
                                                            .toString(),
                                                        Author: snapshot
                                                            .data[1].docs[index]
                                                            .data()['UserName']
                                                            .toString(),
                                                        Story: Story.split(
                                                            '< NEW PART BEGINS >'),
                                                        Characters: snapshot
                                                                .data[1]
                                                                .docs[index]
                                                                .data()[
                                                            'Characters'],
                                                        StoryUserID: snapshot
                                                            .data[1].docs[index]
                                                            .data()['UserID'],
                                                      ),
                                                    ),
                                                  );
                                                  DocumentSnapshot viewers =
                                                      await firestore
                                                          .collection('Stories')
                                                          .doc(doc2)
                                                          .collection(
                                                              'UsersViewed')
                                                          .doc(UserID)
                                                          .get();

                                                  // setState(() {
                                                  //   Viewers = viewers;
                                                  // });

                                                  if (viewers.exists == false) {
                                                    firestore.runTransaction(
                                                        (transaction) async {
                                                      // Get the document

                                                      DocumentSnapshot
                                                          snapshot =
                                                          await transaction
                                                              .get(doc);

                                                      if (!snapshot.exists) {
                                                        throw Exception(
                                                            "User does not exist!");
                                                      }

                                                      // Update the follower count based on the current count
                                                      int views = snapshot
                                                              .data()['Views'] +
                                                          1;

                                                      // Perform an update on the document
                                                      transaction.update(doc,
                                                          {'Views': views});
                                                    }).then((value) => () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Stories')
                                                              .doc(doc2)
                                                              .collection(
                                                                  'UsersViewed')
                                                              .doc(UserID)
                                                              .set({
                                                            'UserID': UserID,
                                                            'Attempted': true,
                                                            "Completed": false,
                                                            "Time":
                                                                DateTime.now()
                                                          });
                                                        });
                                                  }
                                                },
                                                child: Card(
                                                  margin: EdgeInsets.all(0),
                                                  child: Container(
                                                    height: 452,
                                                    width: 252,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 175,
                                                          width: 252,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      snapshot
                                                                          .data[
                                                                              0]
                                                                          .docs[
                                                                              index]
                                                                          .data()['TitleImage'],
                                                                    ),
                                                                    fit: BoxFit
                                                                        .fill),
                                                          ),
                                                        ),
                                                        SizedBox(height: 7),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8),
                                                          child: Text(
                                                              snapshot.data[0]
                                                                      .docs[index]
                                                                      .data()[
                                                                  'Title'],
                                                              style: GoogleFonts
                                                                  .ptSansNarrow(
                                                                      fontSize:
                                                                          19,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8),
                                                          child: Row(
                                                            // mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '$Views Views',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Ebrima',
                                                                    color: Color(
                                                                        0xff707070),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                  )),
                                                              Spacer(),
                                                              Text(
                                                                  '5 mins read',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Ebrima',
                                                                    color: Color(
                                                                        0xff707070),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                  )),
                                                              Spacer(),
                                                              Row(
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                children: [
                                                                  Text(
                                                                      '$Rating',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Ebrima',
                                                                        color: Color(
                                                                            0xff707070),
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                      )),
                                                                  Icon(Icons
                                                                      .star_rate_rounded),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    bottom: 4,
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Text(
                                                                Description
                                                                    .join(' '),
                                                                style: GoogleFonts.ptSerif(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount:
                                                snapshot.data[1].docs.length,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Text("No data");
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> AllRecent() async {
    return await firestore
        .collection('Stories')
        .where('UserID', isEqualTo: widget.StoryUserID)
        .get();
  }

  Future<QuerySnapshot> AllPopular() async {
    return await firestore
        .collection('Stories')
        .where('UserID', isEqualTo: widget.StoryUserID)
        .orderBy('Views', descending: true)
        .get();
  }
}
