import 'dart:io';

import 'package:sase_server/src/enums/sase_enums.dart';
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
    final tipoClienteRaw = mensagem['tipo_cliente'] as String?;

    if (tipoClienteRaw == null) {
      print('[AVISO] Handshake sem "tipo_cliente" de $enderecoRemoto');
      return;
    }

    final tipoCliente = TipoCliente.fromSigla(tipoClienteRaw);

    if (tipoCliente != null) {
      clienteManager.registrar(socket, tipoCliente);
      print('[REGISTRO] $enderecoRemoto registrado como ${tipoCliente.sigla}');
      print('[STATUS] Conexões ativas — ${clienteManager.resumo}');

      logger.registrar(
        modulo: 'SRV',
        acao: AcaoSase.registrar.comando,
        dados: {
          'tipo_cliente': tipoCliente.sigla,
          'endereco': enderecoRemoto,
          'status': 'sucesso',
        },
      );
    } else {
      print('[AVISO] tipo_cliente inválido "$tipoClienteRaw" de $enderecoRemoto');
    }
  }
}
