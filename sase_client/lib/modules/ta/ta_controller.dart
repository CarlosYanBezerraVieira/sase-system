import 'package:get/get.dart';
import 'package:sase_client/core/enums/sase_enums.dart';
import 'package:sase_client/core/model/sase_mensagem.dart';
import 'package:sase_client/core/services/socket_service.dart';
import 'package:sase_client/core/ui/utils/sase_feedback_utils.dart';

/// Define o estado da tela do Terminal de Atendimento.
enum EstadoTa {
  aguardando, // Tela inicial — esperando o atendente chamar.
  atendendo, // Exibe a senha que foi concedida pelo servidor.
  filaVazia, // Servidor retornou que não há senhas na fila.
}

/// Controlador do Terminal de Atendimento (TA).
///
/// Gerencia o número do guichê (mesa), a conexão TCP e as reações
/// às mensagens do servidor: `sua_vez` e `fila_vazia`.
class TaController extends GetxController {
  final SocketService _socketService = Get.find<SocketService>();

  // Número do guichê, configurado pelo atendente na tela de setup.
  final RxInt numeroMesa = 0.obs;

  // Estado atual da tela do TA (observável pela View).
  final Rx<EstadoTa> estado = EstadoTa.aguardando.obs;

  // Senha atualmente sendo atendida.
  final RxString senhaAtual = '---'.obs;

  bool get isPrioritaria => senhaAtual.startsWith('P');

  /// Salva o número do guichê e inicia a conexão com o servidor.
  Future<void> configurarEConectar(int mesa) async {
    numeroMesa.value = mesa;
    await _socketService.conectar(TipoCliente.ta);
    _escutarMensagens();
  }

  /// Assina o stream do SocketService para reagir a eventos do servidor.
  void _escutarMensagens() {
    _socketService.messages.listen((mensagem) {
      final SaseMensagem(:acao, :senha) = mensagem;
      if (acao == null) return;

      switch (acao) {
        case AcaoSase.suaVez:
          if (senha != null) {
            senhaAtual.value = senha;
            estado.value = EstadoTa.atendendo;
          }
          break;

        case AcaoSase.filaVazia:
          estado.value = EstadoTa.filaVazia;
          break;

        default:
          break;
      }
    });
  }

  /// Envia o pedido de próxima senha ao servidor com o número do guichê.
  void chamarProxima() {
    if (!_socketService.isConnected.value) {
      SaseFeedbackUtils.showError(
        title: 'Atenção',
        message:
            'Sem conexão com o servidor. Por favor, aguarde ou chame o suporte.',
      );
      return;
    }

    _socketService.enviar(
      SaseMensagem(acao: AcaoSase.chamarProxima, mesa: numeroMesa.value),
    );
  }
}
