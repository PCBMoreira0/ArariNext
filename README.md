# 🚤 Arari Next — Telemetry Dashboard

Um software de dashboard de telemetria desenvolvido em **Flutter**, focado em visualização através de cards com dashboard customizável e monitoramento em tempo real via protocolo **MAVLink**.

---

## Aviso Importante (Branch `main`)

> A branch `main` utiliza por padrão uma fonte de dados simulada que reproduz o fluxo de telemetria sem necessidade de hardware físico ou conexão serial.

A aplicação possui suporte completo à comunicação serial via MAVLink. A implementação real (`SerialDatasource`) permanece disponível para uso com o sistema embarcado, enquanto o modo simulado permite executar e avaliar o dashboard de forma independente.

---

## Contexto do Projeto

Durante as competições da Equipe Arariboia, é preciso analisar a performance do barco em tempo real para tomada de decisão estratégica. Este aplicativo permite a visualização dos dados através de um dashboard, recebendo os pacotes que chegam via rádio.

Este repositório (**`arari_next`**) é uma evolução do software de telemetria anterior. O objetivo principal desta versão é melhorar a interface e arquitetura geral do software, trazendo um dashboard customizável e novas fontes de dados (WIP).

---

## Funcionalidades Atuais (Versão Estável)

- **Dashboard Modular por Cards:**
  - Grade flexível com suporte a redimensionamento, reordenação e remoção de cards.
  - **4 Tipos de Cards implementados:**
    - **Métrica (`Metric Card`):** Exibe o valor numérico em tempo real de uma métrica selecionada (Ex: Nível de bateria, Tensão, RPM).
    - **Propulsão (`Propulsion Card`):** Visualização focada no estado dos motores (Bombordo/Boreste), com velocímetro, tensões e temperaturas do ESC/Motor.
    - **Bateria (`Battery Card`):** Monitoramento completo do BMS (SoC %, Tensão, Corrente e estimativa de autonomia com/sem geração solar).
    - **Gráfico (`Chart Card`):** Gráficos temporais em tempo real para múltiplas métricas com seleção de intervalo de janela (minutos).

- **Conexão Serial & MAVLink:**
  - Suporte a recepção de dados via porta serial com detecção de portas e configuração de *Baudrate* (padrão `115200`).
  - Parsing de pacotes no protocolo **MAVLink** (dialeto *Arariboat*) convertidos automaticamente para modelos de domínio fortemente tipados.
  - Página de **Configurações** dedicada com controle de conexão e desconexão.

- **Suporte a Temas:**
  - Alternância de temas **Claro / Escuro**.
  - Personalização de cor primária (Seed Color) em tempo real na barra superior.

- **Compatibilidade:**
  - Testado e validado em ambiente **Desktop (Windows)**.

---

## Demonstração

### Visão Geral do Dashboard
<!-- ADICIONE O GIF DA GERAL DO DASHBOARD AQUI -->
![Demonstração do Dashboard](https://via.placeholder.com/800x450?text=GIF+Geral+do+Dashboard)

### Configuração e Customização de Cards
<!-- ADICIONE O GIF REORDENANDO OU CONFIGURANDO CARDS AQUI -->
![Configuração de Cards](https://via.placeholder.com/800x450?text=GIF+Configurando+Cards)

### Conexão Serial e Configurações
<!-- ADICIONE O GIF DA TELA DE CONFIGURAÇÕES CONECTANDO NA PORTA AQUI -->
![Tela de Configurações](https://via.placeholder.com/800x450?text=GIF+Conectando+Serial)

---

## Arquitetura e Tecnologias

O projeto adota a arquitetura **MVVM (Model-View-ViewModel)** para desacoplar a lógica de comunicação, processamento de telemetria e apresentação:

- **`lib/domain/`**: Modelos de domínio limpos (BMS, Motores, GPS, MPPT, Configurações dos Cards e Dashboards).
- **`lib/data/`**: Repositórios (`DashboardRepository`, `PacketRepository`, `SettingsRepository`) e fontes de dados (`ISerialDatasource`, geradores de dados mock para testes).
- **`lib/ui/viewmodels/`**: Gerenciamento de estado das views utilizando `ChangeNotifier` e `ValueNotifier`.
- **`lib/ui/views/` & `lib/ui/core/widgets/`**: Interface de usuário e componentes visuais (gauges, gráficos e grade do dashboard).

### Principais Dependências
- **`flutter_libserialport`**: Comunicação de baixo nível com portas seriais.
- **`dart_mavlink`**: Parser e decodificação de mensagens do protocolo MAVLink.
- **`sliver_dashboard`**: Sistema de grade interativa, reordenação e layouts responsivos para os cards.
- **`geekyants_flutter_gauges`**: Componentes de mostradores radiais e lineares (velocímetros e medidores de bateria).
- **`cristalyse`**: Visualização gráfica para os cards de série temporal.
- **`provider`**: Injeção de dependência e gerenciamento de estado.

---

## 🚀 Como Executar no Windows

### Pré-requisitos
- **Flutter SDK** (`^3.9.0` ou superior)
- **Dart SDK**
- Suporte a desenvolvimento Windows habilitado (`flutter config --enable-windows-desktop`)

### Passos
1. Clone este repositório:
   ```bash
   git clone https://github.com/PCBMoreira0/ArariNext.git
   cd arari_next
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Execute a aplicação no Windows:
   ```bash
   flutter run -d windows
   ```

## Roadmap / Próximas Implementações
O desenvolvimento está ativo. As próximas entregas focam em expandir a conectividade e portabilidade:

- [ ] Novos Tipos de Cards: Adição de cards dedicados a GPS (Mapa/Rastreio), painéis solares (MPPT), bombas e alertas do console.

- [ ] Recepção de Dados via MQTT: Suporte completo ao cliente MQTT para monitoramento remoto sem fio em tempo real.

- [ ] Seleção de fonte de dados via configuração de ambiente (Mock/Serial/MQTT)

- [ ] Refatoração de Camadas: Isolamento extra entre os provedores de fluxo de dados (Serial vs. MQTT) e serviços de log (InfluxDB / CSV local).

- [ ] Suporte Mobile: Adaptação da interface de grade de cards para telas pequenas (Android/iOS).