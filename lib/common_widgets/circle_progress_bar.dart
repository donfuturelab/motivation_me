import 'package:flutter/material.dart';

import '../core/constant/colors.dart';

class CircleProgressBar extends StatefulWidget {
  const CircleProgressBar({Key? key}) : super(key: key);

  @override
  CircleProgressBarState createState() => CircleProgressBarState();
}

class CircleProgressBarState extends State<CircleProgressBar> {
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isMounted
          ? Center(
              child: Container(
                color: Colors.transparent,
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(
                  color: AppColors.textColor,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
