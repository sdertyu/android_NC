import 'package:btl/obj/obj_sanPham.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CT_SanPham extends StatefulWidget {
  sanPham sp;
  List<sanPham> listTP;

  CT_SanPham({super.key, required this.sp, required this.listTP});

  @override
  State<CT_SanPham> createState() => _CT_SanPhamState();
}

class _CT_SanPhamState extends State<CT_SanPham> {
  late sanPham sp;
  String sizeSP = "";
  List<bool> topping = [];
  List<String> topp_name = ["Trân châu", "thạch đào", "thạch dừa", "lô hội"];
  List<sanPham> listTP = [];
  double ice = 1;
  double sugar = 1;
  int sl = 1;
  double gia = 0;
  TextEditingController _controller_GC = TextEditingController();
  TextEditingController _controller_SL = TextEditingController();

  @override
  void initState() {
    super.initState();
    sp = widget.sp;
    listTP = widget.listTP;
    topping = List.generate(
      widget.listTP.length,
      (index) => false,
    );
    _controller_SL.text = sl.toString();
    gia = sp.gia;
    setState(() {});
  }

  String formatNumber(double number) {
    final formatter = NumberFormat.decimalPattern('vi_VN');
    return formatter.format(number);
  }

  void themVaoGH() async {
    String topp = "";
    int tp = 0;
    for (int i = 0; i < topping.length; i++) {
      if (topping[i]) {
        tp++;
        if (topp != "") {
          topp += ", " + topp_name[i];
        } else
          topp += topp_name[i];
      }
    }
    // String topping =
    Map<String, dynamic> data = {
      "sTenSP": sp.tenSP,
      "sLink": sp.link,
      "iSoLuong": sl,
      "fDa": ice,
      "fDuong": sugar,
      "sTopping": topp,
      "sGhiChu": _controller_GC.text,
      "fThanhTien": gia,
      "fGiaGoc": sp.gia + tp * 3000,
    };
    final add =
        await FirebaseFirestore.instance.collection("tblGioHang").add(data);
    _showXacNhan();
  }

