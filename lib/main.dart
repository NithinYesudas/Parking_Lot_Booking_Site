import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_slot_booker/screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(

          apiKey: "AIzaSyBOZJIGcs9zZ6-AiFdePdXSFGaaEYeCh9s",
          appId: "1:744036313656:web:4f92dd3f45acb4fdd954cd",
          messagingSenderId: "744036313656",
          projectId: "parking-slot-booker")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking Booking App',
      home: HomeScreen(),
    );
  }
}