import 'package:flutter/material.dart';

class ShowDiary extends StatefulWidget {
  final Diary;
  final DiaryTitle;
  final List Tags;
  final List AllImages;
  final int Date;
  final int Rating;
  final String Day;
  final int Year;
  final String Month;

  ShowDiary(
      {this.Diary,
      this.DiaryTitle,
      this.AllImages,
      this.Date,
      this.Day,
      this.Month,
      this.Rating,
      this.Tags,
      this.Year});

  @override
  _ShowDiaryState createState() => _ShowDiaryState();
}

class _ShowDiaryState extends State<ShowDiary> {
  @override
  Widget build(BuildContext context) {
    return
     Scaffold(
            body: Container(
      child: SafeArea(
              child: Column(
          children: [
            Row(
              children: [
                Text('${widget.Date} ${widget.Month} ${widget.Year}'),
                Spacer(),
                Text('${widget.Rating}'),
                Icon(Icons.star_rate_rounded)
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              height:30,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.Tags.asMap().length,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow[500],
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('   ${widget.Tags.asMap()[index]}'),
                        ));
                  }),

            ),
            SizedBox(height: 20,),
                  Text(widget.Diary),
            SizedBox(height: 20,),Container(
              height:120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.AllImages.asMap().length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 120,width: 120,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.AllImages[index]),fit: BoxFit.fill
                          )
                            ),
                      );
                  }),

            ),

          ],
        ),
      ),
    ));
  }
}
