import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mobile Number',
                  hintText: "mobile",
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OTP',
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle login logic here
                  String mobile = mobileController.text;
                  String otp = otpController.text;
                  print('Mobile: $mobile, OTP: $otp');
                },
                child: Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Background(){
    return Stack(children: [
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

            //all the extra items will come here

            Flexible(flex: 1, child: LogInWidget()),
          ],
        ),
      )


      // FadeInImage.assetNetwork(image:'https://www.shutterstock.com/image-photo/business-woman-drawing-global-structure-260nw-1006041130.jpg',placeholder: 'assets/circle_img.jpg'),
    ]);
  }
  Widget TextHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Today",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Colors.white)),
            Text("Yesterday",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Colors.white)),
            Text("Other",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Colors.white)),
          ],
        )
      ],
    );
  }

  Widget ExtraWidgets() {
    return Container(
      height: 50,
      width: 50,
      color: Colors.green,
    );
  }

  Widget LogInWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mobile Number',
                hintText: "mobile",
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'OTP',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle login logic here
                String mobile = mobileController.text;
                String otp = otpController.text;
                print('Mobile: $mobile, OTP: $otp');
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
