# axau15-fh1223

Firmware per la scheda **AXAU15** (XCAU15P-2FFVB676, Artix UltraScale+) con FMC card **FH1223**:
- Ricezione dati da un dispositivo esterno via **Aurora 64B/66B 6.25 Gbps** (SFP1 su FH1223)
- Memorizzazione in **BRAM** on-chip (16 K parole × 32 bit = 64 KB)
- Controllo e readout via **IPBus over RGMII Ethernet** (RTL8211F/JL2121 su AXAU15)

## Architettura

```
Dispositivo esterno
  │  Aurora 64B/66B  6.25 Gbps
  │  SFP1 (FH1223 FMC_DP0, Bank 225 lane 0 = GTHE4_CHANNEL_X0Y4)
  ▼
aurora_64b66b_0 (Vivado IP)     ← refclk 156.25 MHz (MGTREFCLK0_225)
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
                                 (RGMII MAC + MMCM + IPBus UDP)
                                     │
                               RTL8211F/JL2121 ── RJ45 Ethernet
```

**Board**: IP=`192.168.200.1`, UDP port=`50001`, MAC=`02:0d:db:a1:15:20`

## IPBus address map

| Word addr | Slave | Descrizione |
|-----------|-------|-------------|
| `0x00000000` | `acq_ctrl` | start/stop acquisizione, status, contatore parole |
| `0x00000100` | `remote_ctrl` | FIFO → Aurora TX (config dispositivo remoto) |
| `0x00001000` | `bram_readout` | lettura diretta BRAM dati (16 K parole) |

### acq_ctrl (base 0x00000000)
| Offset | Nome | Accesso | Descrizione |
|--------|------|---------|-------------|
| 0 | CTRL | W | bit[0]=start, bit[1]=stop |
| 1 | STATUS | R | bit[0]=chan_up, bit[1]=acq_running |
| 2 | WORDS | R | parole scritte (free-running) |

### remote_ctrl (base 0x00000100)
| Offset | Nome | Accesso | Descrizione |
|--------|------|---------|-------------|
| 0 | DATA_LO | W | byte bassi parola 64-bit |
| 1 | DATA_HI | W | byte alti — scrittura trigger push FIFO |
| 2 | STATUS | R | bit[0]=fifo_full, bit[1]=fifo_empty |

### bram_readout (base 0x00001000)
| Offset | Nome | Accesso | Descrizione |
|--------|------|---------|-------------|
| 0..16383 | BRAM[i] | R | dato acquisito i-esimo (32 bit) |

## Repository layout

```
rtl/
  top_axau15.vhd              Top-level entity
  axau15_infra.vhd            Clocks + RGMII MAC + IPBus UDP
  clocks_us_serdes_rgmii.vhd  MMCM: 200→31.25/40/125/200/333 MHz
  eth_axau15_rgmii.vhd        Wrapper TEMAC (RGMII, PHY addr=001)
  payload.vhd                 Aurora + BRAM + slave IPBus
  ipbus_decode_payload.vhd    Address decoder fabric
  aurora_rx_path.vhd          AXI-S 64-bit → BRAM write
  bram_ctrl.vhd               Dual-port BRAM (xpm_memory_tdpram)
  acq_ctrl_slave.vhd          IPBus slave: acquisizione
  remote_ctrl_slave.vhd       IPBus slave: config remota (FIFO→Aurora TX)
  bram_readout_slave.vhd      IPBus slave: dump BRAM → rete
constraints/
  top_axau15.xdc              Constraints completi (pin + timing)
scripts/
  create_project.tcl          Crea il progetto Vivado da zero
  run_synth.tcl               Lancia sintesi batch
  run_impl.tcl                Lancia P&R + bitstream batch
  run_sim.tcl                 Lancia simulazione XSim
sim/
  tb_payload.vhd              Testbench per payload (senza Aurora/TEMAC IP)
notebooks/
  axau15_control.ipynb        Notebook Jupyter di controllo (raw IPBus/UDP)
doc/
  Schematic_CARRIER_ACAU15.pdf
  Schematic_CORE_ACAU15.pdf
  FH1223原理图.pdf
```

## Vivado IP

| IP | Nome istanza | Configurazione chiave |
|----|-------------|-----------------------|
| Tri-Mode Ethernet MAC | `temac_gbe_v9_0` | RGMII, 1G, shared logic in core, MDIO on, refclk=333 MHz |
| Aurora 64B/66B | `aurora_64b66b_0` | 6.25 Gbps, refclk=156.25 MHz, 64-bit user, GT=GTHE4_CHANNEL_X0Y4 |

## Dipendenze

**ipbus-firmware** (CERN, Apache 2.0):
```
components/ipbus_core/firmware/hdl/
components/ipbus_transport_udp/firmware/hdl/
components/ipbus_util/firmware/hdl/
```

**Notebook**: `numpy`, `matplotlib` — IPBus via UDP raw senza `uhal`.

## Stato

- [x] RTL completo
- [x] Constraints XDC completi (pin assignment + clock groups + false path)
- [x] IP Vivado configurati (TEMAC + Aurora)
- [x] Sintesi: PASS — 10.75% LUT, 5.57% FF, 22% BRAM
- [x] Implementazione: PASS — WNS=+0.027 ns, WHS=+0.011 ns
- [x] Testbench XSim (`sim/tb_payload.vhd`)
- [x] Notebook di controllo (`notebooks/axau15_control.ipynb`)
- [ ] Bitstream: richiede licenza Vivado `tri_mode_eth_mac` (Design Linking non sufficiente)
