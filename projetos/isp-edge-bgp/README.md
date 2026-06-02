# Laboratório ISP Edge BGP — GNS3 + FRRouting

Simulação de uma rede de provedor de internet (ISP) com dual-homing BGP, roteamento interno OSPF multi-área e Route Reflector, utilizando FRRouting 8.2.2 no GNS3.

---

## Visão geral

O laboratório simula um ISP (AS64512) conectado a dois provedores upstream (ISP1 e ISP2) via eBGP, com política de roteamento para preferir o ISP1 como saída primária. Internamente, a rede utiliza OSPF multi-área e iBGP com Route Reflector.

---

## Topologia

```
        ISP1 (AS64501)        ISP2 (AS64502)
        1.1.1.1                2.2.2.2
        198.51.100.1/30        198.51.100.5/30
              |  eBGP                 |  eBGP
        198.51.100.2/30        198.51.100.6/30
              |                      |
             R1 ——————————————————— R2
          10.0.0.1               10.0.0.2
        (Border+RR)           (Border+RR)
               \                  /
                \   iBGP + OSPF  /
                 \              /
                       R3
                    10.0.0.3
                   (Core Router)
                  /            \
           OSPF área 0      OSPF área 1
                /                \
              R4                  R5
           10.10.0.1           10.20.0.1
```

---

## Endereçamento

### Links ponto a ponto (eBGP — upstreams)

| Link | Rede | R1/R2 | ISP1/ISP2 |
|------|------|-------|-----------|
| R1 ↔ ISP1 | 198.51.100.0/30 | .2 | .1 |
| R2 ↔ ISP2 | 198.51.100.4/30 | .6 | .5 |

### Links ponto a ponto (OSPF — core)

| Link | Rede | Interface |
|------|------|-----------|
| R1 ↔ R3 | 192.168.100.0/30 | eth1 / eth0 |
| R2 ↔ R3 | 192.168.100.4/30 | eth1 / eth1 |
| R3 ↔ R4 | 192.168.1.0/30 | eth2 / eth0 |
| R3 ↔ R5 | 192.168.2.0/30 | eth3 / eth0 |

### Loopbacks (router-id e iBGP)

| Roteador | Loopback |
|----------|----------|
| R1 | 10.0.0.1/32 |
| R2 | 10.0.0.2/32 |
| R3 | 10.0.0.3/32 |
| R4 | 10.10.0.1/32 |
| R5 | 10.20.0.1/32 |
| ISP1 | 1.1.1.1/32 |
| ISP2 | 2.2.2.2/32 |

---

## O que foi implementado

### BGP
- eBGP entre R1 e ISP1 (AS64501) e entre R2 e ISP2 (AS64502)
- iBGP full mesh entre R1, R2 e R3 usando loopbacks como update-source
- Route Reflector: R1 e R2 refletem rotas para R3
- Default route recebida de ambos os ISPs via `default-originate`
- Política de local-preference: ISP1 = 150 (primário), ISP2 = 100 (backup)
- Prefix-list `OUR-NETS` filtrando o que é anunciado upstream (apenas redes internas)
- Route-maps de entrada e saída por ISP

### OSPF
- Área 0 (backbone): R1, R2, R3, R4
- Área 1 (stub): R3, R5
- Loopbacks configurados como passivos
- `default-information originate` no R1 para distribuir rota default internamente
- `area 1 range` no R3 para sumarizar a área 1

### Redistribuição
- OSPF redistribuído no BGP nos border routers (R1 e R2)
- Redes internas anunciadas via `network` statement no R3

---

## Decisões de design

**Por que dual-homing com dois ISPs?**
Redundância de uplink — se ISP1 cair, o tráfego migra automaticamente para ISP2 sem intervenção manual.

**Por que local-preference 150 no ISP1 e 100 no ISP2?**
Define ISP1 como saída primária. Quanto maior o local-preference, mais preferida a rota. ISP2 entra automaticamente como backup.

**Por que Route Reflector em vez de iBGP full mesh?**
Em redes maiores, full mesh iBGP escala mal — N roteadores exigem N*(N-1)/2 sessões. O RR centraliza a reflexão de rotas, reduzindo complexidade.

**Por que OSPF multi-área?**
R5 fica em área 1 isolada do backbone. R3 sumariza a área 1 com `area 1 range`, reduzindo o tamanho da tabela de rotas no core.

**Por que R4 e R5 não rodam BGP?**
Simulam redes de cliente/filial — só precisam de alcançabilidade interna via OSPF. BGP seria overhead desnecessário nessa camada.

---

## Pré-requisitos

- [GNS3](https://www.gns3.com/software/download) instalado (versão 2.2+)
- GNS3 VM configurada (recomendado para rodar appliances QEMU)
- Appliance **FRRouting** importado via GNS3 Marketplace

---

## Setup do laboratório

### 1. Instalar o GNS3 e a GNS3 VM

Baixe o instalador no [site oficial do GNS3](https://www.gns3.com/software/download). Durante a instalação, o assistente oferece a opção de baixar a GNS3 VM para VMware ou VirtualBox — use a VM para rodar appliances QEMU como o FRR.

### 2. Importar o appliance FRRouting

1. No GNS3, vá em **File → New Template**.
2. Selecione **Install an appliance from the GNS3 server (recommended)**.
3. Pesquise por **FRRouting** na lista.
4. Selecione a versão **8.2.2** e clique em **Install**.
5. Escolha **GNS3 VM** como destino de instalação.
6. Aguarde o download do arquivo `frr-8.2.2.qcow2`.

### 3. Criar o projeto

1. **File → New blank project** → nome: `ISP_Edge_BGP`.
2. Arraste 7 instâncias do appliance FRRouting para o canvas.
3. Renomeie os nós: ISP1, ISP2, R1, R2, R3, R4, R5.

### 4. Conectar os nós

Conecte as interfaces conforme a tabela abaixo (clique no ícone de cabo no GNS3):

| De | Interface | Para | Interface |
|----|-----------|------|-----------|
| ISP1 | eth0 | R1 | eth0 |
| ISP2 | eth0 | R2 | eth0 |
| R1 | eth1 | R3 | eth0 |
| R2 | eth1 | R3 | eth1 |
| R3 | eth2 | R4 | eth0 |
| R3 | eth3 | R5 | eth0 |

### 5. Aplicar as configurações

1. Inicie todos os nós (**Start all nodes** ▶).
2. Aguarde o boot (cerca de 30 segundos).
3. Acesse o console de cada roteador (botão direito → Console).
4. Entre no shell FRR com `vtysh`.
5. Cole o conteúdo do arquivo `.conf` correspondente da pasta `configs/`.

Exemplo para o R1:
```bash
vtysh
# cole o conteúdo de configs/R1.conf
```

### 6. Verificar a topologia

Após aplicar todas as configs, verifique:

```bash
# Verificar vizinhos BGP
show bgp summary

# Verificar tabela de rotas BGP
show bgp ipv4 unicast

# Verificar adjacências OSPF
show ip ospf neighbor

# Verificar tabela de rotas completa
show ip route
```

---

## Credenciais dos nós

| Campo | Valor |
|-------|-------|
| Usuário | `root` |
| Senha | `root` |
| Shell FRR | `vtysh` |

---

## Referências

- [FRRouting Documentation](https://docs.frrouting.org/)
- [GNS3 Documentation](https://docs.gns3.com/)
- [RFC 4271 — BGP-4](https://www.rfc-editor.org/rfc/rfc4271)
- [RFC 2328 — OSPF Version 2](https://www.rfc-editor.org/rfc/rfc2328)
