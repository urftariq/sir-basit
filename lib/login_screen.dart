import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mwff/home_screen.dart';
import 'package:flutter_mwff/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  void userRegister()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail.text,
          password: userPassword.text);
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Logged In")));
          Navigator.push(context,  MaterialPageRoute(builder: (context) => DashBoardScreen(),));
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
        title: const Text("Login Screen"),
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
            }, child: const Text("Login"))),

            const SizedBox(
              height: 20,
            ),

            Center(child: TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHome(),));
            }, child: const Text("Go to Register"))),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
