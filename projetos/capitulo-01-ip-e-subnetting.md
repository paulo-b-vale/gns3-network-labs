# Capítulo 1 — Endereçamento IP e Subnetting

**Guia de Estudo MikroTik RouterOS · CHR no GNS3**  
Laboratório prático · Nível fundacional

---

## Passo 1 — Montagem da Topologia no GNS3

**Objetivo:** Criar um laboratório com dois roteadores CHR conectados back-to-back para atribuir IPs e testar conectividade em um link ponto a ponto.

### Topologia

```
── Rede de Gerenciamento (acesso Winbox) ──
CHR-R1 (ether1) ↔ Switch1 ↔ (ether1) CHR-R2 · · · Cloud1

── Rede de Laboratório (link ponto a ponto) ──
CHR-R1 (ether2) ———————————————— (ether2) CHR-R2
```

> `ether1` → Switch1 → Cloud1: ponte entre os roteadores e o host (Winbox).  
> `ether2`: link isolado de laboratório onde os IPs /30 são atribuídos.

### Passo a passo no GNS3

1. Abra o GNS3 e crie um **New Project** (ex: `ch1-subnetting`).
2. Arraste **dois appliances CHR QEMU** para o canvas. Nomeie como `R1` e `R2`.
3. Adicione um nó **Switch** (Switch1) e um nó **Cloud** (Cloud1). Conecte Cloud1 ao Switch1.
4. Conecte R1 `ether1` → Switch1, e R2 `ether1` → Switch1. Esta é a **rede de gerenciamento** — permite acesso Winbox do host a ambos os roteadores.
5. Desenhe o link de laboratório: R1 `ether2` → R2 `ether2`. Este é o **link ponto a ponto** onde os IPs /30 serão atribuídos.
6. Clique em **Start all nodes** (botão verde ▶).

> **Dica:** Após os roteadores iniciarem, abra Winbox → aba Neighbors. R1 aparece pelo endereço MAC — conecte antes de qualquer IP ser configurado.

> **Primeiro boot:** Credenciais padrão são `admin` / senha vazia. Pressione Enter quando solicitado.

---

## Passo 2 — Teoria de Subnetting

**Objetivo:** Dividir o bloco `10.0.0.0/24` em 4 sub-redes iguais manualmente.

### Fórmula principal

```
Hosts utilizáveis por sub-rede = 2^(32 − prefixo) − 2
```

### As quatro sub-redes de 10.0.0.0/24 (divididas em /26)

| Sub-rede | Rede        | Primeiro utilizável | Último utilizável | Broadcast    | Hosts |
|----------|-------------|---------------------|-------------------|--------------|-------|
| /26 #1   | 10.0.0.0    | 10.0.0.1            | 10.0.0.62         | 10.0.0.63    | 62    |
| /26 #2   | 10.0.0.64   | 10.0.0.65           | 10.0.0.126        | 10.0.0.127   | 62    |
| /26 #3   | 10.0.0.128  | 10.0.0.129          | 10.0.0.190        | 10.0.0.191   | 62    |
| /26 #4   | 10.0.0.192  | 10.0.0.193          | 10.0.0.254        | 10.0.0.255   | 62    |

### Links ponto a ponto

Para o link back-to-back entre R1 e R2, utiliza-se um **/30** — fornece exatamente **2 hosts utilizáveis**, um para cada extremidade. Sem desperdício de IPs.

```
/30 — ponto a ponto
2^(32−30) − 2 = 4 − 2 = 2 hosts
```

> **Lembrete:** Faixas privadas mais usadas: `10.x.x.x` (Classe A), `172.16.x.x–172.31.x.x` (Classe B), `192.168.x.x` (Classe C). Não roteáveis na internet pública.

---

## Passo 3 — Atribuição de IPs via CLI (Terminal RouterOS)

**Objetivo:** Atribuir `192.168.1.1/30` ao R1 e `192.168.1.2/30` ao R2 na interface `ether2`.

### No R1 — Terminal GNS3 ou Winbox

```routeros
# Atribuir IP à interface do link de laboratório (ether2)
/ip address add address=192.168.1.1/30 interface=ether2

# Verificar se foi aplicado
/ip address print
```

### No R2 — Segundo terminal

```routeros
# Atribuir o outro extremo do /30
/ip address add address=192.168.1.2/30 interface=ether2

/ip address print
```

### Saída esperada

