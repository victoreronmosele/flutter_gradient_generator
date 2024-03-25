import 'package:flutter/material.dart';

sealed class GradientDirection {
  const GradientDirection();

  static const topLeft = GradientDirectionTopLeft._();
  static const topCenter = GradientDirectionTopCenter._();
  static const topRight = GradientDirectionTopRight._();
  static const centerLeft = GradientDirectionCenterLeft._();
  static const center = GradientDirectionCenter._();
  static const centerRight = GradientDirectionCenterRight._();
  static const bottomLeft = GradientDirectionBottomLeft._();
  static const bottomCenter = GradientDirectionBottomCenter._();
  static const bottomRight = GradientDirectionBottomRight._();

  factory GradientDirection.custom({
    Alignment alignment = const Alignment(-0.5, 0),
    Alignment endAlignment = const Alignment(0.5, 0),
  }) {
    return GradientDirectionCustom._(
      alignment: alignment,
      endAlignment: endAlignment,
    );
  }
}

class GradientDirectionTopLeft extends GradientDirection {
  const GradientDirectionTopLeft._();
}

class GradientDirectionTopCenter extends GradientDirection {
  const GradientDirectionTopCenter._();
}

class GradientDirectionTopRight extends GradientDirection {
  const GradientDirectionTopRight._();
}

class GradientDirectionCenterLeft extends GradientDirection {
  const GradientDirectionCenterLeft._();
}

class GradientDirectionCenter extends GradientDirection {
  const GradientDirectionCenter._();
}

class GradientDirectionCenterRight extends GradientDirection {
  const GradientDirectionCenterRight._();
}

class GradientDirectionBottomLeft extends GradientDirection {
  const GradientDirectionBottomLeft._();
}

class GradientDirectionBottomCenter extends GradientDirection {
  const GradientDirectionBottomCenter._();
}

class GradientDirectionBottomRight extends GradientDirection {
  const GradientDirectionBottomRight._();
}

class GradientDirectionCustom extends GradientDirection {
  const GradientDirectionCustom._({
    required this.alignment,
    required this.endAlignment,
  });

  final Alignment alignment;
  final Alignment endAlignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GradientDirectionCustom &&
        other.alignment == alignment &&
        other.endAlignment == endAlignment;
  }

  @override
  int get hashCode => alignment.hashCode ^ endAlignment.hashCode;
}
