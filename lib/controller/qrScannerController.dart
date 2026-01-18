import 'package:get/get.dart';

class QrScannerController extends GetxController {
  RxBool isLoading = RxBool(false);

  QrScannerController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //friendInfo = getFriendInfo();
  }
}
