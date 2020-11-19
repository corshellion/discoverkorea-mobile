import 'package:discoverkorea/fanbase.dart';
import 'package:discoverkorea/utilities/custom_heading.dart';
import 'package:discoverkorea/grup/detailgroup.dart';
import 'package:flutter/material.dart';


class Fanbase extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Fanbase> {
  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // CustomHeading(
            //   title: 'Pesan',
            // ),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => ChatDetails(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(50),
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(''),
                                  minRadius: 35,
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Blink',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Text(
                                  'Black Pink Boombayah!!',
                                  style: TextStyle(
                                    color: Color(0xff8f7f85),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
