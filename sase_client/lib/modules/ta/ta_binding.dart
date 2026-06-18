import 'package:get/get.dart';
import 'package:sase_client/modules/ta/ta_controller.dart';

/// Define as injeções de dependência específicas para as rotas do Terminal de Atendimento.
class TaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaController>(() => TaController());
  }
}
