# Laboratórios de Redes — GNS3

Repositório de laboratórios práticos de redes desenvolvidos durante meu estudo de infraestrutura, cobrindo desde fundamentos de endereçamento IP até simulação de ambiente ISP com BGP e OSPF.

---

## Projetos

### [ISP Edge BGP](./isp-edge-bgp/)
Simulação de um provedor de internet (AS64512) com dual-homing BGP, OSPF multi-área e Route Reflector utilizando FRRouting 8.2.2 no GNS3.

**Conceitos:** eBGP, iBGP, Route Reflector, OSPF multi-área, local-preference, prefix-list, route-map, dual-homing

---

### [Capítulo 1 — Endereçamento IP e Subnetting](./capitulo-01-ip-e-subnetting.md)
Laboratório fundacional de subnetting e configuração de interfaces com MikroTik CHR no GNS3.

**Conceitos:** CIDR, VLSM, /30 ponto a ponto, RouterOS CLI, Winbox

---

## Ferramentas utilizadas

- GNS3 2.2+
- FRRouting 8.2.2 (QEMU)
- MikroTik CHR (QEMU)
- Winbox

## Contexto

Material desenvolvido como parte dos meus estudos de infraestrutura e redes, com foco em ambientes ISP e administração de roteadores.
