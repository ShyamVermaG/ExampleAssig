
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:example_assi/LogIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import 'Home.dart';


class ShowQR extends StatefulWidget {
  const ShowQR({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the ststate. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<ShowQR> createState() => _MyShowQr();
}

class _MyShowQr extends State<ShowQR> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final ScreenshotController screenshotController=ScreenshotController();
  String id="155521212";

  String randomNumStr="sds";

  int logInHour=0;
  String logInIsZone="AM";

    @override
    void initState() {
      super.initState();

      getCheckData();

      //generating random number for qr image
      var random = Random();
      randomNumStr= (10000+random.nextInt(90000)).toString() ;

      Duration duration = Duration(milliseconds: int.parse(id));
      logInHour=duration.inHours;

      logInHour%=24;

      if(logInHour>12)
        logInIsZone="PM";
      else{
        logInIsZone="AM";
      }

      logInHour%=12;
    }

    Future<void> getCheckData() async {
      id = (await _secureStorage.read(key: 'id'))!;

      if (id == null || id == "") {
        //goto logIn activity
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }


  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Custom duration
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Code to execute.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  Future<void> saveQrImage() async {
      Uint8List? unit8list=await screenshotController.capture();

      if(unit8list!=null){

        uploadImageToFirebaseStorage(unit8list);
      }

  }

  Future<File> convertUint8ListToFile(Uint8List data, String fileName) async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(data);
    return file;
  }

  Future<void> uploadImageToFirebaseStorage(Uint8List imageData) async {
    try {
      _showSnackBar(context, "Uploading Image");
      var imageNameId=DateTime.now().millisecondsSinceEpoch;
      // Convert Uint8List to File
      File imageFile = await convertUint8ListToFile(imageData, '${imageNameId}.png');

      // Upload file to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child('images').child(imageNameId.toString());
      UploadTask uploadTask = storageRef.putFile(imageFile);

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      print('Image uploaded successfully. Download URL: $downloadUrl');


      //update data to add image Url
      await FirebaseDatabase.instance.ref().child('userLogIn').child(id).update({
        'img': downloadUrl,
      }).then((_) {
        print('Url Added successfully.');
        _showSnackBar(context, "Uploaded Sucessful");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }).catchError((error) {
        print('Error updating data: $error');
      });


      // await uploadTask.whenComplete(() => print('Image uploaded successfully'));
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(

      home: Scaffold(
        body:Background(context),
      ),


    );


  }


  Widget Background(BuildContext context){
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
                
                child: Column(
                  children: [
                    Expanded(flex:1,child: Container()),
                    Container(
                        height:150,
                        width:double.infinity,
                        margin: EdgeInsets.all(20),
                        child: Image.asset('assets/images/center_img.jpg')
                    ),

                    Expanded(flex:2,child: Container()),

                  ],
                )

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
                    color: Color(0xff50318d),
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
                  "PLUGIN",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                )),

            //all the extra items will come here

            Flexible(flex: 1, child:

                ExtraWidgets(context)

            ),
          ],
        ),
      )


      // FadeInImage.assetNetwork(image:'https://www.shutterstock.com/image-photo/business-woman-drawing-global-structure-260nw-1006041130.jpg',placeholder: 'assets/circle_img.jpg'),
    ]);
  }














  Widget ExtraWidgets(BuildContext context) {
    return
        Container(
          margin: EdgeInsets.all(20),

          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top:30),
                child: Column(children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: Colors.white),

                    child: Screenshot(
                      controller: screenshotController,
                      child: QrImageView(data: randomNumStr,version: QrVersions.auto,gapless: false,
                      size: 100,),
                    ),
                  ),

                  Container(
                      margin:EdgeInsets.only(top:10),
                      child: Text('Generated number',style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.normal),)),
                  Container(
                      margin:EdgeInsets.only(top:10),
                      child: Text(randomNumStr,style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.normal),)),

                ],),
              ),
              Column(children: [
                Container(
                  margin: EdgeInsets.only(left:20,right: 20,bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),border: Border.all(color: Colors.white,width: 1)),

                  child: TextButton(

                    onPressed: () {

                      print("gotoNext avi");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Text("Last login at Today,"+logInHour.toString()+""+logInIsZone,style:TextStyle(color: Colors.white,fontSize:10,fontWeight: FontWeight.normal)),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left:20,right:20,top:10),
                  padding: EdgeInsets.all(2),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(1),borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextButton(

                    onPressed: () {

                      saveQrImage();
                    },
                    child: Text("SAVE" ,style: TextStyle(color: Colors.white),),
                  ),
                ),

              ],)
            ],
          ),
        );
  }


}
