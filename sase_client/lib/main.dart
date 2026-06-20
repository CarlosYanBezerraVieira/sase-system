import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/constants/app_constants.dart';
import 'package:sase_client/core/di/dependency_injection.dart';
import 'package:sase_client/modules/ta/ta_binding.dart';
import 'package:sase_client/modules/ta/ta_config_view.dart';
import 'package:sase_client/modules/ta/ta_view.dart';
import 'package:sase_client/modules/ts/ts_binding.dart';
import 'package:sase_client/modules/ts/ts_view.dart';
import 'package:sase_client/modules/tv/tv_binding.dart';
import 'package:sase_client/modules/tv/tv_view.dart';

void main() {
  // Inicializa o binding do Flutter antes de injeções nativas
  WidgetsFlutterBinding.ensureInitialized();

  // Configura Injeção de Dependências global
  DependencyInjection.init();

  runApp(const SaseClientApp());
}

class SaseClientApp extends StatelessWidget {
  const SaseClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SASE Client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: AppConstants.routeHome,
      getPages: [
        GetPage(
          name: AppConstants.routeHome,
          page: () => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppConstants.routeTs),
                    child: const Text('Abrir Terminal de Senhas (TS)'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppConstants.routeTa),
                    child: const Text('Abrir Terminal de Atendimento (TA)'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppConstants.routeTv),
                    child: const Text('Abrir Painel de TV (TV)'),
                  ),
                ],
              ),
            ),
          ),
        ),
        GetPage(
          name: AppConstants.routeTs,
          page: () => const TsView(),
          binding: TsBinding(),
        ),
        GetPage(
          name: AppConstants.routeTa,
          page: () => const TaConfigView(),
          binding: TaBinding(),
        ),
        GetPage(
          name: AppConstants.routeTaAtendimento,
          page: () => const TaView(),
          binding: TaBinding(),
        ),
        GetPage(
          name: AppConstants.routeTv,
          page: () => const TvView(),
          binding: TvBinding(),
        ),
      ],
    );
  }
}
