import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/enums/sase_enums.dart';
import 'package:sase_client/core/ui/widgets/sase_button.dart';
import 'package:sase_client/core/ui/widgets/sase_header.dart';
import 'package:sase_client/modules/ts/ts_controller.dart';

/// Tela principal do Terminal de Senhas (TS).
///
/// Interface visual limpa focada em dois grandes botões para autoatendimento.
/// Não contém regras de negócio, apenas amarrações com o `TsController`.
class TsView extends GetView<TsController> {
  const TsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const SaseHeader(title: 'Terminal de Emissão de Senhas'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: SaseButton(
                      label: 'Atendimento\nNormal',
                      icon: Icons.person,
                      color: Colors.blue[700]!,
                      onTap: () => controller.solicitarSenha(TipoSenha.normal),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: SaseButton(
                      label: 'Atendimento\nPrioritário',
                      icon: Icons.accessible_forward,
                      color: Colors.orange[800]!,
                      onTap: () => controller.solicitarSenha(TipoSenha.prioritaria),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
