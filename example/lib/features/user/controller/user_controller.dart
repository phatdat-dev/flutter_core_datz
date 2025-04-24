import 'package:flutter/material.dart';

import '../../../core/controller/base_controller.dart';
import '../../../models/user_model.dart';

class UserController extends BaseController {
  final ValueNotifier<UserModel?> state = ValueNotifier(null);

  @override
  Future<void> onInitData() async {}
}
