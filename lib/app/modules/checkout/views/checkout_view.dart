import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/appointment_model.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/payment_details_widget.dart';
import '../widgets/payment_method_item_widget.dart';

class CheckoutView extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout".tr,
          style: context.textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadPaymentMethodsList();
          await controller.loadWalletList();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Obx(() {
            if (controller.isLoading.isTrue|| controller.isLoadingPayment.isTrue) {
              return CircularLoadingWidget(height: 200);
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.payment,
                      color: Get.theme.hintColor,
                    ),
                    title: Text(
                      "Payment Option".tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.headlineSmall,
                    ),
                    subtitle: Text("Select your preferred payment mode".tr, style: Get.textTheme.bodyMedium),
                  ),
                ),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.paymentsList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    var _paymentMethod = controller.paymentsList.elementAt(index);
                    return PaymentMethodItemWidget(paymentMethod: _paymentMethod);
                  },
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: buildBottomWidget(Get.arguments as Appointment),
    );
  }

  Widget buildBottomWidget(Appointment _appointment) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentDetailsWidget(appointment: _appointment),

          Obx(() {
            if ( controller.isLoadingPayment.isTrue) {
              return  BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Appointment is being booked".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.titleLarge?.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      Icon(Icons.upload_rounded, color: Get.theme.primaryColor, size: 16)
                    ],
                  ),
                  color: Get.theme.colorScheme.secondary,
                  onPressed: () async{
                  print("جاري حجز الموعد");

                  }).paddingSymmetric(vertical: 10, horizontal: 20);
            }
          return  BlockButtonWidget(
                text: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Confirm & Pay Now".tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.titleLarge?.merge(
                          TextStyle(color: Get.theme.primaryColor),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 20)
                  ],
                ),
                color: Get.theme.colorScheme.secondary,
                onPressed: () async{
                  if((Get.find<SettingsService>().setting.value.enablePaymentBeforeAppointmentIsCompleted ?? false) == false){
                    print("payAppointment");
                    await controller.payAppointment(_appointment);
                  }else{
                    print("createAppointment");
                    await controller.createAppointment(_appointment);
                  }
                }).paddingSymmetric(vertical: 10, horizontal: 20);
          }),



        ],
      ),
    );
  }
}
