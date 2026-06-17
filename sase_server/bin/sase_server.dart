import 'dart:io';

import 'package:sase_server/sase_server.dart';

/// Ponto de entrada do servidor SASE.
///
/// Uso: `dart run`
///
/// O servidor escuta na porta 4040 por padrão.
/// Para encerrar, pressione Ctrl+C no terminal.
void main() async {
  const host = '0.0.0.0'; // Escuta em todas as interfaces de rede.
  const port = 4040;

  final clienteManager = ClienteManager();
  final logger = LoggerService();

  final server = SaseServer(
    host: host,
    port: port,
    clienteManager: clienteManager,
    logger: logger,
  );

  // Trata o sinal de interrupção (Ctrl+C) para encerrar graciosamente.
  ProcessSignal.sigint.watch().listen((_) async {
    print('\n[INFO] Encerrando servidor...');
    await server.parar();
    exit(0);
  });

  await server.iniciar();
}
