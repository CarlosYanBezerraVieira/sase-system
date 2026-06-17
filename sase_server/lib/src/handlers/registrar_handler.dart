import 'dart:io';

import 'package:sase_server/src/handlers/action_handler.dart';

/// Manipulador para a ação "registrar".
///
/// Trata o handshake de registro de um cliente.
/// Payload esperado:
/// ```json
/// {"acao": "registrar", "tipo_cliente": "TS|TA|TV"}
/// ```
class RegistrarHandler extends ActionHandler {
  RegistrarHandler({
    required super.clienteManager,
    required super.logger,
    required super.filaManager,
  });

  @override
  void handle(Socket socket, Map<String, dynamic> mensagem, String enderecoRemoto) {
    final tipoCliente = mensagem['tipo_cliente'] as String?;

    if (tipoCliente == null) {
      print('[AVISO] Handshake sem "tipo_cliente" de $enderecoRemoto');
      return;
    }

    final registrado = clienteManager.registrar(socket, tipoCliente);

    if (registrado) {
      print('[REGISTRO] $enderecoRemoto registrado como $tipoCliente');
      print('[STATUS] Conexões ativas — ${clienteManager.resumo}');

      logger.registrar(
        modulo: 'SRV',
        acao: 'cliente_registrado',
        dados: {
          'tipo_cliente': tipoCliente,
          'endereco': enderecoRemoto,
          'status': 'sucesso',
        },
      );
    } else {
      print('[AVISO] tipo_cliente inválido "$tipoCliente" de $enderecoRemoto');
    }
  }
}
