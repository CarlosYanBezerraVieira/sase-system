import 'dart:io';

import 'package:sase_server/src/enums/sase_enums.dart';
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
    final tipoRaw = mensagem['tipo'] as String?;

    if (senha == null || tipoRaw == null) {
      print('[AVISO] "nova_senha" mal formatada de $enderecoRemoto: $mensagem');
      return;
    }

    final tipo = TipoSenha.fromCodigo(tipoRaw);
    if (tipo == null) {
      print('[AVISO] Tipo de senha inválido "$tipoRaw" de $enderecoRemoto');
      return;
    }

    // Adiciona na fila correspondente.
    filaManager.adicionarSenha(senha, tipo);

    print('[FILA] Nova senha recebida: $senha (Tipo: ${tipo.codigo})');
    print('[STATUS] Fila atual — Normal: ${filaManager.tamanhoFilaNormal} | Prioritária: ${filaManager.tamanhoFilaPrioritaria}');

    // Registra auditoria (timestamp do exato instante de recebimento).
    logger.registrar(
      modulo: 'SRV',
      acao: AcaoSase.novaSenha.comando,
      dados: {
        'senha': senha,
        'tipo': tipo.codigo,
        'status': 'sucesso',
      },
    );
  }
}
