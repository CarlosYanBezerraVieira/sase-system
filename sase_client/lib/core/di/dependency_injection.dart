import 'package:get/get.dart';
import 'package:sase_client/core/services/socket_service.dart';

/// Configura a injeção de dependências global do aplicativo SASE Client.
///
/// Registra os serviços, controladores ou repositórios que precisam
/// estar disponíveis em toda a aplicação desde a inicialização.
class DependencyInjection {
  static void init() {
    // Serviços Globais
    Get.put<SocketService>(SocketService(), permanent: true);
    
    // Controladores e Repositórios específicos podem ser
    // injetados aqui ou via Get_Bindings em rotas específicas.
  }
}
