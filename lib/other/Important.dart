/*

List a = [
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  22 * 102
];

CustomFutureBuilder(
  Future<QuerySnapshot> LoadUsers(),
  Future<QuerySnapshot> LoadStories(),
  int Rating,
  String Views,
  String UserID,
  String UserName,
  String UserPhoto,
  String UserEmail,
  Future<QuerySnapshot> LoadStoriesPopularTrending(),
) {
  return FutureBuilder(
    future: LoadUsers(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length + 8,
          itemBuilder: (BuildContext context, int index) {
            return Container();
          },
          separatorBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'People To Follow',
                    style: GoogleFonts.robotoCondensed(fontSize: 22),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FutureBuilder(
                    future: LoadUsers(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: 95,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: false,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 95,
                                width: 90,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: CircleAvatar(
                                        radius: 29,
                                        backgroundImage: NetworkImage(
                                          snapshot.data.docs[index]
                                              .data()['UserPhoto'],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        snapshot.data.docs[index]
                                            .data()['UserName'],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            }
            if (index == 2) {
              return FutureBuilder(
                // future: function3,
                future: LoadStoriesPopularTrending(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 340,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Rating = snapshot.data.docs[index].data()['Rating'];
                          Views = NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(snapshot.data.docs[index].data()['Views']);
                          AverageTime =
                              snapshot.data.docs[index].data()['Average Time'];
                          List Description =
                              snapshot.data.docs[index].data()['Description'];
                          return FlatButton(
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
                                    StoryUserPhoto: snapshot.data.docs[index]
                                        .data()['UserPhoto'],
                                    DocID: doc2,
                                    Title: snapshot.data.docs[index]
                                        .data()['Title']
                                        .toString(),
                                    Author: snapshot.data.docs[index]
                                        .data()['UserName']
                                        .toString(),
                                    Story: Story.split('< NEW PART BEGINS >'),
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
                                height: 340,
                                width: 252,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot.data.docs[index]
                                              .data()['TitleImage'],

                                          // height: 400,
                                          // width: 150,
                                        ),
                                      )),
                                    ),
                                    Container(
                                      height: 150,
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
                                    Text(
                                        snapshot.data.docs[index]
                                            .data()['Title'],
                                        style: GoogleFonts.balthazar(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 8),
                                    Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('$Views Views',
                                            style: TextStyle(fontSize: 18)),
                                        Text('5 mins read',
                                            style: TextStyle(fontSize: 18)),
                                        Row(
                                          textBaseline:
                                              TextBaseline.ideographic,
                                          children: [
                                            Text('$Rating',
                                                style: TextStyle(fontSize: 18)),
                                            Icon(Icons.star_rate_rounded),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 11),
                                    Container(
                                      child: Text(
                                        Description.join(' '),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                        .data.docs[index]
                                                        .data()['UserPhoto'],
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
            if (index == 3) {
              return FutureBuilder(
                // future: function3,
                future: LoadStoriesPopularTrending(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 450,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Rating = snapshot.data.docs[index].data()['Rating'];
                          Views = NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(snapshot.data.docs[index].data()['Views']);
                          AverageTime =
                              snapshot.data.docs[index].data()['Average Time'];
                          List Description =
                              snapshot.data.docs[index].data()['Description'];
                          return FlatButton(
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
                                    DocID: doc2,
                                    Title: snapshot.data.docs[index]
                                        .data()['Title'],
                                    Author: snapshot.data.docs[index]
                                        .data()['UserName'],
                                    Story: Story.split('< NEW PART BEGINS >'),
                                    Characters: snapshot.data.docs[index]
                                        .data()['Characters'],
                                    StoryUserID: snapshot.data.docs[index]
                                        .data()['UserID'],
                                    StoryUserPhoto: snapshot.data.docs[index]
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
                                height: 340,
                                width: 252,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot.data.docs[index]
                                              .data()['TitleImage'],

                                          // height: 400,
                                          // width: 150,
                                        ),
                                      )),
                                    ),
                                    Container(
                                      height: 150,
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
                                    Text(
                                        snapshot.data.docs[index]
                                            .data()['Title'],
                                        style: GoogleFonts.balthazar(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 8),
                                    Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('$Views Views',
                                            style: TextStyle(fontSize: 18)),
                                        Text('5 mins read',
                                            style: TextStyle(fontSize: 18)),
                                        Row(
                                          textBaseline:
                                              TextBaseline.ideographic,
                                          children: [
                                            Text('$Rating',
                                                style: TextStyle(fontSize: 18)),
                                            Icon(Icons.star_rate_rounded),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 11),
                                    Container(
                                      child: Text(
                                        Description.join(' '),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                        .data.docs[index]
                                                        .data()['UserPhoto'],
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
            if (index >= 4) {
              return FutureBuilder(
                future: LoadStories(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 190,
                      child: ListView.separated(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                              child: FlatButton(
                                color: Color(0xFFC8FDE2),
                                padding: EdgeInsets.all(0),
                                onPressed: () async {
                                  DocumentReference doc =
                                      stories.doc(snapshot.data.docs[index].id);
                                  DocumentReference userRef = FirebaseFirestore
                                      .instance
                                      .collection('Users')
                                      .doc(snapshot.data.docs[index]
                                          .data()['UserID']);
                                  String doc2 = doc.id;
                                  String Story =
                                      snapshot.data.docs[index].data()['Story'];
                                  int Rating = snapshot.data.docs[index]
                                      .data()['Rating'];
                                  String Views = NumberFormat.compactCurrency(
                                    decimalDigits: 0,
                                    symbol:
                                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                                  ).format(snapshot.data.docs[index]
                                      .data()['Views']);
                                  int AverageTime = snapshot.data.docs[index]
                                      .data()['Average Time'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoryRead(
                                        DocID: doc2,
                                        Title: snapshot.data.docs[index]
                                            .data()['Title']
                                            .toString(),
                                        TitleImage: snapshot.data.docs[index]
                                            .data()['TitleImage'],
                                        Author: snapshot.data.docs[index]
                                            .data()['UserName']
                                            .toString(),
                                        StoryUserPhoto: snapshot
                                            .data.docs[index]
                                            .data()['UserPhoto'],
                                        Story:
                                            Story.split('< NEW PART BEGINS >'),
                                        // Characters: snapshot
                                        //     .data.docs[index]
                                        //     .data()['Characters'],
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
                                      .get()
                                      .then((value) {
                                    if (value.exists == false) {
                                      firestore
                                          .runTransaction((transaction) async {
                                        // Get the document

                                        DocumentSnapshot snapshot =
                                            await transaction.get(userRef);
                                        // Update the follower count based on the current count
                                        int views =
                                            snapshot.data()['TotalViews'] + 1;

                                        // Perform an update on the document
                                        transaction.update(
                                            userRef, {'TotalViews': views});
                                      });

                                      firestore
                                          .runTransaction((transaction) async {
                                        // Get the document

                                        DocumentSnapshot snapshot =
                                            await transaction.get(firestore
                                                .collection('Users')
                                                .doc(userRef.id));

                                        // Update the follower count based on the current count
                                        int views =
                                            snapshot.data()['MonthlyViews'] + 1;

                                        // Perform an update on the document
                                        transaction.update(
                                            userRef, {'MonthlyViews': views});
                                      });
                                      firestore
                                          .runTransaction((transaction) async {
                                        // Get the document

                                        DocumentSnapshot snapshot =
                                            await transaction.get(doc);

                                        if (!snapshot.exists) {
                                          throw Exception(
                                              "User does not exist!");
                                        }

                                        // Update the follower count based on the current count
                                        int views =
                                            snapshot.data()['Views'] + 1;

                                        // Perform an update on the document
                                        transaction
                                            .update(doc, {'Views': views});
                                      });
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
                                    } else {}
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(31)),
                                  width: double.infinity,
                                  height: 190,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 136,
                                        child: Container(
                                          height: 190,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(21),
                                                  topLeft: Radius.circular(21),
                                                  topRight: Radius.zero,
                                                  bottomRight: Radius.zero)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(21),
                                                topLeft: Radius.circular(21),
                                                topRight: Radius.zero,
                                                bottomRight: Radius.zero),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: snapshot.data
                                                                    .docs[index]
                                                                    .data()[
                                                                'TitleImage'] ==
                                                            null
                                                        ? NetworkImage(
                                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ1mp1Me8Nu3Mt2HKYaYGbffVX8I7v83p1lHA&usqp=CAU')
                                                        : NetworkImage(snapshot
                                                                .data
                                                                .docs[index]
                                                                .data()[
                                                            'TitleImage']),
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.3),
                                      Expanded(
                                        flex: 281,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFC8FDE2),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(31),
                                                topRight: Radius.circular(31),
                                                topLeft: Radius.zero,
                                                bottomLeft: Radius.zero),
                                          ),
                                          width: 235,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(height: 2),
                                              Center(
                                                child: Text(
                                                  snapshot.data.docs[index]
                                                                  .data()[
                                                              'Title'] ==
                                                          null
                                                      ? 'NO TEXT'
                                                      : snapshot
                                                          .data.docs[index]
                                                          .data()['Title'],
                                                  style: (GoogleFonts.balthazar(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 20,
                                                    fontStyle: FontStyle.italic,
                                                  )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6.2,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    12, 0, 12, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text('$Views Views'),
                                                    Text('12 mins read'),
                                                    Row(
                                                      children: [
                                                        Text('$Rating'),
                                                        Icon(Icons
                                                            .star_rate_rounded),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 6.2),
                                              Text(
                                                snapshot.data.docs[index]
                                                            .data()[
                                                                'Description']
                                                            .join(' ') ==
                                                        null
                                                    ? 'NO TEXT'
                                                    : snapshot.data.docs[index]
                                                        .data()['Description']
                                                        .join(' '),
                                                style: (GoogleFonts.signika()),
                                              ),
                                              SizedBox(height: 9.8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 2.3,
                                                      ),
                                                      Text(
                                                        snapshot.data.docs[index]
                                                                        .data()[
                                                                    'UserName'] ==
                                                                null
                                                            ? 'NO UID'
                                                            : snapshot.data
                                                                    .docs[index]
                                                                    .data()[
                                                                'UserName'],
                                                        style:
                                                            (GoogleFonts.aladin(
                                                                fontSize: 17)),
                                                      ),
                                                    ],
                                                  ),
                                                  // SizedBox(width: 3),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    UserViewer(
                                                              UserName:
                                                                  UserName,
                                                              UserEmail:
                                                                  UserEmail,
                                                              UserID: UserID,
                                                              UserPhoto:
                                                                  UserPhoto,
                                                              StoryUserID: snapshot
                                                                      .data
                                                                      .docs[index]
                                                                      .data()[
                                                                  'UserID'],
                                                              StoryUserName: snapshot
                                                                      .data
                                                                      .docs[index]
                                                                      .data()[
                                                                  'UserName'],
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
                                                        radius: 25,
                                                        child: snapshot.data
                                                                        .docs[index]
                                                                        .data()[
                                                                    'UserPhoto'] ==
                                                                null
                                                            ? Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .account_circle,
                                                                  size: 50,
                                                                ),
                                                              )
                                                            : Container(
                                                                height: 0,
                                                                width: 0,
                                                              ),
                                                        backgroundImage: snapshot
                                                                        .data
                                                                        .docs[index]
                                                                        .data()[
                                                                    'UserPhoto'] ==
                                                                null
                                                            ? NetworkImage(
                                                                'https://images.everydayhealth.com/images/despite-more-dieting--americans-still-arent-losing-weight-722x406.jpg')
                                                            : NetworkImage(snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .data()[
                                                                'UserPhoto']),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          if (index != 0 && index % 6 == 0) {
                            return Container(
                              child: Container(
                                height: 180,
                                width: 360,
                                child: Card(
                                  child: NativeAdmob(
                                    options: NativeAdmobOptions(
                                        headlineTextStyle:
                                            NativeTextStyle(fontSize: 44),
                                        bodyTextStyle:
                                            NativeTextStyle(fontSize: 44),
                                        advertiserTextStyle:
                                            NativeTextStyle(fontSize: 77)),
                                    adUnitID:
                                        'ca-app-pub-4144128581194892/2113810299',
                                    controller: controller,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
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
            return Container();
          },
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

Widget FBuilderNormal(Future<QuerySnapshot> function, String UserID,
    String UserName, String Views, int Rating, String UserEmail, UserPhoto) {
  return FutureBuilder(
    future: function,
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Expanded(
          child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                    child: FlatButton(
                      color: Color(0xFFC8FDE2),
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        DocumentReference doc =
                            stories.doc(snapshot.data.docs[index].id);
                        DocumentReference userRef = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(snapshot.data.docs[index].data()['UserID']);
                        String doc2 = doc.id;
                        String Story =
                            snapshot.data.docs[index].data()['Story'];
                        int Rating = snapshot.data.docs[index].data()['Rating'];
                        String Views = NumberFormat.compactCurrency(
                          decimalDigits: 0,
                          symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                        ).format(snapshot.data.docs[index].data()['Views']);
                        int AverageTime =
                            snapshot.data.docs[index].data()['Average Time'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryRead(
                              DocID: doc2,
                              Title: snapshot.data.docs[index]
                                  .data()['Title']
                                  .toString(),
                              TitleImage: snapshot.data.docs[index]
                                  .data()['TitleImage'],
                              Author: snapshot.data.docs[index]
                                  .data()['UserName']
                                  .toString(),
                              StoryUserPhoto:
                                  snapshot.data.docs[index].data()['UserPhoto'],
                              Story: Story.split('< NEW PART BEGINS >'),
                              // Characters: snapshot
                              //     .data.docs[index]
                              //     .data()['Characters'],
                              StoryUserID:
                                  snapshot.data.docs[index].data()['UserID'],
                            ),
                          ),
                        );
                        DocumentSnapshot viewers = await FirebaseFirestore
                            .instance
                            .collection('Stories')
                            .doc(doc2)
                            .collection('UsersViewed')
                            .doc(UserID)
                            .get()
                            .then((value) {
                          if (value.exists == false) {
                            FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              // Get the document

                              DocumentSnapshot snapshot =
                                  await transaction.get(userRef);
                              // Update the follower count based on the current count
                              int views = snapshot.data()['TotalViews'] + 1;

                              // Perform an update on the document
                              transaction
                                  .update(userRef, {'TotalViews': views});
                            });

                            FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              // Get the document

                              DocumentSnapshot snapshot = await transaction.get(
                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(userRef.id));

                              // Update the follower count based on the current count
                              int views = snapshot.data()['MonthlyViews'] + 1;

                              // Perform an update on the document
                              transaction
                                  .update(userRef, {'MonthlyViews': views});
                            });
                            FirebaseFirestore.instance
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
                            });
                            FirebaseFirestore.instance
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
                          } else {}
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(31)),
                        width: double.infinity,
                        height: 190,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 136,
                              child: Container(
                                height: 190,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(21),
                                        topLeft: Radius.circular(21),
                                        topRight: Radius.zero,
                                        bottomRight: Radius.zero)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(21),
                                      topLeft: Radius.circular(21),
                                      topRight: Radius.zero,
                                      bottomRight: Radius.zero),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: snapshot.data.docs[index]
                                                      .data()['TitleImage'] ==
                                                  null
                                              ? NetworkImage(
                                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ1mp1Me8Nu3Mt2HKYaYGbffVX8I7v83p1lHA&usqp=CAU')
                                              : NetworkImage(snapshot
                                                  .data.docs[index]
                                                  .data()['TitleImage']),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 2.3),
                            Expanded(
                              flex: 281,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFC8FDE2),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(31),
                                      topRight: Radius.circular(31),
                                      topLeft: Radius.zero,
                                      bottomLeft: Radius.zero),
                                ),
                                width: 235,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(height: 2),
                                    Center(
                                      child: Text(
                                        snapshot.data.docs[index]
                                                    .data()['Title'] ==
                                                null
                                            ? 'NO TEXT'
                                            : snapshot.data.docs[index]
                                                .data()['Title'],
                                        style: (GoogleFonts.balthazar(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                        )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.2,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('$Views Views'),
                                          Text('12 mins read'),
                                          Row(
                                            children: [
                                              Text('$Rating'),
                                              Icon(Icons.star_rate_rounded),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6.2),
                                    Text(
                                      snapshot.data.docs[index]
                                                  .data()['Description']
                                                  .join(' ') ==
                                              null
                                          ? 'NO TEXT'
                                          : snapshot.data.docs[index]
                                              .data()['Description']
                                              .join(' '),
                                      style: (GoogleFonts.signika()),
                                    ),
                                    SizedBox(height: 9.8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 2.3,
                                            ),
                                            Text(
                                              snapshot.data.docs[index]
                                                          .data()['UserName'] ==
                                                      null
                                                  ? 'NO UID'
                                                  : snapshot.data.docs[index]
                                                      .data()['UserName'],
                                              style: (GoogleFonts.aladin(
                                                  fontSize: 17)),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(width: 3),
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
                                                        .data.docs[index]
                                                        .data()['UserPhoto'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 25,
                                              child: snapshot.data.docs[index]
                                                              .data()[
                                                          'UserPhoto'] ==
                                                      null
                                                  ? Center(
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        size: 50,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                              backgroundImage: snapshot
                                                              .data.docs[index]
                                                              .data()[
                                                          'UserPhoto'] ==
                                                      null
                                                  ? NetworkImage(
                                                      'https://images.everydayhealth.com/images/despite-more-dieting--americans-still-arent-losing-weight-722x406.jpg')
                                                  : NetworkImage(snapshot
                                                      .data.docs[index]
                                                      .data()['UserPhoto']),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
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

FBuilderProStory(
  Future<QuerySnapshot> function,
  Future<QuerySnapshot> function1,
  Future<QuerySnapshot> function2,
  Future<QuerySnapshot> function3,
  Future<QuerySnapshot> function4,
  String UserID,
  String UserName,
  String Views,
  int Rating,
  String UserEmail,
  UserPhoto,
) {
  return FutureBuilder(
    future: function1,
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Expanded(
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length + 4,
              itemBuilder: (BuildContext context, int index) {
                // print(snapshot.data.docs[0].data()['UserName']);
                return Container(
                  height: 0,
                  width: index.toDouble(),
                );
              },
              separatorBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'People To Follow',
                        style: GoogleFonts.robotoCondensed(fontSize: 22),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                        future: function2,
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              height: 95,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: false,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 95,
                                    width: 90,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: CircleAvatar(
                                            radius: 29,
                                            backgroundImage: NetworkImage(
                                              snapshot.data.docs[index]
                                                  .data()['UserPhoto'],
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            snapshot.data.docs[index]
                                                .data()['UserName'],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.none) {
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
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                } else if (index == 1) {
                  return FutureBuilder(
                    future: function3,
                    //  future: LoadStoriesPopularTrending(randomNo),.
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: 340,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Rating =
                                  snapshot.data.docs[index].data()['Rating'];
                              Views = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol:
                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                              ).format(
                                  snapshot.data.docs[index].data()['Views']);
                              AverageTime = snapshot.data.docs[index]
                                  .data()['Average Time'];
                              List Description = snapshot.data.docs[index]
                                  .data()['Description'];
                              return FlatButton(
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
                                    height: 340,
                                    width: 252,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data.docs[index]
                                                  .data()['TitleImage'],

                                              // height: 400,
                                              // width: 150,
                                            ),
                                          )),
                                        ),
                                        Container(
                                          height: 150,
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
                                        Text(
                                            snapshot.data.docs[index]
                                                .data()['Title'],
                                            style: GoogleFonts.balthazar(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(height: 8),
                                        Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('$Views Views',
                                                style: TextStyle(fontSize: 18)),
                                            Text('5 mins read',
                                                style: TextStyle(fontSize: 18)),
                                            Row(
                                              textBaseline:
                                                  TextBaseline.ideographic,
                                              children: [
                                                Text('$Rating',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Icon(Icons.star_rate_rounded),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 11),
                                        Container(
                                          child: Text(
                                            Description.join(' '),
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
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
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
                } else if (index == 2) {
                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Stories In SciFi',
                        style: GoogleFonts.robotoCondensed(fontSize: 22),
                      ),
                      // SizedBox(height: 15),
                    ],
                  );
                } else if (index == 3) {
                  return FutureBuilder(
                    future: function3,
                    //  future: LoadStoriesPopularTrending(randomNo),.
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: 450,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Rating =
                                  snapshot.data.docs[index].data()['Rating'];
                              Views = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol:
                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                              ).format(
                                  snapshot.data.docs[index].data()['Views']);
                              AverageTime = snapshot.data.docs[index]
                                  .data()['Average Time'];
                              List Description = snapshot.data.docs[index]
                                  .data()['Description'];
                              return FlatButton(
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
                                        DocID: doc2,
                                        Title: snapshot.data.docs[index]
                                            .data()['Title'],
                                        Author: snapshot.data.docs[index]
                                            .data()['UserName'],
                                        Story:
                                            Story.split('< NEW PART BEGINS >'),
                                        Characters: snapshot.data.docs[index]
                                            .data()['Characters'],
                                        StoryUserID: snapshot.data.docs[index]
                                            .data()['UserID'],
                                        StoryUserPhoto: snapshot
                                            .data.docs[index]
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
                                    height: 340,
                                    width: 252,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data.docs[index]
                                                  .data()['TitleImage'],

                                              // height: 400,
                                              // width: 150,
                                            ),
                                          )),
                                        ),
                                        Container(
                                          height: 150,
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
                                        Text(
                                            snapshot.data.docs[index]
                                                .data()['Title'],
                                            style: GoogleFonts.balthazar(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(height: 8),
                                        Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('$Views Views',
                                                style: TextStyle(fontSize: 18)),
                                            Text('5 mins read',
                                                style: TextStyle(fontSize: 18)),
                                            Row(
                                              textBaseline:
                                                  TextBaseline.ideographic,
                                              children: [
                                                Text('$Rating',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Icon(Icons.star_rate_rounded),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 11),
                                        Container(
                                          child: Text(
                                            Description.join(' '),
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
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
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
                } else if (index >= 4) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reccomended For You',
                        style: GoogleFonts.robotoCondensed(fontSize: 22),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListBuilder(index - 4, snapshot, UserID, UserName,
                          UserPhoto, UserEmail, Views, Rating, context),
                    ],
                  );
                }
              }),
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

ListBuilder(index, snapshot, UserID, UserName, UserPhoto, UserEmail, Views,
    Rating, context) {
  FBuilderLegend(Future<QuerySnapshot> function, String UserID, String UserName,
      String Views, int Rating, String UserEmail, UserPhoto) {
    return FutureBuilder(
      future: function,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: 190,
            child: ListView.separated(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                    child: FlatButton(
                      color: Color(0xFFC8FDE2),
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        DocumentReference doc =
                            stories.doc(snapshot.data.docs[index].id);
                        DocumentReference userRef = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(snapshot.data.docs[index].data()['UserID']);
                        String doc2 = doc.id;
                        String Story =
                            snapshot.data.docs[index].data()['Story'];
                        int Rating = snapshot.data.docs[index].data()['Rating'];
                        String Views = NumberFormat.compactCurrency(
                          decimalDigits: 0,
                          symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                        ).format(snapshot.data.docs[index].data()['Views']);
                        int AverageTime =
                            snapshot.data.docs[index].data()['Average Time'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryRead(
                              DocID: doc2,
                              Title: snapshot.data.docs[index]
                                  .data()['Title']
                                  .toString(),
                              TitleImage: snapshot.data.docs[index]
                                  .data()['TitleImage'],
                              Author: snapshot.data.docs[index]
                                  .data()['UserName']
                                  .toString(),
                              StoryUserPhoto:
                                  snapshot.data.docs[index].data()['UserPhoto'],
                              Story: Story.split('< NEW PART BEGINS >'),
                              // Characters: snapshot
                              //     .data.docs[index]
                              //     .data()['Characters'],
                              StoryUserID:
                                  snapshot.data.docs[index].data()['UserID'],
                            ),
                          ),
                        );
                        DocumentSnapshot viewers = await firestore
                            .collection('Stories')
                            .doc(doc2)
                            .collection('UsersViewed')
                            .doc(UserID)
                            .get()
                            .then((value) {
                          if (value.exists == false) {
                            firestore.runTransaction((transaction) async {
                              // Get the document

                              DocumentSnapshot snapshot =
                                  await transaction.get(userRef);
                              // Update the follower count based on the current count
                              int views = snapshot.data()['TotalViews'] + 1;

                              // Perform an update on the document
                              transaction
                                  .update(userRef, {'TotalViews': views});
                            });

                            firestore.runTransaction((transaction) async {
                              // Get the document

                              DocumentSnapshot snapshot = await transaction.get(
                                  firestore
                                      .collection('Users')
                                      .doc(userRef.id));

                              // Update the follower count based on the current count
                              int views = snapshot.data()['MonthlyViews'] + 1;

                              // Perform an update on the document
                              transaction
                                  .update(userRef, {'MonthlyViews': views});
                            });
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
                            });
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
                          } else {}
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(31)),
                        width: double.infinity,
                        height: 190,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 136,
                              child: Container(
                                height: 190,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(21),
                                        topLeft: Radius.circular(21),
                                        topRight: Radius.zero,
                                        bottomRight: Radius.zero)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(21),
                                      topLeft: Radius.circular(21),
                                      topRight: Radius.zero,
                                      bottomRight: Radius.zero),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: snapshot.data.docs[index]
                                                      .data()['TitleImage'] ==
                                                  null
                                              ? NetworkImage(
                                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ1mp1Me8Nu3Mt2HKYaYGbffVX8I7v83p1lHA&usqp=CAU')
                                              : NetworkImage(snapshot
                                                  .data.docs[index]
                                                  .data()['TitleImage']),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 2.3),
                            Expanded(
                              flex: 281,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFC8FDE2),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(31),
                                      topRight: Radius.circular(31),
                                      topLeft: Radius.zero,
                                      bottomLeft: Radius.zero),
                                ),
                                width: 235,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(height: 2),
                                    Center(
                                      child: Text(
                                        snapshot.data.docs[index]
                                                    .data()['Title'] ==
                                                null
                                            ? 'NO TEXT'
                                            : snapshot.data.docs[index]
                                                .data()['Title'],
                                        style: (GoogleFonts.balthazar(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                        )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.2,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('$Views Views'),
                                          Text('12 mins read'),
                                          Row(
                                            children: [
                                              Text('$Rating'),
                                              Icon(Icons.star_rate_rounded),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6.2),
                                    Text(
                                      snapshot.data.docs[index]
                                                  .data()['Description']
                                                  .join(' ') ==
                                              null
                                          ? 'NO TEXT'
                                          : snapshot.data.docs[index]
                                              .data()['Description']
                                              .join(' '),
                                      style: (GoogleFonts.signika()),
                                    ),
                                    SizedBox(height: 9.8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 2.3,
                                            ),
                                            Text(
                                              snapshot.data.docs[index]
                                                          .data()['UserName'] ==
                                                      null
                                                  ? 'NO UID'
                                                  : snapshot.data.docs[index]
                                                      .data()['UserName'],
                                              style: (GoogleFonts.aladin(
                                                  fontSize: 17)),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(width: 3),
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
                                                        .data.docs[index]
                                                        .data()['UserPhoto'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 25,
                                              child: snapshot.data.docs[index]
                                                              .data()[
                                                          'UserPhoto'] ==
                                                      null
                                                  ? Center(
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        size: 50,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                              backgroundImage: snapshot
                                                              .data.docs[index]
                                                              .data()[
                                                          'UserPhoto'] ==
                                                      null
                                                  ? NetworkImage(
                                                      'https://images.everydayhealth.com/images/despite-more-dieting--americans-still-arent-losing-weight-722x406.jpg')
                                                  : NetworkImage(snapshot
                                                      .data.docs[index]
                                                      .data()['UserPhoto']),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                if (index != 0 && index % 6 == 0) {
                  return Container(
                    child: Container(
                      height: 180,
                      width: 360,
                      child: Card(
                        child: NativeAdmob(
                          options: NativeAdmobOptions(
                              headlineTextStyle: NativeTextStyle(fontSize: 44),
                              bodyTextStyle: NativeTextStyle(fontSize: 44),
                              advertiserTextStyle:
                                  NativeTextStyle(fontSize: 77)),
                          adUnitID: 'ca-app-pub-4144128581194892/2113810299',
                          controller: controller,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
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
}

FBuilderProArticle(
  Future<QuerySnapshot> function,
  Future<QuerySnapshot> function1,
  Future<QuerySnapshot> function2,
  Future<QuerySnapshot> function3,
  Future<QuerySnapshot> function4,
  String UserID,
  String UserName,
  String Views,
  int Rating,
  String UserEmail,
  UserPhoto,
) {
  return FutureBuilder(
    future: function1,
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Expanded(
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length + 4,
              itemBuilder: (BuildContext context, int index) {
                // print(snapshot.data.docs[0].data()['UserName']);
                return Container(
                  height: 0,
                  width: index.toDouble(),
                );
              },
              separatorBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'People To Follow',
                        style: GoogleFonts.robotoCondensed(fontSize: 22),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                        future: function2,
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              height: 95,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: false,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 95,
                                    width: 90,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: CircleAvatar(
                                            radius: 29,
                                            backgroundImage: NetworkImage(
                                              snapshot.data.docs[index]
                                                  .data()['UserPhoto'],
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            snapshot.data.docs[index]
                                                .data()['UserName'],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.none) {
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
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                } else if (index == 1) {
                  return FutureBuilder(
                    future: function3,
                    //  future: LoadStoriesPopularTrending(randomNo),.
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: 340,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Rating =
                                  snapshot.data.docs[index].data()['Rating'];
                              Views = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol:
                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                              ).format(
                                  snapshot.data.docs[index].data()['Views']);
                              AverageTime = snapshot.data.docs[index]
                                  .data()['Average Time'];
                              List Description = snapshot.data.docs[index]
                                  .data()['Description'];
                              return FlatButton(
                                onPressed: () async {
                                  String Story = snapshot.data.docs[index]
                                      .data()['Article'];

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
                                      .collection('Article')
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
                                                  .collection('Article')
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
                                    height: 340,
                                    width: 252,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data.docs[index]
                                                  .data()['TitleImage'],

                                              // height: 400,
                                              // width: 150,
                                            ),
                                          )),
                                        ),
                                        Container(
                                          height: 150,
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
                                        Text(
                                            snapshot.data.docs[index]
                                                .data()['Title'],
                                            style: GoogleFonts.balthazar(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(height: 8),
                                        Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('$Views Views',
                                                style: TextStyle(fontSize: 18)),
                                            Text('5 mins read',
                                                style: TextStyle(fontSize: 18)),
                                            Row(
                                              textBaseline:
                                                  TextBaseline.ideographic,
                                              children: [
                                                Text('$Rating',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Icon(Icons.star_rate_rounded),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 11),
                                        Container(
                                          child: Text(
                                            Description.join(' '),
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
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
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
                } else if (index == 2) {
                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Stories In SciFi',
                        style: GoogleFonts.robotoCondensed(fontSize: 22),
                      ),
                      // SizedBox(height: 15),
                    ],
                  );
                } else if (index == 3) {
                  return FutureBuilder(
                    future: function3,
                    //  future: LoadStoriesPopularTrending(randomNo),.
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: 450,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Rating =
                                  snapshot.data.docs[index].data()['Rating'];
                              Views = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol:
                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                              ).format(
                                  snapshot.data.docs[index].data()['Views']);
                              AverageTime = snapshot.data.docs[index]
                                  .data()['Average Time'];
                              List Description = snapshot.data.docs[index]
                                  .data()['Description'];
                              return FlatButton(
                                onPressed: () async {
                                  String Story = snapshot.data.docs[index]
                                      .data()['Article'];

                                  DocumentReference doc =
                                      stories.doc(snapshot.data.docs[index].id);
                                  String doc2 = doc.id;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoryRead(
                                        TitleImage: snapshot.data.docs[index]
                                            .data()['TitleImage'],
                                        DocID: doc2,
                                        Title: snapshot.data.docs[index]
                                            .data()['Title'],
                                        Author: snapshot.data.docs[index]
                                            .data()['UserName'],
                                        Story:
                                            Story.split('< NEW PART BEGINS >'),
                                        Characters: snapshot.data.docs[index]
                                            .data()['Characters'],
                                        StoryUserID: snapshot.data.docs[index]
                                            .data()['UserID'],
                                        StoryUserPhoto: snapshot
                                            .data.docs[index]
                                            .data()['UserPhoto'],
                                      ),
                                    ),
                                  );
                                  DocumentSnapshot viewers = await firestore
                                      .collection('Articles')
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
                                                  .collection('Articles')
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
                                    height: 340,
                                    width: 252,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data.docs[index]
                                                  .data()['TitleImage'],

                                              // height: 400,
                                              // width: 150,
                                            ),
                                          )),
                                        ),
                                        Container(
                                          height: 150,
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
                                        Text(
                                            snapshot.data.docs[index]
                                                .data()['Title'],
                                            style: GoogleFonts.balthazar(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(height: 8),
                                        Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('$Views Views',
                                                style: TextStyle(fontSize: 18)),
                                            Text('5 mins read',
                                                style: TextStyle(fontSize: 18)),
                                            Row(
                                              textBaseline:
                                                  TextBaseline.ideographic,
                                              children: [
                                                Text('$Rating',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Icon(Icons.star_rate_rounded),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 11),
                                        Container(
                                          child: Text(
                                            Description.join(' '),
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
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
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
                } else if (index >= 4) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reccomended For You',
                        style: GoogleFonts.robotoCondensed(fontSize: 22),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListBuilder(index - 4, snapshot, UserID, UserName,
                          UserPhoto, UserEmail, Views, Rating, context),
                    ],
                  );
                }
              }),
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

Widget UsersPhotos(Future<QuerySnapshot> LoadUsers()) {
  return FutureBuilder(
    future: LoadUsers(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Container(
          height: 95,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: false,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              //     String NameOfUser = firestore.collection('collectionPath')
              return Container(
                height: 95,
                width: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 29,
                        backgroundImage: NetworkImage(
                          snapshot.data.docs[index].data()['UserPhoto'],
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        snapshot.data.docs[index].data()['UserName'],
                      ),
                    ),
                    SizedBox(width: 5),
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

*/










