import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  TextEditingController userName = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  // void userAdd()async{
  //
  //   Map<String, dynamic> uAdd = {
  //     "userName" : userName.text,
  //     "userEmail" : userEmail.text,
  //     "userAddress" : userAddress.text,
  //     "userPassword" : userPassword.text
  //   };
  //
  //   await FirebaseFirestore.instance.collection("userData").add(uAdd);
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Added Successfully")));
  //
  // }

  void userAdd()async{

    String userID = const Uuid().v1();

    Map<String, dynamic> uAdd = {
      "userID" : userID,
      "userName" : userName.text,
      "userEmail" : userEmail.text,
      "userAddress" : userAddress.text,
      "userPassword" : userPassword.text
    };

    await FirebaseFirestore.instance.collection("userData").doc(userID).set(uAdd);
    if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Added Successfully")));
    }
    Future.delayed(const Duration(milliseconds: 500));
    userName.clear();
    userEmail.clear();
    userPassword.clear();
    userAddress.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),

            TextFormField(
              decoration: const InputDecoration(
                  hintText: "Enter Your Name"
              ),
              controller: userName,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: "Enter Your Address"
              ),
              controller: userAddress,
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
              userAdd();
            }, child: const Text("Add User"))),


            const SizedBox(
              height: 10,
            ),

            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("userData").snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }

                  if(snapshot.hasData){

                    var dataLength = snapshot.data!.docs.length;

                    return ListView.builder(
                      itemCount: dataLength,
                      shrinkWrap: true,
                      itemBuilder:  (context, index) {

                        String userName = snapshot.data!.docs[index]["userName"];
                        String uID = snapshot.data!.docs[index]["userID"];
                        //String userEmail = snapshot.data!.docs[index]["userEmail"];

                      return ListTile(
                        title: Text(userName),
                        subtitle: Text("${snapshot.data!.docs[index]["userEmail"]}"),
                        trailing: IconButton(onPressed: (){
                         showAdaptiveDialog(
                           context: context,
                           builder: (context) {
                           return  AlertDialog(
                             title: const Text("Do You want to Delete?"),
                             actions: [
                               IconButton(onPressed: ()async{
                                 await FirebaseFirestore.instance.collection("userData").doc(uID).delete();
                                 if(context.mounted){
                                   Navigator.pop(context);
                                 }
                               }, icon: const Text("Delete", style: TextStyle(color: Colors.red),)),
                               IconButton(onPressed: (){
                                 Navigator.pop(context);
                               }, icon: const Text("Cancel")),
                             ],
                           );
                         },);
                        }, icon: const Icon(Icons.delete,color: Colors.red,)),
                      );
                    },);
                  }

                  if(snapshot.hasError){
                    return const Icon(Icons.error, color: Colors.red,);
                  }

                  return Container();
                },)
          ],
        ),
      )
    );
  }
}
