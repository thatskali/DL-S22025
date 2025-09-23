# ------------------------------
# Tang Nano 9K - Makefile
# ------------------------------
SHELL := /bin/sh

# Herramientas (asume que están en el PATH)
YOSYS       := yosys
NEXTPNR     := nextpnr-gowin
GOWIN_PACK  := gowin_pack
OPENLOADER  := openFPGALoader

# Dispositivo / placa
FAMILY  := GW1N-9C
DEVICE  := GW1NR-LV9QN88PC6/I5
BOARD   := tangnano9k

# Carpetas / ficheros
SRC_DIR := src
TB_DIR  := tb
CONSTR  := constr/module_cons.cst
BUILD   := build

TOP     := top
JSON    := $(BUILD)/top.json
PNRJSON := $(BUILD)/top_pnr.json
BITFS   := $(BUILD)/top.fs
SIMOUT  := $(BUILD)/sim.out

# Fuentes
SRCS := \
  $(SRC_DIR)/top.sv \
  $(SRC_DIR)/module_decoder.sv \
  $(SRC_DIR)/module_leds.sv \
  $(SRC_DIR)/module_seg.sv \
  $(SRC_DIR)/hamming_secded_encoder.sv \
  $(SRC_DIR)/hamming_secded_syndrome.sv \
  $(SRC_DIR)/hamming_secded_corrector.sv \
  $(SRC_DIR)/hamming_secded_decoder.sv

TB := $(TB_DIR)/top_tb.sv

# ---------------------------------------
# Targets
# ---------------------------------------
.PHONY: all sim synth pnr pack prog flash clean

all: synth pnr pack

$(BUILD):
	mkdir -p $(BUILD)

sim: $(BUILD)
	iverilog -g2012 -Wall -o "$(SIMOUT)" -s top_tb \
		$(TB) $(SRCS)
	@echo "[OK] Compilación de simulación."
	vvp "$(SIMOUT)"

synth: $(BUILD)
	$(YOSYS) -p "read_verilog -sv $(SRCS); synth_gowin -top $(TOP) -json \"$(JSON)\""
	@echo "[OK] Síntesis Yosys -> $(JSON)"

pnr: synth
	$(NEXTPNR) --family $(FAMILY) --device "$(DEVICE)" \
		--json "$(JSON)" --cst "$(CONSTR)" --write "$(PNRJSON)"
	@echo "[OK] P&R nextpnr -> $(PNRJSON)"

pack: pnr
	$(GOWIN_PACK) -d $(FAMILY) -o "$(BITFS)" "$(PNRJSON)"
	@echo "[OK] Empaquetado gowin_pack -> $(BITFS)"

# Cargar a SRAM (volátil). Alias "prog"
prog: sram
sram: pack
	$(OPENLOADER) -b $(BOARD) "$(BITFS)"

# Grabar en flash (persistente)
flash: pack
	$(OPENLOADER) -b $(BOARD) -f "$(BITFS)"

clean:
	rm -rf $(BUILD)
	@echo "[OK] Limpieza completada."
