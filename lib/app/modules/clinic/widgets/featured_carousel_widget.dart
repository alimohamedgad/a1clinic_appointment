import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../controllers/clinic_controller.dart';

class FeaturedCarouselWidget extends GetWidget<ClinicController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      color: Get.theme.primaryColor,
      child: Obx(() {
        if (controller.featuredDoctors.isEmpty) {
          //return CircularLoadingWidget(height: 250);
          return SizedBox();
        }
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.featuredDoctors.length,
            itemBuilder: (_, index) {
              var _doctor = controller.featuredDoctors.elementAt(index);
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.DOCTOR, arguments: {'doctor': _doctor, 'heroTag': 'featured_carousel'});
                },
                child: Container(
                  width: 170,
                  margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Get.theme.focusColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'featured_carousel' + _doctor.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: _doctor.firstImageUrl,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 140,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        height: 135,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              _doctor.name ?? '',
                              maxLines: 2,
                              style: Get.textTheme.bodyMedium?.merge(TextStyle(color: Get.theme.hintColor)),
                            ),
                            Wrap(
                              children: Ui.getStarsList(_doctor.rate),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 5,
                              alignment: WrapAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text(
                                  "Start from".tr,
                                  style: Get.textTheme.bodySmall,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (_doctor.getOldPrice > 0)
                                      Ui.getPrice(
                                        _doctor.getOldPrice,
                                        style: Get.textTheme.bodyLarge?.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                                      ),
                                    Ui.getPrice(
                                      _doctor.getPrice,
                                      style: Get.textTheme.bodyMedium?.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
