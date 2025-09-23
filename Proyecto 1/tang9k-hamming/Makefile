# ==== Rutas ====
SRC_DIR     := src
TB_DIR      := tb
CONSTR_DIR  := constr
BUILD_DIR   := build

# ==== Herramientas (puedes sobreescribirlas al invocar make) ====
YOSYS       ?= yosys
NEXTPNR     ?= nextpnr-gowin
GOWIN_PACK  ?= gowin_pack
PROG        ?= openFPGALoader

# ==== Dispositivo Tang Nano 9K ====
FAMILY   := GW1N-9C
DEVICE   := GW1NR-LV9QN88PC6/I5
PACKAGE  := QFN88P

# ==== Fuentes ====
SRC := \
  $(SRC_DIR)/top.sv \
  $(SRC_DIR)/module_decoder.sv \
  $(SRC_DIR)/module_leds.sv \
  $(SRC_DIR)/module_seg.sv \
  $(SRC_DIR)/hamming_secded_encoder.sv \
  $(SRC_DIR)/hamming_secded_syndrome.sv \
  $(SRC_DIR)/hamming_secded_corrector.sv \
  $(SRC_DIR)/hamming_secded_decoder.sv

TB := $(TB_DIR)/top_tb.sv

# ==== Artefactos ====
JSON     := $(BUILD_DIR)/top.json
PNR_JSON := $(BUILD_DIR)/top_pnr.json
FS       := $(BUILD_DIR)/top.fs
CST      := $(CONSTR_DIR)/module_cons.cst

# ==== Targets por defecto ====
.PHONY: all sim run synth pnr pack flash clean

all: synth pnr pack

# ---- Simulación (Icarus) ----
sim: $(BUILD_DIR)
	iverilog -g2012 -Wall -o "$(BUILD_DIR)/sim.out" -s top_tb $(TB) $(SRC)
	@echo "[OK] Compilación de simulación."

run: sim
	vvp "$(BUILD_DIR)/sim.out"
	@echo "[OK] Simulación ejecutada. Revisa wave.vcd si generas volcado."

# ---- Síntesis (Yosys) ----
synth: $(BUILD_DIR)
	$(YOSYS) -p "read_verilog -sv $(SRC); synth_gowin -top top -json \"$(JSON)\""
	@echo "[OK] Síntesis Yosys -> $(JSON)"

# ---- Place & Route (nextpnr) ----
pnr: synth
	$(NEXTPNR) --family $(FAMILY) --device "$(DEVICE)" --json "$(JSON)" --cst "$(CST)" --write "$(PNR_JSON)"
	@echo "[OK] P&R nextpnr -> $(PNR_JSON)"

# ---- Empaquetado bitstream (gowin_pack) ----
pack: pnr
	$(GOWIN_PACK) -o "$(FS)" -d $(FAMILY) "$(PNR_JSON)"
	@echo "[OK] Bitstream -> $(FS)"

# ---- Programación (openFPGALoader) ----
flash: pack
	$(PROG) -b tangnano9k "$(FS)"
	@echo "[OK] Programación completada."

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
	@echo "[OK] Limpieza."