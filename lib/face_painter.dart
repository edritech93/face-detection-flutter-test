import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final Size imageSize;
  double? scaleX, scaleY;
  Face? face;
  String? label;
  final bool isCorrect;

  FacePainter(
      {required this.imageSize,
      required this.face,
      this.label,
      required this.isCorrect});

  @override
  void paint(Canvas canvas, Size size) {
    if (face == null) return;
    Paint paint;
    if (isCorrect) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = Colors.green;
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = Colors.red;
    }
    scaleX = size.width / imageSize.width;
    scaleY = size.height / imageSize.height;

    TextSpan textSpan = TextSpan(
      text: label ?? 'Unknown',
      style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          backgroundColor: isCorrect ? Colors.green : Colors.red,
          height: 0.9),
    );
    TextPainter textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    Offset textCenter = Offset(
      size.width - face!.boundingBox.right.toDouble() * scaleX!,
      face!.boundingBox.bottom.toDouble() * scaleY!,
    );
    textPainter.paint(canvas, textCenter);
    canvas.drawRRect(
        _scaleRect(
            rect: face!.boundingBox,
            imageSize: imageSize,
            widgetSize: size,
            scaleX: scaleX ?? 1,
            scaleY: scaleY ?? 1),
        paint);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.face != face;
  }
}

RRect _scaleRect(
    {required Rect rect,
    required Size imageSize,
    required Size widgetSize,
    double scaleX = 1,
    double scaleY = 1}) {
  return RRect.fromLTRBR(
      (widgetSize.width - rect.left.toDouble() * scaleX),
      rect.top.toDouble() * scaleY,
      widgetSize.width - rect.right.toDouble() * scaleX,
      rect.bottom.toDouble() * scaleY,
      const Radius.circular(10));
}
