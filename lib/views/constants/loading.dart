import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constants.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: SpinKitThreeBounce(
        color: primarycolor,
        size: 50,
      ),
    ));
  }
}

class LoadingSmall extends StatelessWidget {
  const LoadingSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitRing(
      color: primarycolor,
      size: 5,
    );
  }
}
