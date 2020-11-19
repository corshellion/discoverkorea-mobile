import 'package:flutter/material.dart';
import 'package:discoverkorea/profile_follower/following.dart';
import 'package:discoverkorea/profile_follower/follower.dart';
import 'package:discoverkorea/profile_follower/fanbase.dart';
void main() {
  runApp(FollowingProfiles(1));
}

class FollowingProfiles extends StatelessWidget {
  int selectedPage;
  FollowingProfiles(this.selectedPage);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Informasi",
      debugShowCheckedModeBanner: false,
      home: new Tabview(1),
    );
  }
}

class Tabview extends StatefulWidget {
  int selectedPage;
  Tabview(this.selectedPage);
  @override
  _HomePageState createState() => _HomePageState(2);
}

class _HomePageState extends State<Tabview>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int selectedPage;
  _HomePageState(this.selectedPage);
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex:2,
      length: 3,
      child:Scaffold(
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
              child: Follower(),
            ),
            Center(
              child: Following(),
            ),
            Center(
              child: Fanbase(),
            ),
          ],
          controller: _tabController,
        ),
      )
    );

  }
}
