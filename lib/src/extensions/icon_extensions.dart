import 'package:flutter/widgets.dart';

extension IconExtension on Icon {
  //copyWith
  Icon copyWith({
    IconData? icon,
    Key? key,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    dynamic opticalSize,
    Color? color,
    List<Shadow>? shadows,
    String? semanticLabel,
    // TextDirection? textDirection,
  }) {
    return Icon(
      icon ?? this.icon,
      key: key ?? this.key,
      size: size ?? this.size,
      fill: fill ?? this.fill,
      weight: weight ?? this.weight,
      grade: grade ?? this.grade,
      opticalSize: opticalSize ?? this.opticalSize,
      color: color ?? this.color,
      shadows: shadows ?? this.shadows,
      semanticLabel: semanticLabel ?? this.semanticLabel,
    );
  }

  //fromJson
  static Icon fromJson(Map<String, dynamic> json) {
    return Icon(
      IconDataExtension.fromJson(json['icon']),
      size: json['size'],
      fill: json['fill'],
      weight: json['weight'],
      grade: json['grade'],
      opticalSize: json['opticalSize'],
      color: json['color'] != null ? Color(json['color']) : null,
      // shadows: json["shadows"] != null ? json["shadows"].map((e) => ShadowExtension.fromJson(e)).toList() : null,
      semanticLabel: json['semanticLabel'],
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'icon': icon!.toJson(),
      if (size != null) 'size': size,
      if (fill != null) 'fill': fill,
      if (weight != null) 'weight': weight,
      if (grade != null) 'grade': grade,
      if (opticalSize != null) 'opticalSize': opticalSize,
      if (color != null) 'color': color?.value,
      // "shadows": shadows?.map((e) => e.toJson()).toList(),
      if (semanticLabel != null) 'semanticLabel': semanticLabel,
    };
  }
}

extension IconDataExtension on IconData {
  //fromJson
  static IconData fromJson(Map<String, dynamic> json) {
    return IconData(
      json['codePoint'],
      fontFamily: json['fontFamily'],
      fontPackage: json['fontPackage'],
      matchTextDirection: json['matchTextDirection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codePoint': codePoint,
      'fontFamily': fontFamily,
      'fontPackage': fontPackage,
      'matchTextDirection': matchTextDirection,
    };
  }
}
