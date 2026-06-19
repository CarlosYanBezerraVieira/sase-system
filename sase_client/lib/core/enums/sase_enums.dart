/// Enums compartilhados com o protocolo do servidor SASE.
///
/// Estes enums espelham os do sase_server e garantem que o cliente
/// nunca use strings mágicas ao montar ou parsear payloads JSON.
library;

/// Define os tipos de senhas disponíveis no sistema.
enum TipoSenha {
  normal('N'),
  prioritaria('P');

  final String codigo;
  const TipoSenha(this.codigo);

  static TipoSenha? fromCodigo(String codigo) {
    for (final tipo in values) {
      if (tipo.codigo == codigo) return tipo;
    }
    return null;
  }
}

/// Define as ações suportadas pelo protocolo de comunicação TCP.
enum AcaoSase {
  registrar('registrar'),
  novaSenha('nova_senha'),
  chamarProxima('chamar_proxima'),
  suaVez('sua_vez'),
  filaVazia('fila_vazia'),
  atualizarPainel('atualizar_painel');

  final String comando;
  const AcaoSase(this.comando);

  static AcaoSase? fromComando(String comando) {
    for (final acao in values) {
      if (acao.comando == comando) return acao;
    }
    return null;
  }
}

/// Define os tipos de terminais clientes que se conectam ao servidor.
enum TipoCliente {
  ts('TS'),
  ta('TA'),
  tv('TV');

  final String sigla;
  const TipoCliente(this.sigla);

  static TipoCliente? fromSigla(String sigla) {
    for (final tipo in values) {
      if (tipo.sigla == sigla) return tipo;
    }
    return null;
  }
}
