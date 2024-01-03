import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mwff/firebase_options.dart';
import 'package:flutter_mwff/login_screen.dart';

import 'home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DashBoardScreen(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  void userRegister()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail.text,
          password: userPassword.text);
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Registered")));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
      }
    } on FirebaseAuthException catch(ex){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),

            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter Your Email"
              ),
              controller: userEmail,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: "Enter Your Password"
              ),
              controller: userPassword,
            ),

            const SizedBox(
              height: 20,
            ),

            Center(child: ElevatedButton(onPressed: (){
              userRegister();
            }, child: const Text("Register"))),

            const SizedBox(
              height: 20,
            ),

            Center(child: TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
            }, child: const Text("Go to Login"))),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}


