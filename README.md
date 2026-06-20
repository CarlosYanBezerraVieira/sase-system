# SASE - Sistema de Atendimento por Senha Eletronica

Sistema distribuido para emissao, chamada e exibicao de senhas de atendimento. O projeto e composto por um servidor TCP em Dart e por um cliente Flutter para desktop, com telas para Terminal de Senhas (TS), Terminal de Atendimento (TA) e Terminal de Visualizacao (TV).

## Visao Geral

O SASE organiza o fluxo de atendimento ao publico usando senhas normais e prioritarias. O Terminal de Senhas gera as senhas, o Servidor centraliza as filas e distribui a proxima senha quando um guiche solicita atendimento, e o Painel de TV exibe em tempo real a senha chamada e o respectivo guiche.

O sistema utiliza sockets TCP com mensagens JSON delimitadas por quebra de linha (`\n`), mantendo a comunicacao simples entre os modulos.

## Modulos

- **SRV - Servidor**: aplica as regras de negocio, gerencia conexoes TCP, registra senhas, controla filas e envia atualizacoes para os clientes.
- **TS - Terminal de Senhas**: gera senhas normais (`N`) e prioritarias (`P`) em ordem crescente e envia ao servidor.
- **TA - Terminal de Atendimento**: permite configurar o numero do guiche e chamar a proxima senha disponivel.
- **TV - Terminal de Visualizacao**: recebe atualizacoes do servidor, exibe a senha chamada, mostra historico recente e reproduz alerta sonoro.

## Regra de Atendimento

As senhas sao separadas em duas filas:

- Normal: `N1`, `N2`, `N3`...
- Prioritaria: `P1`, `P2`, `P3`...

O servidor aplica a regra de intercalacao 2:1: a cada duas senhas normais chamadas, a proxima senha deve ser prioritaria, quando houver senha prioritaria aguardando.

## Tecnologias

- **Dart** no servidor (`sase_server`)
- **Flutter** no cliente desktop (`sase_client`)
- **GetX** para rotas, injecao de dependencias e estado reativo
- **audioplayers** para alerta sonoro no painel de TV
- **Sockets TCP** com payloads JSON
- **JSON Lines** para logs do servidor

## Estrutura do Projeto

```text
sase-system/
+-- sase_server/
|   +-- bin/sase_server.dart
|   +-- lib/src/
|   |   +-- sase_server.dart
|   |   +-- fila_manager.dart
|   |   +-- cliente_manager.dart
|   |   +-- logger_service.dart
|   |   +-- handlers/
|   +-- test/
+-- sase_client/
|   +-- lib/main.dart
|   +-- lib/core/
|   |   +-- services/socket_service.dart
|   |   +-- model/sase_mensagem.dart
|   |   +-- constants/app_constants.dart
|   +-- lib/modules/
|   |   +-- ts/
|   |   +-- ta/
|   |   +-- tv/
|   +-- assets/sounds/
|   +-- windows/
+-- README.md
```

## Pre-Requisitos

- Dart SDK compativel com o servidor (`^3.5.4`)
- Flutter SDK compativel com o cliente (`Dart >=3.12.2 <4.0.0`)
- Ambiente Flutter configurado para build desktop Windows

## Instalacao

Instale as dependencias do servidor:

```bash
cd sase_server
dart pub get
```

Instale as dependencias do cliente:

```bash
cd sase_client
flutter pub get
```

## Configuracao

O servidor escuta na porta `4040`.

No cliente, o endereco do servidor fica em:

```text
sase_client/lib/core/constants/app_constants.dart
```

Por padrao:

```dart
static const String serverHost = '127.0.0.1';
static const int serverPort = 4040;
```

Quando o cliente estiver em outro computador da rede, ajuste `serverHost` para o IP da maquina onde o servidor esta em execucao.

## Como Executar

Inicie o servidor:

```bash
cd sase_server
dart run
```

Em outro terminal, execute o cliente Flutter:

```bash
cd sase_client
flutter run -d windows
```

Na tela inicial do cliente, escolha o modulo desejado:

- **Terminal de Senhas (TS)** para emitir senhas.
- **Terminal de Atendimento (TA)** para configurar o guiche e chamar a proxima senha.
- **Painel de TV (TV)** para acompanhar as chamadas em tempo real.

## Fluxo de Uso

1. Inicie o servidor.
2. Abra uma instancia do cliente como **TV** para exibir o painel de chamadas.
3. Abra uma instancia como **TS** para gerar senhas normais ou prioritarias.
4. Abra uma instancia como **TA**, informe o numero do guiche e clique em **Chamar Proxima**.
5. O servidor entrega a senha ao TA e envia a mesma chamada para todas as TVs conectadas.

## Compilacao Para Windows

Para gerar o executavel Windows em modo release:

```bash
cd sase_client
flutter build windows --release
```

O executavel sera gerado em:

```text
sase_client/build/windows/x64/runner/Release/sase_client.exe
```

Para distribuir o aplicativo, utilize a pasta `Release`, pois ela contem o `.exe` e os arquivos necessarios para execucao.

O executavel gerado pelo Flutter nao deve ser distribuido sozinho. Ele precisa
das DLLs e da pasta `data` que ficam em `build/windows/x64/runner/Release`.

## Protocolo JSON

Todas as mensagens trafegam via TCP em UTF-8, no formato JSON, finalizadas com `\n`.

Handshake do cliente:

```json
{
  "acao": "registrar",
  "tipo_cliente": "TS"
}
```

Nova senha enviada pelo TS:

```json
{
  "acao": "nova_senha",
  "senha": "P1",
  "tipo": "P"
}
```

Solicitacao do TA:

```json
{
  "acao": "chamar_proxima",
  "mesa": 1
}
```

Resposta do servidor ao TA:

```json
{
  "acao": "sua_vez",
  "senha": "P1"
}
```

Atualizacao enviada para as TVs:

```json
{
  "acao": "atualizar_painel",
  "senha": "P1",
  "mesa": 1
}
```

Resposta quando nao ha senha aguardando:

```json
{
  "acao": "fila_vazia"
}
```

## Logs

O servidor registra eventos de auditoria em arquivos diarios no formato JSON Lines:

```text
logs/sase_logs_YYYY-MM-DD.log
```

Os logs incluem eventos como inicializacao do servidor, registro de clientes, recebimento de novas senhas e envio de senhas para atendimento.

## Testes

Execute os testes do servidor:

```bash
cd sase_server
dart test
```

Execute os testes do cliente:

```bash
cd sase_client
flutter test
```

## Licenca

Este projeto esta licenciado sob a licenca MIT.
