import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mwff/Product/product_add.dart';

    class SingleProduct extends StatefulWidget {
      const SingleProduct({super.key , required this.productID});

      final String productID;

      @override
      State<SingleProduct> createState() => _SingleProductState();
    }

    class _SingleProductState extends State<SingleProduct> {

      int productQuantity = 1;

      void pIncrease(){
        setState(() {
          productQuantity = productQuantity + 1;
        });
      }

      void pDecrease(){
        if(productQuantity>1){
          setState(() {
            productQuantity = productQuantity - 1;
          });
        }
      }


      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Column(

            children: [

              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductAdd(),));
              }, child: Text("Add Cart")),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Products").where("Product-ID",isEqualTo: widget.productID).snapshots(),
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

                        int pPrice = int.parse(productPrice);
                        int productprice = pPrice * productQuantity;
                        return ListTile(
                          title: Text(productName),
                          subtitle: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productCategory),
                                  Text("${productprice}")
                                ],
                              ),

                              IconButton(onPressed: (){
                                pDecrease();
                              }, icon: Icon(Icons.minimize)),
                              Text("$productQuantity"),
                              IconButton(onPressed: (){
                                pIncrease();
                              }, icon: Icon(Icons.add))
                            ],
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

