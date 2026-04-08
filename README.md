# AntiToxicChat (AMX Mod X Plugin)

## 📌 Descrição

O **AntiToxicChat** é um plugin para servidores de Counter-Strike 1.6 (AMX Mod X) que tem como objetivo reduzir toxicidade no chat, bloqueando palavras ofensivas e aplicando punições progressivas aos jogadores.

---

## ⚙️ Funcionalidades

* 🔍 Detecção automática de palavras ofensivas
* 📄 Lista de palavras configurável (badwords.ini)
* ⚠️ Sistema de avisos progressivos
* 👢 Kick automático após atingir o limite
* 📢 Aviso global quando um jogador é punido
* 🔄 Reset de infrações ao sair

---

## 📁 Estrutura de arquivos

```
addons/amxmodx/configs/antitoxic/badwords.ini
```

* Arquivo contendo palavras proibidas
* Uma palavra por linha
* Criado automaticamente caso não exista

---

## 🧠 Funcionamento

### 1. Carregamento de palavras

O plugin lê o arquivo `badwords.ini` e armazena todas as palavras proibidas em memória.

### 2. Interceptação do chat

Monitora os comandos:

* `say`
* `say_team`

### 3. Verificação de conteúdo

* Converte a mensagem para minúsculo
* Verifica se contém alguma palavra proibida

---

## ⚠️ Sistema de punição

### Limite padrão

```
#define MAX_WARNINGS 3
```

### Fluxo

1. Primeira infração → Aviso
2. Segunda infração → Aviso
3. Terceira infração → Kick

---

## 💬 Mensagens padrão

### Aviso

```
[AVISO 1/3] Evite linguagem ofensiva!
```

### Aviso público

```
[ANTI-TOXICO] Jogador foi advertido por mensagem inapropriada
```

### Kick

```
Você foi kickado por linguagem ofensiva
```

### Entrada no servidor

```
[ANTI-TOXICO] Chat monitorado: Evite xingamentos e racismo!
```

---

## 🔄 Comportamento adicional

* Infrações são resetadas ao sair do servidor
* Não há armazenamento persistente

---

## ⚠️ Limitações

* ❌ Não detecta variações (ex: v1ado, v!ado)
* ❌ Não usa regex
* ❌ Pode detectar palavras parcialmente (falsos positivos)
* ❌ Não aplica ban (apenas kick)

