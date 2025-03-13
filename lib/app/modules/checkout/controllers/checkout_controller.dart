import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/appointment_model.dart';
import '../../../models/payment_method_model.dart';
import '../../../models/payment_model.dart';
import '../../../models/wallet_model.dart';
import '../../../repositories/appointment_repository.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../appointments/controllers/appointments_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class CheckoutController extends GetxController {
  late PaymentRepository _paymentRepository;
  late AppointmentRepository _appointmentRepository;
  final paymentsList = <PaymentMethod>[].obs;
  final walletList = <Wallet>[];
  final isLoading = true.obs;
  final isLoadingPayment = false.obs;
  final appointment = new Appointment().obs;
  Rx<PaymentMethod> selectedPaymentMethod = new PaymentMethod().obs;
  Address get currentAddress => Get.find<SettingsService>().address.value;

  CheckoutController() {
    _paymentRepository = new PaymentRepository();
    _appointmentRepository = new AppointmentRepository();
  }

  @override
  void onInit() async {
    appointment.value = Get.arguments as Appointment;
    await loadPaymentMethodsList();
    await loadWalletList();
    selectedPaymentMethod.value = this.paymentsList.firstWhere((element) => element.isDefault);
    super.onInit();
  }

  Future<void> createAppointment(Appointment _appointment) async {
    try {
      if (!currentAddress.isUnknown() && appointment.value.address!.isUnknown()) {
        this.appointment.value.address = currentAddress;
      }
      try {
        isLoadingPayment.value=true;
        appointment.value = await _appointmentRepository.add(_appointment);
        Get.find<AppointmentsController>().currentStatus.value = Get.find<AppointmentsController>().getStatusByOrder(1).id;
        if (Get.isRegistered<TabBarController>(tag: 'appointments')) {
          Get.find<TabBarController>(tag: 'appointments').selectedId.value = Get.find<AppointmentsController>().getStatusByOrder(1).id;
        }
        payAppointment(appointment.value);
      }finally{
        isLoadingPayment.value=false;
      }



    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }


  Future loadPaymentMethodsList() async {
    try {
      paymentsList.assignAll(await _paymentRepository.getMethods());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future loadWalletList() async {
    try {
      var _walletIndex = paymentsList.indexWhere((element) => element.route.toLowerCase() == Routes.WALLET);
      if (_walletIndex > -1) {
        // wallet payment method enabled
        // remove existing wallet method
        var _walletPaymentMethod = paymentsList.removeAt(_walletIndex);
        walletList.assignAll(await _paymentRepository.getWallets());
        // and replace it with new payment method object
        _insertWalletsPaymentMethod(_walletIndex, _walletPaymentMethod);
        paymentsList.refresh();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  Future<void> payAppointment(Appointment _appointment) async {
    try {

     _appointment.payment = new Payment(paymentMethod: selectedPaymentMethod.value);
      print("Ahmed Route :${selectedPaymentMethod.value.route.toLowerCase()}");
      Get.toNamed(selectedPaymentMethod.value.route.toLowerCase(),
          arguments: {'appointment': Appointment(id: _appointment.id, payment: _appointment.payment,status:_appointment.status,startAt: _appointment.appointmentAt,address: _appointment.address,appointmentAt: _appointment.appointmentAt,doctor:_appointment.doctor,duration: _appointment.duration,endsAt: _appointment.endsAt,taxes: _appointment.taxes,user: _appointment.user,cancel: _appointment.cancel,clinic: _appointment.clinic,coupon: _appointment.coupon,online: _appointment.online,patient: _appointment.patient,hint: _appointment.hint,  ), 'wallet': selectedPaymentMethod.value.wallet});
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  TextStyle getTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.primaryColor));
    } else if (paymentMethod.wallet != null && paymentMethod.wallet!.balance < appointment.value.getTotal()) {
      return Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.focusColor));
    }
    return Get.textTheme.bodyMedium!;
  }

  TextStyle getSubTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodySmall!.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodySmall!;
  }

  Color? getColor(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.theme.colorScheme.secondary;
    }
    return null;
  }

  void _insertWalletsPaymentMethod(int _walletIndex, PaymentMethod _walletPaymentMethod) {
    walletList.forEach((_walletElement) {
      paymentsList.insert(
          _walletIndex,
          new PaymentMethod(
            isDefault: _walletPaymentMethod.isDefault,
            id: _walletPaymentMethod.id,
            name: _walletElement.name,
            description: _walletElement.balance.toString(),
            logo: _walletPaymentMethod.logo,
            route: _walletPaymentMethod.route,
            wallet: _walletElement,
          ));
    });
  }
}
