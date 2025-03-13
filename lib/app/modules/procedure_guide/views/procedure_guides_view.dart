import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/procedure_guides_controller.dart';
import '../widgets/procedure_guide_item_widget.dart';



class ProcedureGuidesView extends GetView<ProcedureGuidesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Procedure Guides".tr,
            style: Get.textTheme.titleLarge,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => {Get.back()},
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshProcedureGuides(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: ListView(
            primary: true,
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("You can view the questions related to the operations".tr,textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 14),),
              ),


              Obx(() {
                return Offstage(
                  offstage: controller.layout.value != ProcedureGuidesLayout.GRID,
                  child: controller.procedureGuides.isEmpty
                      ? CircularLoadingWidget(height: 400)
                      : MasonryGridView.count(
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: controller.procedureGuides.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ProcedureGuideItemWidget(procedureGuides: controller.procedureGuides.elementAt(index), heroTag: "heroTag");
                          },
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                        ),
                );
              }),


            ],
          ),
        ));
  }
}
