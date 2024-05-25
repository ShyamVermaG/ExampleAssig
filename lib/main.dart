import 'dart:io';

import 'package:example_assi/ShowQR.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
// import 'package:firebase_auth/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: 'AIzaSyCjRhi61fHV4WPhgrvtkcq13AKhRZM4hUc',
    appId: 'com.example.example_assi',

    messagingSenderId: 'sendid',

    projectId: 'exampleassign-83518',
    storageBucket: 'exampleassign-83518.appspot.com',
  ));
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //for getting current location
  String _locationMessage = 'Fetching location...';
  String _ipAddress = 'Fetching...';




  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();



  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLogin = false;
  String VerificationIdF="";

  String id = "";
  String mob = "";
  String otp = "";
  String location = "";
  String? ipAddress = "";

  @override
  void initState() {
    super.initState();

    //if already login navigate to another
    checkLogIn();

    _getCurrentLocation();

    //for taking ip address

    _getIPAddress();


  }


  //for taking city name

  Future<void> _getCityNameFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        location = place.locality ?? 'Unknown';
        print(location);
      });
    } catch (e) {
      print(e);
    }
  }



  //for show message

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


  //check user alredy login or not
  Future<void> checkLogIn() async {
    String? id = await _secureStorage.read(key: 'id');

    if(id==null||id==""){

    }else{
      //goto next activity
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowQR()),
      );
    }
  }

  //store session data
  Future<void> storeDataLocaly() async {
    await _secureStorage.write(key: 'id', value: id);
    await _secureStorage.write(key: 'mob', value: mob);
  }

  

  //for testing
  void showData(){
    print("ip"+ipAddress!);
    print("location"+_locationMessage);
  }


  //for taking current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'Location services are disabled.';
        showData();
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = 'Location permissions are denied';
          showData();
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = 'Location permissions are permanently denied, we cannot request permissions.';
        showData();
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      // location='${position.latitude},${position.longitude}';
      _getCityNameFromCoordinates(position.latitude,position.longitude);
      showData();
    });
  }

  //getting ip address
  Future<void> _getIPAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            setState(() {
              _ipAddress = addr.address;
              showData();
            });
            return;
          }
        }
      }
      setState(() {
        _ipAddress = 'IP address not found';
        showData();
      });
    } catch (e) {
      setState(() {
        _ipAddress = 'Failed to get IP address: $e';
        showData();
      });
    }
  }
  Future<void> _getIpAddress() async {
    final info = NetworkInfo();
    String? ipAddress;

    try {

      ipAddress = await info.getWifiIP(); // For WiFi
      // ipAddress = await info.getWifiIPv6(); // For IPv6
      // ipAddress = await info.getWifiSubmask(); // For Subnet Mask
      // ipAddress = await info.getWifiGatewayIP(); // For Gateway IP
    } catch (e) {
      ipAddress = 'Failed to get IP address: $e';
    }

    setState(() {
      _ipAddress = ipAddress!;
      showData();
    });
  }


  //if user click first time then send otp else verify otp
  void LogInOrValidateOTP() async {
    if (!isLogin) {

      _showSnackBar(context, "Sending OTP");
      //send otp
      await FirebaseAuth.instance.verifyPhoneNumber(
          verificationCompleted: (PhoneAuthCredential credential) {
            print("OtpVerifeid login sucessfull ");

          },
          verificationFailed: (FirebaseAuthException ex) {},
          codeSent: (String verificationId, int? resendToken) {

            print("Sucessfullt code sent"+verificationId);
            VerificationIdF=verificationId;

          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _showSnackBar(context, "Time Out");
            setState(() {

              isLogin=false;
            });
            return;

          },
          phoneNumber:"+91"+mobileController.text.toString());
      isLogin = true;

      mob=mobileController.text.toString();
      print('Mobile: $mob');
    } else {

      _showSnackBar(context, "Verifying OTP");

      //for verify otp
      try{

        PhoneAuthCredential credentiale=await  PhoneAuthProvider.credential(verificationId: VerificationIdF, smsCode: otpController.text.toString());

        FirebaseAuth.instance.signInWithCredential(credentiale).then((value) async => {

          print("Sucessfull login"+DateTime.now().millisecondsSinceEpoch.toString()),

          id=DateTime.now().millisecondsSinceEpoch.toString(),
          //store data
           await FirebaseDatabase.instance.ref().child("userLogIn").child(id).set({
            'mob':mob,
            'ip':_ipAddress,
            'location':location,
            'img':'',
          }).then((_) {

            storeDataLocaly();

            _showSnackBar(context, "Sucessfull login");

            print('Data stored successfully!');

            //goto next activity
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowQR()),
            );

          }).catchError((error) {
            print('Failed to store data: $error');
          }),

        });
      }catch(ex){
        _showSnackBar(context, "Incorrect OTP");

        print("Error Occured During Auth");
      }

      //get location,ip address
      //store it on firebase
      //store userId in session
      //goto next Activity
    }

    //for apply changes
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      body: Background(),

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
                    color: Color(0xff50318d),
                  ),
                  onPressed: () {
                    // Handle menu icon press
                  },
                ),
                Flexible(flex: 1, child: Container()),
                Text(
                  '',
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
                  "LOGIN",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                )),

            //all the extra items will come here

            Flexible(flex: 1, child: logInWidget()),
          ],
        ),
      )


      // FadeInImage.assetNetwork(image:'https://www.shutterstock.com/image-photo/business-woman-drawing-global-structure-260nw-1006041130.jpg',placeholder: 'assets/circle_img.jpg'),
    ]);
  }

  Widget ExtraWidgets() {
    return Container(
      height: 50,
      width: 50,
      color: Colors.green,
    );
  }

  Widget logInWidget(){
    return Container(
      margin: EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              Text("Phone Number",style: TextStyle(color: Colors.white),),
              const SizedBox(height: 5),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.white,fontSize: 18),

                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(top: 0,bottom: 0,right: 2,left: 10),
                  hintStyle: TextStyle(color: Colors.black,fontSize: 10),
                  filled: true,
                  fillColor: Color(0xff50318d),

                ),
              ),
              const SizedBox(height: 16),
              Text("OTP",style: TextStyle(color: Colors.white),),
              const SizedBox(height: 5),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.white,fontSize: 18),

                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(top: 0,bottom: 0,right: 2,left: 10),
                  filled: true,
                  fillColor: Color(0xff50318d),

                ),
              ),
              SizedBox(height: 48),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(2),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(1),borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextButton(

                  onPressed: () {
                    LogInOrValidateOTP();
                  },
                  child: Text(!isLogin ? "SEND OTP" : "LOGIN" ,style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
