import 'package:get/get.dart';

import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    Get.lazyPut<RootController>(
          () => RootController(),
    );
  }
}
