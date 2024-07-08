import 'package:flutter/material.dart';

class khuyenMai extends StatefulWidget {
  const khuyenMai({super.key});

  @override
  State<khuyenMai> createState() => _khuyenMaiState();
}

class _khuyenMaiState extends State<khuyenMai> {
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
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 30),
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
              Container(
                padding: EdgeInsets.only(right: 30),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 35,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 35,
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
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset("assets/images/mixue_logo.jpg"),
                    ),
                  ),
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Image.asset(
                        "assets/images/mixue_logo.jpg",
                        height: 50,
                        fit: BoxFit.cover,
                      );
                    }, childCount: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.0),
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
