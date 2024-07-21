import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class bank extends StatefulWidget {
  const bank({super.key});

  @override
  State<bank> createState() => _bankState();
}

class _bankState extends State<bank> {
  // Các thông tin xác thực và endpoint API của MB Bank
  String apiKey = "UAWC2IY0CF0AOM98SVHDWKIJ3XTLORJE8APNSNHU5H6RUTAEXZOQPYVLGZPBDDZM"; // Thay bằng API Key của bạn
  String customerId = "266"; // Thay bằng mã khách hàng của bạn
  String apiEndpoint = 'https://my.sepay.vn/userapi/transactions/list'; // Thay bằng URL thực tế của MB Bank

  Future<void> getTransactionHistory() async {
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
        print('Transaction History:' +  data['transactions'].toString());
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching transaction history: $error');
    }
  }

  void init() async {

    apiKey = dotenv.env["API_BANK"]!; // Thay bằng API Key của bạn
    customerId = dotenv.env["id_user"]!; // Thay bằng mã khách hàng của bạn
    print(apiKey);
  }


  @override
  void initState() {
    super.initState();
    // init();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('MB Bank API Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              getTransactionHistory();
            },
            child: Text('Get Transaction History'),
          ),
        ),
      );
  }
}


