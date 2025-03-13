

import 'package:get/get.dart';

import '../../clinic/controllers/clinic_controller.dart';
import '../../clinic/controllers/doctors_controller.dart';

import '../../messages/controllers/messages_controller.dart';

class ContactUsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ClinicController>(
          () => ClinicController(),
    );


  }


}