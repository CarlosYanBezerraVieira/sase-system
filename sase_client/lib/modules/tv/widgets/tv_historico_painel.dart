import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/modules/tv/tv_controller.dart';
import 'package:sase_client/modules/tv/widgets/tv_historico_item.dart';

/// Painel lateral com as últimas chamadas da TV.
class TvHistoricoPainel extends GetView<TvController> {
  const TvHistoricoPainel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            color: Colors.black26,
            child: const Text(
              'ÚLTIMAS CHAMADAS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final historico = controller.historico;
              if (historico.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum histórico',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }

              return ListView.separated(
                itemCount: historico.length,
                padding: const EdgeInsets.all(24),
                separatorBuilder: (_, _) =>
                    const Divider(color: Colors.white24, height: 32),
                itemBuilder: (context, index) {
                  return TvHistoricoItem(item: historico[index],
                  isPrioritaria: controller.getIsPrioritariaByIndex(index),);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
