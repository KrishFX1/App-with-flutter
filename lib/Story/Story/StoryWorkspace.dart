import 'dart:io';
import 'package:Kahani_App/Story/Story/ReadStory.dart';
import 'package:Kahani_App/Story/Story/StoryRead.dart';
import 'package:Kahani_App/other/Tags.dart';
import 'package:Kahani_App/Widgets/WriteBottomSheet.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:quill_delta/quill_delta.dart';
import '../../main.dart';
import 'Preview.dart';
import 'package:zefyr/zefyr.dart';

///  Initially for every writing one ad is must .
///  Onwards , 1500 for 2.
///  and then 2000 for 3.
///  1 for every 1000 then
/// 4 for 3000
///
///
///
///
///
///
// TxetStyle text = GoogleFonts();
// BannerAd bannerAd;
ImagePicker imagePicker = ImagePicker();
CollectionReference stories = firestore.collection('Stories');
String UserID1;
Reference Images =
    FirebaseStorage.instance.ref().child('Images/').child('$UserID1/');

class StoryWorkspace extends StatefulWidget {
  StoryWorkspace({
    this.UserEmail,
    this.UserID,
    this.UserName,
    this.UserPhoto,
    this.Description,
    this.Story,
    this.Title,
    this.TitleImage,
    this.StoryOrArticle,
    this.doc,
  });

  final String Description;
  DocumentReference doc;
  final String Story;
  final StoryOrArticle;
  final String Title;
  final String TitleImage;
  final String UserEmail;
  final String UserID;
  final String UserName;
  final String UserPhoto;

  @override
  _StoryWorkspaceState createState() => _StoryWorkspaceState();
}

class _StoryWorkspaceState extends State<StoryWorkspace> {
  List AllImages = [];
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  var delegate;
  List Description;
  List<String> DescriptionInList;
  FocusNode focusNode = FocusNode();
  String ImageLink;
  bool KeyboardVisible = false;
  String Link;
  String LinkText;
  String Story;
  DocumentReference StoryDraftDoc;
  List<String> Tags = [];
  List<String> TagSelected = [];
  ColorSwatch TextColor;
  String TextForLink;
  String Title;
  TextEditingController TitleController = TextEditingController();
  String TitleImage;
  File TitleImageFile;
  String UserEmail;
  String UserID;
  String UserName;
  String UserPhoto;
  ZefyrController zefyrController;

  @override
  void initState() {
    Delta delta = Delta()..insert('\n');
    super.initState();
    zefyrController = ZefyrController(NotusDocument.fromDelta(delta));

    // KeyboardVisibility.onChange.listen((bool visible) {
    //   setState(() {
    //     KeyboardVisible = visible;
    //   });
    // });
    if (widget.Story != null) {
      setState(() {
        c1.text = widget.Story;
      });
    }
    if (widget.TitleImage != null) {
      setState(() {
        TitleImage = widget.TitleImage;
      });
    }
    if (widget.UserID == null) {
      LoadUserData();
    } else {
      UserName = widget.UserName;
      UserEmail = widget.UserEmail;
      UserID = widget.UserID;
      UserPhoto = widget.UserPhoto;
    }
    setState(() {
      UserID1 = UserID;
    });
  }

