import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/constants/app_constants.dart';
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
                    const Text(
                      'Terminal de Atendimento',
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
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Campo de número do guichê
                    TextFormField(
                      controller: mesaController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Número do Guichê',
                        hintText: '1',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.blue[700]!,
                            width: 2,
                          ),
                        ),
                      ),
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
                    ),
                    const SizedBox(height: 32),

                    // Botão Confirmar
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final mesa = int.parse(mesaController.text);
                            await controller.configurarEConectar(mesa);
                            Get.toNamed(AppConstants.routeTaAtendimento);
                          }
                        },
                        icon: const Icon(Icons.login),
                        label: const Text(
                          'CONFIRMAR E CONECTAR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
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
