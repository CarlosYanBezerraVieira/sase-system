import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/constants/app_constants.dart';
import 'package:sase_client/core/enums/sase_enums.dart';
import 'package:sase_client/core/model/sase_mensagem.dart';

/// Serviço responsável por gerenciar a conexão TCP nativa com o Servidor SASE.
///
/// Lida com a conexão, envio de handshake, parsing de pacotes JSON
/// e expõe um Stream para que a UI (Controllers) reaja aos eventos.
class SocketService extends GetxService {
  Socket? _socket;

  /// Indica se o cliente está atualmente conectado ao servidor.
  final RxBool isConnected = false.obs;

  /// Stream que expõe as mensagens recebidas já convertidas em JSON.
  final _messageStream = StreamController<SaseMensagem>.broadcast();
  Stream<SaseMensagem> get messages => _messageStream.stream;

  /// Estabelece a conexão TCP e realiza o handshake com o servidor.
  Future<void> conectar(TipoCliente tipoCliente) async {
    if (isConnected.value) return;

    try {
      _socket = await Socket.connect(
        AppConstants.serverHost,
        AppConstants.serverPort,
        timeout: const Duration(seconds: 5),
      );
      
      isConnected.value = true;
      debugPrint('[SOCKET] Conectado ao servidor ${AppConstants.serverHost}:${AppConstants.serverPort}');

      // Envia o payload de handshake imediatamente após conectar
      _enviarJson({
        'acao': AcaoSase.registrar.comando,
        'tipo_cliente': tipoCliente.sigla,
      });

      // Buffer para tratar pacotes TCP quebrados
      String buffer = '';

      _socket!.listen(
        (data) {
          buffer += utf8.decode(data);
          
          while (buffer.contains('\n')) {
            final indiceQuebra = buffer.indexOf('\n');
            final mensagemCompleta = buffer.substring(0, indiceQuebra).trim();
            buffer = buffer.substring(indiceQuebra + 1);

            if (mensagemCompleta.isNotEmpty) {
              _processarMensagem(mensagemCompleta);
            }
          }
        },
        onError: (error) {
          debugPrint('[ERRO SOCKET] $error');
          desconectar();
        },
        onDone: () {
          debugPrint('[INFO SOCKET] O servidor encerrou a conexão.');
          desconectar();
        },
      );
    } catch (e) {
      debugPrint('[ERRO SOCKET] Falha ao conectar: $e');
      isConnected.value = false;
    }
  }

  /// Converte a string JSON e propaga pelo Stream para os ouvintes (Controllers).
  void _processarMensagem(String rawMsg) {
    try {
      final Map<String, dynamic> msgDecodificada =
          Map<String, dynamic>.from(jsonDecode(rawMsg) as Map);
      _messageStream.add(SaseMensagem.fromJson(msgDecodificada));
    } catch (e) {
      debugPrint('[ERRO JSON] Falha ao decodificar mensagem do servidor: $rawMsg');
    }
  }

  /// Converte uma mensagem tipada em JSON e envia via Socket.
  void enviar(SaseMensagem mensagem) {
    _enviarJson(mensagem.toJson());
  }

  /// Converte um payload Map em JSON e envia via Socket.
  void _enviarJson(Map<String, dynamic> payload) {
    if (_socket != null && isConnected.value) {
      final stringJson = jsonEncode(payload);
      _socket!.writeln(stringJson);
      debugPrint('[SOCKET TX] $stringJson');
    } else {
      debugPrint('[AVISO] Tentativa de envio de mensagem sem conexão ativa: $payload');
    }
  }

  /// Encerra a conexão e reseta os estados.
  void desconectar() {
    _socket?.destroy();
    _socket = null;
    isConnected.value = false;
    debugPrint('[SOCKET] Desconectado.');
  }

  @override
  void onClose() {
    desconectar();
    _messageStream.close();
    super.onClose();
  }
}
