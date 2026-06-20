import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/ui/widgets/sase_button.dart';
import 'package:sase_client/core/ui/widgets/sase_header.dart';
import 'package:sase_client/modules/ta/ta_controller.dart';
import 'package:sase_client/modules/ta/widgets/ta_painel_central.dart';

/// Tela principal do Terminal de Atendimento (TA).
///
/// Exibe o painel de senha ou o widget de fila vazia dependendo do estado
/// gerenciado pelo `TaController`. Nenhuma regra de negócio aqui.
class TaView extends GetView<TaController> {
  const TaView({super.key});

  @override
  Widget build(BuildContext context) {
    final tamanhoTela = MediaQuery.sizeOf(context);
    return Obx(() {
      final titulo = 'Guichê N° ${controller.numeroMesa.value}';

      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: SaseHeader(title: titulo),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: const TaPainelCentral(),
                ),
                const SizedBox(height: 64),
                SizedBox(
                  width: tamanhoTela.width * 0.8,
                  height: tamanhoTela.height * 0.15,
                  child: SaseButton(
                    label: 'Chamar Próxima',
                    icon: Icons.notifications_active,
                    color: Colors.blue[700]!,
                    onTap: controller.chamarProxima,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
