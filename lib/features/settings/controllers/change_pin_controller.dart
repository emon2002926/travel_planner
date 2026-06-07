import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePinController extends GetxController {
  final List<TextEditingController> currentPinControllers =
  List.generate(5, (_) => TextEditingController());
  final List<TextEditingController> newPinControllers =
  List.generate(5, (_) => TextEditingController());
  final List<TextEditingController> retypePinControllers =
  List.generate(5, (_) => TextEditingController());

  final List<FocusNode> currentFocusNodes =
  List.generate(5, (_) => FocusNode());
  final List<FocusNode> newFocusNodes = List.generate(5, (_) => FocusNode());
  final List<FocusNode> retypeFocusNodes =
  List.generate(5, (_) => FocusNode());

  void onChanged(
      String value, int index, List<FocusNode> nodes) {
    if (value.length == 1 && index < 4) {
      nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      nodes[index - 1].requestFocus();
    }
  }

  void onSave() {}

  @override
  void onClose() {
    for (final c in [
      ...currentPinControllers,
      ...newPinControllers,
      ...retypePinControllers
    ]) {
      c.dispose();
    }
    for (final f in [
      ...currentFocusNodes,
      ...newFocusNodes,
      ...retypeFocusNodes
    ]) {
      f.dispose();
    }
    super.onClose();
  }
}