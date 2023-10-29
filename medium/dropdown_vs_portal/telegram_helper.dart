import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showDiscovery = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.dark,
          appBar: AppBar(title: Text('Telegramdagi helper oynalar', style: TextStyle(color: AppColors.green),), backgroundColor: AppColors.darkest),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$count", style: const TextStyle(color: Colors.white, fontSize: 32),),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.green),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      shadowColor: MaterialStateProperty.all(AppColors.green.withOpacity(0.1)),
                      minimumSize: MaterialStateProperty.all(const Size(100, 100))
                  ),
                  onPressed: () => setState(() => showDiscovery = true),
                  child: const Text('How to increment?', style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Discovery(
            visible: showDiscovery,
            description: const Text('Click to increment the counter', style: TextStyle(color: Colors.white),),
            onClose: () => setState(() => showDiscovery = false),
            child: FloatingActionButton(
              backgroundColor: AppColors.green,
              onPressed: _increment,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _increment() {
    setState(() {
      showDiscovery = false;
      count++;
    });
  }
}

class Discovery extends StatelessWidget {
  const Discovery({
    Key? key,
    required this.visible,
    required this.onClose,
    required this.description,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Widget description;
  final bool visible;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Barrier(
      visible: visible,
      onClose: onClose,
      child: PortalTarget(
        visible: visible,
        closeDuration: kThemeAnimationDuration,
        anchor: const Aligned(
          target: Alignment.center,
          follower: Alignment.center,
          alignToPortal: AxisFlag(x: true)
        ),
        portalFollower: Stack(
          children: [
            CustomPaint(
              painter: HolePainter(AppColors.green.withOpacity(0.7)),
              child: Padding(
                padding: const EdgeInsets.all(150),
                child: child,
              ),
            ),
            Positioned(
              top: 100,
              left: 75,
              child: Opacity(
                opacity: 0.8,
                child: description,
              ),
            )
          ],
        ),
        child: child,
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  const HolePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(center: center, radius: size.width / 2)),
        Path()
          ..addOval(Rect.fromCircle(center: center, radius: 40))
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(HolePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

class Barrier extends StatelessWidget {
  const Barrier({
    Key? key,
    required this.onClose,
    required this.visible,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClose,
        child: TweenAnimationBuilder<Color>(
          duration: kThemeAnimationDuration,
          tween: ColorTween(
            begin: Colors.transparent,
            end: visible ? Colors.black54 : Colors.transparent,
          ),
          builder: (context, color, child) {
            return ColoredBox(color: color);
          },
        ),
      ),
      child: child,
    );
  }
}

class ColorTween extends Tween<Color> {
  ColorTween({required Color begin, required Color end})
      : super(begin: begin, end: end);

  @override
  Color lerp(double t) => Color.lerp(begin, end, t)!;
}
