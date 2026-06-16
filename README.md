# axau15-fh1223

Firmware per la scheda **AXAU15** (XCAU15P-2FFVB676, Artix UltraScale+) con FMC card **FH1223**:
- Ricezione dati da un dispositivo esterno via **Aurora 64B/66B 6.25 Gbps** (SFP1 su FH1223)
- Memorizzazione in **BRAM** on-chip (dimensione configurabile, default 64 KB)
- Controllo e readout via **IPBus over RGMII Ethernet** (RTL8211F/JL2121 su AXAU15)

## Architettura

```
Dispositivo esterno
  │  Aurora 64B/66B  6.25 Gbps
  │  SFP1 (FH1223, FMC_DP0, Bank 224 lane 0)
  ▼
aurora_64b66b_0 (Vivado IP)     ← refclk 156.25 MHz (core board MGTREFCLK0_225)
  │  AXI4-Stream 64-bit
  ▼
aurora_rx_path  ──────────────►  bram_ctrl (xpm_memory_tdpram)
                                     │
aurora_tx_path  ◄── remote_ctrl ◄────┤
                                     ▼
                               IPBus fabric
                                 ├─ acq_ctrl      0x0000_xxxx
                                 ├─ remote_ctrl   0x0001_xxxx
                                 └─ bram_readout  0x1000_xxxx
                                     │
                               axau15_infra
                                 (RGMII MAC + clocks + IPBus UDP)
                                     │
                               RTL8211F/JL2121 ── RJ45 Ethernet
```

## IPBus address map

| Base (word addr) | Slave | Descrizione |
|-----------------|-------|-------------|
| `0x00000000` | `acq_ctrl` | start/stop acquisizione, status, contatore parole |
| `0x00010000` | `remote_ctrl` | FIFO → Aurora TX (config dispositivo remoto) |
| `0x10000000` | `bram_readout` | lettura diretta BRAM dati (fino a 16 K parole) |

### acq_ctrl registers (offset in parole)
| Offset | Nome | Accesso | Descrizione |
|--------|------|---------|-------------|
| 0 | CTRL | W | bit[0]=start, bit[1]=stop |
| 1 | STATUS | R | bit[0]=chan_up, bit[1]=acq_running |
| 2 | WORDS | R | parole scritte (free-running) |

### remote_ctrl registers
| Offset | Nome | Accesso | Descrizione |
|--------|------|---------|-------------|
| 0 | DATA_LO | W | byte bassi parola 64-bit |
| 1 | DATA_HI | W | byte alti — scrittura trigger push FIFO |
| 2 | STATUS | R | bit[0]=fifo_full, bit[1]=fifo_empty |

## Repository layout

```
rtl/
  top_axau15.vhd              Top-level entity
  axau15_infra.vhd            Clocks + RGMII MAC + IPBus UDP
  clocks_us_serdes_rgmii.vhd  MMCM: 200→31.25/40/125/200 MHz
  eth_axau15_rgmii.vhd        Wrapper TEMAC (RGMII, PHY addr=001)
  payload.vhd                 Aurora + BRAM + slave IPBus
  ipbus_decode_payload.vhd    Address decoder fabric
  aurora_rx_path.vhd          AXI-S 64-bit → BRAM write
  bram_ctrl.vhd               Dual-port BRAM (xpm_memory_tdpram)
  acq_ctrl_slave.vhd          IPBus slave: acquisizione
  remote_ctrl_slave.vhd       IPBus slave: config remota (FIFO→Aurora TX)
  bram_readout_slave.vhd      IPBus slave: dump BRAM → rete
constraints/
  top_axau15.xdc              Constraints template (TODO: ball numbers)
doc/
  Schematic_CARRIER_ACAU15.pdf
  Schematic_CORE_ACAU15.pdf
  FH1223原理图.pdf
  Alinx_IPBUS_RAME_HTG_daSMA_MGT_156MC_ok.xpr.zip  (reference design)
```

## Vivado IP da generare

| IP | Nome | Configurazione chiave |
|----|------|-----------------------|
| Tri-Mode Ethernet MAC | `temac_gbe_v9_0` | RGMII, 1G, MDIO on, shared logic in core |
| Aurora 64B/66B | `aurora_64b66b_0` | 6.25 Gbps, refclk 156.25 MHz, 64-bit user, GT=GTHE4_X0Y0 |

## Dipendenze ipbus-firmware (CERN, Apache 2.0)

```
components/ipbus_core/firmware/hdl/       ipbus_package, fabric, transactor
components/ipbus_transport_udp/firmware/hdl/  UDP/IP stack
components/ipbus_util/firmware/hdl/       ipbus_ctrl, led_stretcher, clock_div
components/ipbus_slaves/firmware/hdl/     (opzionale: ipbus_ram, ipbus_reg_v)
```

## TODO prima della sintesi

- [ ] Leggere i numeri di ball dai PDF schematici e riempire i TODO in `top_axau15.xdc`
  - SYS_CLK_P/N (Core p.3, Bank 65)
  - PHY_* RGMII signals (Core p.5 Bank 84, Carrier p.3)
  - LED0/1 (Carrier p.9)
- [ ] Generare i due IP Vivado (TEMAC + Aurora)
- [ ] Clonare ipbus-firmware e aggiungere le sorgenti al progetto
- [ ] Script Tcl `scripts/create_project.tcl`
- [ ] Notebook `notebooks/axau15_control.ipynb`

## Stato

- [x] Tutti i moduli RTL scritti
- [x] XDC template con logic constraints
- [ ] Ball numbers nei TODO dell'XDC
- [ ] IP Vivado generati
- [ ] Prima sintesi