// ! STORY WORKSPECE


 // TODO pata nahi kya

 

// String Title;
// List Description;
// File TitleImageFile;
// List<String> TagSelected = [];
// FontWeight style = FontWeight.normal;
// List<String> DescriptionInList;
// DocumentReference doc;
// DocumentReference StoryDraftDoc;
// String TitleImage;
// String Story;
// String StoryHtml;
// List<String> Tags = [];
// String ImageLink;
// String TextForLink;
// String LinkText;
// Color ColorSelected = Colors.white;
//   Random randomNo = Random();
// //  inputFormatters: [
//   //   FilteringTextInputFormatter.allow(
//   //       RegExp("[a-zA-Z'\",%^. ()&%\$@#!~*+_:;/|\\-]")),
//   // ]
//   Future getImage() async {
//     ImagePicker imagePicker = ImagePicker();
//     var imageOne = await imagePicker.getImage(
//         source: ImageSource.gallery, imageQuality: 100);

//     setState(() {
//       TitleImageFile = File(imageOne.path);
//     });
//   }

//   @override
//   void initState() {
//     if (widget.Story == null) {
//     } else {
//       c3.text = widget.Story;
//     }

//     if (widget.UserID == null) {
//       LoadUserData();
//     } else {
//       UserName = widget.UserName;
//       UserEmail = widget.UserEmail;
//       UserID = widget.UserID;
//       UserPhoto = widget.UserPhoto;
//     }
//     if (widget.TitleImage != null) {
//       setState(() {
//         TitleImage = widget.TitleImage;
//       });
//     }
//     LoadTags();
//     c3.text = '';

