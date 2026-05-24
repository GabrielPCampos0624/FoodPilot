# FoodPilot

FoodPilot é um aplicativo desenvolvido em Flutter para auxiliar usuários no controle alimentar, acompanhamento de consumo de água, cálculo de meta calórica e organização de alertas personalizados.

## Sobre o projeto

O projeto foi desenvolvido como parte de um Trabalho de Conclusão de Curso em Ciência da Computação.

O objetivo do FoodPilot é oferecer uma solução simples e acessível para apoiar hábitos alimentares mais saudáveis, permitindo que o usuário acompanhe sua rotina nutricional de forma prática.

## Funcionalidades

- Cadastro e login de usuários
- Persistência local dos dados
- Modo claro e modo escuro
- Interface responsiva para Web e Mobile
- Cadastro de informações nutricionais
- Cálculo de meta calórica com a fórmula de Mifflin-St Jeor
- Cálculo de meta diária de água
- Registro de refeições
- Seleção de múltiplos alimentos por refeição
- Cálculo de calorias consumidas
- Controle de saldo calórico diário
- Alertas personalizados
- Notificações locais
- Reset diário de refeições e consumo de água

## Fórmulas utilizadas

### Meta calórica

O cálculo da Taxa Metabólica Basal utiliza a fórmula de Mifflin-St Jeor:

**Homens:**

```txt
(10 × peso) + (6,25 × altura) − (5 × idade) + 5
```

**Mulheres:**

```txt
(10 × peso) + (6,25 × altura) − (5 × idade) − 161
```

Após isso, o resultado é multiplicado pelo fator de atividade física informado pelo usuário.

### Consumo diário de água

```txt
peso corporal × 35 ml
```

O resultado é convertido para litros.

## Tecnologias utilizadas

- Flutter
- Dart
- Local Storage / Shared Preferences
- Flutter Local Notifications
- Git e GitHub

## Plataformas

O projeto foi desenvolvido para funcionar como:

- Aplicação Web
- APK Android

## Como executar o projeto

Clone o repositório:

```bash
git clone https://github.com/GabrielPCampos0624/FoodPilot.git
```

Acesse a pasta:

```bash
cd FoodPilot
```

Instale as dependências:

```bash
flutter pub get
```

Execute no navegador:

```bash
flutter run -d chrome
```

## Gerar versão Web

```bash
flutter build web
```

A versão será criada em:

```txt
build/web
```

## Gerar APK

```bash
flutter build apk --release
```

O APK será gerado em:

```txt
build/app/outputs/flutter-apk/app-release.apk
```

## Observações

Este projeto utiliza persistência local, portanto os dados ficam armazenados no navegador ou dispositivo do usuário.

A versão atual representa um MVP funcional. Futuras melhorias podem incluir:

- Banco de dados em nuvem
- Sincronização entre dispositivos
- Histórico semanal e mensal
- Integração com APIs nutricionais
- Recomendações alimentares inteligentes
- Push notifications com Firebase

## Autor

Gabriel Pereira Campos

## Instituição

Centro Universitário Dom Helder
