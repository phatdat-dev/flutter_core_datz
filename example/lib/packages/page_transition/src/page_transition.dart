import 'package:flutter/material.dart';

import 'enum.dart';

/// This package allows you amazing transition for your routes

/// Page transition class extends PageRouteBuilder
class PageTransition<T> extends PageRouteBuilder<T> {
  /// Child for your next page
  final Widget child;

  // ignore: public_member_api_docs
  final PageTransitionsBuilder matchingBuilder;

  /// Child for your next page
  final Widget? childCurrent;

  /// Transition types
  ///  fade,rightToLeft,leftToRight, upToDown,downToUp,scale,rotate,size,rightToLeftWithFade,leftToRightWithFade
  final PageTransitionType type;

  /// Curves for transitions
  final Curve curve;

  /// Alignment for transitions
  final Alignment? alignment;

  /// Duration for your transition default is 300 ms
  final Duration duration;

  /// Duration for your pop transition default is 300 ms
  final Duration reverseDuration;

  /// Context for inherit theme
  final BuildContext? ctx;

  /// Optional inherit theme
  final bool inheritTheme;

  // ignore: public_member_api_docs
  final bool isIos;

  // ignore: public_member_api_docs
  final bool? maintainStateData;

  /// Page transition constructor. We can pass the next page as a child,
  PageTransition({
    Key? key,
    required this.child,
    required this.type,
    this.childCurrent,
    this.ctx,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration = const Duration(milliseconds: 200),
    super.fullscreenDialog = false,
    super.opaque = false,
    this.isIos = false,
    this.matchingBuilder = const CupertinoPageTransitionsBuilder(),
    this.maintainStateData,
    super.settings,
  }) : assert(
         inheritTheme ? ctx != null : true,
         "'ctx' cannot be null when 'inheritTheme' is true, set ctx: context",
       ),
       super(
         pageBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
             ) {
               return inheritTheme
                   ? InheritedTheme.captureAll(ctx!, child)
                   : child;
             },
         maintainState: maintainStateData ?? true,
       );

  @override
  Duration get transitionDuration => duration;

  @override
  // ignore: public_member_api_docs
  Duration get reverseTransitionDuration => reverseDuration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => buildTransitionss(
    context,
    animation,
    secondaryAnimation,
    child,
    type: this.type,
    route: this,
    isIos: isIos,
    alignment: alignment,
    matchingBuilder: matchingBuilder,
    childCurrent: childCurrent,
    curve: curve,
  );
}

