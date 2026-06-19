import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/enums/sase_enums.dart';
import 'package:sase_client/core/services/socket_service.dart';
import 'package:sase_client/core/ui/utils/sase_feedback_utils.dart';

/// Controlador do Terminal de Senhas (TS).
///
/// Responsável por manter a numeração local, solicitar senhas ao servidor
/// e fornecer feedback visual (Snackbars) ao usuário do totem.
class TsController extends GetxController {
  final SocketService _socketService = Get.find<SocketService>();

  // Contadores locais do TS
  int _contadorNormal = 0;
  int _contadorPrioritario = 0;

  @override
  void onInit() {
    super.onInit();
    // Ao iniciar o módulo TS, conecta-se ao servidor informando que é um TS.
    _conectarComoTs();
  }

  Future<void> _conectarComoTs() async {
    await _socketService.conectar(TipoCliente.ts);
  }

  /// Solicita uma nova senha com base no [TipoSenha] escolhido pelo usuário.
  void solicitarSenha(TipoSenha tipo) {
    if (!_socketService.isConnected.value) {
      SaseFeedbackUtils.showError(
          title: 'Atenção',
          message:
          'Sem conexão com o servidor. Por favor, aguarde ou chame o suporte.');
      return;
    }

    String senhaGerada = '';

    if (tipo == TipoSenha.normal) {
      _contadorNormal++;
      senhaGerada = '${tipo.codigo}$_contadorNormal';
    } else {
      _contadorPrioritario++;
      senhaGerada = '${tipo.codigo}$_contadorPrioritario';
    }

    // Envia o payload de nova senha para o servidor
    _socketService.enviar({
      'acao': AcaoSase.novaSenha.comando,
      'senha': senhaGerada,
      'tipo': tipo.codigo,
    });

    // Feedback visual de sucesso na tela do TS
    final cor = tipo == TipoSenha.normal ? Colors.blue : Colors.orange;
    final titulo = tipo == TipoSenha.normal ? 'Normal' : 'Prioritária';

    SaseFeedbackUtils.showSuccess(
      title: 'Senha Emitida',
      message: 'Sua senha $titulo é $senhaGerada.\nAguarde ser chamado no painel.',
      color: cor,
      icon: Icons.print,
    );
  }
}
