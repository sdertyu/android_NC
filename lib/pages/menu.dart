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
  List<sanPham> _listALL = [];
  List<String> tieuDe = ["Tất cả"];
  String title = "Tất cả";

  Future getListSP() async {
    try {
      final result = await FirebaseFirestore.instance
          .collection("tblSanPham")
          .orderBy("sLoai", descending: false)
          .get();
      if (result.docs.isNotEmpty) {
        int count = 0;
        result.docs.forEach((value) {
          if (value["sLoai"] != "topping") {
            sanPham sp = new sanPham(value.id, value["sTenSP"], value["sLink"],
                value["fGia"], value["sLoai"]);

            if (!tieuDe.contains(value["sLoai"])) {
              tieuDe.add(value["sLoai"]);
            }

            _listALL.add(sp);
          } else {
            sanPham sp = new sanPham(value.id, value["sTenSP"], value["sLink"],
                value["fGia"], value["sLoai"]);
            _listTP.add(sp);
          }
        });
      }
      _listSP = _listALL;
      setState(() {});
    } catch (e) {
      print(e.toString() + "ERROR");
    }
  }

  Future GetListTheoTD(String td) async {
    _listSP = [];
    if (td == "Tất cả") {
      _listSP = _listALL;
    } else
      _listSP = _listALL.where((sp) => sp.loai == td).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getListSP();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Container(
              width: size.width * 0.2,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(width: 2, color: Colors.red)),
              ),
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: tieuDe.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        margin: EdgeInsets.only(top: 30),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.pink),
                          ),
                          onPressed: () {
                            if (title != tieuDe[index]) {
                              title = tieuDe[index];
                              GetListTheoTD(title);
                              setState(() {});
                            }
                          },
                          child: Text(
                            tieuDe[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30, top: 30),
                        child: Text(
                          title,
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
