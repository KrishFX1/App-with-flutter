import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadStory extends StatefulWidget {
  String Story;
  ReadStory({this.Story});
  @override
  _ReadStoryState createState() => _ReadStoryState();
}

class _ReadStoryState extends State<ReadStory> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
                  child: SafeArea(
            child: Column(
              children: [

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Elon Musk : Name Defines' , style: GoogleFonts.openSans(
                            fontSize: 20,fontWeight: FontWeight.w600
                          ),),
                          // HtmlWidget(
                          //   widget.Story,
                          //   textStyle: GoogleFonts.openSans(
                          //       fontSize: 16, fontWeight: FontWeight.w500),

                          // ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
