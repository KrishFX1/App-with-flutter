import 'package:Kahani_App/Story/Story/ReadStory.dart';
import 'package:Kahani_App/Widgets/CustomTabBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryDetails extends StatefulWidget {
  final String TitleImage;
  final String Title;
  final String StoryUserName;
  final String StoryUserID;
  final String StoryUsePhoto;
  final String Story;
  final String Description;
  final String DocID;
  StoryDetails(
      {this.Description,
      this.Story,
      this.StoryUserID,
      this.StoryUserName,
      this.StoryUsePhoto,
      this.Title,
      this.TitleImage,
      this.DocID});
  @override
  _StoryDetailsState createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
  int Index = 0;
  Color kMainColor = Color(0xFFFFAAA5);
  Color kBackgroundColor = Color(0xFFFAFAFA);
  Color kBlackColor = Color(0xFF121212);
  Color kGreyColor = Color(0xFFAAAAAA);
  Color kLightGreyColor = Color(0xFFF4F4F4);
  Color kWhiteColor = Color(0xFFFFFFFF);
  Color c = Color(0xFFf25287);
  @override
  Widget build(BuildContext context) {
    // TabController tabController = TabController(length: 3 , initialIndex: 0 );
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
        height: 49,
        color: Colors.transparent,
        child: FlatButton(
          color: kMainColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReadStory(
                          Story: widget.Story,
                        )));
          },
          child: Text(
            'Read',
            style: GoogleFonts.openSans(
                fontSize: 14, fontWeight: FontWeight.w600, color: kWhiteColor),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(widget.TitleImage),
                          fit: BoxFit.fill),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    label: Text(''),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all<Color>(c),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 9, left: 13),
                    child: Text(
                      widget.Title,
                      style: GoogleFonts.openSans(
                          fontSize: 27,
                          color: kBlackColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 13),
                    child: Text(
                      widget.StoryUserName,
                      style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 5, left: 13),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Free',
                            style: GoogleFonts.openSans(
                                fontSize: 32,
                                color: kMainColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                  Container(
                    height: 28,
                    margin: EdgeInsets.only(top: 12, bottom: 12),
                    padding: EdgeInsets.only(left: 13),
                    child: DefaultTabController(
                      initialIndex: 0,
                      length: 3,
                      child: TabBar(
                          onTap: (index) {
                            setState(() {
                              Index = index;
                            });
                          },
                          labelPadding: EdgeInsets.all(0),
                          indicatorPadding: EdgeInsets.all(0),
                          isScrollable: true,
                          labelColor: kBlackColor,
                          unselectedLabelColor: kGreyColor,
                          labelStyle: GoogleFonts.openSans(
                              fontSize: 14, fontWeight: FontWeight.w700),
                          unselectedLabelStyle: GoogleFonts.openSans(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          indicator: RoundedRectangleTabIndicator(
                              weight: 2, width: 30, color: kBlackColor),
                          tabs: [
                            Tab(
                              child: Container(
                                margin: EdgeInsets.only(right: 39),
                                child: Text('Description'),
                              ),
                            ),
                            Tab(
                              child: Container(
                                margin: EdgeInsets.only(right: 39),
                                child: Text('Reviews'),
                              ),
                            ),
                            Tab(
                              child: Container(
                                margin: EdgeInsets.only(right: 39),
                                child: Text('About The Author'),
                              ),
                            )
                          ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 13, right: 13, bottom: 25),
                    child: Text(
                      Index == 0 ? widget.Description : 'Hattot Kutt',
                      style: GoogleFonts.openSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                        letterSpacing: 1.5,
                        height: 2,
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
