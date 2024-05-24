import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'LogIn.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: FirebaseOptions(
//     apiKey: 'AIzaSyCjRhi61fHV4WPhgrvtkcq13AKhRZM4hUc',
//     appId: 'com.example.example_assi',
//
//     messagingSenderId: 'sendid',
//
//     projectId: 'exampleassign-83518',
//     storageBucket: 'exampleassign-83518.appspot.com',
//   ));
//   await Firebase.initializeApp();
//   runApp( Home());
// }

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  String id = "155521212";
  String mob = "155521212";
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  final dbRef = FirebaseDatabase.instance.ref("userLogIn");

  @override
  void initState() {
    super.initState();

    getCheckData();
  }

  Future<void> getCheckData() async {
    id = (await _secureStorage.read(key: 'id'))!;
    mob = (await _secureStorage.read(key: 'mob'))!;

    if (id == null || id == "") {
      //goto logIn activity
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Background());
  }

  Widget Background() {
    return Container(
      child: Stack(children: [
        //for background
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xff50318d),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/circle_assig.jpg',
                    height: 60,
                    width: 110,
                  ),
                ],
              ),
              Flexible(
                flex: 1,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                ),
              )
            ],
          ),
        ),

        //for appbar and a stack with rest of screen

        Container(
          margin: EdgeInsets.all(5),
          color: Colors.black.withOpacity(0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Handle menu icon press
                    },
                  ),
                  Flexible(flex: 1, child: Container()),
                  Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        letterSpacing: 1),
                  ),
                ],
              ),

              //activity name
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.blueAccent),
                  padding: EdgeInsets.all(2),
                  child: Text(
                    "Last Login",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal),
                  )),

              TextHeader(),

              //all the extra items will come here
              Expanded(
                child: FirebaseAnimatedList(
                    query: dbRef,
                    defaultChild: Text("Loading"),
                    itemBuilder: (context, snapshot, animation, index) {
                      // Map users=snapshot.value as Map;
                      // users['time']=snapshot.key;

                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            height: 70,
                            decoration: BoxDecoration(
                                color: Color(0xff404040),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.child('mob').value.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 12),
                                ),
                                Text(
                                  snapshot.child('ip').value.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 12),
                                ),
                                Text(
                                  snapshot.child('location').value.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              if (snapshot.child('img').value.toString() !=
                                      null &&
                                  snapshot.child('img').value.toString() != "")
                                Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.white),
                                    child: Image.network(
                                        snapshot.child('img').value.toString()))
                              // child: NetworkImage(
                              //     child:snapshot.child('img').value.toString()),
                              // ),
                            ],
                          )
                        ],
                      );
                    }),
              ),
              // ExtraWidgets(),
            ],
          ),
        )

        // FadeInImage.assetNetwork(image:'https://www.shutterstock.com/image-photo/business-woman-drawing-global-structure-260nw-1006041130.jpg',placeholder: 'assets/circle_img.jpg'),
      ]),
    );
  }

  Widget TextHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(15),
            child: Text("Today",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Colors.white)),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: Text("Yesterday",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                    decorationThickness: 2,
                    decorationColor: Colors.white)),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: Text("Other",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    decorationThickness: 2,
                    decorationColor: Colors.white)),
          ),
        ],
      )
    ]);
  }
}
