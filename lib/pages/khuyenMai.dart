import 'package:btl/obj/obj_khuyenMai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class khuyenMai extends StatefulWidget {
  const khuyenMai({super.key});

  @override
  State<khuyenMai> createState() => _khuyenMaiState();
}

class _khuyenMaiState extends State<khuyenMai> {

  List<obj_khuyenMai> listKM = [];

  Future getKM() async {
    final result =
        await FirebaseFirestore.instance.collection("tblKhuyenMai").get();
    if(result.docs.isNotEmpty) {
      result.docs.forEach((value) {
        obj_khuyenMai km = obj_khuyenMai(value["sTen"], value["sLink"], value["sNoiDung"], value["dThoiGian"]);
        listKM.add(km);
      });
    }
    setState(() {

    });
  }


  @override
  void initState() {
    super.initState();
    getKM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          flexibleSpace: Container(
            height: 200,
            child: Image.asset(
              "assets/images/mixue_logo.jpg",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 3,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 30, bottom: 7),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/fire.png",
                      height: 40,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      "Tin hot!!!",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: CustomScrollView(
                slivers: [
                  if(listKM.length > 0) ...[
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),

                        child: Image.network(listKM[0].link),
                      ),
                    ),
                  ],

                  SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Image.network(
                        listKM[index + 1].link,
                        // height: 50,
                        fit: BoxFit.cover,
                      );
                    }, childCount: listKM.length -1),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        // crossAxisCount: 2,
                        maxCrossAxisExtent: 500,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 30,

                        childAspectRatio: 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
