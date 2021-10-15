import 'package:flutter/material.dart';
import 'package:sam_rider_app/driver_src/util/utils.dart';

class Driver_PromotionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PromotionsView();
  }
}

class PromotionsView extends StatefulWidget {
  @override
  _PromotionsViewState createState() => _PromotionsViewState();
}

class _PromotionsViewState extends State<PromotionsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.main,
          title: Text("Promotions"),
        ),
        body: ListView(
          children: <Widget>[],
        ));
  }
}
