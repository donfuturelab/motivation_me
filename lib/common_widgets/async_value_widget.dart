import 'package:flutter/material.dart';
import 'package:motivation_me/common_widgets/circle_progress_bar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) data;

  const AsyncValueWidget({
    Key? key,
    required this.value,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const Center(child: CircleProgressBar()),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
    );
  }
}
