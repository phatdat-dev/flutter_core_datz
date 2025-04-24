/*

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/assets.gen.dart';

class SearchErrorLottieWidget extends StatefulWidget {
  const SearchErrorLottieWidget({super.key});

  @override
  State<SearchErrorLottieWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SearchErrorLottieWidget> {
  late final Future<LottieComposition> _composition;

  @override
  void initState() {
    _composition = AssetLottie(Assets.lottie.animationSearchEmpty).load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<LottieComposition>(
        future: _composition,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Lottie(composition: snapshot.data)
              : const CircularProgressIndicator();
        },
      ),
    );
  }
}

*/
