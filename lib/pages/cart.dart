import 'dart:convert';
import 'dart:typed_data';

import 'package:btl/obj/obj_sp_gh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:crc/crc.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  List<obj_sp_gh> listSP = [];
  double tongTien = 0;

  // List<String> options = ["Tiền mặt", "Chuyển khoản", "Thẻ tín dụng"];
  // List<String> listIcons = [
  //   "assets/images/cash_icon.png",
  //   "assets/images/banking_icon.png",
  //   "assets/images/credit_card_icon.png"
  // ];

  List<Map<String, String>> options = [
    {"title": "Tiền mặt", "icon": "images/cash_icon.png"},
    {"title": "Chuyển khoản", "icon": "images/banking_icon.png"},
    {"title": "Thẻ tín dụng", "icon": "images/credit_card_icon.png"},
  ];
  late String selectedValue;

  // Future getListSP() async {
  //   try {
  //     final result =
  //     await FirebaseFirestore.instance.collection("tblGioHang").get();
  //     if (result.docs.isNotEmpty) {
  //       result.docs.forEach((value) {
  //         obj_sp_gh sp = obj_sp_gh(
  //             value.id,
  //             value["sTenSP"],
  //             value["sLink"],
  //             value["iSoLuong"],
  //             value["fThanhTien"],
  //             value["fDa"],
  //             value["fDuong"],
  //             value["sGhiChu"],
  //             value["sTopping"],
  //             value["fGiaGoc"]);
  //         listSP.add(sp);
  //       });
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     print(e.toString() + "ERROR");
  //   }
  // }

  String formatNumber(double number) {
    final formatter = NumberFormat.decimalPattern('vi_VN');
    return formatter.format(number);
  }

  String generateVcbQrData({
    required String amount,
    String? description,
    String? additionalData,
  }) {
    final sb = StringBuffer();
    sb.write(
        "00020101021238540010A00000072701240006970436011010239115130208QRIBFTTA530370454");
    if (amount.length < 10) {
      sb.write("0" + amount.length.toString() + amount);
    } else {
      sb.write(amount.length.toString() + amount);
    }
    sb.write("5802VN6304");

    int crcValue = calculateCRC16CCITT(sb.toString());
    final crc16 = crcValue.toRadixString(16).toUpperCase().padLeft(4, '0');
    sb.write(crc16.toString());

    return sb.toString();
  }

  int calculateCRC16CCITT(String input) {
    // Chuyển đổi chuỗi thành danh sách các byte
    List<int> bytes = input.codeUnits;

    // Bảng mã CRC-16/CCITT-FALSE
    const int polynomial = 0x1021;
    int crc = 0xFFFF; // Giá trị ban đầu

    for (int byte in bytes) {
      crc ^= (byte << 8);
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ polynomial;
        } else {
          crc <<= 1;
        }
      }
    }

    // Loại bỏ bit cao nhất để có kết quả 16-bit
    crc &= 0xFFFF;

    return crc;
  }

  Future<void> _showXanNhan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận thanh toán"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Text('Bạn đang chọn phương thức: '),
                    Text(
                      selectedValue,
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    )
                  ],
                ),
                Text('Bạn chắc chắn muốn thanh toán bằng hình thức này?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Chấp nhận'),
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        width: 400,
                        height: 400,
                        child: Center(
                          child: QrImageView(
                            data:
                                generateVcbQrData(amount: tongTien.toString()),
                            version: QrVersions.auto,
                            size: 400.0,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            TextButton(
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    selectedValue = options.first['title']!;
    // getListSP();
  }

  void calculateTongTien() {
    double total = 0;
    for (var sp in listSP) {
      total += sp.fThanhTien;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Logic tính toán tổng tiền
        tongTien = total; // giá trị mới
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String rdata = generateVcbQrData(amount: tongTien.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("tblGioHang")
                    .snapshots(),
                builder: (context, snapshot) {
                  listSP = [];
                  if (snapshot.hasData) {
                    tongTien = 0;
                    snapshot.data?.docs.forEach((value) {
                      obj_sp_gh sp = obj_sp_gh(
                          value.id,
                          value["sTenSP"],
                          value["sLink"],
                          value["iSoLuong"],
                          value["fThanhTien"],
                          value["fDa"],
                          value["fDuong"],
                          value["sGhiChu"],
                          value["sTopping"],
                          value["fGiaGoc"]);
                      listSP.add(sp);
                      // tongTien += value["fThanhTien"];
                    });
                    calculateTongTien();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: listSP.length,
                    itemBuilder: (context, index) {
                      obj_sp_gh spgh = listSP[index];

                      return GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Hình ảnh
                              Container(
                                margin: EdgeInsets.only(right: 40),
                                child: Image.network(
                                  spgh.slink,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                              ),

                              //Tên SP, Topping, ghi chú
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    spgh.sTenSP,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text("topping: " + spgh.sTopping),
                                  Text("Đá: " +
                                      (spgh.fDa * 100).toString() +
                                      "%"),
                                  Text("Đường: " +
                                      (spgh.fDuong * 100).toString() +
                                      "%")
                                ],
                              ),

                              Expanded(
                                child: Container(),
                              ),

                              //Số lượng
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        if (spgh.iSoLuong == 1) return;
                                        spgh.iSoLuong--;
                                        await FirebaseFirestore.instance
                                            .collection("tblGioHang")
                                            .doc(spgh.id)
                                            .update({
                                          "iSoLuong": spgh.iSoLuong,
                                          "fThanhTien":
                                              spgh.fThanhTien - spgh.giaGoc
                                        });
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.remove_circle),
                                    ),
                                    Text(spgh.iSoLuong.toString()),
                                    IconButton(
                                      onPressed: () async {
                                        spgh.iSoLuong++;
                                        await FirebaseFirestore.instance
                                            .collection("tblGioHang")
                                            .doc(spgh.id)
                                            .update({
                                          "iSoLuong": spgh.iSoLuong,
                                          "fThanhTien":
                                              spgh.giaGoc * spgh.iSoLuong
                                        });
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.add_circle),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                // padding: EdgeInsets.only(left: 40),
                                child: Text(
                                  formatNumber(spgh.fThanhTien) + " VNĐ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),

                              Container(
                                child: IconButton(
                                  onPressed: () async {
                                    final remo = await FirebaseFirestore
                                        .instance
                                        .collection("tblGioHang")
                                        .doc(spgh.id)
                                        .delete();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.pink,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),

            //Thanh toán
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 100, top: 20),
                        child: DropdownButton<String>(
                          value: selectedValue,
                          icon: Icon(Icons.arrow_drop_down_rounded),
                          focusColor: Colors.white,
                          underline: SizedBox(),
                          items: options.map((item) {
                            return DropdownMenuItem<String>(
                              value: item['title'],
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 4),
                                child: Row(
                                  children: [
                                    Image.asset(item['icon'].toString()),
                                    SizedBox(width: 10),
                                    Text(item['title'].toString()),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            selectedValue = newValue!;
                            print(selectedValue);
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          "Tổng tiền: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 60),
                        child: Text(
                          formatNumber(tongTien) + " VNĐ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: () {
                      _showXanNhan();
                    },
                    color: Color(0xffDB4B4B),
                    child: Text(
                      "Thanh toán",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            // QrImageView(
            //   data: generateVcbQrData(amount: tongTien.toString()),
            //   version: QrVersions.auto,
            //   size: 200.0,
            // )
          ],
        ),
      ),
    );
  }
}
