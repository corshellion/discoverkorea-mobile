import 'package:flutter/material.dart';
import 'package:discoverkorea/otherprofile_follower/following.dart';
import 'package:discoverkorea/otherprofile_follower/follower.dart';
import 'package:discoverkorea/otherprofile_follower/fanbase.dart';
import 'package:discoverkorea/providers/api_mengikuti.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(FollowingProfiles());
}

class FollowingProfiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Informasi",
      debugShowCheckedModeBanner: false,
      home: new Tabview(),
    );
  }
}

class Tabview extends StatefulWidget {
  final String uid;
  Tabview({this.uid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Tabview>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String uid="";

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    Provider.of<ApiMengikuti>(context, listen: false)
        .getOtherUserSpecified(widget.uid);
    uid = widget.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: new Text("Informasi ",
            style: TextStyle(color: Colors.black),
            textDirection: TextDirection.ltr),
        bottom: TabBar(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.blueGrey,
          tabs: [
            new Tab(child: Text("Fans")),
            new Tab(child: Text("Following")),
            new Tab(child: Text("Komunitas")),
          ],
          controller: _tabController,
          indicatorColor: Colors.blueGrey,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          Center(
            child: Follower(uid: uid),
          ),
          Center(
            child: Following(uid: uid),
          ),
          Center(
            child: Fanbase(),
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
