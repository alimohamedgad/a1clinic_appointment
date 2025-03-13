
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/appointment_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../appointments/controllers/appointments_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';


class UrWayController extends GetxController {
  late WebViewController webView;
  late PaymentRepository _paymentRepository;
  final url = Uri().obs;
  final progress = 0.0.obs;
  final appointment = new Appointment().obs;
  var isLoading = true.obs;


  UrWayController() {
    _paymentRepository = new PaymentRepository();
  }


  // استدعاء عند بدء تحميل الصفحة
  void onPageStarted(String url) {
    isLoading.value = true;
    print("🚀 بدأ تحميل الصفحة: $url");

    // التحقق من نجاح الدفع وإغلاق WebView
    if (url.contains("payment-success")) {
      Get.back(); // إغلاق WebView عند نجاح الدفع
    }
  }

  // استدعاء عند انتهاء تحميل الصفحة
  void onPageFinished(String url) {
    isLoading.value = false;
    print("✅ انتهى تحميل الصفحة: $url");

    // التحقق مرة أخرى من نجاح الدفع
    if (url.contains("payment-success")) {
      Get.back(); // إغلاق WebView عند نجاح الدفع
    }
  }

  @override
  void onInit() {
    appointment.value = Get.arguments['appointment'] as Appointment;
    print("Ahmed:${appointment.value.doctor?.price}");
    WebViewController webViewController = Get.put(WebViewController());
    getUrl();
    initWebView();
    super.onInit();
  }

  void initWebView() {

    webView = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('paymentSuccess', onMessageReceived: (JavaScriptMessage message){
        if (message.message == 'success') {
          Get.back();// إغلاق WebView عند نجاح الدفع
        }
      })

      ..loadRequest(url.value)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String _url) {
            url.value = Uri.parse(_url);
            isLoading.value = true;
            print("🚀 بدأ تحميل الصفحة: $url");
            showConfirmationIfSuccess();
            // إغلاق WebView عند نجاح الدفع
            if (_url.contains("payment-success")) {
              Get.back();
            }
          },
          onPageFinished: (String url) {
            progress.value = 1;
            isLoading.value = false;
            print("✅ انتهى تحميل الصفحة: $url");

            // إغلاق WebView عند نجاح الدفع
            if (url.contains("payment-success")) {
              Get.find<AppointmentsController>().currentStatus.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
              if (Get.isRegistered<TabBarController>(tag: 'appointments')) {
                Get.find<TabBarController>(tag: 'appointments').selectedId.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
              }
              Get.toNamed(Routes.CONFIRMATION, arguments: {
                'title': "Payment Successful".tr,
                'long_message': "Your Payment is Successful".tr,
              });
            }else if(url.contains("payment-failed")){

              Get.toNamed(Routes.REJECTION, arguments: {
                'title': "Payment Failed".tr,
                'long_message': "Your Payment is Failed".tr,
              });

              print("failed AHmed");
            }
          },
          onWebResourceError: (WebResourceError error) {
            print("❌ خطأ في تحميل الصفحة: ${error.description}");
          },

        ),

      );
  }

  void getUrl() {
    url.value = _paymentRepository.getUrWayUrl(appointment.value);
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}payments/mada";
    if (url.value.toString() == _doneUrl) {
      Get.find<AppointmentsController>().currentStatus.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
      if (Get.isRegistered<TabBarController>(tag: 'appointments')) {
        Get.find<TabBarController>(tag: 'appointments').selectedId.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
      }
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
