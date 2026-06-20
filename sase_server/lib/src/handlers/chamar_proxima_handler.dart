import 'dart:convert';
import 'dart:io';

import 'package:sase_server/src/enums/sase_enums.dart';
import 'package:sase_server/src/handlers/action_handler.dart';

/// Manipulador para a ação "chamar_proxima".
///
/// Disparado pelo Terminal de Atendimento (TA).
/// O servidor aplica as regras de intercalação para definir quem é o próximo,
/// retorna para o TA que pediu e propaga via broadcast para as TVs.
///
/// Payload esperado do TA:
/// ```json
/// {
///   "acao": "chamar_proxima",
///   "mesa": 1
/// }
/// ```
class ChamarProximaHandler extends ActionHandler {
  ChamarProximaHandler({
    required super.clienteManager,
    required super.logger,
    required super.filaManager,
  });

  @override
  void handle(
      Socket socket, Map<String, dynamic> mensagem, String enderecoRemoto) {
    final mesa = mensagem['mesa'];

    if (mesa == null) {
      print(
          '[AVISO] "chamar_proxima" mal formatada de $enderecoRemoto: $mensagem');
      return;
    }

    final proximaSenha = filaManager.chamarProxima();

    if (proximaSenha == null) {
      // Filas vazias
      final payload = jsonEncode({'acao': AcaoSase.filaVazia.comando});
      socket.writeln(payload);
      print('[FILA] Mesa $mesa tentou chamar, mas as filas estão vazias.');
    } else {
      // Retorna para o TA
      final payloadTa = jsonEncode({
        'acao': AcaoSase.suaVez.comando,
        'senha': proximaSenha,
      });
      socket.writeln(payloadTa);

      // Broadcast para as TVs
      final payloadTv = jsonEncode({
        'acao': AcaoSase.atualizarPainel.comando,
        'senha': proximaSenha,
        'mesa': mesa,
      });
      final tVs = clienteManager.terminaisVisualizacao;
      for (final tvSocket in tVs) {
        try {
          tvSocket.writeln(payloadTv);
        } catch (e) {
          print('[ERRO] Falha ao enviar broadcast para uma TV: $e');
        }
      }

      print(
          '[CHAMADA] Senha $proximaSenha chamada para a Mesa $mesa (Enviado para ${tVs.length} TVs)');

      // Registra auditoria (timestamp exato do envio)
      logger.registrar(
        modulo: 'SRV',
        acao: AcaoSase.chamarProxima.comando,
        dados: {
          'mesa': mesa,
          'senha_entregue': proximaSenha,
          'tvs_notificadas': tVs.length,
        },
      );
    }
  }
}
