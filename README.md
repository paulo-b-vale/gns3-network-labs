# Laboratórios de Redes — GNS3

Repositório de laboratórios práticos de redes desenvolvidos durante meu estudo de infraestrutura, cobrindo simulação de ambientes ISP com BGP, OSPF, autenticação PPPoE/RADIUS e monitoramento.

---

## Projetos

### [ISP Edge BGP (FRRouting)](./projetos/isp-edge-bgp/)
Simulação de um provedor de internet (AS64512) com dual-homing BGP, OSPF multi-área e Route Reflector utilizando **FRRouting** 8.2.2 no GNS3. Foco em roteamento open-source.

**Conceitos:** eBGP, iBGP, Route Reflector, OSPF multi-área, local-preference, prefix-list, route-map, dual-homing

---

### [ISP Lab — BGP, OSPF & Zabbix](./projetos/isp-bgp-ospf-zabbix/)
Simulação avançada de ISP com BGP multi-homing e OSPF utilizando **Cisco IOS (Dynamips)**, integrada com monitoramento infraestrutural externo via **Zabbix** rodando em Docker.

**Conceitos:** Cisco IOS, BGP multi-homed, OSPF, Resiliência de Links, Monitoramento SNMP, Zabbix LLD

---

### [ISP Lab — Autenticação PPPoE + RADIUS + MySQL](./projetos/radius-lab/)
Implementação completa da stack AAA que provedores reais utilizam em produção: **FreeRADIUS** com backend **MySQL**, autenticação PPPoE via **MikroTik CHR**, troca de plano ao vivo via CoA e failover automático de servidor RADIUS.

**Conceitos:** FreeRADIUS, PPPoE, AAA, RADIUS VSA, CoA (RFC 5176), SQL backend, MikroTik RouterOS, Docker, Failover

---

## Ferramentas utilizadas

- GNS3 com GNS3 VM (VMware Workstation)
- FRRouting 8.2.2 (QEMU)
- Cisco IOS c3725 (Dynamips)
- MikroTik CHR (RouterOS)
- Ubuntu 22.04 LTS (Cloud Guest)
- FreeRADIUS 3.2.x (Docker)
- MySQL 8.x (Docker)
- Zabbix (Docker)
- Winbox

## Contexto

Material desenvolvido como parte dos meus estudos de infraestrutura e redes, com foco em ambientes ISP e administração de roteadores.