//     print(randomNo);
//   }

//   @override
//   Widget build(BuildContext context) {
// StorageReference TitleImageStorage = FirebaseStorage.instance
//     .ref()
//     .child('TitleImage/')
//     .child(UserID)
//     .child('Story Title Images//');

// StorageReference StoryImageStorage = FirebaseStorage.instance
//     .ref()
//     .child('StoryImage/')
//     .child(UserID)
//     .child('StoryImages/${randomNo.toString()}');

// Future GetImagesFromGallery() async {
//   setState(() {
//     randomNo = Random();
//   });
//   print(randomNo);
//   ImagePicker imagePicker = ImagePicker();
//   var imageOne = await imagePicker.getImage(
//       source: ImageSource.gallery, imageQuality: 100);
//   while (StoryImageStorage.child(randomNo.toString()) == null) {
//     await StoryImageStorage.putFile(File(imageOne.path))
//         .onComplete
//         .then((value) => () {
//               setState(() async {
//                 ImageLink = await value.ref.getDownloadURL();
//                 randomNo = Random();
//               });
//             });
//   }
// }

// Future GetImagesFromCamera() async {
//   ImagePicker imagePicker = ImagePicker();
//   var imageOne = await imagePicker.getImage(
//       source: ImageSource.camera, imageQuality: 100);
//   StoryImageStorage.putFile(File(imageOne.path))
//       .onComplete
//       .then((value) => () {
//             setState(() async {
//               ImageLink = await value.ref.getDownloadURL();
//             });
//           });
// }

