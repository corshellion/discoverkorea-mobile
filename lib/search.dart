import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/providers/api_unggahan.dart';
import 'package:discoverkorea/image_detail.dart';

class Discover extends StatefulWidget {
  Discover({Key key}) : super(key: key);

  @override
  DiscoverList createState() => DiscoverList();
}

class DiscoverList extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.4,
        backgroundColor: Colors.white,
        title: Text(
          'Search ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: EdgeInsets.only(bottom: 0),
          padding: EdgeInsets.only(bottom: 0),
          child: FutureBuilder(
            future: Provider.of<ApiUnggahan>(context, listen: false).getAllPost(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Consumer<ApiUnggahan>(
                builder: (context, data, _) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: data.dataPost.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, i) {
                        return new InkWell(
                          child: new Card(
                            child: new GridTile(
                              child: Container(
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                          'https://discoverkorea.site/uploads/file/' +
                                              data.dataPost[i].file),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageDetail(
                                        id: data.dataPost[i].id,
                                      )),
                            ).then((value) => setState(() {}));
                          },
                        );
                      });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<List<String>> fetchGalleryData() async {
  try {
    final response = await http
        .get(
            'https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json')
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      return compute(parseGalleryData, response.body);
    } else {
      throw Exception('Failed to load');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load');
  }
}

List<String> parseGalleryData(String responseBody) {
  final parsed = List<String>.from(json.decode(responseBody));
  return parsed;
}
