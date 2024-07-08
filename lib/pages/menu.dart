import 'package:btl/obj/obj_sanPham.dart';
import 'package:btl/pages/CT_SanPham.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class menu extends StatefulWidget {
  const menu({super.key});

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  List<sanPham> _listSP = [];
  List<sanPham> _listTP = [];


  Future getListSP() async {
    try {
      final result =
          await FirebaseFirestore.instance.collection("tblSanPham").get();
      if (result.docs.isNotEmpty) {

        int count = 0;
        result.docs.forEach((value) {

          if (value["iLoai"] == 1) {
            sanPham sp = new sanPham(value.id,
                value["sTenSp"], value["sLink"], value["fGia"], value["iLoai"] );

            _listSP.add(sp);
          } else {
            sanPham sp = new sanPham(value.id,
                value["sTenSp"], value["sLink"], value["fGia"], value["iLoai"] );
            _listTP.add(sp);
          }
        });
      }
      setState(() {});
    } catch (e) {
      print(e.toString() + "ERROR");
    }
  }

  @override
  void initState() {
    super.initState();
    getListSP();
    print(_listTP.length.toString() + "hah");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, top: 30),
                  child: Text(
                    "Menu",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 27),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 30, top: 30),
                  child: IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearch(_listSP, _listTP),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 500,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CT_SanPham(
                          sp: _listSP[index],
                          listTP: _listTP,
                        );
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Color(0xfff6b5b5),
                          borderRadius: BorderRadius.circular(20)),
                      height: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.network(
                            _listSP[index].link,
                            width: 270,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                _listSP[index].tenSP,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Text(
                            _listSP[index].gia.toString() + " VNĐ",
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: _listSP.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  List<sanPham> _listSP;
  List<sanPham> _listTP;



  CustomSearch(this._listSP, this._listTP);



  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    List<sanPham> matchQuery = [];

    for (var fruit in _listSP) {
      if (fruit.tenSP.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: 30,
      ),
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        // var result = matchQuery[index];
        return Container(
          child: Row(
            children: [
              SizedBox(
                width: 70,
              ),
              Image.network(
                matchQuery[index].link,
                height: 70,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 40,
              ),
              Text(matchQuery[index].tenSP)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {


    List<sanPham> matchQuery = [];

    for (var fruit in _listSP) {
      if (fruit.tenSP.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: 30,
      ),
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        // var result = matchQuery[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CT_SanPham(sp: matchQuery[index], listTP: _listTP);
            }));
          },
          child: Container(
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                ),
                Image.network(
                  matchQuery[index].link,
                  height: 70,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 40,
                ),
                Text(matchQuery[index].tenSP)
              ],
            ),
          ),
        );
      },
    );
  }
}
