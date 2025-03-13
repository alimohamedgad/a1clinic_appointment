import 'package:get/get.dart';

import '../models/procedure_guide_model.dart';
import '../models/speciality_model.dart';
import '../providers/laravel_provider.dart';

class ProcedureGuideRepository {
  late LaravelApiClient _laravelApiClient;

  ProcedureGuideRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<ProcedureGuide>> getAllProcedureGuides() {
    return _laravelApiClient.getAllProcedureGuides();
  }


}
