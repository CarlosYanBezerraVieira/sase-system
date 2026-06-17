import 'dart:io';

import 'package:sase_server/src/handlers/action_handler.dart';

/// Manipulador para a ação "nova_senha".
///
/// Disparado pelo Terminal de Senhas (TS) quando uma nova senha é gerada.
/// Payload esperado:
/// ```json
/// {
///   "acao": "nova_senha",
///   "senha": "P1",
///   "tipo": "P"
/// }
/// ```
class NovaSenhaHandler extends ActionHandler {
  NovaSenhaHandler({
    required super.clienteManager,
    required super.logger,
    required super.filaManager,
  });

  @override
  void handle(Socket socket, Map<String, dynamic> mensagem, String enderecoRemoto) {
    final senha = mensagem['senha'] as String?;
    final tipo = mensagem['tipo'] as String?;

    if (senha == null || tipo == null) {
      print('[AVISO] "nova_senha" mal formatada de $enderecoRemoto: $mensagem');
      return;
    }

    // Adiciona na fila correspondente.
    filaManager.adicionarSenha(senha, tipo);

    print('[FILA] Nova senha recebida: $senha (Tipo: $tipo)');
    print('[STATUS] Fila atual — Normal: ${filaManager.tamanhoFilaNormal} | Prioritária: ${filaManager.tamanhoFilaPrioritaria}');

    // Registra auditoria (timestamp do exato instante de recebimento).
    logger.registrar(
      modulo: 'SRV',
      acao: 'nova_senha',
      dados: {
        'senha': senha,
        'tipo': tipo,
        'status': 'sucesso',
      },
    );
  }
}
