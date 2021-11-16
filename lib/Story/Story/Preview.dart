import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

ScrollController control = ScrollController();
NativeAdmobController controller;
String adUnitID = 'ca-app-pub-4144128581194892/8591658542';

class Preview extends StatefulWidget {
  final String Title;
  final String TitleImage;
  final String Author;
  final String Characters;
  final List Story;
  final String StoryUserID;
  final String StoryUserPhoto;
  final String DocID;

  Preview({
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
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  int index = 0;
  int length;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    length = widget.Story.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          controller: control,
          child: Container(
            child: Column(
              children: [
                index == 0
                    ? Container(
                        width: double.infinity,
                        height: 294,
                        child: Image(
                          fit: BoxFit.fill,
                          image: widget.TitleImage != null
                              ? NetworkImage(widget.TitleImage)
                              : NetworkImage(
                                  'https://thelogicalindian.com/h-upload/2020/07/29/178182-tigerwev.jpg'),
                        ),
                      )
                    : Container(),
                index == 0
                    ? SizedBox(
                        height: 20,
                      )
                    : SizedBox(
                        height: 50,
                      ),
                index == 0
                    ? widget.Title != null
                        ? Text(widget.Title,
                            style: GoogleFonts.newsCycle(
                                fontSize: 31, fontWeight: FontWeight.w700))
                        : Text('TITLE',
                            style: GoogleFonts.newsCycle(
                                fontSize: 31, fontWeight: FontWeight.w700))
                    : Container(),
                index == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.Author != null
                              ? Text('~ By ${widget.Author}',
                                  style: GoogleFonts.secularOne())
                              : Text(' ~ BY YOU',
                                  style: GoogleFonts.secularOne())
                        ],
                      )
                    : Container(),
                index == 0 ? SizedBox(height: 20) : Container(),
                // TODO
                //***
                // HtmlWidget(
                //   widget.Story.asMap()[index],
                //   textStyle: GoogleFonts.workSans(
                //       fontSize: 17, fontWeight: FontWeight.w500),
                // ),
                // TODO
                SizedBox(
                  height: 15,
                ),
                index == widget.Story.length - 1
                    ? Column(
                        children: [
                          SizedBox(height: 18),
                          Center(
                              child: Text(
                            '  THE END  ',
                            style: GoogleFonts.architectsDaughter(fontSize: 28),
                          )),
                          SizedBox(height: 16),
                        ],
                      )
                    : Container(),
                SizedBox(height: 15),
                Container(
                  height: 340,
                  width: double.infinity,
                  child: Card(
                    child: NativeAdmob(
                      type: NativeAdmobType.full,
                      options: NativeAdmobOptions(
                          storeTextStyle: NativeTextStyle(color: Colors.green),
                          callToActionStyle:
                              NativeTextStyle(backgroundColor: Colors.green),
                          headlineTextStyle: NativeTextStyle(fontSize: 19),
                          bodyTextStyle: NativeTextStyle(fontSize: 22),
                          advertiserTextStyle: NativeTextStyle(fontSize: 20)),
                      adUnitID: adUnitID,
                      controller: controller,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    index == 0
                        ? Container(
                            width: 2,
                          )
                        : FlatButton(
                            onPressed: () {
                              setState(() {
                                index--;
                              });
                              control.animateTo(0,
                                  duration: Duration(microseconds: 5),
                                  curve: Curves.bounceOut);
                              controller.reloadAd();
                            },
                            child: Text(
                              'PREVIOUS',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            )),
                    Container(
                      child: index == length - 1
                          ? FlatButton(
                              onPressed: () {},
                              child: Text(
                                'REVIEW',
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w600),
                              ))
                          : FlatButton(
                              padding: EdgeInsets.all(11),
                              onPressed: () {
                                control.jumpTo(0);
                                control.animateTo(0,
                                    duration: Duration(seconds: 2),
                                    curve: Curves.bounceIn);

                                //  int indexNo = index + 1;
                                setState(() {
                                  //  index = indexNo;
                                  // adUnitID ==
                                  //         'ca-app-pub-4144128581194892/8591658542'
                                  //     ? adUnitID =
                                  //         'ca-app-pub-4144128581194892/2339560056'
                                  //     : adUnitID =
                                  //         'ca-app-pub-4144128581194892/8591658542';
                                });

                                // controller.setAdUnitID(adUnitID);
                              },
                              child: Text(
                                'NEXT',
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w600),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
