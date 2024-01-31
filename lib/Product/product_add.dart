import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mwff/Product/product_fetch.dart';
import 'package:uuid/uuid.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  TextEditingController productName = TextEditingController();
  TextEditingController productCategory = TextEditingController();
  TextEditingController productPrice = TextEditingController();

  void addProduct()async{
    try{

      String productID = Uuid().v1();

      Map<String, dynamic> productAdd = {
        "Product-ID" : productID,
        "Product-Name" : productName.text,
        "Product-Category" : productCategory.text,
        "Product-Price" : productPrice.text,
      };

      await FirebaseFirestore.instance.collection("Products").doc().set(productAdd);

      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductFetch(),));

    } catch(ex){

        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),

          TextFormField(
            decoration: const InputDecoration(
                hintText: "Enter Your Product Name"
            ),
            controller: productName,
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Enter Product Category"
            ),
            controller: productCategory,
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Enter Product Price"
            ),
            controller: productPrice,
          ),

          const SizedBox(
            height: 20,
          ),

          Center(child: ElevatedButton(onPressed: (){
            addProduct();
          }, child: const Text("Add Product"))),


          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