//     return Scaffold(
//       backgroundColor: Color(0xFFfff5ee),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 11),
//               Center(
//                   child: Text(
//                 'Start Writing Here',
//                 style: GoogleFonts.acme(fontSize: 23),
//               )),
//               SizedBox(height: 34),
//               Text(
//                 'Give Title Of Your Story',
//                 style: GoogleFonts.aldrich(
//                   fontSize: 19,
//                   color: Color(0xFF005b96),
//                 ),
//               ),
//               SizedBox(height: 11),
//               TextFormField(
//                 initialValue: widget.Title == null ? null : widget.Title,
//                 maxLength: 25,
//                 controller: c1,
//                 onChanged: (value) {
//                   setState(() {
//                     Title = value;
//                   });
//                 },
//                 style: TextStyle(fontWeight: style),
//                 decoration: InputDecoration(
//                   fillColor: Colors.lightBlueAccent[400],
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                     borderSide: BorderSide(
//                       width: 1.3,
//                       color: Colors.blue[300],
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                     borderSide: BorderSide(
//                       color: Colors.lightBlue[200],
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//               widget.TitleImage == null
//                   ? TitleImageFile == null
//                       ? Center(
//                           child: TextButton(
//                             padding: EdgeInsets.all(5),
//                             onPressed: () {
//                               getImage();
//                             },
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.add),
//                                 Text('Add Image',
//                                     style: TextStyle(fontSize: 19)),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Container(
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: FileImage(TitleImageFile),
//                                   fit: BoxFit.fill)),
//                           width: 350,
//                           height: 350,
//                           child: TextButton(
//                             padding: EdgeInsets.all(0),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       SeeImage(TitleImageFile: TitleImageFile),
//                                 ),
//                               );
//                             },
//                             child: null,
//                           ),
//                         )
//                   : Container(
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: NetworkImage(TitleImage),
//                               fit: BoxFit.fill)),
//                       width: 350,
//                       height: 350,
//                       child: TextButton(
//                         padding: EdgeInsets.all(0),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   SeeImage(TitleImage: TitleImage),
//                             ),
//                           );
//                         },
//                         child: null,
//                       ),
//                     ),
//               SizedBox(height: 11),
//               Text(
//                 'Give A Description Of Your Story',
//                 style: GoogleFonts.aldrich(
//                     fontSize: 19, color: Colors.lightBlueAccent[400]),
//               ),
//               SizedBox(height: 11),
//               TextFormField(
//                 initialValue:
//                     widget.Description == null ? null : widget.Description,
//                 controller: c2,
//                 maxLength: 190,
//                 maxLines: 5,
//                 onChanged: (value) {
//                   setState(() {
//                     DescriptionInList = value.split(' ');
//                   });
//                 },
//                 decoration: InputDecoration(
//                   fillColor: Colors.lightBlueAccent[400],
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                     borderSide: BorderSide(
//                       width: 1.5,
//                       color: Colors.blue[300],
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                     borderSide: BorderSide(
//                       color: Colors.lightBlue[200],
//                       width: 1.4,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 11),
//               Center(
//                 child: Text(
//                   'Write The Story',
//                   style: GoogleFonts.aldrich(
//                       fontSize: 19, color: Colors.lightBlueAccent[400]),
//                 ),
//               ),
//               SizedBox(height: 11),
//               TextFormField(
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 12,
//                 ),
//                 controller: c3,
//                 keyboardType: TextInputType.multiline,
//                 minLines: 8,
//                 maxLength: null,
//                 maxLines: null,
//                 onChanged: (value) {
//                   setState(() {
//                     Story = value;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   helperText:
//                       'Note!! Your Text Will not be shown inside  <!--   -->',
//                   helperStyle: GoogleFonts.ptSans(fontSize: 15),
//                   fillColor: Colors.black,
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                     borderSide: BorderSide(
//                       width: 1.3,
//                       color: Colors.blue[300],
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                     borderSide: BorderSide(
//                       color: Colors.lightBlue[200],
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Preview(
//                         Story: StoryHtml,
//                         Title: Title,
//                         TitleImage: TitleImage == null ? null : TitleImage,
//                         TitleImageFile:
//                             TitleImageFile == null ? null : TitleImageFile,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text('PREVIEW'),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     padding: EdgeInsets.all(0),
//                     child: SvgPicture.asset('Icons/bold (1).svg',
//                         height: 34, width: 17),
//                     onPressed: () {
//                       setState(() {
//                         c3.text = Story + '  * Write Here **  ';
//                         Story = c3.text;
//                       });
//                     },
//                   ),
//                   TextButton(
//                     padding: EdgeInsets.all(0),
//                     child: SvgPicture.asset(
//                       'Icons/italic.svg',
//                       height: 34,
//                       width: 17,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         c3.text = Story + '  ` Write Here ``  ';
//                         Story = c3.text;
//                       });
//                     },
//                   ),
//                   TextButton(
//                     padding: EdgeInsets.all(0),
//                     child: SvgPicture.asset('Icons/paragraph.svg',
//                         height: 34, width: 17),
//                     onPressed: () {
//                       setState(() {
//                         c3.text = Story + '  ~ Write Here ~~  ';
//                         Story = c3.text;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 3.54),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     padding: EdgeInsets.all(0),
//                     child: SvgPicture.asset(
//                       'Icons/add.svg',
//                       height: 44,
//                       width: 25,
//                     ),
// onPressed: () {
// showModalBottomSheet(
//     context: context,
//     builder: (BuildContext bc) {
//       return Container(
//         child: Wrap(
//           children: <Widget>[
//             TextButton(
//               padding: EdgeInsets.fromLTRB(11, 11, 0, 0),
//               child: ListTile(
//                 leading: SvgPicture.asset(
//                   'Icons/gallery.svg',
//                   height: 40,
//                   width: 22,
//                 ),
//                 title: Text('Gallery'),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 GetImagesFromGallery().then(
//                   (value) => () {
//                     setState(
//                       () {
//                         c3.text = Story +
//                             '  <img>$ImageLink</img>  ';
//                         Story = c3.text;
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//             TextButton(
//               padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
//               child: ListTile(
//                 leading: SvgPicture.asset(
//                   'Icons/camera.svg',
//                   height: 40,
//                   width: 22,
//                 ),
//                 title: Text('Camera'),
//               ),
//               onPressed: () {
//                 GetImagesFromCamera().then((value) => () {
//                       setState(
//                         () {
//                           c3.text = Story +
//                               '  <img>$ImageLink</img>  ';
//                           Story = c3.text;
//                         },
//                       );
//                     });
//               },
//             ),
//                 TextButton(
//                   padding: EdgeInsets.fromLTRB(11, 0, 0, 11),
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return Center(
//                           child: SingleChildScrollView(
//                             child: AlertDialog(
//                               title: Center(
//                                 child: Text(
//                                     'Give An Image Link'),
//                               ),
//                               content: ListBody(
//                                 children: <Widget>[
//                                   Center(
//                                     child: TextFormField(
//                                       onChanged: (value) {
//                                         setState(() {
//                                           ImageLink = value;
//                                         });
//                                       },
//                                       decoration:
//                                           InputDecoration(
//                                         fillColor: Colors
//                                                 .lightBlueAccent[
//                                             400],
//                                         focusedBorder:
//                                             OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius
//                                                   .circular(
//                                                       20.0),
//                                           borderSide:
//                                               BorderSide(
//                                             width: 1.5,
//                                             color: Colors
//                                                 .blue[300],
//                                           ),
//                                         ),
//                                         enabledBorder:
//                                             OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius
//                                                   .circular(
//                                                       20.0),
//                                           borderSide:
//                                               BorderSide(
//                                             color: Colors
//                                                     .lightBlue[
//                                                 200],
//                                             width: 1.4,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Center(
//                                     child: TextButton(
//                                         onPressed: () {
//                                           setState(
//                                             () {
//                                               c3.text = Story +
//                                                   ' <img>$ImageLink</img> ';
//                                               Story = c3.text;
//                                             },
//                                           );
//                                         },
//                                         child:
//                                             Text('Submit')),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: ListTile(
//                     leading: SvgPicture.asset(
//                       'Icons/folder.svg',
//                       height: 40,
//                       width: 20,
//                     ),
//                     title: Text('Network Image'),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   },
// ),
// TextButton(
//   padding: EdgeInsets.all(0),
//   child: SvgPicture.asset(
//     'Icons/link.svg',
//     height: 40,
//     width: 22,
//   ),
// onPressed: () {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Center(
//         child: SingleChildScrollView(
//           child: AlertDialog(
//             elevation: 0,
//             insetPadding: EdgeInsets.fromLTRB(5, 0, 5, 4),
//             contentPadding:
//                 EdgeInsets.fromLTRB(10, 4, 10, 12),
//             titlePadding: EdgeInsets.all(5),
//             title: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Center(
//                   child: Text('Add A Link',
//                       style:
//                           GoogleFonts.kavoon(fontSize: 22)),
//                 ),
//                 Spacer(),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(18),
//                   child: TextButton(
//                     padding: EdgeInsets.zero,
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: SvgPicture.asset(
//                       'Icons/cancel.svg',
//                       height: 40,
//                       width: 22,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             content: ListBody(
//               children: <Widget>[
//                 SizedBox(height: 2),
//                 Text('Enter The Text For The Link',
//                     style:
//                         GoogleFonts.kavoon(fontSize: 17)),
//                 SizedBox(height: 5),
//                 Center(
//                   child: TextFormField(
//                     onChanged: (value) {
//                       setState(() {
//                         TextForLink = value;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       fillColor:
//                           Colors.lightBlueAccent[400],
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 0.7,
//                           color: Colors.blue[300],
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.lightBlue[200],
//                           width: 0.71,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 7),
//                 Text('Enter The Link',
//                     style:
//                         GoogleFonts.kavoon(fontSize: 17)),
//                 SizedBox(height: 8),
//                 Center(
//                   child: TextFormField(
//                     onChanged: (value) {
//                       setState(() {
//                         LinkText = value;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       fillColor:
//                           Colors.lightBlueAccent[400],
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 0.7,
//                           color: Colors.blue[300],
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.lightBlue[200],
//                           width: 0.7,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: TextButton(
//                       onPressed: () {
//                         if (LinkText == null) {}
//                         if (TextForLink == null) {
//                           setState(
//                             () {
//                               // link:wux'''
//                               // Text[Link]
//                               c3.text = Story +
//                                   'Link : $LinkText {$TextForLink} ';
//                               Story = c3.text;
//                               // '  <a href="$LinkText">$LinkText</a>  ';
//                             },
//                           );
//                           Navigator.pop(context);
//                         }

//                         if (LinkText != null &&
//                             TextForLink != null) {
//                           setState(
//                             () {
//                               // link:wux'''
//                               // Text[Link]
//                               c3.text = Story +
//                                   'Link : $LinkText {$TextForLink} ';
//                               Story = c3.text;
//                               // '  <a href="$LinkText">$LinkText</a>  ';
//                             },
//                           );
//                           // setState(
//                           // () {
//                           // c3.text = Story +
//                           //     '  <a href="$LinkText">$TextForLink</a>  ';
//                           // StoryHtml = Story +
//                           //     '  <a href="$LinkText">$TextForLink</a>  ';
//                           //   },
//                           // );
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: Text('Submit')),
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// },
// ),
//                   TextButton(
//                     padding: EdgeInsets.all(0),
//                     child: SvgPicture.asset(
//                       'Icons/artist.svg',
//                       height: 40,
//                       width: 22,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         c3.text = Story + '  "Red" Write Here "Red" ';
//                         StoryHtml = Story +
//                             '  <p style = "color:red;"> Write Here </p>  ';
//                       });
//                     },
//                   ),
//                 ],
//               ),
// TextButton(
//     onPressed: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Preview(
//             Story: c3.text
//                 .replaceAll('**', '</b>')
//                 .replaceAll('*', '<b>')
//                 .replaceAll('``', '</em>')
//                 .replaceAll('Link:', 'Link :')
//                 .replaceAll('Link  :', 'Link :')
//                 .replaceAll('Link   :', 'Link :')
//                 .replaceAll('Link :', '<a href :" ')
//                 .replaceAll('{', '">')
//                 .replaceAll('}', '</a>'),
//           ),
//         ),
//       );
//     },
//     child: Text('PREVIEW 2 2')),
//               SizedBox(height: 12),
// ChipsChoice<String>.multiple(
//   itemConfig: ChipsChoiceItemConfig(),
//   value: TagSelected,
//   options: ChipsChoiceOption.listFrom<String, String>(
//     source: Tags,
//     value: (i, v) => v,
//     label: (i, v) => v,
//   ),
//   onChanged: (val) => setState(() => TagSelected = val),
//   isWrapped: true,
// ),
//               SizedBox(height: 12),
// Row(
//   children: [
//     TextButton(
//         child: Text('Add To Your Drafts'),
//         onPressed: () async {
//           if (TitleImage != null) {
//             doc == null
//                 ? firestore
//                     .collection('Users')
//                     .doc(UserID)
//                     .collection('StoriesDarft')
//                     .add(
//                     {
//                       'Description': DescriptionInList,
//                       'Title': Title,
//                       'TitleImage': TitleImage,
//                       'Story': Story,
//                       'Time': DateTime.now(),
//                       'Tag': TagSelected
//                     },
//                   ).then((value) {
//                     setState(() {
//                       StoryDraftDoc = value;
//                     });
//                   }).then((value) {
//                     firestore
//                         .collection('Users')
//                         .doc(StoryDraftDoc.id)
//                         .set({'doc': doc.id},
//                             SetOptions(merge: true));
//                   })
//                 : firestore
//                     .collection('Users')
//                     .doc(UserID)
//                     .collection('StoriesDarft')
//                     .doc(doc.path)
//                     .update(
//                     {
//                       'Description': DescriptionInList,
//                       'Title': Title,
//                       'TitleImage': TitleImage,
//                       'Story': Story,
//                       'Tag': TagSelected,
//                       'Time': DateTime.now(),
//                     },
//                   );
//           } else if (TitleImageFile != null) {
//             TitleImageStorage.putFile(TitleImageFile)
//                 .onComplete
//                 .then((value) => () async {
//                       String url =
//                           await value.ref.getDownloadURL();
//                       setState(() {
//                         TitleImage = url;
//                       });
//                     })
//                 .then((value) => () {
//                       doc == null
//                           ? firestore
//                               .collection('Users')
//                               .doc(UserID)
//                               .collection('StoriesDarft')
//                               .add(
//                               {
//                                 'Description': DescriptionInList,
//                                 'Title': Title,
//                                 'TitleImage': TitleImage,
//                                 'Story': Story,
//                                 'Tag': TagSelected,
//                                 'Time': DateTime.now(),
//                               },
//                             ).then((value) {
//                               setState(() {
//                                 StoryDraftDoc = value;
//                               });
//                             }).then((value) {
//                               firestore
//                                   .collection('Users')
//                                   .doc(StoryDraftDoc.id)
//                                   .set({'doc': doc.id},
//                                       SetOptions(merge: true));
//                             })
//                           : firestore
//                               .collection('Users')
//                               .doc(UserID)
//                               .collection('StoriesDarft')
//                               .doc(doc.path)
//                               .update(
//                               {
//                                 'Description': DescriptionInList,
//                                 'Title': Title,
//                                 'TitleImage': TitleImage,
//                                 'Story': Story,
//                                 'Tag': TagSelected,
//                                 'Time': DateTime.now(),
//                               },
//                             );
//                     });
//           }
//         }),
//     TextButton(
//         child: Text('Submit'),
//         onPressed: () async {
//           if ((c1.text.length <= 5 && c2.text.length <= 20) &&
//               c3.text.length <= 200) {
//           } else {
//             if (TitleImage != null) {
//               firestore
//                   .collection('Stories')
//                   .add(
//                     {
//                       'UserID': UserID,
//                       'UserName': UserName,
//                       'UserPhoto': UserPhoto,
//                       'Description': DescriptionInList,
//                       'Title': Title,
//                       'TitleImage': TitleImage,
//                       'Views': 0,
//                       'Rating': 0,
//                       'Story': c3.text,
//                       'Tag': TagSelected,
//                       'Time': DateTime.now(),
//                     },
//                   )
//                   .then((value) {
//                     setState(() {
//                       doc = value;
//                     });
//                   })
//                   .then(
//                     (value) => stories
//                         .doc(doc.id)
//                         .collection('UsersViewed')
//                         .doc(UserID)
//                         .set(
//                       {'UserID': UserID, 'doc': doc.id},
//                     ),
//                   )
//                   .then((value) {
//                     firestore
//                         .collection('Stories')
//                         .doc(doc.id)
//                         .set({'doc': doc.id});
//                   });
//             } else if (TitleImageFile != null) {
//               TitleImageStorage.putFile(TitleImageFile)
//                   .onComplete
//                   .then((value) => () async {
//                         String url =
//                             await value.ref.getDownloadURL();
//                         setState(() {
//                           TitleImage = url;
//                         });
//                       })
//                   .then(
//                     (value) => () {
//                       firestore
//                           .collection('Stories')
//                           .add(
//                             {},
//                           )
//                           .then((value) {
//                             setState(() {
//                               doc = value;
//                             });
//                           })
//                           .then(
//                             (value) => stories
//                                 .doc(doc.id)
//                                 .collection('UsersViewed')
//                                 .doc(UserID)
//                                 .set(
//                               {'UserID': UserID},
//                             ),
//                           )
//                           .then(
//                             (value) {
//                               firestore
//                                   .collection('Stories')
//                                   .doc(doc.id)
//                                   .set(
//                                 {
//                                   'doc': doc.id,
//                                   'UserID': UserID,
//                                   'UserName': UserName,
//                                   'UserPhoto': UserPhoto,
//                                   'Description':
//                                       DescriptionInList,
//                                   'Title': Title,
//                                   'TitleImage': TitleImage,
//                                   'Views': 0,
//                                   'Rating': 0,
//                                   'Story': Story,
//                                   'Tag': TagSelected,
//                                   'Time': DateTime.now(),
//                                 },
//                               );
//                             },
//                           );
//                     },
//                   );
//             }
//           }
//         }),
//   ],
// ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// Future<QuerySnapshot> LoadTags() async {
//   firestore
//       .collection("Tag")
//       .doc('Smartphone')
//       .collection("Tags")
//       .get()
//       .then((querySnapshot) {
//     querySnapshot.docs.forEach((element) {
//       // List<String> data = element.get('Tag');
//       String data = element.data()['Tag'];
//       Tags.add(data);
//       setState(() {
//         Tags = Tags;
//       });
//     });
//   });
// }

//   LoadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     UserEmail = prefs.getString('UserEmail');
//     UserPhoto = prefs.getString('UserPhoto');
//     UserName = prefs.getString('UserName');
//     UserID = prefs.getString('UserID');
//     String Color = prefs.getString('BackgroundColor');
//     if (Color == 'White') {
//       setState(() {
//         ColorSelected = Colors.white;
//       });
//     } else if (Color == 'Black') {
//       setState(() {
//         ColorSelected = Colors.black;
//       });
//     }
//   }

//   // LoadBannerAd() {
//   //   bannerAd
//   //     ..load()
//   //     ..show(anchorType: AnchorType.top);
//   // }

//   final c1 = TextEditingController();
//   final c2 = TextEditingController();
//   final c3 = TextEditingController();

//   clearTexts() {
//     c1.clear();
//     c2.clear();
//     c3.clear();
//   }

//   // ignore: unused_element
//   void _openColorPicker() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Center(
//           child: SingleChildScrollView(
//             child: AlertDialog(
//               title: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Center(
//                     child: Text('Select Color'),
//                   ),
//                   Spacer(),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: SvgPicture.asset(
//                       'Icons/cancel.svg',
//                       height: 40,
//                       width: 22,
//                     ),
//                   ),
//                 ],
//               ),
//               content: ListBody(
//                 children: <Widget>[
//                   MaterialColorPicker(
//                     selectedColor: null,
//                     allowShades: true,
//                     colors: [],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// ! YAHA TAK HAI
//? STORY WORKSPACE