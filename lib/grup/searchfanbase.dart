import 'package:discoverkorea/providers/api_fanbase.dart';
import 'package:discoverkorea/utilities/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:discoverkorea/providers/api_notification.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/grup/detailgroup.dart';

class SearchFanbase extends StatefulWidget {
  @override
  _FanState createState() => _FanState();
}

class _FanState extends State<SearchFanbase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Pencarian Fanbase',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              child: FutureBuilder(
                future: Provider.of<ApiFanbase>(context, listen: false)
                    .getAllKategori(),
                builder: (context1, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot1.hasData) {
                    // jika sudah ada data
                    return Consumer<ApiFanbase>(
                      builder: (context, data, _) {
                        return ListView.builder(
                          itemCount: data.dataFanbase2.length??null,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(15),
                          itemBuilder: (BuildContext context1, int incount) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 10,right: 6),
                                      child: Text(
                                        "#"+data.dataFanbase2[incount].namakategori,
                                        style: TextStyle(
                                          color: Colors.black,
                                          backgroundColor: Color(0xff79abfc),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                            letterSpacing: 3.0,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Center(
                              // child: new CircularProgressIndicator(),
                              ),
                          SizedBox(
                            height: 50,
                          ),
                          Text('Tidak ada Fanbase')
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: FutureBuilder(
                future: Provider.of<ApiFanbase>(context, listen: false)
                    .getFanbase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    // jika sudah ada data
                    return Consumer<ApiFanbase>(
                      builder: (context, data, _) {
                        return ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: data.dataFanbase3.length??null,
                          itemBuilder: (context, i) {
                            return Material(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailGrup(
                                              idfan: data.dataFanbase3[i].uid,
                                              groupname: data
                                                  .dataFanbase3[i].group_name,
                                              description: data
                                                  .dataFanbase3[i].description,
                                              chairman:
                                              data.dataFanbase3[i].chairman,
                                            )),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              data.dataFanbase3[i].group_name,
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
                                              data.dataFanbase3[i].description,
                                              style: TextStyle(
                                                color: Color(0xff8C68EC),
                                                fontSize: 14,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                            ),
                                            Text(
                                              data.dataFanbase3[i].category,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      // Column(
                                      //   children: <Widget>[
                                      //     Padding(
                                      //       padding: EdgeInsets.only(right: 15),
                                      //       child: Icon(
                                      //         Icons.chevron_right,
                                      //         size: 18,
                                      //       ),
                                      //     )
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Center(
                              // child: new CircularProgressIndicator(),
                              ),
                          SizedBox(
                            height: 50,
                          ),
                          Text('Tidak ada notifikasi')
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
// ListView.builder(
//               itemCount: 1,
//               shrinkWrap: true,
//               physics: ClampingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               itemBuilder: (BuildContext context, int index) {
//                 return Material(
//                   child: InkWell(
//                     onTap: () {},
//                     child: Container(
//                       margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
//                       padding: EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withAlpha(50),
//                             offset: Offset(0, 0),
//                             blurRadius: 5,
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.white,
//                       ),
//                       child: Row(
//                         children: <Widget>[
//                           Stack(
//                             children: <Widget>[
//                               Container(
//                                 child: CircleAvatar(
//                                   backgroundImage: NetworkImage(''),
//                                   minRadius: 35,
//                                   backgroundColor: Colors.grey[200],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: 10),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   'Jocelyn',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(top: 5),
//                                 ),
//                                 Text(
//                                   'Hi How are you ?',
//                                   style: TextStyle(
//                                     color: Color(0xff8C68EC),
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(top: 5),
//                                 ),
//                                 Text(
//                                   '11:00 AM',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           // Column(
//                           //   children: <Widget>[
//                           //     Padding(
//                           //       padding: EdgeInsets.only(right: 15),
//                           //       child: Icon(
//                           //         Icons.chevron_right,
//                           //         size: 18,
//                           //       ),
//                           //     )
//                           //   ],
//                           // )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
