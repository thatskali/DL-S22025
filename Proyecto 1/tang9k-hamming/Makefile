# Tang Nano 9K + SystemVerilog (OSS-CAD)

# ====== Proyecto ======
TOP        ?= top
SRC        := $(wildcard src/*.sv)
TB_FILE    ?= tb/module_top_tb.sv
SIM_TOP    ?= top_tb
BUILD_DIR  := build

# ====== Herramientas ======
YOSYS      ?= yosys
NEXTPNR    ?= nextpnr-gowin
PACK       ?= gowin_pack
PROG       ?= openFPGALoader
IVERILOG   ?= iverilog
VVP        ?= vvp
GTKWAVE    ?= gtkwave

# ====== Dispositivo ======
FAMILY     ?= GW1N-9C
DEVICE     ?= GW1NR-LV9QN88PC6/I5
CST        ?= constr/module_cons.cst

BITFILE    := $(BUILD_DIR)/$(TOP).fs
JSON_RTL   := $(BUILD_DIR)/$(TOP).json
JSON_PNR   := $(BUILD_DIR)/$(TOP)_pnr.json
SIM_OUT    := $(BUILD_DIR)/sim.out
VCD_FILE   ?= $(BUILD_DIR)/module_top_tb.vcd

# ====== Reglas ======
$(BUILD_DIR):
	mkdir -p "$(BUILD_DIR)"

.PHONY: all synth pnr pack bit prog sim wave clean show

all: synth pnr pack prog

# Imprime qué archivos está viendo el wildcard (útil para depurar en Windows)
show:
	@echo SRC=$(SRC)

synth: $(BUILD_DIR)
	$(YOSYS) -p "read_verilog -sv $(SRC); synth_gowin -top $(TOP) -json \"$(JSON_RTL)\""

pnr: synth
	$(NEXTPNR) --family $(FAMILY) --device "$(DEVICE)" \
	           --json "$(JSON_RTL)" --cst "$(CST)" \
	           --write "$(JSON_PNR)"

pack: pnr
	$(PACK) -d $(FAMILY) -o "$(BITFILE)" "$(JSON_PNR)"

bit: pack

prog: bit
	$(PROG) -b tangnano9k "$(BITFILE)"

# --- Simulación (Icarus + VCD) ---
sim: $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -o "$(SIM_OUT)" -s $(SIM_TOP) "$(TB_FILE)" $(SRC)
	$(VVP) "$(SIM_OUT)"

wave: sim
	$(GTKWAVE) "$(VCD_FILE)"

clean:
	rm -rf "$(BUILD_DIR)"

