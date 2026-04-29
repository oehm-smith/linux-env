# Network Replacement Plan: ASUS Mesh → OpenWrt/OPNsense

**Date:** 2026-04-28
**Status:** Future project — planning phase
**Context:** Discussed with Claude Chat after reviewing ASUS AiProtection privacy concerns (Trend Micro telemetry)

---

## Motivation

ASUS AiProtection sends traffic metadata to Trend Micro. The goal is to replicate (and exceed) its security features with open-source tools that keep all data local.

## Feature-by-Feature Replacement

### Malicious Sites Blocking → AdGuard Home / Pi-hole

DNS-level blocking of known-bad domains (malware, phishing, C2, scams, ads, trackers).

**Recommended:** AdGuard Home (modern, actively developed).

- Runs on Raspberry Pi, Synology Docker, OpenWrt package, or OPNsense plugin
- Tiny resource footprint
- Per-device rules possible
- Dashboard showing every DNS query by every device

**Key blocklists to subscribe to:**

| List | Purpose |
|------|---------|
| OISD Big | Best malware/phishing list (replaces AiProtection's malicious site DB) |
| StevenBlack unified | Broad ads/malware |
| Hagezi multi pro | Comprehensive ads/trackers/malware |
| Phishing Army | Phishing-specific |
| NoCoin | Cryptominer scripts |
| PiHole-Anti-Telemetry | Microsoft/Apple/etc. telemetry endpoints |

### Two-Way IPS → Suricata / Snort / Zenarmor

Deep packet inspection using known exploit signatures, malware C2 traffic patterns.

**Recommended:** Suricata (modern, built into OPNsense as a one-click plugin).

- Match traffic against signature databases (Emerging Threats, ET Pro)
- Block in real-time (IPS mode) or alert-only (IDS mode)
- All logs stay local
- Zenarmor is a commercial-but-free-tier alternative for OPNsense (very polished)

**Threat feeds:** Free Emerging Threats feed is good. Paid ET Pro for commercial-grade rules.

### Infected Device Prevention → Suricata + DNS + Outbound Blocklists

Combination of:
- DNS-level blocking (catches C2 domains before connection)
- Suricata (catches IP-based C2 traffic that bypasses DNS)
- Threat feeds (FireHOL, Spamhaus DROP, AbuseIPDB) as firewall aliases

OPNsense "Aliases" feature auto-updates from threat feeds, then firewall rules deny outbound to those IPs.

**Bonus:** geographical filtering ("alert if any device connects to unexpected country") — AiProtection doesn't offer this.

### HTTPS Scanning → Skip It

Modern HTTPS + HSTS + cert pinning handles this. DNS-level + IP-level blocking is the privacy-preserving approach. TLS interception at home isn't worth the complexity.

### Router Security Assessment → Built-in

OPNsense has built-in security audit features. For additional scanning: lynis (system audit), nmap (external port scan), OpenSCAP (compliance).

## Architecture Comparison

**Current (ASUS AiProtection):**
```
Traffic → ASUS router → Trend Micro cloud (telemetry) → Internet
```

**Replacement (OpenWrt/OPNsense):**
```
Traffic → Your router
           ├── AdGuard Home (DNS, local logs)
           ├── Suricata IDS/IPS (local rules + logs)
           ├── Firewall (your rules)
           ├── Threat feeds (pulled locally)
           └── Optional: Grafana/Loki/Graylog for log aggregation
         → Internet
```

## Recommended Hardware Stack

```
Modem (bridge mode)
  │
  └── OPNsense box (Protectli VP2410 or mini-PC, $200-400)
       │ Running: PPPoE, Suricata IPS, WireGuard, VLANs, firewall
       │
       └── Managed switch (TP-Link TL-SG2008P PoE, ~$120)
            │ VLANs trunked
            │
            └── APs (UniFi U6-Lite x 2-3, ~$100 each)
                 Or: GL.iNet Flint or similar

       └── Raspberry Pi 5 with PoE hat (~$120)
            │ Running: AdGuard Home
            │ Optional: Home Assistant, Uptime Kuma
```

**Total cost:** ~$700-1000. Lasts a decade (no vendor obsolescence).

**Hardware alternatives:**
- Protectli — purpose-built mini-PCs, popular in community
- Used mini-PCs (Lenovo M720q, Dell Wyse 5070) + 2x NIC card — $100-200
- Mikrotik — CLI-driven, unique but powerful OS

## Capability Comparison

| Capability | AiProtection | OpenWrt/OPNsense |
|-----------|--------------|------------------|
| Block malware domains | Yes (Trend Micro list) | Yes (community lists, broader) |
| Block phishing | Yes | Yes |
| Block ads/trackers | No | Yes |
| IDS/IPS exploit detection | Yes | Yes (ET Open or paid) |
| Botnet/C2 detection | Yes | Yes |
| Per-device rules | Limited | Comprehensive |
| Dashboards/visibility | Basic | Excellent |
| Custom rules | No | Yes |
| Time-based rules | Yes | Yes (more flexible) |
| Geographical blocking | No | Yes (GeoIP) |
| VPN integration | Limited | First-class WireGuard |
| Vendor telemetry | Yes | None |
| Data ownership | Vendor | Yours |
| Auditability | Closed-box | Fully open |

## Quick Win: AdGuard Home on Synology (No Hardware Needed)

Can start today without buying anything:

1. Install AdGuard Home in Docker on Synology NAS
2. Configure ASUS to point clients at NAS for DNS
3. AdGuard forwards upstream to Cloudflare DoT
4. Get DNS-blocking layer without Trend Micro
5. Bonus: ad blocking, tracker blocking, per-device rules, full query visibility

**Effort:** One evening. Replicates ~70% of AiProtection's value with full privacy. AdGuard config migrates easily to future OPNsense build.

## Revisit List (Priority Order)

1. ~~Save ASUS settings~~ ✓ Done 2026-04-28 → `home-nas.local/backup/ASUS-ZenWifi-router/`
2. VDSL modem audit
3. VPN Server (WireGuard)
4. Guest Room Ethernet cable replacement
5. Investigate first guest network's original issues
6. Consolidate guest networks
7. Re-add devices to right networks
8. **Quick win: AdGuard Home on Synology**
9. **Future: full OpenWrt/OPNsense rebuild**

## Reading Recommendations

- **OPNsense documentation** — comprehensive, well-written
- **Lawrence Systems YouTube** — practical content
- **AdGuard Home docs** — clear setup guides
- **Suricata Quickstart** — for IPS setup
- **r/homelab and r/HomeNetworking** — active communities

---

**Last Updated:** 2026-04-28
