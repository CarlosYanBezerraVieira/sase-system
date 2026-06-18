import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/enums/sase_enums.dart';
import 'package:sase_client/core/services/socket_service.dart';

class SenhaChamada {
  final String senha;
  final int mesa;

  SenhaChamada({required this.senha, required this.mesa});
}

/// Controlador do Terminal de Visualização (TV).
///
/// Mantém as senhas ativas, histórico de chamadas e reproduz o
/// efeito sonoro (campainha) ao receber atualizações do servidor.
class TvController extends GetxController {
  final SocketService _socketService = Get.find<SocketService>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Estado Reativo
  final Rx<SenhaChamada?> ultimaChamada = Rx<SenhaChamada?>(null);
  final RxList<SenhaChamada> historico = <SenhaChamada>[].obs;

  @override
  void onInit() {
    super.onInit();
    _conectarComoTv();
  }

  Future<void> _conectarComoTv() async {
    await _socketService.conectar(TipoCliente.tv);
    _escutarMensagens();
  }

  void _escutarMensagens() {
    _socketService.messages.listen((mensagem) {
      final acaoRaw = mensagem['acao'] as String?;
      if (acaoRaw == null) return;

      final acao = AcaoSase.fromComando(acaoRaw);

      if (acao == AcaoSase.atualizarPainel) {
        final senha = mensagem['senha'] as String?;
        final mesa = mensagem['mesa'] as int?;

        if (senha != null && mesa != null) {
          _registrarNovaChamada(senha, mesa);
        }
      }
    });
  }

  void _registrarNovaChamada(String senha, int mesa) {
    // Se já havia uma chamada sendo exibida, move para o histórico
    if (ultimaChamada.value != null) {
      historico.insert(0, ultimaChamada.value!);
      // Limita o histórico a 5 itens para não quebrar layout
      if (historico.length > 5) {
        historico.removeLast();
      }
    }

    // Atualiza a tela central
    ultimaChamada.value = SenhaChamada(senha: senha, mesa: mesa);

    // Toca o som de alerta
    _tocarCampainha();
  }

  Future<void> _tocarCampainha() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/ding.wav'));
    } catch (e) {
      debugPrint('[ERRO AUDIO] Falha ao reproduzir som: $e');
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
