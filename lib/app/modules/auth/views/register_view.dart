import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/phone_login_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Register".tr,
            style: Get.textTheme.titleLarge?.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
          ),
        ),
        body: Form(
          key: controller.registerFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 160,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _settings.appName ?? "",
                            style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 24)),
                          ),
                          SizedBox(height: 5),


                          // Text("Fill the following credentials to login your account", style: Get.textTheme.bodySmall?.merge(TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border: Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (controller.loading.isTrue) {
                  return CircularLoadingWidget(height: 300);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                     TextFieldWidget(
                        labelText: "Full Name".tr,
                        hintText: "ahmed naji".tr,
                        initialValue: controller.currentUser.value.name,
                        onSaved: (input) => controller.currentUser.value.name = input,
                        validator: (input) => input!.length < 3 ? "Should be more than 3 characters".tr : null,
                        iconData: Icons.person_outline,
                        isFirst: true,
                        isLast: false,
                      ),
                   /*  TextFieldWidget(
                        labelText: "Email Address".tr,
                        hintText: "info@a1clinic.com".tr,
                        initialValue: controller.currentUser.value.email,
                        onSaved: (input) => controller.currentUser.value.email = input,
                        validator: (input) => !input!.contains('@') ? "Should be a valid email".tr : null,
                        iconData: Icons.alternate_email,
                        isFirst: false,
                        isLast: false,
                      ),*/

                      PhoneLoginFieldWidget(
                        labelText: "Phone Number".tr,
                        hintText: "0593166156".tr,
                        initialValue: controller.currentUser.value.phoneNumber,
                        onSaved: (input) => controller.currentUser.value.phoneNumber = input,

                        validator: (input) => input!.length < 10 ? "Should be more than 9 characters".tr : null,
                        iconData: Icons.phone_iphone,
                        maxLength: 10,
                      ),
                      /*PhoneFieldWidget(
                        labelText: "Phone Number".tr,
                        hintText: "593166156".tr,
                        initialCountryCode: "SA",
                       // initialCountryCode: controller.currentUser.value.getPhoneNumber().countryISOCode,
                        initialValue: controller.currentUser.value.getPhoneNumber().number,
                        onSaved: (phone) {
                          controller.currentUser.value.phoneNumber = phone?.completeNumber;
                        },
                        isLast: false,
                        isFirst: false,
                      ),*/

                   /*  Obx(() {
                        return TextFieldWidget(
                          labelText: "Password".tr,
                          hintText: "••••••••••••".tr,
                          initialValue: controller.currentUser.value.password,
                          onSaved: (input) => controller.currentUser.value.password = input,
                          validator: (input) => input!.length < 3 ? "Should be more than 3 characters".tr : null,
                          obscureText: controller.hidePassword.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          isLast: true,
                          isFirst: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value = !controller.hidePassword.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          ),
                        );
                     }),*/


                      Container(

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [

                                SizedBox(
                                  width: Get.width,
                                  child: BlockButtonWidget(
                                    onPressed: () {
                                   //   controller.register();
                                      controller.registerByPhone();
                                    },
                                    color: Get.theme.colorScheme.secondary,
                                    text: Text(
                                      "Register".tr,
                                      style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.primaryColor)),
                                    ),
                                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.LOGIN);
                                  },
                                  child: Text("You already have an account?".tr),
                                ).paddingOnly(bottom: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                  );
                }
              })
            ],
          ),
        ),

      /*  bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [

                SizedBox(
                  width: Get.width,
                  child: BlockButtonWidget(
                    onPressed: () {
                      controller.register();
                    },
                    color: Get.theme.colorScheme.secondary,
                    text: Text(
                      "Register".tr,
                      style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                  child: Text("You already have an account?".tr),
                ).paddingOnly(bottom: 10),
              ],
            ),
          ],
        ),*/

      ),
    );
  }
}
