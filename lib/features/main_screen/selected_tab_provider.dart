//import riverpod annotations
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_tab_provider.g.dart';

@Riverpod(keepAlive: true)
class SelectedTab extends _$SelectedTab {
  @override
  int build() {
    if (DateTime.now().year == 2024) {
      return 1;
    } else {
      return 0;
    }
  }

  void selectTab(int index) {
    state = index;
  }
}
