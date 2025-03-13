import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';
import '../widgets/contact_clinic_widget.dart';

class AccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    var _currentUser = Get.find<AuthService>().user;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Account".tr,
            style: Get.textTheme.titleLarge?.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Colors.black),
            onPressed: () => {Scaffold.of(context).openDrawer()},
          ),
          elevation: 0,
          actions: [
            NotificationsButtonWidget(
              iconColor: Colors.black,
              labelColor:Colors.white,
            )
          ],
        ),
        body: ListView(
          primary: true,
          children: [
            Obx(() {
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 150,
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
                            _currentUser.value.name ?? '',
                            style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                          SizedBox(height: 10),
                          Text(_currentUser.value.email ?? '', style: Get.textTheme.bodySmall?.merge(TextStyle(color: Get.theme.primaryColor))),
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
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        imageUrl: _currentUser.value.avatar?.thumb ?? '',
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                ],
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [

                  AccountLinkWidget(
                    icon: Icon(Icons.person_outline, color: Get.theme.colorScheme.secondary),
                    text: Text("Profile".tr),
                    onTap: (e) {
                     /* print("Fire:${Get.find<AuthService>().user.value.deviceToken}");
                       Get.find<FireBaseMessagingService>().setDeviceToken();*/
                      Get.toNamed(Routes.PROFILE);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.assignment_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("My Appointments".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(1);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.accessibility_new_rounded, color: Get.theme.colorScheme.secondary),
                    text: Text("Procedure Guides".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.PROCEDURE_GUIDES);
                    },
                  ),
                 /* AccountLinkWidget(
                    icon: Icon(Icons.group_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("My Patients".tr),
                    onTap: (e) {

                      Get.find<RootController>().changePage(2);
                    },
                  ),*/

                  AccountLinkWidget(
                    icon: Icon(Icons.notifications_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Notifications".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.NOTIFICATIONS);


                    },
                  ),

                  ContactUsWidget(
                    icon: Icon(Icons.call, color: Get.theme.colorScheme.secondary),
                    text: Text("Contact us".tr),
                    onTap: (e) {

                    },
                  ),

                  //chat View
                 /* AccountLinkWidget(
                    icon: Icon(Icons.chat_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Messages".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(2);
                    },
                  ),*/
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.settings_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Settings".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.translate_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Languages".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_LANGUAGE);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.brightness_6_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Theme Mode".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_THEME_MODE);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.support_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Help & FAQ".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.HELP);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.logout, color: Get.theme.colorScheme.secondary),
                    text: Text("Logout".tr),
                    onTap: (e) async {
                      await Get.find<AuthService>().removeCurrentUser();
                      Get.find<RootController>().changePage(0);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
