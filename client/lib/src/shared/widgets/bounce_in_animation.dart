import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BounceInAnimation extends HookWidget {
  final Widget child;

  const BounceInAnimation({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 100));

    final scale = Tween<double>(begin: 1.0, end: 0.9)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));

    return GestureDetector(
      onTap: () {},
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          controller.forward();
        },
        onPointerUp: (PointerUpEvent event) {
          controller.reverse();
        },
        onPointerCancel: (event) {
          controller.reverse();
        },
        child: ScaleTransition(
          scale: scale,
          child: child,
        ),
      ),
    );
  }
}

//* Below hat the class looks like normally. Above is how simple flutter hooks makes it
// class BounceInAnimation extends StatefulWidget {
//   final Widget child;
//   final VoidCallback onTap;

//   const BounceInAnimation({
//     super.key,
//     required this.child,
//     required this.onTap,
//   });

//   @override
//   State<BounceInAnimation> createState() => _BounceInAnimationState();
// }

// class _BounceInAnimationState extends State<BounceInAnimation>
//     with SingleTickerProviderStateMixin {
//   late Animation<double> _scale;
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 100),
//     );
//     _scale = Tween<double>(begin: 1.0, end: 0.9)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: Listener(
//         onPointerDown: (PointerDownEvent event) {
//           _controller.forward();
//         },
//         onPointerUp: (PointerUpEvent event) {
//           _controller.reverse();
//         },
//         onPointerCancel: (event) {
//           _controller.reverse();
//         },
//         child: ScaleTransition(
//           scale: _scale,
//           child: widget.child,
//         ),
//       ),
//     );
//   }
// }
