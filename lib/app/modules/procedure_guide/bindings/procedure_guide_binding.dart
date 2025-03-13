import 'package:get/get.dart';


import '../controllers/procedure_guides_controller.dart';


class ProcedureGuideBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ProcedureGuidesController>(
      () => ProcedureGuidesController(),
    );
  }
}
