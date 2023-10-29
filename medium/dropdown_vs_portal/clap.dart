import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:i_billing/asset/colors/app_colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.dark,
          appBar: AppBar(
            backgroundColor: AppColors.green,
            title: const Text('Qarsaklar👏'),
          ),
          body: const Center(child: ClapButton()),
        ),
      ),
    );
  }
}

class ClapButton extends StatefulWidget {
  const ClapButton({Key? key}) : super(key: key);

  @override
  _ClapButtonState createState() => _ClapButtonState();
}

class _ClapButtonState extends State<ClapButton> {
  int clapCount = 0;
  bool hasClappedRecently = false;
  Timer? resetHasClappedRecentlyTimer;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: hasClappedRecently,
      // aligns the top-center of `child` with the bottom-center of `portal`
      anchor: const Aligned(
        target: Alignment.topCenter,
        follower: Alignment.bottomCenter,
      ),
      closeDuration: kThemeChangeDuration,
      portalFollower: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: hasClappedRecently ? 1 : 0),
        duration: kThemeChangeDuration,
        builder: (context, progress, child) {
          return Material(
            color: Colors.transparent,
            elevation: 0 * progress,
            animationDuration: Duration.zero,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: Opacity(
              opacity: progress,
              child: child,
            ),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.darkest),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          child: Text('+$clapCount', style: TextStyle(color: AppColors.white)),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.green),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          shadowColor: MaterialStateProperty.all(AppColors.green.withOpacity(0.1)),
          minimumSize: MaterialStateProperty.all(const Size(100, 100))
        ),
        onPressed: _clap,
        child: const Text("👏", style: TextStyle(fontSize: 32),),
      ),
    );
  }

  void _clap() {
    resetHasClappedRecentlyTimer?.cancel();

    resetHasClappedRecentlyTimer = Timer(
      const Duration(seconds: 2),
      () => setState(() => hasClappedRecently = false),
    );

    setState(() {
      hasClappedRecently = true;
      if(clapCount<50){
        clapCount++;
      }
    });
  }
}
