# Netmaker Netclient – Home Assistant Add-on

Dieses Add-on verbindet deinen Home Assistant über einen
[Netmaker](https://www.netmaker.io/) WireGuard-Tunnel mit deinem
privaten Overlay-Netzwerk.

## Installation

1. Kopiere diesen Ordner (`netclient-addon/`) in dein
   **lokales Add-on-Repository** unter
   `/addons/netmaker-netclient/` auf deinem HA-Host.  
   Alternativ: Erstelle ein eigenes Git-Repository und füge es
   in **Einstellungen → Add-ons → Add-on-Store → Repositories** hinzu.

2. Gehe zu **Einstellungen → Add-ons → Add-on-Store** und klicke
   auf das Reload-Symbol (↻) oben rechts.

3. Das Add-on „Netmaker Netclient" erscheint nun unter
   **Lokale Add-ons**. Klicke auf **Installieren**.

## Konfiguration

| Option       | Pflicht | Beschreibung                                          |
|-------------|---------|-------------------------------------------------------|
| `token`     | **Ja**  | Enrollment-Token aus der Netmaker-UI (Access Keys)    |
| `hostname`  | Nein    | Hostname für diesen Node (Standard: `homeassistant`)  |
| `endpoint`  | Nein    | Öffentliche IP/Domain, falls hinter NAT               |
| `port`      | Nein    | WireGuard-Port (0 = automatisch)                      |
| `mtu`       | Nein    | MTU-Wert (0 = automatisch)                            |
| `is_static` | Nein    | Statischer Endpunkt (true/false)                      |
| `verbosity` | Nein    | Log-Level 0–4 (0 = minimal, 4 = debug)                |

### Beispiel

```yaml
token: "eyJhcGlzZXJ2ZXIiOiJhcGkubmV0bWFrZX..."
hostname: "ha-wohnzimmer"
verbosity: 1
```

## Hinweise

- Das Add-on läuft im **privilegierten Modus** mit Host-Netzwerk,
  da es WireGuard-Interfaces auf dem Host erstellt.
- Die Netclient-Konfiguration wird persistent unter
  `/config/netclient/` gespeichert und überlebt Neustarts.
- Logs findest du im Add-on-Log-Tab der HA-Oberfläche.

## Deinstallation

Beim Entfernen des Add-ons bleibt der Ordner
`/config/netclient/` erhalten. Falls du die Konfiguration
vollständig entfernen möchtest, lösche diesen Ordner manuell.
