import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app_color.dart';

class AccountCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.isSelected,
    required this.onTap,
  });

  double h(BuildContext context, double v) =>
      MediaQuery.of(context).size.height * v;

  double w(BuildContext context, double v) =>
      MediaQuery.of(context).size.width * v;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        scale: isSelected ? 1.03 : 1,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(w(context, 0.04)),
          margin: EdgeInsets.only(bottom: h(context, 0.02)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(w(context, 0.04)),
            border: Border.all(
              color: isSelected ? AppColor.orange : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.orange.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title + Check
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: w(context, 0.045),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: h(context, 0.005)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: w(context, 0.035),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  /// Checkbox Animation
                  AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: w(context, 0.06),
                    height: w(context, 0.06),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? AppColor.orange : Colors.grey,
                      ),
                      color: isSelected ? AppColor.orange : Colors.transparent,
                    ),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: isSelected ? 1 : 0,
                      child: Icon(
                        Icons.check,
                        size: w(context, 0.04),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: h(context, 0.015)),
              Divider(),
              SizedBox(height: h(context, 0.01)),

              /// Features
              ...features.map(
                (e) => Padding(
                  padding: EdgeInsets.only(bottom: h(context, 0.008)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ", style: TextStyle(fontSize: w(context, 0.04))),
                      Expanded(
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: w(context, 0.035),
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
