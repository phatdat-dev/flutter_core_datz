// ignore_for_file: unused_element

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../extensions/app_extensions.dart';
import '../../../utils/helper.dart';
import '../../../utils/helper_widget.dart';
import 'border_container_widget.dart';

class TaskAnimateDesignWidget extends StatefulWidget {
  const TaskAnimateDesignWidget({
    super.key,
    this.title,
    this.statusTitle,
    required this.statusColor,
    this.backgroundColor,
    this.imageAvatar,
    required this.field,
    required this.data,
  });
  final String? title;
  final String? statusTitle;
  final Color statusColor;
  final String? imageAvatar;

  // final Color? borderColor;
  final Color? backgroundColor;
  final Map<String, String> field;
  final Map<String, dynamic> data;

  @override
  State<TaskAnimateDesignWidget> createState() =>
      _TaskAnimateDesignWidgetState();
}

class _TaskAnimateDesignWidgetState extends State<TaskAnimateDesignWidget>
    with SingleTickerProviderStateMixin {
  late final Animation<Offset> animation;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween<Offset>(
      begin: const Offset(200.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(curvedAnimation);

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Stack(
        children: <Widget>[
          SlideTransition(
            position: animation,
            child: ClipPath(
              clipper: Clipper(),
              child: Card(
                color: widget.backgroundColor,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: widget.statusColor),
                ),
                child: InkWell(
                  // onTap: () {}, //! tạm bỏ cái này
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      top: 10.0,
                      right: 10.0,
                      bottom: 10.0,
                    ),
                    child: IntrinsicHeight(
                      child: Column(children: buildDataInfo()),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _CircleAnimateAvatarWidget(
                imageAvatar: widget.imageAvatar,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildDataInfo() {
    if (widget.data.length.isOdd) widget.data.addAll({'': ''});

    final Map<String, String> newField = Map.from(widget.field);
    if (newField.length.isOdd) newField.addAll({'': ''});

    return [
      if (widget.title != null || widget.statusTitle != null)
        rowText(
          title: Text(
            widget.title ?? '',
            style: TextStyle(
              color: context.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: BorderContainerWidget(
            color: widget.statusColor,
            title: widget.statusTitle ?? "",
          ),
        ),
      //! sau này sẽ xóa đoạn này
      ...buildFieldFromField(newField),
    ];
  }

  List<Widget> buildFieldFromData(Iterable<MapEntry<String, dynamic>> map) {
    return map.mapIndexed<Widget>((index, e) {
      final int index2 = ((index + 1) >= map.length) ? index : index + 1;
      final int index3 = (index == 0) ? index : index - 1;
      final MapEntry<String, dynamic> e2 = map.elementAt(index2);
      final MapEntry<String, dynamic> e3 = map.elementAt(index3);
      if (index.isEven) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: rowText(
            title: Text(
              e.key,
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            //title right
            trailing: Text(
              e2.key,
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        );
      }
      final e3IsMap = e3.value is Map<String, dynamic>;
      final eIsMap = e.value is Map<String, dynamic>;
      if (e3IsMap || eIsMap) {
        return rowText(
          title: Text(
            e3IsMap ? "${e3.value["text"]}" : e3.value,
            style: TextStyle(
              color: e3IsMap
                  ? (e3.value['color'] as Color)
                  : context.theme.colorScheme.inverseSurface,
            ),
          ),
          trailing: Text(
            eIsMap ? "${e.value["text"]}" : e.value,
            style: TextStyle(
              color: eIsMap
                  ? (e.value['color'] as Color)
                  : context.theme.colorScheme.inverseSurface,
              fontSize: 12,
            ),
            textAlign: TextAlign.right,
          ),
        );
      }

      return rowText(
        title: Text(
          e3.value.toString(),
          style: TextStyle(color: context.theme.colorScheme.inverseSurface),
        ),
        //right Value
        trailing: Text(
          e.value.toString(),
          style: TextStyle(
            color: context.theme.colorScheme.inverseSurface,
            fontSize: 14,
          ),
          textAlign: TextAlign.right,
        ),
      );
    }).toList();
  }

  List<Widget> buildFieldFromField(Map<String, String> field) {
    return field.entries.mapIndexed<Widget>((index, e) {
      final int index2 = ((index + 1) >= field.length) ? index : index + 1;
      final int index3 = (index == 0) ? index : index - 1;
      final e2 = field.entries.elementAt(index2);
      final e3 = field.entries.elementAt(index3);
      if (index.isEven) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: rowText(
            title: Text(
              e.key,
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            //title right
            trailing: Text(
              e2.key,
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        );
      }

      return rowText(
        title: Text(Helper.tryFormatDateTime(widget.data[e3.value].toString())),

        //right Value
        trailing: Text(
          Helper.tryFormatDateTime(widget.data[e.value].toString()),
          textAlign: TextAlign.right,
        ),
      );
    }).toList();
  }

  Widget rowText({required Widget title, required Widget trailing}) => Row(
    children: [
      Expanded(flex: 5, child: title),
      Expanded(
        flex: 3,
        child: Align(alignment: Alignment.centerRight, child: trailing),
      ),
    ],
  );
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    var radius = 28.0;

    path.lineTo(0.0, size.height / 2 + radius);
    path.arcToPoint(
      Offset(0.0, size.height / 2 - radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _CircleAnimateAvatarWidget extends StatefulWidget {
  final String? imageAvatar;
  const _CircleAnimateAvatarWidget({this.imageAvatar});

  @override
  _CircleAnimateAvatarWidgetState createState() {
    return _CircleAnimateAvatarWidgetState();
  }
}

class _CircleAnimateAvatarWidgetState extends State<_CircleAnimateAvatarWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final Animation<double> animation;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaleTransition(
      scale: animation,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0),
        child: Material(
          type: MaterialType.circle,
          color: Colors.white,
          elevation: 10.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1.0, color: Colors.green),
            ),
            height: 50.0,
            width: 50.0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: HelperWidget.imageProviderFrom(
                widget.imageAvatar ?? "",
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
