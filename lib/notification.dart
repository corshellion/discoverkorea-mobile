import 'package:discoverkorea/utilities/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:discoverkorea/providers/api_notification.dart';
import 'package:provider/provider.dart';

class Notifikasi extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Notifikasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,

          // CustomHeading(
          //   title: 'Aktifitas',
          // ),
          child: FutureBuilder(
            future:
                Provider.of<ApiNotifikasi>(context, listen: false).getNotif(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                // jika sudah ada data
                return Consumer<ApiNotifikasi>(
                  builder: (context, data, _) {
                    return ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: data.dataNotif.length,
                      itemBuilder: (context, i) {
                        return Material(
                          child: InkWell(
                            onTap: () {},
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
                                          data.dataNotif[i].from,
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
                                          data.dataNotif[i].message,
                                          style: TextStyle(
                                            color: Color(0xff8C68EC),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                        ),
                                        Text(
                                          data.dataNotif[i].date,
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
