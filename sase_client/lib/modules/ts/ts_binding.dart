import 'package:get/get.dart';
import 'package:sase_client/modules/ts/ts_controller.dart';

/// Define as injeções de dependência específicas para a rota do Terminal de Senhas.
class TsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TsController>(TsController());
  }
}
