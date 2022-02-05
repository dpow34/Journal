import 'package:flutter/material.dart';
import 'settings_drawer.dart';

class ViewEntry extends StatefulWidget {
  const ViewEntry({ Key? key, required this.title, required this.subtitle, 
  required this.dateTime, required this.rating}) : super(key: key);
  final String title;
  final String subtitle;
  final String dateTime;
  final String rating;

  @override
  _ViewEntryState createState() => _ViewEntryState();
}

class _ViewEntryState extends State<ViewEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Settings(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [Text(widget.dateTime.toString())]
        ),
        centerTitle: true,
         actions: [Padding(
            padding: EdgeInsets.only(right:10),
            child: Builder(builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context). openEndDrawer(),
            )),  
          )],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back)
        )
      ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.only(
              left: leftPadding(context), 
              top: topPadding(context)
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(widget.title, style: TextStyle(fontSize: 30))
            )
          ),
          Padding(
            padding: EdgeInsets.only(
              left: leftPadding(context), 
              top: topPadding(context)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(widget.subtitle)
            )
          ),
          Padding(
            padding: EdgeInsets.only(
              left: leftPadding(context), 
              top: topPadding(context)
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child:Text("Rating: ${widget.rating} out of 4")
            )
          )
        ])
    );
  }

  double leftPadding(BuildContext context){
    return MediaQuery.of(context).size.width * 0.03;
  }

  double topPadding(BuildContext context){
    return MediaQuery.of(context).size.width * 0.03;
  }

}