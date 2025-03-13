import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/faq_model.dart';

class FaqItemWidget extends StatelessWidget {
  final Faq faq;



  FaqItemWidget({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
        //  Ui.removeHtml(this.faq.question, style: Get.textTheme.bodyLarge),
          Html(
            data: this.faq.question,
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
          Divider(
            height: 30,
            thickness: 1,
            color: Get.theme.dividerColor,
          ),
          SingleChildScrollView(

        child: Html(
          data: this.faq.answer,



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
                color: Color(0xFFAA9A6E),
                border: Border(bottom: BorderSide(color: Colors.greenAccent))
            ),
            'p': Style(
                color: Color(0xFFAA9A6E),

            ),



          },


            ),
      ),

         // Ui.applyHtml(this.faq.answer, style: Get.textTheme.bodyLarge)
        ],
      ),
    );
  }
}
