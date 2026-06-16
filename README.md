# axau15-fh1223

Firmware per la scheda **AXAU15** con scheda FMC **FH1223** che implementa:

- Ricezione dati da un dispositivo esterno via **Aurora 64B/66B** (SFP su FH1223)
- Memorizzazione dei dati in una **BRAM** capiente on-chip
- Controllo e readout via **IPBus over Ethernet**

## Architettura

```
Dispositivo esterno
       │  Aurora 64B/66B (SFP su FH1223/FMC)
       ▼
  Aurora RX core
       │  AXI4-Stream
       ▼
  BRAM (acquisizione dati)
       │
       ▼
  IPBus fabric  ◄──── Ethernet (1 GbE onboard)
    ├─ acq_ctrl slave    (avvio/stop acquisizione, stato)
    ├─ remote_ctrl slave (configurazione dispositivo remoto via Aurora TX)
    └─ bram_readout      (dump dati BRAM → rete)
```

## Flusso dati

| Direzione | Percorso |
|-----------|----------|
| Ingresso dati | Dispositivo esterno → Aurora RX → BRAM |
| Controllo acquisizione | Host → Ethernet → IPBus → `acq_ctrl` |
| Configurazione remota | Host → Ethernet → IPBus → `remote_ctrl` → Aurora TX → Dispositivo esterno |
| Readout | Host → Ethernet → IPBus → `bram_readout` → BRAM → Ethernet → Host |

## Repository layout

```
rtl/
  (TODO — in attesa documentazione schede)
constraints/
  (TODO — pin/timing XDC)
scripts/
  (TODO — script Tcl Vivado)
notebooks/
  (TODO — notebook controllo/monitoraggio)
doc/
  (documentazione schede: AXAU15, FH1223)
```

## Stato

- [ ] Documentazione schede acquisita
- [ ] Constraints XDC (FMC pinout SFP+, clock, Ethernet)
- [ ] Aurora RX core + CDC verso BRAM
- [ ] BRAM controller (write side Aurora, read side IPBus)
- [ ] IPBus over Ethernet stack (MAC + UDP engine + fabric)
- [ ] `acq_ctrl` slave IPBus
- [ ] `remote_ctrl` slave IPBus (config dispositivo remoto)
- [ ] `bram_readout` slave IPBus
- [ ] Top-level HDL
- [ ] Script Vivado Tcl