```
Flags: D - Dynamic, X - Disabled, I - Invalid, H - DHCP

 #   ADDRESS            NETWORK         INTERFACE
 0   192.168.1.1/30    192.168.1.0     ether2
```

> **Verificação /30:** Rede = 192.168.1.0 · Broadcast = 192.168.1.3 · Utilizáveis = .1 e .2 apenas. Não há espaço para um terceiro host — esse é o propósito do /30.

---

## Passo 4 — Atribuição de IPs via Winbox (GUI)

**Objetivo:** Usar o Winbox para adicionar endereços IP — o método gráfico que todo administrador MikroTik deve conhecer.

### Passos no Winbox

1. Conecte o Winbox ao R1 (aba Neighbors → endereço MAC).
2. No menu lateral, vá em **IP** → **Addresses**.
3. Clique no botão azul **+** para abrir o diálogo de adição.
4. Preencha:
   - **Address:** `192.168.1.1/30`
   - **Interface:** `ether2`
5. Clique em **OK**. O endereço aparece na lista com indicador verde.
6. Repita para o R2 com o endereço `192.168.1.2/30` na `ether2`.

> **Dica:** Segure `Ctrl` e clique em qualquer item do menu para abrir em janela flutuante. Você pode ter **IP → Addresses** e **Tools → Ping** abertas ao mesmo tempo.

### Verificação no Winbox

A janela Addresses exibe cada IP, sua rede e qual interface está associada. Ponto verde = interface ativa. Se estiver cinza, verifique o cabo no GNS3.

> **Atenção:** O Winbox preenche o campo Network automaticamente — não altere. O RouterOS calcula o endereço de rede a partir do prefixo fornecido.

---

## Passo 5 — Verificação de Conectividade com Ping

**Objetivo:** Fazer ping pelo link /30 de R1 para R2 e vice-versa. Um ping bem-sucedido confirma atribuição correta de IP e que o GNS3 está encaminhando os frames.

### Ping via CLI

```routeros
# Pingar R2 a partir do R1 — aguardar respostas
/tool ping 192.168.1.2 count=4
```

### Saída esperada

```
  SEQ HOST            SIZE TTL TIME  STATUS
    0 192.168.1.2       56  64 1ms  echo reply
    1 192.168.1.2       56  64 1ms  echo reply
    2 192.168.1.2       56  64 1ms  echo reply
    3 192.168.1.2       56  64 1ms  echo reply

  sent=4 received=4 packet-loss=0%
```

### Ping via Winbox

1. Vá em **Tools** → **Ping**.
2. Insira `192.168.1.2` no campo Ping To.
3. Clique em **Start** — observe o contador de respostas subir.

### Troubleshooting

| Problema | Causa provável |
|----------|---------------|
| 100% de perda | Verifique se o link GNS3 está desenhado entre `ether2` de ambos os roteadores e se os nós estão rodando |
| Interface errada | Execute `/ip address print` — o IP /30 deve estar na `ether2`, não na `ether1` |
| /30 incompatível | Ambos os lados devem estar no mesmo bloco /30. `192.168.1.1` e `192.168.1.5` estão em /30 diferentes |

---

## Passo 6 — Checklist de Conclusão

**Objetivo:** Confirmar que todos os objetivos do capítulo foram cumpridos.

- [ ] Subdividir `10.0.0.0/24` em quatro sub-redes /26 no papel — anotar rede, broadcast e primeiro/último utilizável de cada.
- [ ] Atribuir IPs a ambas as interfaces (R1 = `192.168.1.1/30`, R2 = `192.168.1.2/30`) via CLI e Winbox.
- [ ] Verificar conectividade com `/tool ping` bem-sucedido — 0% de perda em ambas as direções.
- [ ] Identificar o broadcast e o gateway de cada uma das quatro sub-redes /26.
- [ ] Salvar um snapshot GNS3 da topologia completa para usar como base no Capítulo 2.

---

## Referência rápida — Comandos CLI do Capítulo 1

```routeros
/ip address add address=X.X.X.X/YY interface=etherN
/ip address print
/ip address remove [numbers=N]
/tool ping X.X.X.X count=N
/interface print    # listar todas as interfaces
```

---

> **Próximo capítulo:** Capítulo 2 — RouterOS Basics: identidade do roteador, gerenciamento de usuários e criação de backups. A topologia deste laboratório é o ponto de partida ideal.
