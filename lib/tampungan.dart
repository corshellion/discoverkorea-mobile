// import 'package:flutter/material.dart';
// import 'package:discoverkorea/animation/FadeAnimation.dart';
// import 'package:discoverkorea/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:discoverkorea/providers/api_user.dart';
// import 'package:discoverkorea/login_screen.dart';
//
// class RegisterScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<RegisterScreen> {
//   final TextEditingController _nama = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _username = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   final TextEditingController _confirmation = TextEditingController();
//   bool _isLoading = false;
//
//   final snackbarKey = GlobalKey<ScaffoldState>();
//
//   FocusNode emailNode = FocusNode();
//   FocusNode usernameNode = FocusNode();
//   void submit(BuildContext context) {
//     if (!_isLoading) {
//       setState(() {
//         _isLoading = true;
//       });
//       Provider.of<ApiUser>(context, listen: false)
//           .storeUser(_email.text, _nama.text, _username.text, _password.text,
//               _confirmation.text)
//           .then((res) {
//         if (res) {
//           Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//               (route) => false);
//         } else {
//           var snackbar = SnackBar(
//             content: Text('Ops, Error. Hubungi Admin'),
//           );
//           snackbarKey.currentState.showSnackBar(snackbar);
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Add Employee'),
//           actions: <Widget>[
//             FlatButton(
//               child: _isLoading
//                   ? CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     )
//                   : Icon(
//                       Icons.save,
//                       color: Colors.white,
//                     ),
//               onPressed: () => submit(context),
//             )
//           ],
//         ),
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   height: 250,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/images/background2.png'),
//                           fit: BoxFit.fill)),
//                   child: Stack(
//                     children: <Widget>[
//                       Positioned(
//                         child: FadeAnimation(
//                             1.6,
//                             Container(
//                               margin: EdgeInsets.only(top: 50),
//                               child: Center(
//                                 child: Text(
//                                   "",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 40,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             )),
//                       )
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(30.0),
//                   child: Column(
//                     children: <Widget>[
//                       FadeAnimation(
//                           1.8,
//                           Container(
//                             padding: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Color.fromRGBO(143, 148, 251, .2),
//                                       blurRadius: 20.0,
//                                       offset: Offset(0, 10))
//                                 ]),
//                             child: Column(
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.all(8.0),
//                                   decoration: BoxDecoration(
//                                       border: Border(
//                                           bottom: BorderSide(
//                                               color: Colors.grey[100]))),
//                                   child: TextField(
//                                     controller: _nama,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: "Nama Lengkap",
//                                         hintStyle:
//                                             TextStyle(color: Colors.grey[400])),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(8.0),
//                                   decoration: BoxDecoration(
//                                       border: Border(
//                                           bottom: BorderSide(
//                                               color: Colors.grey[100]))),
//                                   child: TextField(
//                                     controller: _username,
//                                     focusNode: usernameNode,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: "Username",
//                                         hintStyle:
//                                             TextStyle(color: Colors.grey[400])),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(8.0),
//                                   decoration: BoxDecoration(
//                                       border: Border(
//                                           bottom: BorderSide(
//                                               color: Colors.grey[100]))),
//                                   child: TextField(
//                                     controller: _email,
//                                     focusNode: emailNode,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: "E-mail",
//                                         hintStyle:
//                                             TextStyle(color: Colors.grey[400])),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: TextField(
//                                     controller: _password,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: "Kata sandi",
//                                         hintStyle:
//                                             TextStyle(color: Colors.grey[400])),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: TextField(
//                                     controller: _confirmation,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: "Ulangi kata sandi",
//                                         hintStyle:
//                                             TextStyle(color: Colors.grey[400])),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           )),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       FadeAnimation(
//                           2,
//                           FlatButton(
//                             child: _isLoading
//                                 ? CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.black),
//                                   )
//                                 : Icon(
//                                     Icons.save,
//                                     color: Colors.black,
//                                   ),
//                             onPressed: () => submit(context),
//                           )),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }
