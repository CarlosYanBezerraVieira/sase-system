import 'dart:convert';
import 'dart:io';

import 'package:sase_server/src/cliente_manager.dart';
import 'package:sase_server/src/handlers/action_handler.dart';
import 'package:sase_server/src/handlers/registrar_handler.dart';
import 'package:sase_server/src/logger_service.dart';

/// Servidor TCP do Sistema de Atendimento por Senha Eletrônica (SASE).
///
/// Responsável por:
/// - Escutar conexões TCP na porta configurada.
/// - Realizar o handshake com clientes (registrar tipo: TS, TA, TV).
/// - Rotear mensagens JSON recebidas para o handler apropriado.
/// - Gerenciar o ciclo de vida das conexões (conectar/desconectar).
class SaseServer {
  final String host;
  final int port;
  final ClienteManager clienteManager;
  final LoggerService logger;

  late final Map<String, ActionHandler> _handlers;

  ServerSocket? _serverSocket;

  SaseServer({
    required this.host,
    required this.port,
    required this.clienteManager,
    required this.logger,
  }) {
    _handlers = {
      'registrar': RegistrarHandler(clienteManager: clienteManager, logger: logger),
      // Novas ações serão registradas aqui:
      // 'nova_senha': NovaSenhaHandler(...),
    };
  }

  /// Inicia o servidor, abrindo o ServerSocket para escutar conexões.
  Future<void> iniciar() async {
    await logger.init();

    _serverSocket = await ServerSocket.bind(host, port);

    print('===========================================');
    print(' SASE Server iniciado em $host:$port');
    print('===========================================');

    await logger.registrar(
      modulo: 'SRV',
      acao: 'servidor_iniciado',
      dados: {'host': host, 'porta': port},
    );

    // Escuta novas conexões de forma assíncrona.
    _serverSocket!.listen(
      _onClienteConectado,
      onError: (error) {
        print('[ERRO] Erro no ServerSocket: $error');
      },
      onDone: () {
        print('[INFO] ServerSocket encerrado.');
      },
    );
  }

  /// Callback chamado quando um novo cliente se conecta.
  void _onClienteConectado(Socket socket) {
    final enderecoRemoto =
        '${socket.remoteAddress.address}:${socket.remotePort}';

    print('[CONEXÃO] Novo cliente conectado: $enderecoRemoto');

    // Buffer para acumular dados parciais (TCP é stream, não pacotes).
    String buffer = '';

    socket.listen(
      (data) {
        buffer += utf8.decode(data);

        // Processa todas as mensagens completas no buffer.
        // Cada mensagem JSON é delimitada por '\n'.
        while (buffer.contains('\n')) {
          final indiceQuebraDeLinha = buffer.indexOf('\n');
          final mensagemCompleta =
              buffer.substring(0, indiceQuebraDeLinha).trim();
          buffer = buffer.substring(indiceQuebraDeLinha + 1);

          if (mensagemCompleta.isNotEmpty) {
            _processarMensagem(socket, mensagemCompleta, enderecoRemoto);
          }
        }
      },
      onError: (error) {
        print('[ERRO] Erro no socket $enderecoRemoto: $error');
        _onClienteDesconectado(socket, enderecoRemoto);
      },
      onDone: () {
        _onClienteDesconectado(socket, enderecoRemoto);
      },
    );
  }

  /// Processa uma mensagem JSON completa recebida de um cliente.
  void _processarMensagem(
    Socket socket,
    String mensagemRaw,
    String enderecoRemoto,
  ) {
    try {
      final Map<String, dynamic> mensagem = jsonDecode(mensagemRaw);
      final String? acao = mensagem['acao'] as String?;

      if (acao == null) {
        print(
            '[AVISO] Mensagem sem campo "acao" de $enderecoRemoto: $mensagemRaw');
        return;
      }

      final handler = _handlers[acao];

      if (handler != null) {
        handler.handle(socket, mensagem, enderecoRemoto);
      } else {
        print('[AVISO] Ação desconhecida "$acao" de $enderecoRemoto');
      }
    } on FormatException catch (e) {
      print('[ERRO] JSON inválido de $enderecoRemoto: $e');
    }
  }

  /// Callback chamado quando um cliente desconecta.
  void _onClienteDesconectado(Socket socket, String enderecoRemoto) {
    clienteManager.remover(socket);
    print('[DESCONEXÃO] Cliente desconectado: $enderecoRemoto');
    print('[STATUS] Conexões ativas — ${clienteManager.resumo}');

    logger.registrar(
      modulo: 'SRV',
      acao: 'cliente_desconectado',
      dados: {'endereco': enderecoRemoto},
    );

    try {
      socket.destroy();
    } catch (_) {}
  }

  /// Encerra o servidor e libera os recursos.
  Future<void> parar() async {
    await _serverSocket?.close();
    await logger.dispose();
    print('[INFO] Servidor SASE encerrado.');
  }
}
