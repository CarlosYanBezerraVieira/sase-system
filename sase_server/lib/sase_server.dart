/// Servidor do Sistema de Atendimento por Senha Eletrônica (SASE).
///
/// Exporta os módulos principais do servidor:
/// - [SaseServer]: Classe principal que gerencia o ServerSocket TCP.
/// - [ClienteManager]: Gerenciador de conexões classificadas por tipo.
/// - [LoggerService]: Serviço de log com rotação diária em JSONL.
library sase_server;

export 'src/sase_server.dart';
export 'src/cliente_manager.dart';
export 'src/logger_service.dart';
