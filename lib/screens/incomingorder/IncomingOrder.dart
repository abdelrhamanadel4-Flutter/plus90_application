import 'package:flutter/material.dart';
import 'package:plus90_application/screens/incomingorder/card.dart';

class IncomingOrder extends StatelessWidget {
  const IncomingOrder({super.key});
  height(context) => MediaQuery.of(context).size.height;

  width(context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04,
          vertical: height(context) * 0.01,
        ),
        child: ListView.builder(
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: width(context) * 0.015),
            child: Cardincomingorder(),
          ),
          shrinkWrap: true,
          itemCount: 5,
        ),
      ),
    );
  }
}
