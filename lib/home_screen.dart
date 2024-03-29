import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mwff/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String uEmail = '';

  Future getUserCred()async{
    SharedPreferences userCred = await SharedPreferences.getInstance();
    return userCred.getString("userEmail");
  }

  void userLogout()async{
    await FirebaseAuth.instance.signOut();
    SharedPreferences userCred = await SharedPreferences.getInstance();
    userCred.clear();
    if(context.mounted){
      Navigator.push(context,  MaterialPageRoute(builder: (context) => const LoginScreen(),));
    }
  }

  void userAddWithImage()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail.text,
          password: userPassword.text);
      SharedPreferences userCred = await SharedPreferences.getInstance();
      userCred.setString("userEmail", userEmail.text);
      String userID = const Uuid().v1();

      // User Image with ID
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("UserImages/").child(userID).putFile(userProfile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String userImage = await taskSnapshot.ref.getDownloadURL();

      // User Data with ID
      userAdd(userID: userID, userImage: userImage);
    }on FirebaseAuthException catch(ex){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
      }
    }
  }

  void userAdd({String? userID, String? userImage})async{

    Map<String, dynamic> uAdd = {
      "userID" : userID,
      "userName" : userName.text,
      "userImage" : userImage,
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

  File? userProfile;

  @override
  void initState() {
    // TODO: implement initState
    getUserCred().then((value) {
      setState(() {
        uEmail = value;
      });
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(uEmail),
        actions: [
          GestureDetector(
            onTap: (){
              showAdaptiveDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text("Select Your Image Source?"),
                  actions: [
                    TextButton(onPressed: ()async{
                      XFile? selectImage = await ImagePicker().pickImage(source: ImageSource.camera);
                      if(selectImage != null){
                        File convertedFile = File(selectImage.path);
                        setState(() {
                          userProfile = convertedFile;
                        });
                      }
                      else{
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Not Selected")));
                        }
                      }
                      if(context.mounted){
                        Navigator.pop(context);
                      }
                    }, child: const Text("Select From Camera", style: TextStyle(color: Colors.red),)),
                    TextButton(onPressed: ()async{
                      XFile? selectImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(selectImage != null){
                        File convertedFile = File(selectImage.path);
                        setState(() {
                          userProfile = convertedFile;
                        });
                      }
                      else{
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Not Selected")));
                        }
                      }
                      if(context.mounted){
                        Navigator.pop(context);
                      }
                    }, child: const Text("Select From Gallery")),
                  ],
                );
              },);
              },
            child: userProfile == null ?
            const CircleAvatar(
              backgroundImage: NetworkImage('https://cdn3d.iconscout.com/3d/premium/thumb/man-9251877-7590869.png?f=webp'),
              backgroundColor: Colors.blue,
            ): CircleAvatar(
              backgroundImage: userProfile !=null ? FileImage(userProfile!) : null,
              backgroundColor: Colors.blue,
            ),
          ),
          const SizedBox(
            width: 14,
          ),

          IconButton(onPressed: (){
            userLogout();
          }, icon: const Icon(Icons.logout)),

          const SizedBox(
            width: 14,
          ),
        ],
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
              userAddWithImage();
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

                        String uName = snapshot.data!.docs[index]["userName"];
                        String uEmail = snapshot.data!.docs[index]["userEmail"];
                        String uPassword = snapshot.data!.docs[index]["userPassword"];
                        String uAddress = snapshot.data!.docs[index]["userAddress"];
                        String uImage = snapshot.data!.docs[index]["userImage"];
                        String uID = snapshot.data!.docs[index]["userID"];
                        //String userEmail = snapshot.data!.docs[index]["userEmail"];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(uImage),
                        ),
                        title: Text(uName),
                        subtitle: Text(uEmail),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(onPressed: (){
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return  AlertDialog(
                                      title: const Text("Do You want to Delete?"),
                                      actions: [
                                        TextButton(onPressed: ()async{
                                          await FirebaseFirestore.instance.collection("userData").doc(uID).delete();
                                          await FirebaseStorage.instance.refFromURL(uImage).delete();
                                          if(context.mounted){
                                            Navigator.pop(context);
                                          }
                                        }, child: const Text("Delete", style: TextStyle(color: Colors.red),)),
                                        TextButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: const Text("Cancel")),
                                      ],
                                    );
                                  },);
                              }, icon: const Icon(Icons.delete,color: Colors.red,)),
                              IconButton(onPressed: (){
                                showBottomSheet(
                                  // backgroundColor: Colors.red,
                                  context: context,
                                  builder: (context) {
                                    TextEditingController uUserName = TextEditingController();
                                    TextEditingController uUserAddress = TextEditingController();
                                    TextEditingController uUserEmail = TextEditingController();
                                    TextEditingController uUserPassword = TextEditingController();

                                    File? userUpdatedProfile;

                                    void updateUser({String? userImage})async{
                                      await FirebaseFirestore.instance.collection("userData").doc(uID).update(
                                          {
                                            "userName" : uUserName.text,
                                            "userEmail" : uUserEmail.text,
                                            "userImage" : userImage,
                                            "userAddress" : uUserAddress.text,
                                            "userPassword" : uUserPassword.text
                                          });
                                      Navigator.pop(context);
                                    }

                                    void userUpdateWithImage()async{
                                      await FirebaseStorage.instance.refFromURL(uImage).delete();
                                      UploadTask uploadTask = FirebaseStorage.instance.ref().child("UserImages/").child(uID).putFile(userUpdatedProfile!);
                                      TaskSnapshot taskSnapshot = await uploadTask;
                                      String userImage = await taskSnapshot.ref.getDownloadURL();
                                      updateUser(userImage: userImage);
                                    }

                                    uUserName.text = uName;
                                    uUserAddress.text = uAddress;
                                    uUserEmail.text = uEmail;
                                    uUserPassword.text = uPassword;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    height: 500,
                                    child: Column(
                                      children: [
                                      const SizedBox(
                                      height: 20,
                                    ),

                                        const Text("Update User"),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        GestureDetector(
                                          onTap: ()async{
                                            XFile? selectUpdateImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                                            if(selectUpdateImage != null){
                                              File convertUpdatedFile = File(selectUpdateImage.path);
                                              setState(() {
                                                userUpdatedProfile = convertUpdatedFile;
                                              });
                                            }
                                            else{
                                              if(context.mounted){
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Not Selected")));
                                              }
                                            }
                                          },
                                          child: userUpdatedProfile == null ? CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(uImage),
                                          ): CircleAvatar(
                                            radius: 30,
                                            backgroundImage: userUpdatedProfile != null ? FileImage(userUpdatedProfile!): null,
                                          )
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      TextFormField(
                                      decoration: const InputDecoration(
                                      hintText: "Enter Your Name"
                                      ),
                                      controller: uUserName,
                                      ),
                                      TextFormField(
                                      decoration: const InputDecoration(
                                      hintText: "Enter Your Address"
                                      ),
                                      controller: uUserAddress,
                                      ),
                                      TextFormField(
                                      decoration: const InputDecoration(
                                      hintText: "Enter Your Email"
                                      ),
                                      controller: uUserEmail,
                                      ),
                                      TextFormField(
                                      decoration: const InputDecoration(
                                      hintText: "Enter Your Password"
                                      ),
                                      controller: uUserPassword,
                                      ),

                                      const SizedBox(
                                      height: 20,
                                      ),

                                      Center(child: ElevatedButton(onPressed: ()async{
                                        userUpdateWithImage();
                                      }, child: const Text("Update User"))),]
                                    ),
                                  );
                                },);
                              }, icon: const Icon(Icons.update,color: Colors.orange,))
                            ],
                          ),
                        ),
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
