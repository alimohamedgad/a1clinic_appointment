/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../pharmacies/routes/routes.dart' as pharmaciesRoutes;
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/settings_service.dart';
import '../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';
import 'package:url_launcher/url_launcher.dart';
class MainDrawerWidget extends StatelessWidget   {

  final Uri _google_map_clinic_url = Uri.parse('https://maps.app.goo.gl/W1Ps9VYxFPfX3hfe9');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_google_map_clinic_url)) {
      throw Exception('Could not launch $_google_map_clinic_url');
    }
  }

  @override
  Widget build(BuildContext context) {

    
    return Drawer(
      child: ListView(
        children: [
          Obx(() {
            if (!Get.find<AuthService>().isAuth) {
              return GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.LOGIN);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome".tr, style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
                      SizedBox(height: 5),
                      Text("Login account or create new one for free".tr, style: Get.textTheme.bodyLarge),
                      SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            color: Get.theme.colorScheme.secondary,
                            height: 40,
                            elevation: 0,
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.exit_to_app_outlined, color: Get.theme.primaryColor, size: 24),
                                Text(
                                  "Login".tr,
                                  style: Get.textTheme.titleMedium?.merge(TextStyle(color: Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
                          ),
                          MaterialButton(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            height: 40,
                            elevation: 0,
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.person_add_outlined, color: Get.theme.hintColor, size: 24),
                                Text(
                                  "Register".tr,
                                  style: Get.textTheme.titleMedium?.merge(TextStyle(color: Get.theme.hintColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () async {
                  await Get.find<RootController>().changePage(3);
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  accountName: Text(
                    Get.find<AuthService>().user.value.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  accountEmail: Text(
                    Get.find<AuthService>().user.value.email,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          child: CachedNetworkImage(
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: Get.find<AuthService>().user.value.avatar.thumb,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 80,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Get.find<AuthService>().user.value.verifiedPhone ?? false ? Icon(Icons.check_circle, color: Get.theme.colorScheme.secondary, size: 24) : SizedBox(),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
          SizedBox(height: 20),
          DrawerLinkWidget(
            icon: Icons.home_outlined,
            text: "Home",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(0);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.place_outlined,
            text: "A1 Clinic Maps",
            onTap: (e) async{
              _launchUrl();
           //   await  Get.offAndToNamed(Routes.GOOGLE_MAP_CLINIC);
            //  Get.offAndToNamed(Routes.Google_Maps);

            },
          ),
          DrawerLinkWidget(
            icon: Icons.folder_special_outlined,
            text: "Specialities",
            onTap: (e) {
              Get.offAndToNamed(Routes.SPECIALITIES);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.assignment_outlined,
            text: "Appointments",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(1);
            },
          ),
         /* DrawerLinkWidget(
            icon: Icons.group_outlined,
            text: "Patients",
            onTap: (e) async {
              Get.back();
              Get.find<RootController>().changePage(2);
            },
          ),*/
           DrawerLinkWidget(
             icon: Icons.notifications_none_outlined,
             text: "Notifications",
             onTap: (e) {
               Get.offAndToNamed(Routes.NOTIFICATIONS);
             },
           ),
          DrawerLinkWidget(
            icon: Icons.favorite_outline,
            text: "Favorites",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.FAVORITES);
            },
          ),
          // DrawerLinkWidget(
          //   icon: Icons.chat_outlined,
          //   text: "Messages",
          //   onTap: (e) async {
          //     Get.back();
          //     await Get.find<RootController>().changePage(2);
          //   },
          // ),
          if (Get.find<SettingsService>().isModuleActivated("Pharmacies"))
            ListTile(
              dense: true,
              title: Text(
                "Pharmacies".tr,
                style: Get.textTheme.bodySmall,
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            ),
          if (Get.find<SettingsService>().isModuleActivated("Pharmacies"))
          DrawerLinkWidget(
            icon: Icons.place_outlined,
            text: "Explore Pharmacies",
            onTap: (e) {
              Get.offAndToNamed(pharmaciesRoutes.Routes.PHARMACIES_MAPS);
            },
          ),
          if (Get.find<SettingsService>().isModuleActivated("Pharmacies"))
            DrawerLinkWidget(
              icon: Icons.category_outlined,
              text: "Medicines Categories",
              onTap: (e) async {
                await Get.offAndToNamed(pharmaciesRoutes.Routes.CATEGORIES);
              },
            ),
          if (Get.find<SettingsService>().isModuleActivated("Pharmacies"))
            DrawerLinkWidget(
              icon: Icons.assignment_outlined,
              text: "Orders",
              onTap: (e) async {
                await Get.offAndToNamed(pharmaciesRoutes.Routes.ORDERS);
              },
            ),
          ListTile(
            dense: true,
            title: Text(
              "Application preferences".tr,
              style: context.textTheme.titleLarge,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
         // Wallets hide
         /* DrawerLinkWidget(
            icon: Icons.account_balance_wallet_outlined,
            text: "Wallets",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.WALLETS);
            },
          ),*/
          DrawerLinkWidget(
            icon: Icons.person_outline,
            text: "Account",
            onTap: (e) async {
              Get.back();
              // كانت 4 قبل اخفاء بعض الاشياء
              await Get.find<RootController>().changePage(3);//4
            },
          ),
          DrawerLinkWidget(
            icon: Icons.settings_outlined,
            text: "Settings",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.translate_outlined,
            text: "Languages",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS_LANGUAGE);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.brightness_6_outlined,
            text: Get.isDarkMode ? "Light Theme" : "Dark Theme",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS_THEME_MODE);
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              "Help & Privacy".tr,
              style: context.textTheme.titleLarge,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            icon: Icons.help_outline,
            text: "Help & FAQ",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.HELP);
            },
          ),
          CustomPageDrawerLinkWidget(),
          Obx(() {
            if (Get.find<AuthService>().isAuth) {
              return DrawerLinkWidget(
                icon: Icons.logout,
                text: "Logout",
                onTap: (e) async {
                  await Get.find<AuthService>().removeCurrentUser();
                  Get.back();
                  await Get.find<RootController>().changePage(0);
                },
              );
            } else {
              return SizedBox(height: 0);
            }
          }),
          if (Get.find<SettingsService>().setting.value.enableVersion ?? false)
            ListTile(
              dense: true,
              title: Text(
                "Version".tr + " " + (Get.find<SettingsService>().setting.value.appVersion ?? "1.0.0"),
                style: context.textTheme.titleLarge,
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            )
        ],
      ),
    );
  }
}
