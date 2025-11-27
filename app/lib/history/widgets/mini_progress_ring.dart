// import 'package:flutter/material.dart';

// class MiniProgressRing extends StatelessWidget {
//   final double progress;
//   final Widget? child;
//   final double size;
//   final double strokeWidth;
//   final Color progressColor;
//   final Color? backgroundColor;

//   const MiniProgressRing({
//     super.key,
//     required this.progress,
//     this.child,
//     this.size = 32,
//     this.strokeWidth = 3,
//     this.progressColor = const Color(0xFFFF8A65),
//     this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = backgroundColor ?? Colors.grey[200]!;

//     return SizedBox(
//       width: size,
//       height: size,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Background circle
//           SizedBox(
//             width: size,
//             height: size,
//             child: CircularProgressIndicator(
//               value: 1.0,
//               strokeWidth: strokeWidth,
//               backgroundColor: bgColor,
//               valueColor:
//                   const AlwaysStoppedAnimation<Color>(Colors.transparent),
//             ),
//           ),
//           // Progress circle
//           SizedBox(
//             width: size,
//             height: size,
//             child: CircularProgressIndicator(
//               value: progress.clamp(0.0, 1.0),
//               strokeWidth: strokeWidth,
//               backgroundColor: Colors.transparent,
//               valueColor: AlwaysStoppedAnimation<Color>(progressColor),
//             ),
//           ),
//           // Center content
//           if (child != null) child!,
//         ],
//       ),
//     );
//   }
// }
