import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      
      child: SizedBox(
        height: 30,
        width: 30,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [Colors.white],
          strokeWidth: 2,
        ),
      ),
    );
  }
}