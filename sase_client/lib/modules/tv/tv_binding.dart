import 'package:get/get.dart';
import 'package:sase_client/modules/tv/tv_controller.dart';

class TvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TvController>(() => TvController());
  }
}
