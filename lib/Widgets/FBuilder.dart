import 'package:Kahani_App/Story/Story/StoryDetails.dart';
import 'package:Kahani_App/Story/Story/StoryRead.dart';
import 'package:Kahani_App/Story/User/UserViewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:string_splitter/string_splitter.dart';
import '../main.dart';

LegendaryStories(
    Future<QuerySnapshot> LoadUsers(),
    Future<QuerySnapshot> TrendingStories(String tag),
    Future<QuerySnapshot> LoadStories(),
    List theTwoTags,
    String UserID,
    String UserName,
    String UserEmail,
    String UserPhoto) {
  return FutureBuilder(
    future: Future.wait([
      LoadUsers(),
      TrendingStories(theTwoTags[0]),
      TrendingStories(theTwoTags[1]),
      LoadStories()
    ]),
    builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR5UBGY6fBIId1t09h2G3XChabb2XaNS7BeGA&usqp=CAU'),
                  fit: BoxFit.fill)),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: 1,
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            itemBuilder: (BuildContext context, int index) {
              double height = (270 * snapshot.data[3].docs.length).toDouble();
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'People To Follow',
                        style: GoogleFonts.robotoCondensed(fontSize: 22),
                      ),
                      SizedBox(height: 0),
                      Container(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            String FollowersCount =
                                NumberFormat.compactCurrency(
                              decimalDigits: 0,
                              symbol:
                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(snapshot.data[0].docs[index]
                                    .data()['Followers']);
                            return Container(
                              child: Column(
                                children: [
                                  Container(height: 20),
                                  Container(
                                    height: 120,
                                    width: 100,
                                    child: Column(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserViewer(
                                                  StoryUserID: snapshot
                                                      .data[0].docs[index]
                                                      .data()['UserID'],
                                                  StoryUserName: snapshot
                                                      .data[0].docs[index]
                                                      .data()['UserName'],
                                                  StoryUserPhoto: snapshot
                                                      .data[0].docs[index]
                                                      .data()['UserPhoto'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 33,
                                            backgroundImage: NetworkImage(
                                              snapshot.data[0].docs[index]
                                                  .data()['UserPhoto'],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            snapshot.data[0].docs[index]
                                                .data()['UserName'],
                                            style: GoogleFonts.merriweather(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Center(
                                          child: Text(
                                            '$FollowersCount Followers',
                                            style: GoogleFonts.sourceSansPro(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: snapshot.data[0].docs.length,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.only(left: 13, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Popular ${theTwoTags[1]} Stories",
                              style: GoogleFonts.robotoCondensed(fontSize: 24),
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Icon(Icons.arrow_forward_ios_sharp),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             AllPosts(
                                //               future: AllRecent(),
                                //               UserEmail: UserEmail,
                                //               UserPhoto: UserPhoto,
                                //               UserID: UserID,
                                //               UserName: UserName,
                                //               StoryUserID:
                                //                   StoryUserID,
                                //               StoryUserName:
                                //                   StoryUserName,
                                //               StoryUserPhoto:
                                //                   StoryUserPhoto,
                                //             )));
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 21),
                      Container(
                        height: 433,
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            String Title =
                                snapshot.data[1].docs[index].data()['Title'];
                            double Rating =
                                snapshot.data[1].docs[index].data()['Rating'];
                            String Views = NumberFormat.compactCurrency(
                              decimalDigits: 0,
                              symbol:
                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(
                                snapshot.data[1].docs[index].data()['Views']);
                            int AverageTime = snapshot.data[1].docs[index]
                                .data()['Average Time'];
                            List Description = snapshot.data[1].docs[index]
                                .data()['Description'];
                            return TextButton(
                              onPressed: () async {
                                String Story = snapshot.data[1].docs[index]
                                    .data()['Story'];
                                List<String> parts =
                                    StringSplitter.chunk(Story, 2500);
                                DocumentReference doc = stories
                                    .doc(snapshot.data[1].docs[index].id);
                                String doc2 = doc.id;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryDetails(
                                      TitleImage: snapshot.data[1].docs[index]
                                          .data()['TitleImage'],
                                      // StoryUserPhoto: snapshot
                                      //     .data[1].docs[index]
                                      //     .data()['UserPhoto'],
                                      DocID: doc2,
                                      Title: snapshot.data[1].docs[index]
                                          .data()['Title']
                                          .toString(),
                                      StoryUserName: snapshot
                                          .data[1].docs[index]
                                          .data()['UserName']
                                          .toString(),
                                      Description: Description.join(' '),
                                      Story: Story,
                                      StoryUsePhoto: snapshot
                                          .data[1].docs[index]
                                          .data()['UserPhoto'],
                                      // Characters: snapshot.data[1].docs[index]
                                      // .data()['Characters'],
                                      StoryUserID: snapshot.data[1].docs[index]
                                          .data()['UserID'],
                                    ),
                                  ),
                                );
                                DocumentSnapshot viewers = await firestore
                                    .collection('Stories')
                                    .doc(doc2)
                                    .collection('UsersViewed')
                                    .doc(UserID)
                                    .get();

                                // setState(() {
                                //   Viewers = viewers;
                                // });

                                if (viewers.exists == false) {
                                  firestore.runTransaction((transaction) async {
                                    // Get the document

                                    DocumentSnapshot snapshot =
                                        await transaction.get(doc);

                                    if (!snapshot.exists) {
                                      throw Exception("User does not exist!");
                                    }

                                    // Update the follower count based on the current count
                                    int views = snapshot.data()['Views'] + 1;

                                    // Perform an update on the document
                                    transaction.update(doc, {'Views': views});
                                  }).then((value) => () {
                                        firestore
                                            .collection('Stories')
                                            .doc(doc2)
                                            .collection('UsersViewed')
                                            .doc(UserID)
                                            .set({
                                          'UserID': UserID,
                                          'Attempted': true,
                                          "Completed": false,
                                          "Time": DateTime.now()
                                        });
                                      });
                                }
                              },
                              child: Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                  height: 383,
                                  width: 252,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 175,
                                        width: 252,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                snapshot.data[1].docs[index]
                                                    .data()['TitleImage'],
                                              ),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                            snapshot.data[1].docs[index]
                                                .data()['Title'],
                                            style: GoogleFonts.ptSansNarrow(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      SizedBox(height: 2),
                                      // Padding(
                                      //   padding:
                                      //       EdgeInsets.only(left: 8, right: 8),
                                      //   child: Row(
                                      //     // mainAxisSize: MainAxisSize.min,
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     children: [
                                      //       Text('$Views Views',
                                      //           style: TextStyle(
                                      //             fontFamily: 'Ebrima',
                                      //             color: Color(0xff707070),
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w400,
                                      //             fontStyle: FontStyle.normal,
                                      //           )),
                                      //       Spacer(),
                                      //       Text('5 mins read',
                                      //           style: TextStyle(
                                      //             fontFamily: 'Ebrima',
                                      //             color: Color(0xff707070),
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w400,
                                      //             fontStyle: FontStyle.normal,
                                      //           )),
                                      //       Spacer(),
                                      //       Row(
                                      //         textBaseline:
                                      //             TextBaseline.ideographic,
                                      //         children: [
                                      //           Text('$Rating',
                                      //               style: TextStyle(
                                      //                 fontFamily: 'Ebrima',
                                      //                 color: Color(0xff707070),
                                      //                 fontSize: 16,
                                      //                 fontWeight:
                                      //                     FontWeight.w400,
                                      //                 fontStyle:
                                      //                     FontStyle.normal,
                                      //               )),
                                      //           Icon(Icons.star_rate_rounded),
                                      //         ],
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                      Container(
                                        // height: 123,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 3,
                                              bottom: 3,
                                              left: 8,
                                              right: 8),
                                          child: Text(
                                            Description.join(' '),
                                            maxLines: Title.length > 34 ? 5 : 6,
                                            style: GoogleFonts.ptSerif(
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Spacer(),
                                          // Column(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.center,
                                          //   children: [
                                          //     Text(
                                          //         "${snapshot.data[1].docs[index].data()['UserName']}"),
                                          //   ],
                                          // ),
                                          SizedBox(width: 5),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserViewer(
                                                      UserPhoto: UserPhoto,
                                                      StoryUserID: snapshot
                                                          .data[1].docs[index]
                                                          .data()['UserID'],
                                                      StoryUserName: snapshot
                                                          .data[1].docs[index]
                                                          .data()['UserName'],
                                                      StoryUserPhoto: snapshot
                                                          .data[1].docs[index]
                                                          .data()['UserPhoto'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            snapshot.data[1]
                                                                    .docs[index]
                                                                    .data()[
                                                                'UserPhoto']),
                                                        fit: BoxFit.fill)),
                                              ),
                                              // CircleAvatar(
                                              //   backgroundImage: NetworkImage(
                                              //       snapshot.data[1].docs[index]
                                              //           .data()['UserPhoto']),
                                              //   radius: 25,
                                              // ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            '$UserName',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: snapshot.data[1].docs.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      SizedBox(height: 22),
                      Padding(
                        padding: EdgeInsets.only(left: 13, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Popular ${theTwoTags[1]} Stories',
                              style: GoogleFonts.robotoCondensed(fontSize: 24),
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Icon(Icons.arrow_forward_ios_sharp),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             AllPosts(
                                //               future: AllRecent(),
                                //               UserEmail: UserEmail,
                                //               UserPhoto: UserPhoto,
                                //               UserID: UserID,
                                //               UserName: UserName,
                                //               StoryUserID:
                                //                   StoryUserID,
                                //               StoryUserName:
                                //                   StoryUserName,
                                //               StoryUserPhoto:
                                //                   StoryUserPhoto,
                                //             )));
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 29),
                      Container(
                        height: 433,
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            int Rating =
                                snapshot.data[2].docs[index].data()['Rating'];
                            String Views = NumberFormat.compactCurrency(
                              decimalDigits: 0,
                              symbol:
                                  '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(
                                snapshot.data[2].docs[index].data()['Views']);
                            AverageTime = snapshot.data[2].docs[index]
                                .data()['Average Time'];
                            List Description = snapshot.data[2].docs[index]
                                .data()['Description'];
                            String Title =
                                snapshot.data[2].docs[index].data()['Title'];
                            return TextButton(
                              onPressed: () async {
                                String Story = snapshot.data[2].docs[index]
                                    .data()['Story'];

                                DocumentReference doc = stories
                                    .doc(snapshot.data[2].docs[index].id);
                                String doc2 = doc.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryRead(
                                      TitleImage: snapshot.data[2].docs[index]
                                          .data()['TitleImage'],
                                      StoryUserPhoto: snapshot
                                          .data[2].docs[index]
                                          .data()['UserPhoto'],
                                      DocID: doc2,
                                      Title: snapshot.data[2].docs[index]
                                          .data()['Title']
                                          .toString(),
                                      Author: snapshot.data[2].docs[index]
                                          .data()['UserName']
                                          .toString(),
                                      Story: Story.split('< NEW PART BEGINS >'),
                                      Characters: snapshot.data[2].docs[index]
                                          .data()['Characters'],
                                      StoryUserID: snapshot.data[2].docs[index]
                                          .data()['UserID'],
                                    ),
                                  ),
                                );
                                DocumentSnapshot viewers = await firestore
                                    .collection('Stories')
                                    .doc(doc2)
                                    .collection('UsersViewed')
                                    .doc(UserID)
                                    .get();

                                // setState(() {
                                //   Viewers = viewers;
                                // });

                                if (viewers.exists == false) {
                                  firestore.runTransaction((transaction) async {
                                    // Get the document

                                    DocumentSnapshot snapshot =
                                        await transaction.get(doc);

                                    if (!snapshot.exists) {
                                      throw Exception("User does not exist!");
                                    }

                                    // Update the follower count based on the current count
                                    int views = snapshot.data()['Views'] + 1;

                                    // Perform an update on the document
                                    transaction.update(doc, {'Views': views});
                                  }).then((value) => () {
                                        firestore
                                            .collection('Stories')
                                            .doc(doc2)
                                            .collection('UsersViewed')
                                            .doc(UserID)
                                            .set({
                                          'UserID': UserID,
                                          'Attempted': true,
                                          "Completed": false,
                                          "Time": DateTime.now()
                                        });
                                      });
                                }
                              },
                              child: Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                  height: 383,
                                  width: 252,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 175,
                                        width: 252,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                snapshot.data[2].docs[index]
                                                    .data()['TitleImage'],
                                              ),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                            snapshot.data[2].docs[index]
                                                .data()['Title'],
                                            style: GoogleFonts.ptSansNarrow(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      SizedBox(height: 2),
                                      // Padding(
                                      //   padding:
                                      //       EdgeInsets.only(left: 8, right: 8),
                                      //   child: Row(
                                      //     // mainAxisSize: MainAxisSize.min,
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     children: [
                                      //       Text('$Views Views',
                                      //           style: TextStyle(
                                      //             fontFamily: 'Ebrima',
                                      //             color: Color(0xff707070),
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w400,
                                      //             fontStyle: FontStyle.normal,
                                      //           )),
                                      //       Spacer(),
                                      //       Text('5 mins read',
                                      //           style: TextStyle(
                                      //             fontFamily: 'Ebrima',
                                      //             color: Color(0xff707070),
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w400,
                                      //             fontStyle: FontStyle.normal,
                                      //           )),
                                      //       Spacer(),
                                      //       Row(
                                      //         textBaseline:
                                      //             TextBaseline.ideographic,
                                      //         children: [
                                      //           Text('$Rating',
                                      //               style: TextStyle(
                                      //                 fontFamily: 'Ebrima',
                                      //                 color: Color(0xff707070),
                                      //                 fontSize: 16,
                                      //                 fontWeight:
                                      //                     FontWeight.w400,
                                      //                 fontStyle:
                                      //                     FontStyle.normal,
                                      //               )),
                                      //           Icon(Icons.star_rate_rounded),
                                      //         ],
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                      Container(
                                        // height: 123,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 3,
                                              bottom: 3,
                                              left: 8,
                                              right: 8),
                                          child: Text(
                                            Description.join(' '),
                                            maxLines: Title.length > 34 ? 5 : 6,
                                            style: GoogleFonts.ptSerif(
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  "${snapshot.data[2].docs[index].data()['UserName']}"),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserViewer(
                                                      UserName: UserName,
                                                      UserEmail: UserEmail,
                                                      UserID: UserID,
                                                      UserPhoto: UserPhoto,
                                                      StoryUserID: snapshot
                                                          .data[2].docs[index]
                                                          .data()['UserID'],
                                                      StoryUserName: snapshot
                                                          .data[2].docs[index]
                                                          .data()['UserName'],
                                                      StoryUserPhoto: snapshot
                                                          .data[2].docs[index]
                                                          .data()['UserPhoto'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data[2].docs[index]
                                                        .data()['UserPhoto']),
                                                radius: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: snapshot.data[2].docs.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Recommended For You',
                        style: GoogleFonts.robotoCondensed(fontSize: 22),
                      ),
                      SizedBox(height: 24),
                      // Container(
                      //   height: 2000,
                      //   child: ListView.builder(
                      //     primary: false,
                      //     shrinkWrap: true,
                      //     scrollDirection: Axis.vertical,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       String Title =
                      //           snapshot.data[3].docs[index].data()['Title'];
                      //       List Description = snapshot.data[3].docs[index]
                      //           .data()['Description'];
                      //       String StoryUserID =
                      //           snapshot.data[3].docs[index].data()['UserID'];
                      //       int Rating =
                      //           snapshot.data[3].docs[index].data()['Rating'];
                      //       String Views = NumberFormat.compactCurrency(
                      //         decimalDigits: 0,
                      //         symbol:
                      //             '', // if you want to add currency symbol then pass that in this else leave it empty.
                      //       ).format(
                      //           snapshot.data[3].docs[index].data()['Views']);

                      //       return GestureDetector(
                      //         // padding: EdgeInsets.all(0),
                      //         onTap: () async {
                      //           String Story = snapshot.data[3].docs[index]
                      //               .data()['Story'];

                      //           DocumentReference doc = stories
                      //               .doc(snapshot.data[3].docs[index].id);
                      //           String doc2 = doc.id;
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => StoryDetails(
                      //                 TitleImage: snapshot.data[3].docs[index]
                      //                     .data()['TitleImage'],
                      //                 DocID: doc2,
                      //                 Title: snapshot.data[3].docs[index]
                      //                     .data()['Title'],
                      //                 StoryUserName: snapshot
                      //                     .data[3].docs[index]
                      //                     .data()['UserName'],
                      //                 Story: Story,
                      //                 // Characters: snapshot.data[3].docs[index]
                      //                 // .data()['Characters'],
                      //                 StoryUserID: snapshot.data[3].docs[index]
                      //                     .data()['UserID'],
                      //                 StoryUserPhoto: snapshot
                      //                     .data[3].docs[index]
                      //                     .data()['UserPhoto'],
                      //               ),
                      //             ),
                      //           );
                      //           // DocumentSnapshot viewers = await firestore
                      //           //     .collection('Stories')
                      //           //     .doc(doc2)
                      //           //     .collection('UsersViewed')
                      //           //     .doc(UserID)
                      //           //     .get();

                      //           // if (viewers.exists == false) {
                      //           //   firestore.runTransaction((transaction) async {
                      //           //     // Get the document

                      //           //     DocumentSnapshot snapshot =
                      //           //         await transaction.get(doc);

                      //           //     if (!snapshot.exists) {
                      //           //       throw Exception("User does not exist!");
                      //           //     }

                      //           //     // Update the follower count based on the current count
                      //           //     int views = snapshot.data()['Views'] + 1;

                      //           //     // Perform an update on the document
                      //           //     transaction.update(doc, {'Views': views});
                      //           //   }).then((value) => () {
                      //           //         firestore
                      //           //             .collection('Stories')
                      //           //             .doc(doc2)
                      //           //             .collection('UsersViewed')
                      //           //             .doc(UserID)
                      //           //             .set({
                      //           //           'UserID': UserID,
                      //           //           'Attempted': true,
                      //           //           "Completed": false,
                      //           //           "Time": DateTime.now()
                      //           //         });
                      //           //       });
                      //           // }
                      //           // firestore
                      //           //     .collection('Users')
                      //           //     .doc(UserID)
                      //           //     .collection('Recent Reads')
                      //           //     .add({"doc": doc2, 'UserID': StoryUserID});
                      //         },
                      //         child: Container(
                      //           height: 400,
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(30),
                      //             child: Card(
                      //               shadowColor: Colors.transparent,
                      //               child: Column(
                      //                 mainAxisAlignment: MainAxisAlignment.start,
                      //                 children: [
                      //                   ClipRRect(
                      //                     borderRadius: BorderRadius.circular(20),
                      //                     child: Container(
                      //                       height: 175,
                      //                       width:
                      //                           MediaQuery.of(context).size.width,
                      //                       child: Row(
                      //                         children: [
                      //                           ClipRRect(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(20),
                      //                             child: Container(
                      //                               height: 175,
                      //                               width: 120,
                      //                               decoration: BoxDecoration(
                      //                                   image: DecorationImage(
                      //                                       image: NetworkImage(
                      //                                         snapshot.data[3]
                      //                                                 .docs[index]
                      //                                                 .data()[
                      //                                             'TitleImage'],
                      //                                       ),
                      //                                       fit: BoxFit.fill)),
                      //                             ),
                      //                           ),
                      //                           SizedBox(width: 4),
                      //                           Column(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             children: [
                      //                               Container(
                      //                                 width:
                      //                                     MediaQuery.of(context)
                      //                                             .size
                      //                                             .width -
                      //                                         135,
                      //                                 child: Center(
                      //                                   child: Text(
                      //                                     'Virat Kohli The Run Machine Is Firing',
                      //                                     style: GoogleFonts
                      //                                         .ptSansNarrow(
                      //                                             fontSize: 20,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .w600),
                      //                                     overflow:
                      //                                         TextOverflow.fade,
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                               //  SizedBox(height: 0.8,),
                      //                               // Divider(),
                      //                               SizedBox(
                      //                                 height: 2,
                      //                               ),
                      //                               // SizedBox(height: 0.8,),
                      //                               // Row(
                      //                               //   children: [
                      //                               //     Icon(
                      //                               //       Icons.remove_red_eye,
                      //                               //       color: Colors.black54,
                      //                               //       size: 20,
                      //                               //     ),
                      //                               //     SizedBox(
                      //                               //       width: 4,
                      //                               //     ),
                      //                               // Text('$Views ',
                      //                               //     style: TextStyle(
                      //                               //       fontFamily:
                      //                               //           'Ebrima',
                      //                               //       color:
                      //                               //           Colors.black54,
                      //                               //       fontSize: 16,
                      //                               //       fontWeight:
                      //                               //           FontWeight.w500,
                      //                               //       fontStyle: FontStyle
                      //                               //           .normal,
                      //                               //     )),
                      //                               //   ],
                      //                               // ),

                      //                               // SizedBox(
                      //                               //   height: 1,
                      //                               // ),
                      //                               // Container(
                      //                               //   height: 60,width: MediaQuery.of(context)
                      //                               //               .size
                      //                               //               .width -
                      //                               //           195 ,
                      //                               Container(
                      //                                 width:
                      //                                     MediaQuery.of(context)
                      //                                             .size
                      //                                             .width -
                      //                                         135,
                      //                                 child: Center(
                      //                                     child: Text(
                      //                                   Description.join(' '),
                      //                                   overflow:
                      //                                       TextOverflow.clip,
                      //                                   style: GoogleFonts
                      //                                       .nunitoSans(
                      //                                           fontSize: 12,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .w600),
                      //                                 )),
                      //                               ),
                      //                               Row(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment.end,
                      //                                 crossAxisAlignment:
                      //                                     CrossAxisAlignment.end,
                      //                                 children: [
                      //                                   Text('$Views ',
                      //                                       style: TextStyle(
                      //                                         fontFamily:
                      //                                             'Ebrima',
                      //                                         color:
                      //                                             Colors.black54,
                      //                                         fontSize: 16,
                      //                                         fontWeight:
                      //                                             FontWeight.w500,
                      //                                         fontStyle: FontStyle
                      //                                             .normal,
                      //                                       )),
                      //                                   Spacer(),
                      //                                   CircleAvatar(
                      //                                     radius: 18,
                      //                                     backgroundImage:
                      //                                         NetworkImage(
                      //                                       snapshot.data[3]
                      //                                               .docs[index]
                      //                                               .data()[
                      //                                           'UserPhoto'],
                      //                                     ),
                      //                                   ),
                      //                                 ],
                      //                               )
                      //                             ],
                      //                           )
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //     itemCount: snapshot.data[3].docs.length,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
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
  );
}
// TODO

//  *
// LegnedaryArticles(
//     Future<QuerySnapshot> LoadUsers(),
//     Future<QuerySnapshot> LoadArticlesPopularTrending(String index),
//     Future<QuerySnapshot> LoadArticles(),
//     String UserID,
//     String UserName,
//     String UserEmail,
//     String UserPhoto) {
//   return FutureBuilder(
//     future: Future.wait(
//         [LoadUsers(), LoadArticlesPopularTrending('index'), LoadArticles()]),
//     builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
//       if (snapshot.connectionState == ConnectionState.done) {
//         return ListView.builder(
//           itemCount: 1,
//           scrollDirection: Axis.vertical,
//           shrinkWrap: false,
//           itemBuilder: (BuildContext context, int index) {
//             return Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     'People To Follow',
//                     style: GoogleFonts.robotoCondensed(fontSize: 22),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     height: 120,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (BuildContext context, int index) {
//                         String FollowersCount = NumberFormat.compactCurrency(
//                           decimalDigits: 0,
//                           symbol:
//                               '', // if you want to add currency symbol then pass that in this else leave it empty.
//                         ).format(
//                             snapshot.data[0].docs[index].data()['Followers']);
//                         return Container(
//                           height: 120,
//                           width: 112,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => UserViewer(
//                                         UserName: UserName,
//                                         UserPhoto: UserPhoto,
//                                         UserEmail: UserEmail,
//                                         UserID: UserID,
//                                         StoryUserID: snapshot
//                                             .data[0].docs[index]
//                                             .data()['UserID'],
//                                         StoryUserName: snapshot
//                                             .data[0].docs[index]
//                                             .data()['UserName'],
//                                         StoryUserPhoto: snapshot
//                                             .data[0].docs[index]
//                                             .data()['UserPhoto'],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: CircleAvatar(
//                                   radius: 33,
//                                   backgroundImage: NetworkImage(
//                                     snapshot.data[0].docs[index]
//                                         .data()['UserPhoto'],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               Center(
//                                 child: Text(
//                                   snapshot.data[0].docs[index]
//                                       .data()['UserName'],
//                                   style: GoogleFonts.merriweather(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               Center(
//                                 child: Text(
//                                   '$FollowersCount Followers',
//                                   style: GoogleFonts.sourceSansPro(
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       },
//                       itemCount: snapshot.data[0].docs.length,
//                     ),
//                   ),
//                   Container(
//                     height: 220,
//                     child: ListView.builder(
//                       itemBuilder: (BuildContext context, int index) {
//                         double Rating =
//                             snapshot.data[1].docs[index].data()['Rating'];
//                         String Views = NumberFormat.compactCurrency(
//                           decimalDigits: 0,
//                           symbol:
//                               '', // if you want to add currency symbol then pass that in this else leave it empty.
//                         ).format(snapshot.data[1].docs[index].data()['Views']);
//                         int AverageTime =
//                             snapshot.data[1].docs[index].data()['Average Time'];
//                         List Description =
//                             snapshot.data[1].docs[index].data()['Description'];
//                         return Column(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => UserViewer()));
//                               },
//                               child: CircleAvatar(
//                                 radius: 29,
//                                 backgroundImage: NetworkImage(
//                                   snapshot.data[1].docs[index]
//                                       .data()['UserPhoto'],
//                                 ),
//                               ),
//                             ),
//                             Center(
//                               child: Text(
//                                 snapshot.data[1].docs[index].data()['UserName'],
//                               ),
//                             ),
//                             SizedBox(width: 5),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             TextButton(
//                               onPressed: () async {
//                                 String Article = snapshot.data[1].docs[index]
//                                     .data()['Article'];

//                                 DocumentReference doc = articles
//                                     .doc(snapshot.data[1].docs[index].id);
//                                 String doc2 = doc.id;
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ArticleRead(
//                                       TitleImage: snapshot.data[1].docs[index]
//                                           .data()['TitleImage'],
//                                       ArticleUserPhoto: snapshot
//                                           .data[1].docs[index]
//                                           .data()['UserPhoto'],
//                                       DocID: doc2,
//                                       Title: snapshot.data[1].docs[index]
//                                           .data()['Title']
//                                           .toString(),
//                                       Author: snapshot.data[1].docs[index]
//                                           .data()['UserName']
//                                           .toString(),
//                                       Article:
//                                           Article.split('< NEW PART BEGINS >'),
//                                       Characters: snapshot.data[1].docs[index]
//                                           .data()['Characters'],
//                                       ArticleUserID: snapshot
//                                           .data[1].docs[index]
//                                           .data()['UserID'],
//                                     ),
//                                   ),
//                                 );
//                                 DocumentSnapshot viewers = await firestore
//                                     .collection('Stories')
//                                     .doc(doc2)
//                                     .collection('UsersViewed')
//                                     .doc(UserID)
//                                     .get();

//                                 // setState(() {
//                                 //   Viewers = viewers;
//                                 // });

//                                 if (viewers.exists == false) {
//                                   firestore.runTransaction((transaction) async {
//                                     // Get the document

//                                     DocumentSnapshot snapshot =
//                                         await transaction.get(doc);

//                                     if (!snapshot.exists) {
//                                       throw Exception("User does not exist!");
//                                     }

//                                     // Update the follower count based on the current count
//                                     int views = snapshot.data()['Views'] + 1;

//                                     // Perform an update on the document
//                                     transaction.update(doc, {'Views': views});
//                                   }).then((value) => () {
//                                         firestore
//                                             .collection('Stories')
//                                             .doc(doc2)
//                                             .collection('UsersViewed')
//                                             .doc(UserID)
//                                             .set({
//                                           'UserID': UserID,
//                                           'Attempted': true,
//                                           "Completed": false,
//                                           "Time": DateTime.now()
//                                         });
//                                       });
//                                 }
//                               },
//                               child: Card(
//                                 margin: EdgeInsets.all(0),
//                                 child: Container(
//                                   height: 340,
//                                   width: 252,
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                           image: NetworkImage(
//                                             snapshot.data[1].docs[index]
//                                                 .data()['TitleImage'],

//                                             // height: 400,
//                                             // width: 150,
//                                           ),
//                                         )),
//                                       ),
//                                       Container(
//                                         height: 150,
//                                         width: 252,
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                               image: NetworkImage(
//                                                 snapshot.data[1].docs[index]
//                                                     .data()['TitleImage'],
//                                               ),
//                                               fit: BoxFit.fill),
//                                         ),
//                                       ),
//                                       SizedBox(height: 7),
//                                       Text(
//                                           snapshot.data[1].docs[index]
//                                               .data()['Title'],
//                                           style: GoogleFonts.balthazar(
//                                               fontSize: 22,
//                                               fontWeight: FontWeight.w500)),
//                                       SizedBox(height: 8),
//                                       Row(
//                                         // mainAxisSize: MainAxisSize.min,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           Text('$Views Views',
//                                               style: TextStyle(fontSize: 18)),
//                                           Text('5 mins read',
//                                               style: TextStyle(fontSize: 18)),
//                                           Row(
//                                             textBaseline:
//                                                 TextBaseline.ideographic,
//                                             children: [
//                                               Text('$Rating',
//                                                   style:
//                                                       TextStyle(fontSize: 18)),
//                                               Icon(Icons.star_rate_rounded),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                       SizedBox(height: 11),
//                                       Container(
//                                         child: Text(
//                                           Description.join(' '),
//                                         ),
//                                       ),
//                                       // Row(
//                                       //   mainAxisSize: MainAxisSize.max,
//                                       //   mainAxisAlignment:
//                                       //       MainAxisAlignment.end,
//                                       //   children: [
//                                       //     Column(
//                                       //       mainAxisSize: MainAxisSize.max,
//                                       //       mainAxisAlignment:
//                                       //           MainAxisAlignment.center,
//                                       //       children: [
//                                       //         Text(
//                                       //             "~ BY ${snapshot.data[1].docs[index].data()['UserName']}"),
//                                       //       ],
//                                       //     ),
//                                       //     SizedBox(width: 5),
//                                       //     ClipRRect(
//                                       //       borderRadius:
//                                       //           BorderRadius.circular(25),
//                                       //       child: GestureDetector(
//                                       //         onTap: () {
//                                       //           Navigator.push(
//                                       //             context,
//                                       //             MaterialPageRoute(
//                                       //               builder: (context) =>
//                                       //                   UserViewer(
//                                       //                 UserName: UserName,
//                                       //                 UserEmail: UserEmail,
//                                       //                 UserID: UserID,
//                                       //                 UserPhoto: UserPhoto,
//                                       //                 ArticleUserID: snapshot
//                                       //                     .data[1].docs[index]
//                                       //                     .data()['UserID'],
//                                       //                 ArticleUserName: snapshot
//                                       //                     .data[1].docs[index]
//                                       //                     .data()['UserName'],
//                                       //                 ArticleUserPhoto: snapshot
//                                       //                     .data[1].docs[index]
//                                       //                     .data()['UserPhoto'],
//                                       //               ),
//                                       //             ),
//                                       //           );
//                                       //         },
//                                       //         child: CircleAvatar(
//                                       //           backgroundImage: NetworkImage(
//                                       //               snapshot.data[1].docs[index]
//                                       //                   .data()['UserPhoto']),
//                                       //           radius: 25,
//                                       //         ),
//                                       //       ),
//                                       //     ),
//                                       //   ],
//                                       // )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                           ],
//                         );
//                       },
//                       itemCount: snapshot.data[1].docs.length,
//                       scrollDirection: Axis.horizontal,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Stories In SciFi',
//                     style: GoogleFonts.robotoCondensed(fontSize: 22),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     height: 600,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (BuildContext context, int index) {
//                         double Rating =
//                             snapshot.data[1].docs[index].data()['Rating'];
//                         String Views = NumberFormat.compactCurrency(
//                           decimalDigits: 0,
//                           symbol:
//                               '', // if you want to add currency symbol then pass that in this else leave it empty.
//                         ).format(snapshot.data[1].docs[index].data()['Views']);
//                         double AverageTime =
//                             snapshot.data[1].docs[index].data()['Average Time'];
//                         List Description =
//                             snapshot.data[1].docs[index].data()['Description'];
//                         return TextButton(
//                           onPressed: () async {
//                             String Article =
//                                 snapshot.data[1].docs[index].data()['Article'];

//                             DocumentReference doc =
//                                 articles.doc(snapshot.data[1].docs[index].id);
//                             String doc2 = doc.id;
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ArticleRead(
//                                   TitleImage: snapshot.data[1].docs[index]
//                                       .data()['TitleImage'],
//                                   DocID: doc2,
//                                   Title: snapshot.data[1].docs[index]
//                                       .data()['Title'],
//                                   Author: snapshot.data[1].docs[index]
//                                       .data()['UserName'],
//                                   Article: Article.split('< NEW PART BEGINS >'),
//                                   Characters: snapshot.data[1].docs[index]
//                                       .data()['Characters'],
//                                   ArticleUserID: snapshot.data[1].docs[index]
//                                       .data()['UserID'],
//                                   ArticleUserPhoto: snapshot.data[1].docs[index]
//                                       .data()['UserPhoto'],
//                                 ),
//                               ),
//                             );
//                             DocumentSnapshot viewers = await FirebaseFirestore
//                                 .instance
//                                 .collection('Stories')
//                                 .doc(doc2)
//                                 .collection('UsersViewed')
//                                 .doc(UserID)
//                                 .get();

//                             if (viewers.exists == false) {
//                               firestore.runTransaction((transaction) async {
//                                 // Get the document

//                                 DocumentSnapshot snapshot =
//                                     await transaction.get(doc);

//                                 if (!snapshot.exists) {
//                                   throw Exception("User does not exist!");
//                                 }

//                                 // Update the follower count based on the current count
//                                 int views = snapshot.data()['Views'] + 1;

//                                 // Perform an update on the document
//                                 transaction.update(doc, {'Views': views});
//                               }).then((value) => () {
//                                     firestore
//                                         .collection('Stories')
//                                         .doc(doc2)
//                                         .collection('UsersViewed')
//                                         .doc(UserID)
//                                         .set({
//                                       'UserID': UserID,
//                                       'Attempted': true,
//                                       "Completed": false,
//                                       "Time": DateTime.now()
//                                     });
//                                   });
//                             }
//                           },
//                           child: Card(
//                             margin: EdgeInsets.all(0),
//                             child: Container(
//                               height: 340,
//                               width: 252,
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                       image: NetworkImage(
//                                         snapshot.data[1].docs[index]
//                                             .data()['TitleImage'],

//                                         // height: 400,
//                                         // width: 150,
//                                       ),
//                                     )),
//                                   ),
//                                   Container(
//                                     height: 150,
//                                     width: 252,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                           image: NetworkImage(
//                                             snapshot.data[1].docs[index]
//                                                 .data()['TitleImage'],
//                                           ),
//                                           fit: BoxFit.fill),
//                                     ),
//                                   ),
//                                   SizedBox(height: 7),
//                                   Text(
//                                       snapshot.data[1].docs[index]
//                                           .data()['Title'],
//                                       style: GoogleFonts.balthazar(
//                                           fontSize: 22,
//                                           fontWeight: FontWeight.w500)),
//                                   SizedBox(height: 8),
//                                   Row(
//                                     // mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Text('$Views Views',
//                                           style: TextStyle(fontSize: 18)),
//                                       Text('5 mins read',
//                                           style: TextStyle(fontSize: 18)),
//                                       Row(
//                                         textBaseline: TextBaseline.ideographic,
//                                         children: [
//                                           Text('$Rating',
//                                               style: TextStyle(fontSize: 18)),
//                                           Icon(Icons.star_rate_rounded),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                   SizedBox(height: 11),
//                                   Container(
//                                     child: Text(
//                                       Description.join(' '),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.max,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                               "~ BY ${snapshot.data[1].docs[index].data()['UserName']}"),
//                                         ],
//                                       ),
//                                       SizedBox(width: 5),
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(25),
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     UserViewer(
//                                                   UserName: UserName,
//                                                   UserEmail: UserEmail,
//                                                   UserID: UserID,
//                                                   UserPhoto: UserPhoto,
//                                                   StoryUserID: snapshot
//                                                       .data[1].docs[index]
//                                                       .data()['UserID'],
//                                                   StoryUserName: snapshot
//                                                       .data[1].docs[index]
//                                                       .data()['UserName'],
//                                                   StoryUserPhoto: snapshot
//                                                       .data[1].docs[index]
//                                                       .data()['UserPhoto'],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: CircleAvatar(
//                                             backgroundImage: NetworkImage(
//                                                 snapshot.data[1].docs[index]
//                                                     .data()['UserPhoto']),
//                                             radius: 25,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       itemCount: snapshot.data[1].docs.length,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       } else if (snapshot.connectionState == ConnectionState.none) {
//         return Text("No data");
//       }
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//         ],
//       );
//     },
//   );
// }

LegendaryExploration(
    Future<QuerySnapshot> UsersFollowing(),
    Future<QuerySnapshot> StoriesFromFollwoing(),
    String UserID,
    String UserName,
    String UserEmail,
    String UserPhoto) {
  return FutureBuilder(
    future: Future.wait([
      UsersFollowing(),
      StoriesFromFollwoing(),
    ]),
    builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://digitalsynopsis.com/wp-content/uploads/2017/02/beautiful-color-gradients-backgrounds-030-happy-fisher.png'),
                  fit: BoxFit.fill)),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: 1,
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'From The People You Follow',
                      style: GoogleFonts.robotoCondensed(fontSize: 22),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          print(snapshot.data[0].docs.length);
                          String FollowersCount = NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(
                              snapshot.data[0].docs[index].data()['Followers']);
                          return Container(
                            height: 120,
                            width: 112,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserViewer(
                                          UserName: UserName,
                                          UserPhoto: UserPhoto,
                                          UserEmail: UserEmail,
                                          UserID: UserID,
                                          StoryUserID: snapshot
                                              .data[0].docs[index]
                                              .data()['UserID'],
                                          StoryUserName: snapshot
                                              .data[0].docs[index]
                                              .data()['UserName'],
                                          StoryUserPhoto: snapshot
                                              .data[0].docs[index]
                                              .data()['UserPhoto'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 33,
                                    backgroundImage: NetworkImage(
                                      snapshot.data[0].docs[index]
                                          .data()['UserPhoto'],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: Text(
                                    snapshot.data[0].docs[index]
                                        .data()['UserName'],
                                    style: GoogleFonts.merriweather(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: Text(
                                    '$FollowersCount Followers',
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data[0].docs.length,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    SizedBox(height: 24),
                    Container(
                      height: 1230,
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          String Title =
                              snapshot.data[1].docs[index].data()['Title'];
                          List Description = snapshot.data[1].docs[index]
                              .data()['Description'];
                          String StoryUserID =
                              snapshot.data[1].docs[index].data()['UserID'];
                          int Rating =
                              snapshot.data[1].docs[index].data()['Rating'];
                          String Views = NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(
                              snapshot.data[1].docs[index].data()['Views']);

                          return Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://digitalsynopsis.com/wp-content/uploads/2017/02/beautiful-color-gradients-backgrounds-030-happy-fisher.png'),
                                    fit: BoxFit.fill)),
                            child: TextButton(
                              onPressed: () async {
                                String Story = snapshot.data[1].docs[index]
                                    .data()['Story'];

                                DocumentReference doc = stories
                                    .doc(snapshot.data[1].docs[index].id);
                                String doc2 = doc.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryRead(
                                      TitleImage: snapshot.data[1].docs[index]
                                          .data()['TitleImage'],
                                      DocID: doc2,
                                      Title: snapshot.data[1].docs[index]
                                          .data()['Title'],
                                      Author: snapshot.data[1].docs[index]
                                          .data()['UserName'],
                                      Story: Story.split('< NEW PART BEGINS >'),
                                      Characters: snapshot.data[1].docs[index]
                                          .data()['Characters'],
                                      StoryUserID: snapshot.data[1].docs[index]
                                          .data()['UserID'],
                                      StoryUserPhoto: snapshot
                                          .data[1].docs[index]
                                          .data()['UserPhoto'],
                                    ),
                                  ),
                                );
                                DocumentSnapshot viewers = await firestore
                                    .collection('Stories')
                                    .doc(doc2)
                                    .collection('UsersViewed')
                                    .doc(UserID)
                                    .get();

                                if (viewers.exists == false) {
                                  firestore.runTransaction((transaction) async {
                                    // Get the document

                                    DocumentSnapshot snapshot =
                                        await transaction.get(doc);

                                    if (!snapshot.exists) {
                                      throw Exception("User does not exist!");
                                    }

                                    // Update the follower count based on the current count
                                    int views = snapshot.data()['Views'] + 1;

                                    // Perform an update on the document
                                    transaction.update(doc, {'Views': views});
                                  }).then((value) => () {
                                        firestore
                                            .collection('Stories')
                                            .doc(doc2)
                                            .collection('UsersViewed')
                                            .doc(UserID)
                                            .set({
                                          'UserID': UserID,
                                          'Attempted': true,
                                          "Completed": false,
                                          "Time": DateTime.now()
                                        });
                                      });
                                }
                                firestore
                                    .collection('Users')
                                    .doc(UserID)
                                    .collection('Recent Reads')
                                    .add({"doc": doc2, 'UserID': StoryUserID});
                              },
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      // decoration: BoxDecoration(
                                      //     image: DecorationImage(
                                      //         image: NetworkImage(
                                      //             'https://digitalsynopsis.com/wp-content/uploads/2017/02/beautiful-color-gradients-backgrounds-004-juicy-peach.png'),
                                      //         fit: BoxFit.fill)),
                                      height: 155,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 155,
                                            width: 160,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      snapshot
                                                          .data[1].docs[index]
                                                          .data()['TitleImage'],
                                                    ),
                                                    fit: BoxFit.fill)),
                                          ),
                                          SizedBox(width: 4),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                175,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(Title,
                                                    style: GoogleFonts
                                                        .ptSansNarrow(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                //  SizedBox(height: 0.8,),
                                                Divider(),
                                                // SizedBox(height: 0.8,),
                                                Text('$Views Views',
                                                    style: TextStyle(
                                                      fontFamily: 'Ebrima',
                                                      color: Color(0xff707070),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    )),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Text('5 mins read',
                                                    style: TextStyle(
                                                      fontFamily: 'Ebrima',
                                                      color: Color(0xff707070),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    )),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text('$Rating',
                                                        style: TextStyle(
                                                          fontFamily: 'Ebrima',
                                                          color:
                                                              Color(0xff707070),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        )),
                                                    Icon(Icons
                                                        .star_rate_rounded),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // decoration: BoxDecoration(
                                      //                 image: DecorationImage(
                                      //                     image: NetworkImage(
                                      //                         'https://digitalsynopsis.com/wp-content/uploads/2017/02/beautiful-color-gradients-backgrounds-030-happy-fisher.png'),
                                      //                     fit: BoxFit.fill)),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 4,
                                                  left: 8,
                                                  right: 8),
                                              child: Text(Description.join(' '),
                                                  style: GoogleFonts.ptSerif(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "~ BY ${snapshot.data[1].docs[index].data()['UserName']}"),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserViewer(
                                                          UserName: UserName,
                                                          UserEmail: UserEmail,
                                                          UserID: UserID,
                                                          UserPhoto: UserPhoto,
                                                          StoryUserID: snapshot
                                                              .data[1]
                                                              .docs[index]
                                                              .data()['UserID'],
                                                          StoryUserName: snapshot
                                                                  .data[1]
                                                                  .docs[index]
                                                                  .data()[
                                                              'UserName'],
                                                          StoryUserPhoto: snapshot
                                                                  .data[1]
                                                                  .docs[index]
                                                                  .data()[
                                                              'UserPhoto'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                                .data[1]
                                                                .docs[index]
                                                                .data()[
                                                            'UserPhoto']),
                                                    radius: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data[1].docs.length,
                        // separatorBuilder: (context, index) {
                        //   NativeAdmobController controller;
                        //   return Container(
                        //     child: (index != 0 && index % 6 == 0)
                        //         ? Container(
                        //             height: 180,
                        //             width: 360,
                        //             child: Card(
                        //               child: NativeAdmob(
                        //                 options: NativeAdmobOptions(
                        //                     headlineTextStyle:
                        //                         NativeTextStyle(fontSize: 44),
                        //                     bodyTextStyle:
                        //                         NativeTextStyle(fontSize: 44),
                        //                     advertiserTextStyle:
                        //                         NativeTextStyle(
                        //                             fontSize: 77)),
                        //                 adUnitID:
                        //                     'ca-app-pub-4144128581194892/2113810299',
                        //                 controller: controller,
                        //               ),
                        //             ),
                        //           )
                        //         : Container(),
                        //   );
                        // },
                      ),
                    ),
                    // Container(
                    //   height: 430,
                    //   child: ListView.builder(
                    //     itemBuilder: (BuildContext context, int index) {
                    //       int Rating =
                    //           snapshot.data[1].docs[index].data()['Rating'];
                    //       String Views = NumberFormat.compactCurrency(
                    //         decimalDigits: 0,
                    //         symbol:
                    //             '', // if you want to add currency symbol then pass that in this else leave it empty.
                    //       ).format(
                    //           snapshot.data[1].docs[index].data()['Views']);
                    //       AverageTime = snapshot.data[1].docs[index]
                    //           .data()['Average Time'];
                    //       List Description = snapshot.data[1].docs[index]
                    //           .data()['Description'];
                    //       return TextButton(
                    //         onPressed: () async {
                    //           String Story =
                    //               snapshot.data[1].docs[index].data()['Story'];

                    //           DocumentReference doc =
                    //               stories.doc(snapshot.data[1].docs[index].id);
                    //           String doc2 = doc.id;
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => StoryRead(
                    //                 TitleImage: snapshot.data[1].docs[index]
                    //                     .data()['TitleImage'],
                    //                 StoryUserPhoto: snapshot.data[1].docs[index]
                    //                     .data()['UserPhoto'],
                    //                 DocID: doc2,
                    //                 Title: snapshot.data[1].docs[index]
                    //                     .data()['Title']
                    //                     .toString(),
                    //                 Author: snapshot.data[1].docs[index]
                    //                     .data()['UserName']
                    //                     .toString(),
                    //                 Story: Story.split('< NEW PART BEGINS >'),
                    //                 Characters: snapshot.data[1].docs[index]
                    //                     .data()['Characters'],
                    //                 StoryUserID: snapshot.data[1].docs[index]
                    //                     .data()['UserID'],
                    //               ),
                    //             ),
                    //           );
                    //           DocumentSnapshot viewers = await FirebaseFirestore
                    //               .instance
                    //               .collection('Stories')
                    //               .doc(doc2)
                    //               .collection('UsersViewed')
                    //               .doc(UserID)
                    //               .get();

                    //           // setState(() {
                    //           //   Viewers = viewers;
                    //           // });

                    //           if (viewers.exists == false) {
                    //             firestore.runTransaction((transaction) async {
                    //               // Get the document

                    //               DocumentSnapshot snapshot =
                    //                   await transaction.get(doc);

                    //               if (!snapshot.exists) {
                    //                 throw Exception("User does not exist!");
                    //               }

                    //               // Update the follower count based on the current count
                    //               int views = snapshot.data()['Views'] + 1;

                    //               // Perform an update on the document
                    //               transaction.update(doc, {'Views': views});
                    //             }).then((value) => () {
                    //                   firestore
                    //                       .collection('Stories')
                    //                       .doc(doc2)
                    //                       .collection('UsersViewed')
                    //                       .doc(UserID)
                    //                       .set({
                    //                     'UserID': UserID,
                    //                     'Attempted': true,
                    //                     "Completed": false,
                    //                     "Time": DateTime.now()
                    //                   });
                    //                 });
                    //           }
                    //         },
                    //         child: Card(
                    //           margin: EdgeInsets.all(0),
                    //           child: Container(
                    //             height: 452,
                    //             width: 252,
                    //             child: Column(
                    //               children: [
                    //                 Container(
                    //                   height: 175,
                    //                   width: 252,
                    //                   decoration: BoxDecoration(
                    //                     image: DecorationImage(
                    //                         image: NetworkImage(
                    //                           snapshot.data[1].docs[index]
                    //                               .data()['TitleImage'],
                    //                         ),
                    //                         fit: BoxFit.fill),
                    //                   ),
                    //                 ),
                    //                 SizedBox(height: 7),
                    //                 Padding(
                    //                   padding:
                    //                       EdgeInsets.only(left: 8, right: 8),
                    //                   child: Text(
                    //                       snapshot.data[1].docs[index]
                    //                           .data()['Title'],
                    //                       style: GoogleFonts.ptSansNarrow(
                    //                           fontSize: 19,
                    //                           fontWeight: FontWeight.w400)),
                    //                 ),
                    //                 SizedBox(height: 4),
                    //                 Padding(
                    //                   padding:
                    //                       EdgeInsets.only(left: 8, right: 8),
                    //                   child: Row(
                    //                     // mainAxisSize: MainAxisSize.min,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.start,
                    //                     children: [
                    //                       Text('$Views Views',
                    //                           style: TextStyle(
                    //                             fontFamily: 'Ebrima',
                    //                             color: Color(0xff707070),
                    //                             fontSize: 16,
                    //                             fontWeight: FontWeight.w400,
                    //                             fontStyle: FontStyle.normal,
                    //                           )),
                    //                       Spacer(),
                    //                       Text('5 mins read',
                    //                           style: TextStyle(
                    //                             fontFamily: 'Ebrima',
                    //                             color: Color(0xff707070),
                    //                             fontSize: 16,
                    //                             fontWeight: FontWeight.w400,
                    //                             fontStyle: FontStyle.normal,
                    //                           )),
                    //                       Spacer(),
                    //                       Row(
                    //                         textBaseline:
                    //                             TextBaseline.ideographic,
                    //                         children: [
                    //                           Text('$Rating',
                    //                               style: TextStyle(
                    //                                 fontFamily: 'Ebrima',
                    //                                 color: Color(0xff707070),
                    //                                 fontSize: 16,
                    //                                 fontWeight: FontWeight.w400,
                    //                                 fontStyle: FontStyle.normal,
                    //                               )),
                    //                           Icon(Icons.star_rate_rounded),
                    //                         ],
                    //                       )
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   child: Padding(
                    //                     padding: EdgeInsets.only(
                    //                         top: 5,
                    //                         bottom: 4,
                    //                         left: 8,
                    //                         right: 8),
                    //                     child: Text(Description.join(' '),
                    //                         style: GoogleFonts.ptSerif(
                    //                             fontWeight: FontWeight.w500)),
                    //                   ),
                    //                 ),
                    //                 Row(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment: MainAxisAlignment.end,
                    //                   children: [
                    //                     Column(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Text(
                    //                             "~ BY ${snapshot.data[1].docs[index].data()['UserName']}"),
                    //                       ],
                    //                     ),
                    //                     SizedBox(width: 5),
                    //                     ClipRRect(
                    //                       borderRadius:
                    //                           BorderRadius.circular(25),
                    //                       child: GestureDetector(
                    //                         onTap: () {
                    //                           Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(
                    //                               builder: (context) =>
                    //                                   UserViewer(
                    //                                 UserName: UserName,
                    //                                 UserEmail: UserEmail,
                    //                                 UserID: UserID,
                    //                                 UserPhoto: UserPhoto,
                    //                                 StoryUserID: snapshot
                    //                                     .data[1].docs[index]
                    //                                     .data()['UserID'],
                    //                                 StoryUserName: snapshot
                    //                                     .data[1].docs[index]
                    //                                     .data()['UserName'],
                    //                                 StoryUserPhoto: snapshot
                    //                                     .data[1].docs[index]
                    //                                     .data()['UserPhoto'],
                    //                               ),
                    //                             ),
                    //                           );
                    //                         },
                    //                         child: CircleAvatar(
                    //                           backgroundImage: NetworkImage(
                    //                               snapshot.data[1].docs[index]
                    //                                   .data()['UserPhoto']),
                    //                           radius: 25,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     itemCount: snapshot.data[1].docs.length,
                    //     scrollDirection: Axis.horizontal,
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Text(
                    //   'Stories In SciFi',
                    //   style: GoogleFonts.robotoCondensed(fontSize: 22),
                    // ),
                    // SizedBox(
                    //   height: 32,
                    // ),
                    // Container(
                    //   height: 340,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       int Rating =
                    //           snapshot.data[2].docs[index].data()['Rating'];
                    //       String Views = NumberFormat.compactCurrency(
                    //         decimalDigits: 0,
                    //         symbol:
                    //             '', // if you want to add currency symbol then pass that in this else leave it empty.
                    //       ).format(
                    //           snapshot.data[2].docs[index].data()['Views']);
                    //       double AverageTime = snapshot.data[2].docs[index]
                    //           .data()['Average Time'];
                    //       List Description = snapshot.data[2].docs[index]
                    //           .data()['Description'];
                    //       return TextButton(
                    //         onPressed: () async {
                    //           String Story =
                    //               snapshot.data[2].docs[index].data()['Story'];

                    //           DocumentReference doc =
                    //               stories.doc(snapshot.data[2].docs[index].id);
                    //           String doc2 = doc.id;
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => StoryRead(
                    //                 TitleImage: snapshot.data[2].docs[index]
                    //                     .data()['TitleImage'],
                    //                 DocID: doc2,
                    //                 Title: snapshot.data[2].docs[index]
                    //                     .data()['Title'],
                    //                 Author: snapshot.data[2].docs[index]
                    //                     .data()['UserName'],
                    //                 Story: Story.split('< NEW PART BEGINS >'),
                    //                 Characters: snapshot.data[2].docs[index]
                    //                     .data()['Characters'],
                    //                 StoryUserID: snapshot.data[2].docs[index]
                    //                     .data()['UserID'],
                    //                 StoryUserPhoto: snapshot.data[2].docs[index]
                    //                     .data()['UserPhoto'],
                    //               ),
                    //             ),
                    //           );
                    //           DocumentSnapshot viewers = await FirebaseFirestore
                    //               .instance
                    //               .collection('Stories')
                    //               .doc(doc2)
                    //               .collection('UsersViewed')
                    //               .doc(UserID)
                    //               .get();

                    //           if (viewers.exists == false) {
                    //             firestore
                    //                 .runTransaction((transaction) async {
                    //               // Get the document

                    //               DocumentSnapshot snapshot =
                    //                   await transaction.get(doc);

                    //               if (!snapshot.exists) {
                    //                 throw Exception("User does not exist!");
                    //               }

                    //               // Update the follower count based on the current count
                    //               int views = snapshot.data()['Views'] + 1;

                    //               // Perform an update on the document
                    //               transaction.update(doc, {'Views': views});
                    //             }).then((value) => () {
                    //                       firestore
                    //                           .collection('Stories')
                    //                           .doc(doc2)
                    //                           .collection('UsersViewed')
                    //                           .doc(UserID)
                    //                           .set({
                    //                         'UserID': UserID,
                    //                         'Attempted': true,
                    //                         "Completed": false,
                    //                         "Time": DateTime.now()
                    //                       });
                    //                     });
                    //           }
                    //         },
                    //         child: Card(
                    //           margin: EdgeInsets.all(0),
                    //           child: Container(
                    //             height: 340,
                    //             width: 252,
                    //             child: Column(
                    //               children: [
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                       image: DecorationImage(
                    //                     image: NetworkImage(
                    //                       snapshot.data[2].docs[index]
                    //                           .data()['TitleImage'],

                    //                       // height: 400,
                    //                       // width: 150,
                    //                     ),
                    //                   )),
                    //                 ),
                    //                 Container(
                    //                   height: 150,
                    //                   width: 252,
                    //                   decoration: BoxDecoration(
                    //                     image: DecorationImage(
                    //                         image: NetworkImage(
                    //                           snapshot.data[2].docs[index]
                    //                               .data()['TitleImage'],
                    //                         ),
                    //                         fit: BoxFit.fill),
                    //                   ),
                    //                 ),
                    //                 SizedBox(height: 7),
                    //                 Text(
                    //                     snapshot.data[2].docs[index]
                    //                         .data()['Title'],
                    //                     style: GoogleFonts.balthazar(
                    //                         fontSize: 22,
                    //                         fontWeight: FontWeight.w500)),
                    //                 SizedBox(height: 8),
                    //                 Row(
                    //                   // mainAxisSize: MainAxisSize.min,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceEvenly,
                    //                   children: [
                    //                     Text('$Views Views',
                    //                         style: TextStyle(fontSize: 18)),
                    //                     Text('5 mins read',
                    //                         style: TextStyle(fontSize: 18)),
                    //                     Row(
                    //                       textBaseline:
                    //                           TextBaseline.ideographic,
                    //                       children: [
                    //                         Text('$Rating',
                    //                             style: TextStyle(fontSize: 18)),
                    //                         Icon(Icons.star_rate_rounded),
                    //                       ],
                    //                     )
                    //                   ],
                    //                 ),
                    //                 SizedBox(height: 11),
                    //                 Container(
                    //                   child: Text(
                    //                     Description.join(' '),
                    //                   ),
                    //                 ),
                    //                 Row(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment: MainAxisAlignment.end,
                    //                   children: [
                    //                     Column(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Text(
                    //                             "~ BY ${snapshot.data[2].docs[index].data()['UserName']}"),
                    //                       ],
                    //                     ),
                    //                     SizedBox(width: 5),
                    //                     ClipRRect(
                    //                       borderRadius:
                    //                           BorderRadius.circular(25),
                    //                       child: GestureDetector(
                    //                         onTap: () {
                    //                           Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(
                    //                               builder: (context) =>
                    //                                   UserViewer(
                    //                                 UserName: UserName,
                    //                                 UserEmail: UserEmail,
                    //                                 UserID: UserID,
                    //                                 UserPhoto: UserPhoto,
                    //                                 StoryUserID: snapshot
                    //                                     .data[2].docs[index]
                    //                                     .data()['UserID'],
                    //                                 StoryUserName: snapshot
                    //                                     .data[2].docs[index]
                    //                                     .data()['UserName'],
                    //                                 StoryUserPhoto: snapshot
                    //                                     .data[2].docs[index]
                    //                                     .data()['UserPhoto'],
                    //                               ),
                    //                             ),
                    //                           );
                    //                         },
                    //                         child: CircleAvatar(
                    //                           backgroundImage: NetworkImage(
                    //                               snapshot.data[2].docs[index]
                    //                                   .data()['UserPhoto']),
                    //                           radius: 25,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     itemCount: snapshot.data[1].docs.length,
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Text(
                    //   'Recommended For You',
                    //   style: GoogleFonts.robotoCondensed(fontSize: 22),
                    // ),
                    // SizedBox(height: 18),
                    // Container(
                    //   height: 340,
                    //   child: ListView.separated(
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       int Rating =
                    //           snapshot.data[3].docs[index].data()['Rating'];
                    //       String Views = NumberFormat.compactCurrency(
                    //         decimalDigits: 0,
                    //         symbol:
                    //             '', // if you want to add currency symbol then pass that in this else leave it empty.
                    //       ).format(
                    //           snapshot.data[3].docs[index].data()['Views']);
                    //       double AverageTime = snapshot.data[3].docs[index]
                    //           .data()['Average Time'];
                    //       List Description = snapshot.data[3].docs[index]
                    //           .data()['Description'];
                    //       return TextButton(
                    //         onPressed: () async {
                    //           String Story =
                    //               snapshot.data[3].docs[index].data()['Story'];

                    //           DocumentReference doc =
                    //               stories.doc(snapshot.data[3].docs[index].id);
                    //           String doc2 = doc.id;
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => StoryRead(
                    //                 TitleImage: snapshot.data[3].docs[index]
                    //                     .data()['TitleImage'],
                    //                 DocID: doc2,
                    //                 Title: snapshot.data[3].docs[index]
                    //                     .data()['Title'],
                    //                 Author: snapshot.data[3].docs[index]
                    //                     .data()['UserName'],
                    //                 Story: Story.split('< NEW PART BEGINS >'),
                    //                 Characters: snapshot.data[3].docs[index]
                    //                     .data()['Characters'],
                    //                 StoryUserID: snapshot.data[3].docs[index]
                    //                     .data()['UserID'],
                    //                 StoryUserPhoto: snapshot.data[2].docs[index]
                    //                     .data()['UserPhoto'],
                    //               ),
                    //             ),
                    //           );
                    //           DocumentSnapshot viewers = await FirebaseFirestore
                    //               .instance
                    //               .collection('Stories')
                    //               .doc(doc2)
                    //               .collection('UsersViewed')
                    //               .doc(UserID)
                    //               .get();

                    //           if (viewers.exists == false) {
                    //             firestore
                    //                 .runTransaction((transaction) async {
                    //               // Get the document

                    //               DocumentSnapshot snapshot =
                    //                   await transaction.get(doc);

                    //               if (!snapshot.exists) {
                    //                 throw Exception("User does not exist!");
                    //               }

                    //               // Update the follower count based on the current count
                    //               int views = snapshot.data()['Views'] + 1;

                    //               // Perform an update on the document
                    //               transaction.update(doc, {'Views': views});
                    //             }).then((value) => () {
                    //                       firestore
                    //                           .collection('Stories')
                    //                           .doc(doc2)
                    //                           .collection('UsersViewed')
                    //                           .doc(UserID)
                    //                           .set({
                    //                         'UserID': UserID,
                    //                         'Attempted': true,
                    //                         "Completed": false,
                    //                         "Time": DateTime.now()
                    //                       });
                    //                     });
                    //           }
                    //         },
                    //         child: Card(
                    //           margin: EdgeInsets.all(0),
                    //           child: Container(
                    //             height: 340,
                    //             width: 252,
                    //             child: Column(
                    //               children: [
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                       image: DecorationImage(
                    //                     image: NetworkImage(
                    //                       snapshot.data[3].docs[index]
                    //                           .data()['TitleImage'],

                    //                       // height: 400,
                    //                       // width: 150,
                    //                     ),
                    //                   )),
                    //                 ),
                    //                 Container(
                    //                   height: 150,
                    //                   width: 252,
                    //                   decoration: BoxDecoration(
                    //                     image: DecorationImage(
                    //                         image: NetworkImage(
                    //                           snapshot.data[3].docs[index]
                    //                               .data()['TitleImage'],
                    //                         ),
                    //                         fit: BoxFit.fill),
                    //                   ),
                    //                 ),
                    //                 SizedBox(height: 7),
                    //                 Text(
                    //                     snapshot.data[3].docs[index]
                    //                         .data()['Title'],
                    //                     style: GoogleFonts.balthazar(
                    //                         fontSize: 22,
                    //                         fontWeight: FontWeight.w500)),
                    //                 SizedBox(height: 8),
                    //                 Row(
                    //                   // mainAxisSize: MainAxisSize.min,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceEvenly,
                    //                   children: [
                    //                     Text('$Views Views',
                    //                         style: TextStyle(fontSize: 18)),
                    //                     Text('5 mins read',
                    //                         style: TextStyle(fontSize: 18)),
                    //                     Row(
                    //                       textBaseline:
                    //                           TextBaseline.ideographic,
                    //                       children: [
                    //                         Text('$Rating',
                    //                             style: TextStyle(fontSize: 18)),
                    //                         Icon(Icons.star_rate_rounded),
                    //                       ],
                    //                     )
                    //                   ],
                    //                 ),
                    //                 SizedBox(height: 11),
                    //                 Container(
                    //                   child: Text(
                    //                     Description.join(' '),
                    //                   ),
                    //                 ),
                    //                 Row(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment: MainAxisAlignment.end,
                    //                   children: [
                    //                     Column(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Text(
                    //                             "~ BY ${snapshot.data[3].docs[index].data()['UserName']}"),
                    //                       ],
                    //                     ),
                    //                     SizedBox(width: 5),
                    //                     ClipRRect(
                    //                       borderRadius:
                    //                           BorderRadius.circular(25),
                    //                       child: GestureDetector(
                    //                         onTap: () {
                    //                           Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(
                    //                               builder: (context) =>
                    //                                   UserViewer(
                    //                                 UserName: UserName,
                    //                                 UserEmail: UserEmail,
                    //                                 UserID: UserID,
                    //                                 UserPhoto: UserPhoto,
                    //                                 StoryUserID: snapshot
                    //                                     .data[3].docs[index]
                    //                                     .data()['UserID'],
                    //                                 StoryUserName: snapshot
                    //                                     .data[3].docs[index]
                    //                                     .data()['UserName'],
                    //                                 StoryUserPhoto: snapshot
                    //                                     .data[3].docs[index]
                    //                                     .data()['UserPhoto'],
                    //                               ),
                    //                             ),
                    //                           );
                    //                         },
                    //                         child: CircleAvatar(
                    //                           backgroundImage: NetworkImage(
                    //                               snapshot.data[3].docs[index]
                    //                                   .data()['UserPhoto']),
                    //                           radius: 25,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     itemCount: snapshot.data[3].docs.length,
                    //     separatorBuilder: (context, index) {
                    //       NativeAdmobController controller;
                    //       return Container(
                    //         child: (index != 0 && index % 6 == 0)
                    //             ? Container(
                    //                 height: 180,
                    //                 width: 360,
                    //                 child: Card(
                    //                   child: NativeAdmob(
                    //                     options: NativeAdmobOptions(
                    //                         headlineTextStyle:
                    //                             NativeTextStyle(fontSize: 44),
                    //                         bodyTextStyle:
                    //                             NativeTextStyle(fontSize: 44),
                    //                         advertiserTextStyle:
                    //                             NativeTextStyle(fontSize: 77)),
                    //                     adUnitID:
                    //                         'ca-app-pub-4144128581194892/2113810299',
                    //                     controller: controller,
                    //                   ),
                    //                 ),
                    //               )
                    //             : null,
                    //       );
                    //     },
                    //   ),
                    // )
                  ],
                ),
              );
            },
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
  );
}

RecentReads50(Future<QuerySnapshot> RecentReads(), String UserID,
    String UserName, String UserEmail, String UserPhoto) {
  return FutureBuilder(
    future: RecentReads(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: 1,
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Your Recent Reads',
                          style: GoogleFonts.robotoCondensed(fontSize: 22),
                        ),

                        // Padding(
                        //   padding: EdgeInsets.only(left: 13, right: 10),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "Popular Sci-Fi Stories",
                        //         style: GoogleFonts.robotoCondensed(fontSize: 24),
                        //       ),
                        //       Spacer(),
                        //       GestureDetector(
                        //         child: Icon(Icons.arrow_forward_ios_sharp),
                        //         onTap: () {
                        //           // Navigator.push(
                        //           //     context,
                        //           //     MaterialPageRoute(
                        //           //         builder: (context) =>
                        //           //             AllPosts(
                        //           //               future: AllRecent(),
                        //           //               UserEmail: UserEmail,
                        //           //               UserPhoto: UserPhoto,
                        //           //               UserID: UserID,
                        //           //               UserName: UserName,
                        //           //               StoryUserID:
                        //           //                   StoryUserID,
                        //           //               StoryUserName:
                        //           //                   StoryUserName,
                        //           //               StoryUserPhoto:
                        //           //                   StoryUserPhoto,
                        //           //             )));
                        //         },
                        //       )
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 21),
                        Container(
                          height: 430,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              int Rating =
                                  snapshot.data.docs[index].data()['Rating'];
                              String Views = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol:
                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                              ).format(
                                  snapshot.data.docs[index].data()['Views']);
                              AverageTime = snapshot.data.docs[index]
                                  .data()['Average Time'];
                              List Description = snapshot.data.docs[index]
                                  .data()['Description'];
                              return TextButton(
                                onPressed: () async {
                                  String Story =
                                      snapshot.data.docs[index].data()['Story'];

                                  DocumentReference doc =
                                      stories.doc(snapshot.data.docs[index].id);
                                  String doc2 = doc.id;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoryRead(
                                        TitleImage: snapshot.data.docs[index]
                                            .data()['TitleImage'],
                                        StoryUserPhoto: snapshot
                                            .data.docs[index]
                                            .data()['UserPhoto'],
                                        DocID: doc2,
                                        Title: snapshot.data.docs[index]
                                            .data()['Title']
                                            .toString(),
                                        Author: snapshot.data.docs[index]
                                            .data()['UserName']
                                            .toString(),
                                        Story:
                                            Story.split('< NEW PART BEGINS >'),
                                        Characters: snapshot.data.docs[index]
                                            .data()['Characters'],
                                        StoryUserID: snapshot.data.docs[index]
                                            .data()['UserID'],
                                      ),
                                    ),
                                  );
                                  DocumentSnapshot viewers = await firestore
                                      .collection('Stories')
                                      .doc(doc2)
                                      .collection('UsersViewed')
                                      .doc(UserID)
                                      .get();

                                  // setState(() {
                                  //   Viewers = viewers;
                                  // });

                                  if (viewers.exists == false) {
                                    firestore
                                        .runTransaction((transaction) async {
                                      // Get the document

                                      DocumentSnapshot snapshot =
                                          await transaction.get(doc);

                                      if (!snapshot.exists) {
                                        throw Exception("User does not exist!");
                                      }

                                      // Update the follower count based on the current count
                                      int views = snapshot.data()['Views'] + 1;

                                      // Perform an update on the document
                                      transaction.update(doc, {'Views': views});
                                    }).then((value) => () {
                                              firestore
                                                  .collection('Stories')
                                                  .doc(doc2)
                                                  .collection('UsersViewed')
                                                  .doc(UserID)
                                                  .set({
                                                'UserID': UserID,
                                                'Attempted': true,
                                                "Completed": false,
                                                "Time": DateTime.now()
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
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  snapshot.data.docs[index]
                                                      .data()['TitleImage'],
                                                ),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                              snapshot.data.docs[index]
                                                  .data()['Title'],
                                              style: GoogleFonts.ptSansNarrow(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        SizedBox(height: 4),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Row(
                                            // mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('$Views Views',
                                                  style: TextStyle(
                                                    fontFamily: 'Ebrima',
                                                    color: Color(0xff707070),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                  )),
                                              Spacer(),
                                              Text('5 mins read',
                                                  style: TextStyle(
                                                    fontFamily: 'Ebrima',
                                                    color: Color(0xff707070),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                  )),
                                              Spacer(),
                                              Row(
                                                textBaseline:
                                                    TextBaseline.ideographic,
                                                children: [
                                                  Text('$Rating',
                                                      style: TextStyle(
                                                        fontFamily: 'Ebrima',
                                                        color:
                                                            Color(0xff707070),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      )),
                                                  Icon(Icons.star_rate_rounded),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 4,
                                                left: 8,
                                                right: 8),
                                            child: Text(Description.join(' '),
                                                style: GoogleFonts.ptSerif(
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    "~ BY ${snapshot.data.docs[index].data()['UserName']}"),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserViewer(
                                                        UserName: UserName,
                                                        UserEmail: UserEmail,
                                                        UserID: UserID,
                                                        UserPhoto: UserPhoto,
                                                        StoryUserID: snapshot
                                                            .data.docs[index]
                                                            .data()['UserID'],
                                                        StoryUserName: snapshot
                                                            .data.docs[index]
                                                            .data()['UserName'],
                                                        StoryUserPhoto: snapshot
                                                                .data
                                                                .docs[index]
                                                                .data()[
                                                            'UserPhoto'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data.docs[index]
                                                          .data()['UserPhoto']),
                                                  radius: 25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data.docs.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        SizedBox(height: 22),
                        Padding(
                          padding: EdgeInsets.only(left: 13, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Popular Horror Stories',
                                style:
                                    GoogleFonts.robotoCondensed(fontSize: 24),
                              ),
                              Spacer(),
                              GestureDetector(
                                child: Icon(Icons.arrow_forward_ios_sharp),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             AllPosts(
                                  //               future: AllRecent(),
                                  //               UserEmail: UserEmail,
                                  //               UserPhoto: UserPhoto,
                                  //               UserID: UserID,
                                  //               UserName: UserName,
                                  //               StoryUserID:
                                  //                   StoryUserID,
                                  //               StoryUserName:
                                  //                   StoryUserName,
                                  //               StoryUserPhoto:
                                  //                   StoryUserPhoto,
                                  //             )));
                                },
                              )
                            ],
                          ),
                        ),
                        // SizedBox(height: 29),
                        // Container(
                        //   height: 430,
                        //   child: ListView.builder(
                        //     itemBuilder: (BuildContext context, int index) {
                        //       int Rating =
                        //           snapshot.data[2].docs[index].data()['Rating'];
                        //       String Views = NumberFormat.compactCurrency(
                        //         decimalDigits: 0,
                        //         symbol:
                        //             '', // if you want to add currency symbol then pass that in this else leave it empty.
                        //       ).format(
                        //           snapshot.data[2].docs[index].data()['Views']);
                        //       AverageTime = snapshot.data[2].docs[index]
                        //           .data()['Average Time'];
                        //       List Description = snapshot.data[2].docs[index]
                        //           .data()['Description'];
                        //       return TextButton(
                        //         onPressed: () async {
                        //           String Story = snapshot.data[2].docs[index]
                        //               .data()['Story'];

                        //           DocumentReference doc = stories
                        //               .doc(snapshot.data[2].docs[index].id);
                        //           String doc2 = doc.id;
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => StoryRead(
                        //                 TitleImage: snapshot.data[2].docs[index]
                        //                     .data()['TitleImage'],
                        //                 StoryUserPhoto: snapshot
                        //                     .data[2].docs[index]
                        //                     .data()['UserPhoto'],
                        //                 DocID: doc2,
                        //                 Title: snapshot.data[2].docs[index]
                        //                     .data()['Title']
                        //                     .toString(),
                        //                 Author: snapshot.data[2].docs[index]
                        //                     .data()['UserName']
                        //                     .toString(),
                        //                 Story: Story.split('< NEW PART BEGINS >'),
                        //                 Characters: snapshot.data[2].docs[index]
                        //                     .data()['Characters'],
                        //                 StoryUserID: snapshot.data[2].docs[index]
                        //                     .data()['UserID'],
                        //               ),
                        //             ),
                        //           );
                        //           DocumentSnapshot viewers =
                        //               await firestore
                        //                   .collection('Stories')
                        //                   .doc(doc2)
                        //                   .collection('UsersViewed')
                        //                   .doc(UserID)
                        //                   .get();

                        //           // setState(() {
                        //           //   Viewers = viewers;
                        //           // });

                        //           if (viewers.exists == false) {
                        //             firestore
                        //                 .runTransaction((transaction) async {
                        //               // Get the document

                        //               DocumentSnapshot snapshot =
                        //                   await transaction.get(doc);

                        //               if (!snapshot.exists) {
                        //                 throw Exception("User does not exist!");
                        //               }

                        //               // Update the follower count based on the current count
                        //               int views = snapshot.data()['Views'] + 1;

                        //               // Perform an update on the document
                        //               transaction.update(doc, {'Views': views});
                        //             }).then((value) => () {
                        //                       firestore
                        //                           .collection('Stories')
                        //                           .doc(doc2)
                        //                           .collection('UsersViewed')
                        //                           .doc(UserID)
                        //                           .set({
                        //                         'UserID': UserID,
                        //                         'Attempted': true,
                        //                         "Completed": false,
                        //                         "Time": DateTime.now()
                        //                       });
                        //                     });
                        //           }
                        //         },
                        //         child: Card(
                        //           margin: EdgeInsets.all(0),
                        //           child: Container(
                        //             height: 452,
                        //             width: 252,
                        //             child: Column(
                        //               children: [
                        //                 Container(
                        //                   height: 175,
                        //                   width: 252,
                        //                   decoration: BoxDecoration(
                        //                     image: DecorationImage(
                        //                         image: NetworkImage(
                        //                           snapshot.data[2].docs[index]
                        //                               .data()['TitleImage'],
                        //                         ),
                        //                         fit: BoxFit.fill),
                        //                   ),
                        //                 ),
                        //                 SizedBox(height: 7),
                        //                 Padding(
                        //                   padding:
                        //                       EdgeInsets.only(left: 8, right: 8),
                        //                   child: Text(
                        //                       snapshot.data[2].docs[index]
                        //                           .data()['Title'],
                        //                       style: GoogleFonts.ptSansNarrow(
                        //                           fontSize: 19,
                        //                           fontWeight: FontWeight.w400)),
                        //                 ),
                        //                 SizedBox(height: 4),
                        //                 Padding(
                        //                   padding:
                        //                       EdgeInsets.only(left: 8, right: 8),
                        //                   child: Row(
                        //                     // mainAxisSize: MainAxisSize.min,
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.start,
                        //                     children: [
                        //                       Text('$Views Views',
                        //                           style: TextStyle(
                        //                             fontFamily: 'Ebrima',
                        //                             color: Color(0xff707070),
                        //                             fontSize: 16,
                        //                             fontWeight: FontWeight.w400,
                        //                             fontStyle: FontStyle.normal,
                        //                           )),
                        //                       Spacer(),
                        //                       Text('5 mins read',
                        //                           style: TextStyle(
                        //                             fontFamily: 'Ebrima',
                        //                             color: Color(0xff707070),
                        //                             fontSize: 16,
                        //                             fontWeight: FontWeight.w400,
                        //                             fontStyle: FontStyle.normal,
                        //                           )),
                        //                       Spacer(),
                        //                       Row(
                        //                         textBaseline:
                        //                             TextBaseline.ideographic,
                        //                         children: [
                        //                           Text('$Rating',
                        //                               style: TextStyle(
                        //                                 fontFamily: 'Ebrima',
                        //                                 color: Color(0xff707070),
                        //                                 fontSize: 16,
                        //                                 fontWeight:
                        //                                     FontWeight.w400,
                        //                                 fontStyle:
                        //                                     FontStyle.normal,
                        //                               )),
                        //                           Icon(Icons.star_rate_rounded),
                        //                         ],
                        //                       )
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 Container(
                        //                   child: Padding(
                        //                     padding: EdgeInsets.only(
                        //                         top: 5,
                        //                         bottom: 4,
                        //                         left: 8,
                        //                         right: 8),
                        //                     child: Text(Description.join(' '),
                        //                         style: GoogleFonts.ptSerif(
                        //                             fontWeight: FontWeight.w500)),
                        //                   ),
                        //                 ),
                        //                 Row(
                        //                   mainAxisSize: MainAxisSize.max,
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.end,
                        //                   children: [
                        //                     Column(
                        //                       mainAxisSize: MainAxisSize.max,
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.center,
                        //                       children: [
                        //                         Text(
                        //                             "~ BY ${snapshot.data[2].docs[index].data()['UserName']}"),
                        //                       ],
                        //                     ),
                        //                     SizedBox(width: 5),
                        //                     ClipRRect(
                        //                       borderRadius:
                        //                           BorderRadius.circular(25),
                        //                       child: GestureDetector(
                        //                         onTap: () {
                        //                           Navigator.push(
                        //                             context,
                        //                             MaterialPageRoute(
                        //                               builder: (context) =>
                        //                                   UserViewer(
                        //                                 UserName: UserName,
                        //                                 UserEmail: UserEmail,
                        //                                 UserID: UserID,
                        //                                 UserPhoto: UserPhoto,
                        //                                 StoryUserID: snapshot
                        //                                     .data[2].docs[index]
                        //                                     .data()['UserID'],
                        //                                 StoryUserName: snapshot
                        //                                     .data[2].docs[index]
                        //                                     .data()['UserName'],
                        //                                 StoryUserPhoto: snapshot
                        //                                     .data[2].docs[index]
                        //                                     .data()['UserPhoto'],
                        //                               ),
                        //                             ),
                        //                           );
                        //                         },
                        //                         child: CircleAvatar(
                        //                           backgroundImage: NetworkImage(
                        //                               snapshot.data[2].docs[index]
                        //                                   .data()['UserPhoto']),
                        //                           radius: 25,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 )
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     itemCount: snapshot.data[2].docs.length,
                        //     scrollDirection: Axis.horizontal,
                        //   ),
                        // ),
                        // Text(
                        //   'Popular Fantasy Stories',
                        //   style: GoogleFonts.robotoCondensed(fontSize: 22),
                        // ),
                        // SizedBox(height: 18),
                        // Container(
                        //   height: 300,
                        //   child: ListView.separated(
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (BuildContext context, int index) {
                        //       String StoryUserID =
                        //           snapshot.data[3].docs[index].data()['UserID'];
                        //       int Rating =
                        //           snapshot.data[3].docs[index].data()['Rating'];
                        //       String Views = NumberFormat.compactCurrency(
                        //         decimalDigits: 0,
                        //         symbol:
                        //             '', // if you want to add currency symbol then pass that in this else leave it empty.
                        //       ).format(
                        //           snapshot.data[3].docs[index].data()['Views']);

                        //       return TextButton(
                        //         onPressed: () async {
                        //           String Story = snapshot.data[3].docs[index]
                        //               .data()['Story'];

                        //           DocumentReference doc = stories
                        //               .doc(snapshot.data[3].docs[index].id);
                        //           String doc2 = doc.id;
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => StoryRead(
                        //                 TitleImage: snapshot.data[3].docs[index]
                        //                     .data()['TitleImage'],
                        //                 DocID: doc2,
                        //                 Title: snapshot.data[3].docs[index]
                        //                     .data()['Title'],
                        //                 Author: snapshot.data[3].docs[index]
                        //                     .data()['UserName'],
                        //                 Story: Story.split('< NEW PART BEGINS >'),
                        //                 Characters: snapshot.data[3].docs[index]
                        //                     .data()['Characters'],
                        //                 StoryUserID: snapshot.data[3].docs[index]
                        //                     .data()['UserID'],
                        //                 StoryUserPhoto: snapshot
                        //                     .data[2].docs[index]
                        //                     .data()['UserPhoto'],
                        //               ),
                        //             ),
                        //           );
                        //           DocumentSnapshot viewers =
                        //               await firestore
                        //                   .collection('Stories')
                        //                   .doc(doc2)
                        //                   .collection('UsersViewed')
                        //                   .doc(UserID)
                        //                   .get();

                        //           if (viewers.exists == false) {
                        //             firestore
                        //                 .runTransaction((transaction) async {
                        //               // Get the document

                        //               DocumentSnapshot snapshot =
                        //                   await transaction.get(doc);

                        //               if (!snapshot.exists) {
                        //                 throw Exception("User does not exist!");
                        //               }

                        //               // Update the follower count based on the current count
                        //               int views = snapshot.data()['Views'] + 1;

                        //               // Perform an update on the document
                        //               transaction.update(doc, {'Views': views});
                        //             }).then((value) => () {
                        //                       firestore
                        //                           .collection('Stories')
                        //                           .doc(doc2)
                        //                           .collection('UsersViewed')
                        //                           .doc(UserID)
                        //                           .set({
                        //                         'UserID': UserID,
                        //                         'Attempted': true,
                        //                         "Completed": false,
                        //                         "Time": DateTime.now()
                        //                       });
                        //                     });
                        //           }
                        //           stories
                        //               .doc(UserID)
                        //               .collection('Recent Reads')
                        //               .add({"doc": doc2, 'UserID' : StoryUserID});
                        //         },
                        //         child: Card(
                        //           margin: EdgeInsets.all(0),
                        //           child: Container(
                        //             decoration: BoxDecoration(
                        //                 image: DecorationImage(
                        //                     image: NetworkImage(
                        //                       snapshot.data[3].docs[index]
                        //                           .data()['TitleImage'],
                        //                     ),
                        //                     fit: BoxFit.fill)),
                        //             height: 200,
                        //             width: 200,
                        //             child: Column(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               children: [
                        //                 Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.end,
                        //                   children: [Icon(Icons.info)],
                        //                 ),
                        //               ],
                        //             ),
                        // child: Column(
                        //   children: [
                        //     Container(

                        //     ),
                        //     Container(
                        //       height: 150,
                        //       width: 252,
                        //       decoration: BoxDecoration(
                        //         image: DecorationImage(
                        //             image: NetworkImage(
                        //               snapshot.data[3].docs[index]
                        //                   .data()['TitleImage'],
                        //             ),
                        //             fit: BoxFit.fill),
                        //       ),
                        //     ),
                        //     SizedBox(height: 7),
                        //     Text(
                        //         snapshot.data[3].docs[index]
                        //             .data()['Title'],
                        //         style: GoogleFonts.balthazar(
                        //             fontSize: 22,
                        //             fontWeight: FontWeight.w500)),
                        //     SizedBox(height: 8),
                        //     Row(
                        //       // mainAxisSize: MainAxisSize.min,
                        //       mainAxisAlignment:
                        //           MainAxisAlignment.spaceEvenly,
                        //       children: [
                        //         Text('$Views Views',
                        //             style: TextStyle(fontSize: 18)),
                        //         Text('5 mins read',
                        //             style: TextStyle(fontSize: 18)),
                        //         Row(
                        //           textBaseline:
                        //               TextBaseline.ideographic,
                        //           children: [
                        //             Text('$Rating',
                        //                 style: TextStyle(fontSize: 18)),
                        //             Icon(Icons.star_rate_rounded),
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //     SizedBox(height: 11),
                        //     Container(
                        //       child: Text(
                        //         Description.join(' '),
                        //       ),
                        //     ),
                        //     Row(
                        //       mainAxisSize: MainAxisSize.max,
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         Column(
                        //           mainAxisSize: MainAxisSize.max,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.center,
                        //           children: [
                        //             Text(
                        //                 "~ BY ${snapshot.data[3].docs[index].data()['UserName']}"),
                        //           ],
                        //         ),
                        //         SizedBox(width: 5),
                        //         ClipRRect(
                        //           borderRadius:
                        //               BorderRadius.circular(25),
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       UserViewer(
                        //                     UserName: UserName,
                        //                     UserEmail: UserEmail,
                        //                     UserID: UserID,
                        //                     UserPhoto: UserPhoto,
                        //                     StoryUserID: snapshot
                        //                         .data[3].docs[index]
                        //                         .data()['UserID'],
                        //                     StoryUserName: snapshot
                        //                         .data[3].docs[index]
                        //                         .data()['UserName'],
                        //                     StoryUserPhoto: snapshot
                        //                         .data[3].docs[index]
                        //                         .data()['UserPhoto'],
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //             child: CircleAvatar(
                        //               backgroundImage: NetworkImage(
                        //                   snapshot.data[3].docs[index]
                        //                       .data()['UserPhoto']),
                        //               radius: 25,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                );
              },
              //     itemCount: snapshot.data[3].docs.length,
              //     separatorBuilder: (context, index) {
              //       NativeAdmobController controller;
              //       return Container(
              //         child: (index != 0 && index % 6 == 0)
              //             ? Container(
              //                 height: 180,
              //                 width: 360,
              //                 child: Card(
              //                   child: NativeAdmob(
              //                     options: NativeAdmobOptions(
              //                         headlineTextStyle:
              //                             NativeTextStyle(fontSize: 44),
              //                         bodyTextStyle:
              //                             NativeTextStyle(fontSize: 44),
              //                         advertiserTextStyle:
              //                             NativeTextStyle(
              //                                 fontSize: 77)),
              //                     adUnitID:
              //                         'ca-app-pub-4144128581194892/2113810299',
              //                     controller: controller,
              //                   ),
              //                 ),
              //               )
              //             : Container(),
              //       );
              //     },
              //   ),
              // )
              //     ],
              //   ),
              // ),
              //     );
              //   },
              // ),
            ));
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
  );
}

LoadStoryDrafts(Future<QuerySnapshot> LoadDrafts) {
  return FutureBuilder(
    future: LoadDrafts,
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Container(
          height: 120,
          width: 162,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              String Title = snapshot.data.docs[index].data()['Title'];
              List Description =
                  snapshot.data.docs[index].data()['Description'];
              return Container(
                height: 120,
                width: 162,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Title != null ? Text(Title) : Text('No Title'),
                    SizedBox(width: 5),
                    Description != null
                        ? Text(Description.join(' '))
                        : Text('No Description')
                  ],
                ),
              );
            },
            itemCount: snapshot.data.docs.length,
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
