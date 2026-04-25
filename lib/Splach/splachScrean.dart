import 'package:flutter/material.dart';
import 'package:plus90_application/onBorading/onboradingPages.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({Key? key}) : super(key: key);

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;

  late Animation<Offset> animation1;
  late Animation<Offset> animation2;
  late Animation<Offset> animation3;

  @override
  void initState() {
    super.initState();

    /// Controllers
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    controller3 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    /// Animations
    animation1 = Tween<Offset>(
      begin: Offset(-2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: controller1, curve: Curves.easeOut));

    animation2 = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: controller2, curve: Curves.easeOut));

    animation3 = Tween<Offset>(
      begin: Offset(2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: controller3, curve: Curves.easeOut));

    startAnimation();

    /// ⏱️ بعد 2.5 ثانية يروح للـ Onboarding
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboradingpages()),
      );
    });
  }

  void startAnimation() async {
    controller1.forward();
    await Future.delayed(Duration(milliseconds: 1000));

    controller2.forward();
    await Future.delayed(Duration(milliseconds: 700));

    controller3.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splach.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// صورة 2 (من تحت)
              SlideTransition(
                position: animation2,
                child: Transform.translate(
                  offset: Offset(15, 80),
                  child: Image.asset('assets/images/2.png', width: 170),
                ),
              ),

              /// صورة 1 (من الشمال)
              SlideTransition(
                position: animation1,
                child: Transform.translate(
                  offset: Offset(-10, -10),
                  child: Image.asset('assets/images/1.png', width: 170),
                ),
              ),

              /// صورة 3 (من اليمين)
              SlideTransition(
                position: animation3,
                child: Transform.translate(
                  offset: Offset(35, -10),
                  child: Image.asset('assets/images/3.png', width: 120),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
