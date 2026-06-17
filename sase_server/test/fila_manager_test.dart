import 'package:test/test.dart';
import 'package:sase_server/src/fila_manager.dart';

void main() {
  group('FilaManager - Intercalação', () {
    late FilaManager filaManager;

    setUp(() {
      filaManager = FilaManager();
    });

    test('Deve chamar na ordem N, N, P quando ambas as filas têm senhas suficientes', () {
      // Adiciona 5 senhas normais
      filaManager.adicionarSenha('N1', 'N');
      filaManager.adicionarSenha('N2', 'N');
      filaManager.adicionarSenha('N3', 'N');
      filaManager.adicionarSenha('N4', 'N');
      filaManager.adicionarSenha('N5', 'N');

      // Adiciona 3 senhas prioritárias
      filaManager.adicionarSenha('P1', 'P');
      filaManager.adicionarSenha('P2', 'P');
      filaManager.adicionarSenha('P3', 'P');

      // Chamada 1: Normal
      expect(filaManager.chamarProxima(), equals('N1'));
      // Chamada 2: Normal
      expect(filaManager.chamarProxima(), equals('N2'));
      // Chamada 3: Prioritária (Regra ativada: 2 normais -> 1 prioritária)
      expect(filaManager.chamarProxima(), equals('P1'));
      
      // Chamada 4: Normal
      expect(filaManager.chamarProxima(), equals('N3'));
      // Chamada 5: Normal
      expect(filaManager.chamarProxima(), equals('N4'));
      // Chamada 6: Prioritária
      expect(filaManager.chamarProxima(), equals('P2'));

      // Chamada 7: Normal
      expect(filaManager.chamarProxima(), equals('N5'));
      // Fila normal acabou, as próximas devem ser prioritárias
      expect(filaManager.chamarProxima(), equals('P3'));
      
      // Filas vazias
      expect(filaManager.chamarProxima(), isNull);
    });

    test('Prioritárias vão primeiro se a fila normal estiver vazia', () {
      filaManager.adicionarSenha('P1', 'P');
      filaManager.adicionarSenha('P2', 'P');

      expect(filaManager.chamarProxima(), equals('P1'));
      expect(filaManager.chamarProxima(), equals('P2'));
      expect(filaManager.chamarProxima(), isNull);
    });

    test('Normais vão sendo chamadas se não há prioritária', () {
      filaManager.adicionarSenha('N1', 'N');
      filaManager.adicionarSenha('N2', 'N');
      filaManager.adicionarSenha('N3', 'N');

      expect(filaManager.chamarProxima(), equals('N1'));
      expect(filaManager.chamarProxima(), equals('N2'));
      expect(filaManager.chamarProxima(), equals('N3'));
      expect(filaManager.chamarProxima(), isNull);
    });
  });
}
