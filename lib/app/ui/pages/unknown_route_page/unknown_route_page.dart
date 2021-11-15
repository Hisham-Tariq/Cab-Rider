import '../../layouts/main/widgets/main_layout_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/controllers.dart';

class UnknownRoutePage extends GetView<UnknownRouteController> {
  @override
  Widget build(BuildContext context) {
    return MainLayoutView(
      child: Center(
        child: Text('Test'),
      ),
    );
  }
}