Widget buildTransitionss(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child, {
  required PageTransitionType type,
  PageRoute? route,
  bool isIos = false,
  Alignment? alignment,
  PageTransitionsBuilder matchingBuilder =
      const CupertinoPageTransitionsBuilder(),
  Widget? childCurrent,
  Curve curve = Curves.linear,
}) {
  childCurrent ??= Container(color: Colors.transparent);
  switch (type) {
    case PageTransitionType.theme:
      if (route != null) {
        return Theme.of(context).pageTransitionsTheme.buildTransitions(
          route,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      }
      return child;

    case PageTransitionType.fade:
      if (isIos) {
        var fade = FadeTransition(opacity: animation, child: child);
        if (route != null) {
          return matchingBuilder.buildTransitions(
            route,
            context,
            animation,
            secondaryAnimation,
            fade,
          );
        }
        return fade;
      }
      return FadeTransition(opacity: animation, child: child);
      // ignore: dead_code
      break;

    /// PageTransitionType.rightToLeft which is the give us right to left transition
    case PageTransitionType.rightToLeft:
      var slideTransition = SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
      if (isIos && route != null) {
        return matchingBuilder.buildTransitions(
          route,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      }
      return slideTransition;
      // ignore: dead_code
      break;

    /// PageTransitionType.leftToRight which is the give us left to right transition
    case PageTransitionType.leftToRight:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
      // ignore: dead_code
      break;

    /// PageTransitionType.topToBottom which is the give us up to down transition
    case PageTransitionType.topToBottom:
      var topBottom = SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
      if (isIos && route != null) {
        return matchingBuilder.buildTransitions(
          route,
          context,
          animation,
          secondaryAnimation,
          topBottom,
        );
      }
      return topBottom;
      // ignore: dead_code
      break;

    /// PageTransitionType.downToUp which is the give us down to up transition
    case PageTransitionType.bottomToTop:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
      // ignore: dead_code
      break;

    /// PageTransitionType.scale which is the scale functionality for transition you can also use curve for this transition

    case PageTransitionType.scale:
      assert(alignment != null, """
                When using type "scale" you need argument: 'alignment'
                """);
      if (isIos) {
        var scale = ScaleTransition(
          alignment: alignment!,
          scale: animation,
          child: child,
        );
        if (route != null) {
          return matchingBuilder.buildTransitions(
            route,
            context,
            animation,
            secondaryAnimation,
            scale,
          );
        }
        return scale;
      }
      return ScaleTransition(
        alignment: alignment!,
        scale: CurvedAnimation(
          parent: animation,
          curve: Interval(0.00, 0.50, curve: curve),
        ),
        child: child,
      );
      // ignore: dead_code
      break;

    /// PageTransitionType.rotate which is the rotate functionality for transition you can also use alignment for this transition

    case PageTransitionType.rotate:
      assert(alignment != null, """
                When using type "RotationTransition" you need argument: 'alignment'
                """);
      return RotationTransition(
        alignment: alignment!,
        turns: animation,
        child: ScaleTransition(
          alignment: alignment,
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );
      // ignore: dead_code
      break;

    /// PageTransitionType.size which is the rotate functionality for transition you can also use curve for this transition

    case PageTransitionType.size:
      assert(alignment != null, """
                When using type "size" you need argument: 'alignment'
                """);
      return Align(
        alignment: alignment!,
        child: SizeTransition(
          sizeFactor: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        ),
      );
      // ignore: dead_code
      break;

    /// PageTransitionType.rightToLeftWithFade which is the fade functionality from right o left

    case PageTransitionType.rightToLeftWithFade:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      );
      // ignore: dead_code
      break;

    /// PageTransitionType.leftToRightWithFade which is the fade functionality from left o right with curve

    case PageTransitionType.leftToRightWithFade:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: curve)),
        child: FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      );
      // ignore: dead_code
      break;

    case PageTransitionType.rightToLeftJoined:
      return Stack(
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(-1.0, 0.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: childCurrent,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          ),
        ],
      );
      // ignore: dead_code
      break;

    case PageTransitionType.leftToRightJoined:
      return Stack(
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(1.0, 0.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: childCurrent,
          ),
        ],
      );
      // ignore: dead_code
      break;

    case PageTransitionType.topToBottomJoined:
      return Stack(
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: const Offset(0.0, 0.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(0.0, 1.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: childCurrent,
          ),
        ],
      );
      // ignore: dead_code
      break;

    case PageTransitionType.bottomToTopJoined:
      return Stack(
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: const Offset(0.0, 0.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(0.0, -1.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: childCurrent,
          ),
        ],
      );
      // ignore: dead_code
      break;

    case PageTransitionType.rightToLeftPop:
      return Stack(
        children: <Widget>[
          child,
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(-1.0, 0.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: childCurrent,
          ),
        ],
      );
      // ignore: dead_code
      break;

    case PageTransitionType.leftToRightPop:
      return Stack(
        children: <Widget>[
          child,
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(1.0, 0.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: childCurrent,
          ),
        ],
      );
      // ignore: dead_code
      break;

    case PageTransitionType.topToBottomPop:
      return Stack(
        children: <Widget>[
          child,
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(0.0, 1.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: childCurrent,
          ),
        ],
      );
      // ignore: dead_code
      break;

    case PageTransitionType.bottomToTopPop:
      return Stack(
        children: <Widget>[
          child,
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(0.0, -1.0),
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: childCurrent,
          ),
        ],
      );
      // ignore: dead_code
      break;

      /// FadeTransitions which is the fade transition

      return FadeTransition(opacity: animation, child: child);
  }
}
