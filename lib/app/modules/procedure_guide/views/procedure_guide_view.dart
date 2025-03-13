import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';

import '../../clinic/widgets/clinic_til_widget.dart';
import '../../clinic/widgets/clinic_title_bar_widget.dart';
import '../../clinic/widgets/review_item_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';

import '../controllers/procedure_guides_controller.dart';


class ProcedureGuideView extends GetView<ProcedureGuidesController> {
  List<int> intList = [1];
  @override
  Widget build(BuildContext context) {
    dynamic argumentData = Get.arguments;
    print("Ahmed :${argumentData}");
    return Obx(() {
      var _procedureGuides = controller.procedureGuides.value;
      if (_procedureGuides.isEmpty) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          body: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 250,
                elevation: 0,
                floating: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () => {Get.back()},
                ),

                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      buildCarouselSlider(argumentData[2] ),

                    ],
                  ),
                ).marginOnly(bottom: 5),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  //  SizedBox(height: 10),

                    ClinicTilWidget(
                      title: Text(argumentData[0]?? '', style: Get.textTheme.titleLarge),
                   //   content: Ui.applyHtml(argumentData[0] ?? '', style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w600 )),
                    content: Html(
                      data: argumentData[1],
                      style: {
                        'html' : Style(
                            backgroundColor: Colors.white12
                        ),
                        'table': Style(
                            backgroundColor: Colors.grey.shade200
                        ),
                        'td': Style(
                          backgroundColor: Colors.grey.shade400,
                          padding: HtmlPaddings( ),
                        ),
                        'th': Style(
                            padding: HtmlPaddings( ),
                            color: Colors.black
                        ),
                        'tr': Style(
                            backgroundColor: Colors.grey.shade300,
                            border: Border(bottom: BorderSide(color: Colors.greenAccent))
                        ),
                        'b': Style(
                            color: Colors.black,
                            border: Border(bottom: BorderSide(color: Colors.greenAccent))
                        ),
                      },
                    ),
                    ),






                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }








  CarouselSlider buildCarouselSlider(String image) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 360,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
        //  controller.currentSlide.value = index;
        },
      ),
      items: intList.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: "ahmed",
              child: CachedNetworkImage(
                width: double.infinity,
                height: 360,
                fit: BoxFit.cover,
                imageUrl: image,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }




}
