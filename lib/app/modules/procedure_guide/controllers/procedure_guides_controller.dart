import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/procedure_guide_model.dart';
import '../../../models/speciality_model.dart';
import '../../../repositories/procedure_guide_repository.dart';
import '../../../repositories/speciality_repository.dart';

enum ProcedureGuidesLayout { GRID }

class ProcedureGuidesController extends GetxController {
  late ProcedureGuideRepository _procedureGuideRepository;

  final procedureGuides = <ProcedureGuide>[].obs;

  final layout = ProcedureGuidesLayout.GRID.obs;
  int indexList=0;

  ProcedureGuidesController() {
    _procedureGuideRepository = new ProcedureGuideRepository();
  }

  @override
  Future<void> onInit() async {

    await refreshProcedureGuides();

    super.onInit();
  }

  Future refreshProcedureGuides({bool? showMessage}) async {
    await getProcedureGuides();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of procedure guides refreshed successfully".tr));
    }
  }

  Future getProcedureGuides() async {
    try {
      procedureGuides.assignAll(await _procedureGuideRepository.getAllProcedureGuides());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
