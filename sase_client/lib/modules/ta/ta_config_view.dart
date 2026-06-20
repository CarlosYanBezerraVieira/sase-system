import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/constants/app_constants.dart';
import 'package:sase_client/core/ui/widgets/sase_form_action_button.dart';
import 'package:sase_client/core/ui/widgets/sase_form_text_field.dart';
import 'package:sase_client/modules/ta/ta_controller.dart';

/// Tela de configuração inicial do Terminal de Atendimento.
///
/// O atendente informa o número do seu guichê antes de conectar ao servidor.
class TaConfigView extends GetView<TaController> {
  const TaConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController mesaController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isTextAlignCenter = MediaQuery.sizeOf(context).width < 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            elevation: 8,
            shadowColor: Colors.blue.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ícone
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.support_agent,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Terminal de Atendimento',
                      textAlign: isTextAlignCenter ? TextAlign.center : null,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Informe o número deste guichê para iniciar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 40),

                    SaseFormTextField(
                      controller: mesaController,
                      labelText: 'Número do Guichê',
                      hintText: '1',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe o número do guichê.';
                        }
                        final numero = int.tryParse(value);
                        if (numero == null || numero <= 0) {
                          return 'Número inválido. Use um número maior que zero.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      accentColor: Colors.blue[700]!,
                    ),
                    const SizedBox(height: 32),

                    // Botão Confirmar
                    SaseFormActionButton(
                      label: 'CONFIRMAR E CONECTAR',
                      icon: Icons.login,
                      backgroundColor: Colors.blue[700]!,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final mesa = int.parse(mesaController.text);
                          await controller.configurarEConectar(mesa);
                          Get.toNamed(AppConstants.routeTaAtendimento);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    SaseFormActionButton(
                      label: 'VOLTAR',
                      icon: Icons.arrow_back,
                      backgroundColor: Colors.blueGrey[700]!,
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