  Future<QuerySnapshot> LoadTags() async {
    firestore
        .collection("Tag")
        .doc('Story Tag')
        .collection("Tags")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        print(element.exists);
        String data = element.data()['Tag'];
        print(data);
        Tags.add(data);
        setState(() {
          Tags = Tags;
        });
      });
    });
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  Future GetImage(String WhichImage) async {
    PickedFile image = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 1500,
        maxWidth: 1500);

    await Images.child(image.path)
        .putFile(File(image.path))
        .then((value) async {
      String link = await value.ref.getDownloadURL();

      setState(() {
        if (WhichImage == 'TitleImage') {
          TitleImageFile = File(image.path);
          TitleImage = link;
        } else {
          ImageLink = link;
        }
      });
      if (WhichImage != 'TitleImage') {
        AllImages.add(ImageLink);
        // AllImagesFile.add(image);
      }
    });
  }

  Widget AddImage(int index) {
    return Container(
      child: AllImages.asMap()[index - 1] == null
          ? GestureDetector(
              child: Row(
                children: [
                  Icon(Icons.add),
                  Text('Add Image'),
                ],
              ),
              onTap: () {
                BottomSheet(context);
              },
            )
          : Container(
              width: 0,
              height: 0,
            ),
    );
  }

  Widget ShowImage(
    int index,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: 100,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(AllImages.asMap()[index]),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.delete_rounded),
                      SizedBox(width: 3),
                      Text('Delete'),
                    ],
                  ),
                  onTap: () async {
                    String image = AllImages.asMap()[index];
                    if (image.split('.')[0] == 'firebasestorage') {
                      await FirebaseStorage.instance
                          .refFromURL(AllImages.asMap()[index])
                          .delete();
                      setState(() {
                        AllImages.removeAt(index);
                      });
                    } else {
                      setState(() {
                        AllImages.removeAt(index);
                      });
                    }
                  },
                ),
              ),
            )
          ],
        ),
        Text('To Use This Image : Image[${index + 1}]'),
      ],
    );
  }

  Widget AdError(int noOfAds, int noOfRequired) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Center(
                child: Text('ERROR!!'),
              ),
              content: ListBody(
                children: <Widget>[
                  Center(
                    child: Text(
                      '''Your Story Must Contain Atleast $noOfRequired Parts as it is ${c1.text.length} characters long but Currently it has only $noOfAds Parts.

To Procced You must add ${noOfAds - noOfRequired} more Part(s).''',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                  Center(
                    child: Text(
                        'To add a part tap on the last button in the actions manu above the keyboard'),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok!!'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void AddToFirestore() {
    firestore
        .collection('Stories')
        .add(
          {},
        )
        .then((value) {
          setState(() {
            widget.doc = value;
          });
        })
        .then((value) {
          firestore.collection('Stories').doc(widget.doc.id).set({
            'doc': widget.doc.id,
            'UserID': UserID,
            'UserName': UserName,
            'UserPhoto': UserPhoto,
            'Description': DescriptionInList,
            'DescriptionLength': DescriptionInList.length,
            'Title': Title,
            'TitleImage': TitleImage,
            'Views': 0,
            'Rating': 0,
            'Story': c1.text
                .replaceAll('**', '</b>')
                .replaceAll('*', '<b>')
                .replaceAll('``', '</em>')
                .replaceAll('`', '<em>')
                .replaceAll('Link:', 'Link :')
                .replaceAll('Link  :', 'Link :')
                .replaceAll('Link   :', 'Link :')
                .replaceAll('Link :', '<a href :" ')
                .replaceAll('{', '">')
                .replaceAll('}', '</a>')
                .replaceAll('Image[1]', '<img src= "${AllImages[0]}"/> ')
                .replaceAll('Image[2]', '<img src= "${AllImages[1]}"/> ')
                .replaceAll('Image[3]', '<img src = "${AllImages[2]}"/> ')
                .replaceAll('Image[4]', '<img src= "${AllImages[3]}"/> ')
                .replaceAll('Image[5]', '<img src= "${AllImages[4]}"/> ')
                .replaceAll('Image[6]', '<img src = "${AllImages[5]}"/> ')
                .replaceAll('Image[7]', '<img src = "${AllImages[6]}"/> ')
                .replaceAll('Image[8]', '<img src= "${AllImages[7]}"/> ')
                .replaceAll('Image[9]', '<img src = "${AllImages[8]}"/> ')
                .replaceAll('Image[10]', '<img src= "${AllImages[9]}"/> '),
            'Tag': TagSelected,
            'Time': DateTime.now(),
            'Average Time': c1.text.split(' ').length / 200
          });
        })
        .then(
          (value) => stories
              .doc(widget.doc.id)
              .collection('UsersViewed')
              .doc(UserID)
              .set(
            {'UserID': UserID, 'doc': widget.doc.id},
          ),
        )
        .then((value) async {
          var data = await firestore.collection('Users').doc(UserID).get();
          int MonthlyPosts = data.data()['MonthlyPosts'];
          int updatedPosts = MonthlyPosts + 1;
          firestore
              .collection('Users')
              .doc(UserID)
              .update({'MonthlyPosts': updatedPosts});
        });
  }

  Up() async {}

  void BottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(11, 11, 0, 0),
                  child: TextButton(
                    child: ListTile(
                      leading: SvgPicture.asset(
                        'Icons/gallery.svg',
                        height: 40,
                        width: 22,
                      ),
                      title: Text('Gallery'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      GetImage('NormalImage');
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(11, 0, 0, 11),
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: SingleChildScrollView(
                              child: AlertDialog(
                                title: Center(
                                  child: Text('Give An Image Link'),
                                ),
                                content: ListBody(
                                  children: <Widget>[
                                    Center(
                                      child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            ImageLink = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          // fillColor: Colors.lightBlueAccent[400],
                                          focusedBorder: OutlineInputBorder(
                                            // borderRadius:
                                            //     BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.blue[300],
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            // borderRadius:
                                            //     BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                              color: Colors.lightBlue[200],
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(
                                            () {
                                              AllImages.add(ImageLink);
                                            },
                                          );
                                          c1.text = Story + 'Image[1]';
                                          Story = c1.text;
                                        },
                                        child: Text('Submit'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: ListTile(
                      leading: SvgPicture.asset(
                        'Icons/folder.svg',
                        height: 40,
                        width: 20,
                      ),
                      title: Text('Network Image'),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottomOpacity: 0,
        toolbarOpacity: 0,
        actions: [
          TextButton(
            onPressed: () async {
              final converter = NotusHtmlCodec();
              String html =
                  converter.encode(zefyrController.document.toDelta());
              await firestore.collection('Stories').add({
                'doc': 'oihugekjwhdc',
                'UserID': UserID,
                'UserName': UserName,
                'UserPhoto': UserPhoto,
                'Description':
                    'Elon Reeve Musk FRS is a business magnate, industrial designer, engineer, and philanthropist. He is the founder, CEO, CTO and chief designer of SpaceX; early investor, CEO and product architect of Tesla, Inc.; founder of The Boring Company; co-founder of Neuralink; and co-founder and initial co-chairman of OpenAI',
                'DescriptionLength': 55,
                'Title': 'Elon Musk : Name Defines',
                'TitleImage':
                    'https://www.biography.com/.image/c_fill%2Ccs_srgb%2Cfl_progressive%2Ch_400%2Cq_auto:good%2Cw_620/MTY2MzU3Nzk2OTM2MjMwNTkx/elon_musk_royal_society.jpg',
                'Views': 245764,
                'Rating': 5,
                'Story': html,
                // 'Tag': TagSelected,
                'Time': DateTime.now(),
                'Average Time': html.length / 200
              });

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //           builder: (context) => ReadStory(
              //             Story: html,
              //           )));
            },
            child: Text('IMAGES'),
          ),
          TextButton(
            onPressed: () {
              List Images;
              setState(() {
                Images = AllImages;
              });
              Images.addAll([
                1,
                2,
                3,
                4,
                5,
                6,
                7,
                8,
                9,
                10,
              ]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Preview(
                      StoryUserID: UserID,
                      StoryUserPhoto: UserPhoto,
                      Author: UserName,
                      Story: c1.text

                          // .replaceAll('Image[1]', '<img src= "${Images[0]}"/> ')
                          // .replaceAll('Image[2]', '<img src= "${Images[1]}"/> ')
                          // .replaceAll(
                          //     'Image[3]', '<img src = "${Images[2]}"/> ')
                          // .replaceAll('Image[4]', '<img src= "${Images[3]}"/> ')
                          // .replaceAll('Image[5]', '<img src= "${Images[4]}"/> ')
                          // .replaceAll(
                          //     'Image[6]', '<img src = "${Images[5]}"/> ')
                          // .replaceAll(
                          //     'Image[7]', '<img src = "${Images[6]}"/> ')
                          // .replaceAll('Image[8]', '<img src= "${Images[7]}"/> ')
                          // .replaceAll(
                          //     'Image[9]', '<img src = "${Images[8]}"/> ')
                          // .replaceAll(
                          //     'Image[10]', '<img src= "${Images[9]}"/> ')
                          .split('< NEW PART BEGINS >')),
                ),
              );
            },
            child: Text(
              'PREVIEW',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            child: Text(
              'Next',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () async {
              // await LoadTags();
              // print(Tags);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: SingleChildScrollView(
                      child: AlertDialog(
                        insetPadding: EdgeInsets.all(0),
                        contentPadding: EdgeInsets.all(2),
                        title: Text('Just There!!'),
                        elevation: 0,
                        content: ListBody(
                          children: <Widget>[
                            SizedBox(height: 15),
                            Text('     Title For Your Story'),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: TitleController,
                              decoration: InputDecoration(
                                fillColor: Colors.lightBlueAccent[400],
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: BorderSide(
                                    width: .4,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: BorderSide(
                                    width: .4,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Text('    Add Title Image For The Story'),
                            TitleImage == null
                                ? Padding(
                                    padding: EdgeInsets.all(4),
                                    child: TextButton(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.add),
                                          Text("No Image Selected"),
                                        ],
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return Container(
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              11, 11, 0, 0),
                                                      child: TextButton(
                                                        child: ListTile(
                                                          leading:
                                                              SvgPicture.asset(
                                                            'Icons/gallery.svg',
                                                            height: 40,
                                                            width: 22,
                                                          ),
                                                          title:
                                                              Text('Gallery'),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          GetImage(
                                                              'TitleImage');
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              11, 0, 0, 11),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Center(
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      AlertDialog(
                                                                    title:
                                                                        Center(
                                                                      child: Text(
                                                                          'Give An Image Link'),
                                                                    ),
                                                                    content:
                                                                        ListBody(
                                                                      children: <
                                                                          Widget>[
                                                                        Center(
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                c2,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              fillColor: Colors.lightBlueAccent[400],
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(20.0),
                                                                                borderSide: BorderSide(
                                                                                  width: 1.5,
                                                                                  color: Colors.blue[300],
                                                                                ),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(20.0),
                                                                                borderSide: BorderSide(
                                                                                  color: Colors.lightBlue[200],
                                                                                  width: 1.4,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              setState(() {
                                                                                TitleImage = c2.text;
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text('Submit'),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: ListTile(
                                                          leading:
                                                              SvgPicture.asset(
                                                            'Icons/folder.svg',
                                                            height: 40,
                                                            width: 20,
                                                          ),
                                                          title: Text(
                                                              'Network Image'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  )
                                : Image.network(TitleImage),
                            SizedBox(height: 11),
                            Text('    Give A Description For Your Story'),
                            SizedBox(height: 11),
                            TextFormField(
                              minLines: 6,
                              maxLines: 6,
                              maxLength: 150,
                              controller: c3,
                              decoration: InputDecoration(
                                fillColor: Colors.lightBlueAccent[400],
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    width: 1.1,
                                    color: Colors.blue[300],
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue[200],
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            // ChipsChoice<String>.multiple(
                            //   itemConfig: ChipsChoiceItemConfig(),
                            //   value: TagSelected,
                            //   options:
                            //       ChipsChoiceOption.listFrom<String, String>(
                            //     source: StoryTags,
                            //     value: (i, v) => v,
                            //     label: (i, v) => v,
                            //   ),
                            //   onChanged: (val) {
                            //     setState(() {
                            //       TagSelected = val;
                            //     });
                            //   },
                            //   isWrapped: true,
                            // ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        '  Preview  ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      List Image;
                                      setState(() {
                                        Image = AllImages;
                                      });
                                      Image.addAll(
                                          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

                                      if (c1.text.length <= 1500) {
                                      } else {}
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Preview(
                                              Story: c1.text
                                                  .replaceAll('**', '</b>')
                                                  .replaceAll('*', '<b>')
                                                  .replaceAll('``', '</em>')
                                                  .replaceAll('`', '<em>')
                                                  .replaceAll('~~', '</p>')
                                                  .replaceAll('~', '<p>')
                                                  .replaceAll('Link:', 'Link :')
                                                  .replaceAll(
                                                      'Link  :', 'Link :')
                                                  .replaceAll(
                                                      'Link   :', 'Link :')
                                                  .replaceAll(
                                                      'Link :', '<a href="')
                                                  .replaceAll('{', '">')
                                                  .replaceAll('}', '</a>')
                                                  .replaceAll('Image[1]',
                                                      '<img src= "${Image[0]}"/> ')
                                                  .replaceAll('Image[2]',
                                                      '<img src= "${Image[1]}"/> ')
                                                  .replaceAll('Image[3]',
                                                      '<img src = "${Image[2]}"/> ')
                                                  .replaceAll('Image[4]',
                                                      '<img src= "${Image[3]}"/> ')
                                                  .replaceAll('Image[5]',
                                                      '<img src= "${Image[4]}"/> ')
                                                  .replaceAll('Image[6]',
                                                      '<img src = "${Image[5]}"/> ')
                                                  .replaceAll('Image[7]',
                                                      '<img src = "${Image[6]}"/> ')
                                                  .replaceAll('Image[8]',
                                                      '<img src= "${Image[7]}"/> ')
                                                  .replaceAll('Image[9]',
                                                      '<img src = "${Image[8]}"/> ')
                                                  .replaceAll('Image[10]',
                                                      '<img src= "${Image[9]}"/> ')
                                                  .split(
                                                      '< NEW PART BEGINS >')),
                                        ),
                                      );
                                    }),
                                TextButton(
                                    child: Text(
                                      'Add To Your Drafts',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () async {
                                      widget.doc == null
                                          ? firestore
                                              .collection('Users')
                                              .doc(UserID)
                                              .collection('StoriesDarft')
                                              .add(
                                              {
                                                'Description':
                                                    DescriptionInList,
                                                'Title': Title,
                                                'TitleImage': TitleImage,
                                                'Story': Story,
                                                'Time': DateTime.now(),
                                                'Tag': TagSelected
                                              },
                                            ).then((value) {
                                              setState(() {
                                                StoryDraftDoc = value;
                                              });
                                            }).then((value) {
                                              firestore
                                                  .collection('Users')
                                                  .doc(StoryDraftDoc.id)
                                                  .set({'doc': widget.doc.id},
                                                      SetOptions(merge: true));
                                            })
                                          : firestore
                                              .collection('Users')
                                              .doc(UserID)
                                              .collection('StoriesDarft')
                                              .doc(widget.doc.id)
                                              .update(
                                              {
                                                'Description':
                                                    DescriptionInList,
                                                'Title': Title,
                                                'TitleImage': TitleImage,
                                                'Story': Story,
                                                'Tag': TagSelected,
                                                'Time': DateTime.now(),
                                              },
                                            );
                                    }),
                              ],
                            ),
                            Center(
                              child: TextButton(
                                  child: Text(
                                    'Publish',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final converter = NotusHtmlCodec();
                                    String html = converter.encode(
                                        zefyrController.document.toDelta());
                                    print(html);
                                    // if ((c1.text == null &&
                                    //         TitleImage == null) &&
                                    //     (Title == null &&
                                    //         (Description == null &&
                                    //             TagSelected == null))) {
                                    // } else {
                                    //   if (c1.text.length < 2000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length == 1) {
                                    //       AdError(0, 1);
                                    //     } else {
                                    AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 2000 &&
                                    //       c1.text.length < 4000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 3) {
                                    //       AdError(a.length - 1, 2);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 4000 &&
                                    //       c1.text.length < 6000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 4) {
                                    //       AdError(a.length - 1, 3);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 6000 &&
                                    //       c1.text.length < 8000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 5) {
                                    //       AdError(a.length - 1, 4);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 8000 &&
                                    //       c1.text.length < 10000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 6) {
                                    //       AdError(a.length - 1, 5);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 10000 &&
                                    //       c1.text.length < 12000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 7) {
                                    //       AdError(a.length - 1, 6);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 13000 &&
                                    //       c1.text.length < 16000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 8) {
                                    //       AdError(a.length - 1, 7);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 16000 &&
                                    //       c1.text.length < 19000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 9) {
                                    //       AdError(a.length - 1, 8);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 19000 &&
                                    //       c1.text.length < 22000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 10) {
                                    //       AdError(a.length - 1, 9);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 22000 &&
                                    //       c1.text.length < 25000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 11) {
                                    //       AdError(a.length - 1, 10);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 25000 &&
                                    //       c1.text.length < 28000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 12) {
                                    //       AdError(a.length - 1, 11);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 28000 &&
                                    //       c1.text.length < 31000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 13) {
                                    //       AdError(a.length - 1, 12);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 31000 &&
                                    //       c1.text.length < 34000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 14) {
                                    //       AdError(a.length - 1, 13);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 34000 &&
                                    //       c1.text.length < 37000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 15) {
                                    //       AdError(a.length - 1, 14);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 37000 &&
                                    //       c1.text.length < 40000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 16) {
                                    //       AdError(a.length - 1, 16);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 40000 &&
                                    //       c1.text.length < 43000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 17) {
                                    //       AdError(a.length - 1, 17);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 43000 &&
                                    //       c1.text.length < 46000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 18) {
                                    //       AdError(a.length - 1, 18);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length >= 46000 &&
                                    //       c1.text.length < 49000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 19) {
                                    //       AdError(a.length - 1, 19);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   } else if (c1.text.length > 50000) {
                                    //     List a = c1.text
                                    //         .split('< NEW PART BEGINS >');
                                    //     if (a.length < 20) {
                                    //       AdError(a.length - 1, 20);
                                    //     } else {
                                    //       AddToFirestore();
                                    //     }
                                    //   }
                                    // }
                                  }),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // ZefyrScaffold(
            //   child: 
              ZefyrEditor(
                  // toolbarDelegate: ZefyrButton.icon(action: null, icon: null),
                  // imageDelegate: ,
                  padding: EdgeInsets.all(5),
                  controller: zefyrController,
                  focusNode: focusNode),
            // ),
            Container(
              // color: Colors.black,
              height: 1000,
              width: 360,
              child: TextFormField(
                autofocus: true,
                initialValue: widget.Title == null ? null : widget.Title,
                minLines: 30,
                maxLines: null,
                controller: c1,
                onChanged: (value) {
                  setState(() {
                    Story = value;
                  });
                },
                style: TextStyle(color: TextColor),
                decoration: InputDecoration(
                  fillColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.65,
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 0.65,
                    ),
                  ),
                ),
              ),
            ),
            KeyboardVisible == true
                ? Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black87,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                c1.text = Story + '  * BOLD **  ';
                                Story = c1.text;
                              });
                            },
                            child: Icon(
                              Icons.format_bold,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                c1.text = Story + '  ` Italic ``  ';
                                Story = c1.text;
                              });
                            },
                            child: Icon(
                              Icons.format_italic,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                c1.text = Story +
                                    '''

~ New Paragraph ~~  ''';
                                Story = c1.text;
                              });
                            },
                            child: Icon(
                              Icons.format_align_justify,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: AlertDialog(
                                        elevation: 0,
                                        title: Center(
                                          child: Row(
                                            children: [
                                              Text('Add Images'),
                                              Spacer(),
                                              GestureDetector(
                                                child: Icon(Icons.cancel,
                                                    size: 28),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        content: ListBody(
                                          children: <Widget>[
                                            if (AllImages.asMap()[0] == null)
                                              GestureDetector(
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.add),
                                                      Text('Add Image'),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    BottomSheet(context);
                                                  })
                                            else
                                              ShowImage(0),
                                            SizedBox(height: 6),
                                            if (AllImages.asMap()[1] == null)
                                              AddImage(1)
                                            else
                                              ShowImage(1),
                                            SizedBox(height: 6),
                                            if (AllImages.asMap()[2] == null)
                                              AddImage(2)
                                            else
                                              ShowImage(2),
                                            SizedBox(height: 2),
                                            if (AllImages.asMap()[3] == null)
                                              AddImage(3)
                                            else
                                              ShowImage(3),
                                            SizedBox(height: 6),
                                            if (AllImages.asMap()[4] == null)
                                              AddImage(4)
                                            else
                                              ShowImage(4),
                                            SizedBox(height: 6),
                                            if (AllImages.asMap()[5] == null)
                                              AddImage(5)
                                            else
                                              ShowImage(5),
                                            SizedBox(height: 6),
                                            if (AllImages.asMap()[6] == null)
                                              AddImage(6)
                                            else
                                              ShowImage(6),
                                            SizedBox(height: 6),
                                            if (AllImages.asMap()[7] == null)
                                              AddImage(7)
                                            else
                                              ShowImage(7),
                                            SizedBox(height: 6),
                                            if (AllImages.asMap()[8] == null)
                                              AddImage(8)
                                            else
                                              ShowImage(8),
                                            if (AllImages.asMap()[9] == null)
                                              AddImage(9)
                                            else
                                              ShowImage(9),
                                            SizedBox(height: 6),
                                            Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Done'),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: AlertDialog(
                                        elevation: 0,
                                        insetPadding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 4),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 4, 10, 12),
                                        titlePadding: EdgeInsets.all(5),
                                        title: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Center(
                                              child: Text('Add A Link',
                                                  style: GoogleFonts.kavoon(
                                                      fontSize: 22)),
                                            ),
                                            Spacer(),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              child: TextButton(
                                               
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: SvgPicture.asset(
                                                  'Icons/cancel.svg',
                                                  height: 40,
                                                  width: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: ListBody(
                                          children: <Widget>[
                                            SizedBox(height: 2),
                                            Text('Enter The Text For The Link',
                                                style: GoogleFonts.kavoon(
                                                    fontSize: 17)),
                                            SizedBox(height: 5),
                                            Center(
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    TextForLink = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  fillColor: Colors
                                                      .lightBlueAccent[400],
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.7,
                                                      color: Colors.blue[300],
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.lightBlue[200],
                                                      width: 0.71,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Text('Enter The Link',
                                                style: GoogleFonts.kavoon(
                                                    fontSize: 17)),
                                            SizedBox(height: 8),
                                            Center(
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    LinkText = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  fillColor: Colors
                                                      .lightBlueAccent[400],
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.7,
                                                      color: Colors.blue[300],
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.lightBlue[200],
                                                      width: 0.7,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: TextButton(
                                                  onPressed: () {
                                                    if (LinkText == null) {}
                                                    if (TextForLink == null) {
                                                      setState(
                                                        () {
                                                          // link:wux'''
                                                          // Text[Link]
                                                          c1.text = Story +
                                                              'Link : $LinkText {$TextForLink} ';
                                                          Story = c1.text;
                                                          // '  <a href="$LinkText">$LinkText</a>  ';
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                    }

                                                    if (LinkText != null &&
                                                        TextForLink != null) {
                                                      setState(
                                                        () {
                                                          // link:wux'''
                                                          // Text[Link]
                                                          c1.text = Story +
                                                              'Link : $LinkText {$TextForLink} ';
                                                          Story = c1.text;
                                                          // '  <a href="$LinkText">$LinkText</a>  ';
                                                        },
                                                      );
                                                      // setState(
                                                      // () {
                                                      // c3.text = Story +
                                                      //     '  <a href="$LinkText">$TextForLink</a>  ';
                                                      // StoryHtml = Story +
                                                      //     '  <a href="$LinkText">$TextForLink</a>  ';
                                                      //   },
                                                      // );
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text('Submit')),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.insert_link,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(6.0),
                                    content: Container(
                                      height: 250,
                                      width: 150,
                                      child: MaterialColorPicker(
                                          allowShades: false, // default true
                                          onMainColorChange:
                                              (ColorSwatch color) {
                                            TextColor = color;
                                          },
                                          selectedColor: Colors.red),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('CANCEL'),
                                        onPressed: Navigator.of(context).pop,
                                      ),
                                      TextButton(
                                        child: Text('SUBMIT'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.color_lens,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              c1.text = Story +
                                  '''

< NEW PART BEGINS >

''';
                              Story = c1.text;
                            },
                            child: SvgPicture.asset('Icons/ads.svg',
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  )
          ],
        ),
      ),
    );
  }
}