  Future<void> _showXacNhan() {
    DateTime now = DateTime.now();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(
          Duration(seconds: 1),
          () {
            Navigator.of(context).pop();
          },
        );
        return AlertDialog(
            backgroundColor: Colors.grey.withOpacity(0.4),
            title: Column(
              children: [
                Icon(
                  Icons.check_box_outlined,
                  size: 100,
                  color: Colors.green.withOpacity(0.9),
                ),
                Text(
                  "Đã thêm sản phẩm vào giỏ hàng",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Container(
            width: size.width * 0.55,
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 1, color: Colors.black26))),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.network(
                  sp.link,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Text(
                  sp.tenSP,
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Jetbrains mono"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Container size
                        // Container(
                        //   // height: 100,
                        //   child: Column(
                        //     children: [
                        //       Container(
                        //           child: Text(
                        //         "Size",
                        //         style: TextStyle(
                        //             fontSize: 18, fontWeight: FontWeight.w600),
                        //       )),
                        //       SizedBox(
                        //         height: 20,
                        //       ),
                        //       Container(
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceAround,
                        //           children: [
                        //             Expanded(
                        //               child: RadioListTile(
                        //                 title: Text("S"),
                        //                 value: "S",
                        //                 groupValue: sizeSP,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     sizeSP = value!;
                        //                   });
                        //                 },
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child: RadioListTile(
                        //                 title: Text("M"),
                        //                 value: "M",
                        //                 groupValue: sizeSP,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     sizeSP = value!;
                        //                   });
                        //                 },
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child: RadioListTile(
                        //                 title: Text("L"),
                        //                 value: "L",
                        //                 groupValue: sizeSP,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     sizeSP = value!;
                        //                   });
                        //                 },
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: 30,
                        ),

                        //Container topping
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "TOPPING 3K/PHẦN",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                // height: 300,
                                width: 400,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: listTP.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            listTP[index].link,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            // color: Colors.pinkAccent,
                                            width: 300,
                                            child: CheckboxListTile(
                                              title: Text(listTP[index].tenSP),
                                              value: topping[index],
                                              onChanged: (value) =>
                                                  setState(() {
                                                topping[index] = value!;
                                                if (value!) {
                                                  gia += 3000 * sl;
                                                } else {
                                                  gia -= 3000 * sl;
                                                }
                                              }),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        //Container opption đá - đường
                        Container(
                          child: Row(
                            children: [
                              //Đá
                              Container(
                                width: size.width * 0.45 * 0.5,
                                child: Column(
                                  children: [
                                    Container(
                                        child: Text(
                                      "Đá",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    Row(
                                      children: [
                                        Container(
                                          width: size.width * 0.45 * 0.5 * 0.5,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                title: Text(
                                                  "30%",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                value: 0.3,
                                                groupValue: ice,
                                                onChanged: (value) {
                                                  setState(() {
                                                    ice = value!;
                                                  });
                                                },
                                              ),
                                              RadioListTile(
                                                title: Text(
                                                  "50%",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                value: 0.5,
                                                groupValue: ice,
                                                onChanged: (value) {
                                                  setState(() {
                                                    ice = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.45 * 0.5 * 0.5,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                title: Text(
                                                  "70%",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                value: 0.7,
                                                groupValue: ice,
                                                onChanged: (value) {
                                                  setState(() {
                                                    ice = value!;
                                                  });
                                                },
                                              ),
                                              RadioListTile(
                                                title: Text(
                                                  "100%",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                value: 1.0,
                                                groupValue: ice,
                                                onChanged: (value) {
                                                  setState(() {
                                                    ice = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: size.width * 0.45 * 0.5,
                                child: Column(
                                  children: [
                                    Container(
                                        child: Text(
                                      "Đường",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    Row(
                                      children: [
                                        Container(
                                          width: size.width * 0.45 * 0.5 * 0.5,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                title: Text(
                                                  "30%",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                value: 0.3,
                                                groupValue: sugar,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sugar = value!;
                                                  });
                                                },
                                              ),
                                              RadioListTile(
                                                title: Text(
                                                  "50%",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                value: 0.5,
                                                groupValue: sugar,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sugar = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.45 * 0.5 * 0.5,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                title: Text(
                                                  "70%",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                value: 0.7,
                                                groupValue: sugar,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sugar = value!;
                                                  });
                                                },
                                              ),
                                              RadioListTile(
                                                title: Text(
                                                  "100%",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                value: 1.0,
                                                groupValue: sugar,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sugar = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Container ghi chú
                        Container(
                          child: Column(
                            children: [
                              Text("Ghi chú"),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: TextField(
                                  controller: _controller_GC,
                                  decoration: InputDecoration(
                                      // label: Text("Nhập tại đây"),
                                      hintText: "Nhập tại đây",
                                      border: OutlineInputBorder()),
                                  style: TextStyle(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                //Container giá - số lượng
                Container(
                  child: Column(
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 40),
                            child: Text(formatNumber(gia) + " VNĐ"),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 40),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (sl > 1) {
                                      int tp = 0;
                                      for (int i = 0; i < topping.length; i++) {
                                        if (topping[i] == true) {
                                          tp++;
                                        }
                                      }
                                      sl--;
                                      gia -= (sp.gia + 3000 * tp);
                                      _controller_SL.text = sl.toString();

                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(Icons.remove_circle),
                                ),
                                Container(
                                  width: 25,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: _controller_SL,
                                    decoration: InputDecoration(),
                                    onChanged: (value) {
                                      sl = int.parse(value);
                                      if (sl > 1) {
                                        int tp = 0;
                                        for (int i = 0; i < topping.length; i++) {
                                          if (topping[i] == true) {
                                            tp++;
                                          }
                                        }
                                        gia = (sp.gia * sl + 3000 * tp);

                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    int tp = 0;
                                    for (int i = 0; i < topping.length; i++) {
                                      if (topping[i] == true) {
                                        tp++;
                                      }
                                    }
                                    sl++;
                                    gia += sp.gia + 3000 * tp;
                                    _controller_SL.text = sl.toString();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.add_circle),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                //Giỏ hàng
                Container(
                  child: MaterialButton(
                    onPressed: themVaoGH,
                    child: Text(
                      "Thêm vào giỏ hàng",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    color: Color(0xffDB4B4B),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
