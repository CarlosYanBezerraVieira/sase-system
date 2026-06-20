import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/ui/widgets/sase_header.dart';
import 'package:sase_client/modules/tv/tv_controller.dart';
import 'package:sase_client/modules/tv/widgets/tv_historico_painel.dart';
import 'package:sase_client/modules/tv/widgets/tv_painel_atual.dart';

/// Painel de exibição para a TV.
///
/// Interface otimizada para legibilidade à distância. Fundo de alto contraste,
/// senha principal em destaque máximo e histórico nas laterais.
class TvView extends GetView<TvController> {
  const TvView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: const SaseHeader(title: 'Painel de Chamadas'),
      body: Row(
        children: [
          const Expanded(
            flex: 3,
            child: TvPainelAtual(),
          ),
          Container(width: 2, color: Colors.white24),
          const Expanded(
            flex: 1,
            child: TvHistoricoPainel(),
          ),
        ],
      ),
    );
  }
}
