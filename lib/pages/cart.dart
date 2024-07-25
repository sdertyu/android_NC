import 'dart:async';
import 'dart:convert';

import 'package:btl/main.dart';
import 'package:btl/obj/obj_sp_gh.dart';
import 'package:btl/pages/bank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:crc/crc.dart';
import 'package:uuid/uuid.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  List<obj_sp_gh> listSP = [];
  double tongTien = 0;
  int secondsLeft = 0;
  String MaHD = "";


  @override
  void initState() {
    super.initState();
    selectedValue = options.first['title']!;
    // getListSP();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Map<String, String>> options = [
    {"title": "Tiền mặt", "icon": "assets/images/cash_icon.png"},
    {"title": "Chuyển khoản", "icon": "assets/images/banking_icon.png"},
    {"title": "Momo", "icon": "assets/images/momo.png"},
  ];
  late String selectedValue;

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
        "00020101021138580010A000000727012800069704220114094418921759030208QRIBFTTA530370454");
    if (amount.length < 10) {
      sb.write("0" + amount.length.toString() + amount);
    } else {
      sb.write(amount.length.toString() + amount);
    }
    sb.write("5802VN");

    // Thêm mã định danh vào chuỗi QR
    if (description != null) {
      sb.write("62");
      sb.write((description.length + 4)
          .toString()
          .padLeft(2, '0')); // Độ dài description (2 ký tự)
      sb.write("08");
      sb.write(description.length
          .toString()
          .padLeft(2, '0')); // Độ dài description (2 ký tự)
      sb.write(description);
      // sb.write(description.length.toString().padLeft(2, '0') + description);
    }

    sb.write("6304");

    int crcValue = calculateCRC16CCITT(sb.toString());
    final crc16 = crcValue.toRadixString(16).toUpperCase().padLeft(4, '0');
    sb.write(crc16.toString());
    print(sb.toString());
    return sb.toString();
  }

  String generateMomoQrData({
    required String amount,
    String? description,
    String? additionalData,
  }) {
    final sb = StringBuffer();
    sb.write(
        "00020101021138620010A00000072701320006970454011899MM23311M638106980208QRIBFTTA530370454");
    if (amount.length < 10) {
      sb.write("0" + amount.length.toString() + amount);
    } else {
      sb.write(amount.length.toString() + amount);
    }
    sb.write("5802VN");

    // Thêm mã định danh vào chuỗi QR
    if (description != null) {
      sb.write("62" + (23 + description.length).toString());
      sb.write("0515MOMOW2W63810698");
      sb.write("08");
      sb.write((description.length)
          .toString()
          .padLeft(2, '0')); // Độ dài description (2 ký tự)
      sb.write(description);
      // sb.write(description.length.toString().padLeft(2, '0') + description);
    }

    sb.write("6304");

    int crcValue = calculateCRC16CCITT(sb.toString());
    final crc16 = crcValue.toRadixString(16).toUpperCase().padLeft(4, '0');
    sb.write(crc16.toString());
    print(sb.toString());
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

  void _showHoaDon() async {
    await FirebaseFirestore.instance.collection("tblHoaDon").add({
      "sMaHoaDon" : MaHD,
      "dThoiGian": DateTime.now(),
      "fTongTien": tongTien,
      "sChiTiet": ""
    });
    secondsLeft = 5;
    DateTime now = DateTime.now();
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                "MIXUE",
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.w600,
                    fontSize: 30),
              ),
              Text(
                "(96 Phố Định Công -- Thanh Xuân -- Hà Nội)",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black26),
              ),
              Text(
                "Điện thoại: 0123456789",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.black26),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'HÓA ĐƠN BÁN HÀNG',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              Text("Ngày ${now.day} tháng ${now.month} năm ${now.year}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Mã hóa đơn: "),
                  Text(
                    MaHD,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Table(
                border: TableBorder.all(width: 1),
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1)
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                        // border: Border.all(width: 1),
                        ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Sản phẩm",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            "Số lượng",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            "Thành tiền",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    listSP.length,
                    (index) {
                      obj_sp_gh sp = listSP[index];
                      return TableRow(children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(sp.sTenSP),
                        )),
                        TableCell(
                            child: Center(child: Text(sp.iSoLuong.toString()))),
                        TableCell(
                            child: Center(
                                child: Text(formatNumber(sp.fThanhTien)))),
                      ]);
                    },
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  TableRow(children: [
                    TableCell(child: Text("")),
                    TableCell(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Tổng tiền hóa đơn:",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ))),
                    TableCell(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              formatNumber(tongTien),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ))),
                  ]),
                  TableRow(children: [
                    TableCell(child: Text("")),
                    TableCell(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Chiết khấu:",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ))),
                    TableCell(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              formatNumber(0),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ))),
                  ]),
                  TableRow(children: [
                    TableCell(child: Text("")),
                    TableCell(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Tổng tiền thanh toán:",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ))),
                    TableCell(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              formatNumber(tongTien),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ))),
                  ])
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Phương thức thanh toán: " + selectedValue,
                style: TextStyle(fontStyle: FontStyle.italic),
              )),
              SizedBox(
                height: 35,
              ),
              Center(
                  child: Text(
                "Cảm ơn và hẹn gặp lại",
                style: TextStyle(fontStyle: FontStyle.italic),
              )),
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('In hóa đơn'),
                onPressed: () async {
                  final CollectionReference collection =
                      FirebaseFirestore.instance.collection("tblGioHang");
                  final QuerySnapshot snapshot = await collection.get();

                  for (DocumentSnapshot doc in snapshot.docs) {
                    await doc.reference.delete();
                  }
                  Navigator.of(context).pop();
                  MyApp.globalKey.currentState!.navigateToPage(0);
                }),

          ],
        );
      },
    );
  }

  Future<void> _showXanNhan() async {
    final result =
        await FirebaseFirestore.instance.collection("tblHoaDon").get();

    DateTime now = DateTime.now();
    MaHD = now.day.toString().padLeft(2, "0") +
        now.month.toString().padLeft(2, "0") +
        now.year.toString() +
        result.docs.length.toString().padLeft(4, "0");

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
                if (selectedValue == "Chuyển khoản") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          Timer? _time2;
                          _time2 =Timer.periodic(Duration(seconds: 10), (timer) {
                            getTransactionHistory().then((value) {
                              String? content = value;
                              if(content.contains(MaHD)) {
                                _time2?.cancel();
                                Navigator.of(context).pop();
                                _showHoaDon();
                              }
                              print(content);
                            },);

                          },);
                          return AlertDialog(
                            title: Center(child: Text("QR thanh toán ngân hàng", style: TextStyle(fontWeight: FontWeight.w600),)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Container(
                                    width: 400,
                                    height: 400,
                                    child: QrImageView(
                                      data: generateVcbQrData(
                                        amount: tongTien.toString(),
                                        description: MaHD,
                                      ),
                                      version: QrVersions.auto,
                                      size: 400.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _time2?.cancel();
                                  Navigator.of(context).pop();
                                },
                                child: Text("Hủy"),
                              )
                            ],
                          );
                        },
                      );
                    },
                  );
                } else if (selectedValue == "Tiền mặt") {
                  _showHoaDon();
                }
                else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        // Timer? _time2;
                        // _time2 =Timer.periodic(Duration(seconds: 10), (timer) {
                        //   getTransactionHistory().then((value) {
                        //     String? content = value;
                        //     if(content.contains(MaHD)) {
                        //       _time2?.cancel();
                        //       Navigator.of(context).pop();
                        //       _showHoaDon();
                        //     }
                        //     print(content);
                        //   },);
                        //
                        // },);
                        return AlertDialog(
                          title: Center(child: Text("QR thanh toán MOMO", style: TextStyle(fontWeight: FontWeight.w600),)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Container(
                                  width: 400,
                                  height: 400,
                                  child: QrImageView(
                                    data: generateMomoQrData(
                                      amount: tongTien.toString(),
                                      description: MaHD,
                                    ),
                                    version: QrVersions.auto,
                                    size: 400.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // _time2?.cancel();
                                Navigator.of(context).pop();
                              },
                              child: Text("Hủy"),
                            )
                          ],
                        );
                      },
                    );
                  },);
                }
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

  Future<String> getTransactionHistory() async {
    try {
      final response = await http.get(
        Uri.parse(apiEndpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Customer-ID': customerId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print('Transaction History:' +  double.parse(data['transactions'][0]['amount_in']).toStringAsFixed(0) );
        return data['transactions'][0]['transaction_content'].toString();
        // print('Transaction History:' +  data['transactions'].toString());
      } else {
        print('Error: ${response.reasonPhrase}');
        return "";
      }
    } catch (error) {
      print('Error fetching transaction history: $error');
      return "";
    }
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
                          (value["iSoLuong"]),
                          (value["fThanhTien"].toDouble()),
                          (value["fDa"].toDouble()),
                          (value["fDuong"].toDouble()),
                          value["sGhiChu"],
                          value["sTopping"],
                          (value["fGiaGoc"].toDouble()));
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
                                      "%"),
                                  Text("Ghi chú: " + spgh.sGhiChu)
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
                                      onPressed: () {
                                        if (spgh.iSoLuong == 1) return;
                                        spgh.iSoLuong--;
                                        FirebaseFirestore.instance
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
                                      onPressed: () {
                                        spgh.iSoLuong++;
                                        FirebaseFirestore.instance
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
                      if (listSP.length > 0)
                        _showXanNhan();
                      else
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => bank(),
                            ));
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
