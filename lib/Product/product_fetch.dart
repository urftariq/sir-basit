import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mwff/Product/product_add.dart';
import 'package:flutter_mwff/Product/single_product.dart';

class ProductFetch extends StatefulWidget {
  const ProductFetch({super.key});

  @override
  State<ProductFetch> createState() => _ProductFetchState();
}

class _ProductFetchState extends State<ProductFetch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children: [

            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductAdd(),));
            }, child: Text("Add Product")),

          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Products").snapshots(),
            builder: (context, snapshot) {

              if(snapshot.hasData){
                var dataLength = snapshot.data!.docs.length;
                return ListView.builder(
                  itemCount: dataLength,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String productID = snapshot.data!.docs[index]["Product-ID"];
                    String productName = snapshot.data!.docs[index]["Product-Name"];
                    String productCategory = snapshot.data!.docs[index]["Product-Category"];
                    String productPrice = snapshot.data!.docs[index]["Product-Price"];

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SingleProduct(
                          productID: productID,
                        ),));
                      },
                      child: ListTile(
                        title: Text(productName),
                        subtitle: Text(productCategory),
                      ),
                    );
                  },);
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }

              return Container();
          },),
        ],
      ),
    );
  }
}
