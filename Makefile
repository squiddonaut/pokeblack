# ARM9 build 

MWCCVER        := dsi/1.1
PROC           := arm946e
PROC_S         := arm5te
PROC_LD        := v5te
LCF_TEMPLATE   := ARM9-TS.lcf.template
LIBS           := -L. -lsyscall -nostdlib
OPTFLAGS       := -O4,p

include config.mk

ASM_SUBDIR     := asm asm/arm9
LINKED_C_SRCS  := unk_02008574.c battle_record.c
SYM_GLOBS      := 'asm/unk_*.s' 'asm/overlay_*.s' 'asm/battle_*.s' 'asm/arm9/*.s'
LDSEARCH       := -search -l . -l src -l asm
CRT0_OBJ       := asm/crt0.o

SYSCALL_SRC    := lib/syscall/asm/_secure_$(GAME_CODE).s
SYSCALL_OBJ    := $(BUILD_DIR)/_secure_$(GAME_CODE).o
SYSCALL_LIB    := $(BUILD_DIR)/libsyscall.a
LINK_DEPS      := $(SYSCALL_LIB)

MAKELCF_FLAGS   = \
    -DTARGET_NAME=$(ELFNAME) \
    -DBUILD_DIR=$(BUILD_DIR) \
    -DSDK_LIB='$(SDK_ROOT)/lib/ARM9-TS/Release' \
    -DCW_LIBS='' \
    -DOBJS_AUTOLOAD=''

include common.mk

ifeq ($(GAME_VERSION),WHITE)
BASEROM        := baserom_white.nds
BASEROM_SHA1   := bc696a0dfb448c7b3a8a206f0f8214411a039208
BASEROM_NAME   := Pokemon White
else
BASEROM        := baserom.nds
BASEROM_SHA1   := 26ad0b9967aa279c4a266ee69f52b9b2332399a5
BASEROM_NAME   := Pokemon Black
endif
EXTRACT_DIR    := $(BUILD_DIR)/extracted
ARM9_CONFIG    := ndsdisasm_config/arm9_config.cfg

ORIG_ARM9      := $(EXTRACT_DIR)/arm9.bin
ORIG_ARM7      := $(EXTRACT_DIR)/arm7.bin
ORIG_Y9        := $(EXTRACT_DIR)/y9.bin
ORIG_Y7        := $(EXTRACT_DIR)/y7.bin
ORIG_HEADER    := $(EXTRACT_DIR)/header.bin
ORIG_BANNER    := $(EXTRACT_DIR)/banner.bin
ORIG_OVERLAYS  := $(EXTRACT_DIR)/overlay

# the stored ARM9 is BLZ-compressed and every address in the disassembly refers to the decompressed layout, so that is what the build is compared against
ORIG_ARM9_RAW  := $(EXTRACT_DIR)/arm9_decompressed.bin

SUB_DIR        := sub
SUB_ELFNAME    := arm7
SUB_SBIN       := $(SUB_DIR)/build/$(SUB_ELFNAME).sbin

ROM            := $(BUILD_DIR)/poke$(buildname).nds
ROM_SHA1       := $(buildname)/rom.sha1
OVL_POLICY     := $(buildname)/overlay_compression.txt
FILE_ORDER     := $(buildname)/files.txt
HEADER_TEMPLATE := $(buildname)/rom_header_template.sbin
FNT            := $(buildname)/fnt.bin
TWL_TAIL       := $(buildname)/twl_tail.bin
PACKED_DIR     := $(BUILD_DIR)/packed
PACKED_ARM9    := $(PACKED_DIR)/arm9.bin
BANNER_DIR     := $(buildname)/banner
BANNER         := $(BUILD_DIR)/banner.bin

# data files generated from source
DATA_DIR       := $(BUILD_DIR)/files
SPECIES_STAMP  := $(DATA_DIR)/.species
SPECIES_SRCS   := $(shell find res/pokemon -name '*.json' 2>/dev/null) $(wildcard generated/*.txt)

MAKEFLAGS += --no-print-directory

.PHONY: sub info check-toolchain extract check-baserom compare check-data \
        compare-overlays compare-table compare-arm7 compare-rom compare-all report

all:
	$(MAKE) tools
	$(MAKE) $(ROM)

main: $(SBIN) $(ELF)

sub: ; @$(MAKE) -C $(SUB_DIR)

tidy:
	@$(MAKE) -C $(SUB_DIR) tidy
	$(RM) -r $(BUILD_DIR)

clean: tidy clean-tools
	@$(MAKE) -C $(SUB_DIR) clean

compare: ; @$(MAKE) COMPARE=1

check-baserom:
	@if [ ! -f $(BASEROM) ]; then \
		echo "error: $(BASEROM) not found in the repository root."; \
		echo "       Supply your own dump of $(BASEROM_NAME) (USA/EUR, v1.0, NDSi Enhanced)."; \
		echo "       Expected sha1: $(BASEROM_SHA1)"; \
		exit 1; \
	fi
	@actual=$$($(SHA1SUM) $(BASEROM) | cut -d' ' -f1); \
	if [ "$$actual" != "$(BASEROM_SHA1)" ]; then \
		echo "error: $(BASEROM) is not the expected ROM."; \
		echo "       expected: $(BASEROM_SHA1)"; \
		echo "       actual:   $$actual"; \
		exit 1; \
	fi
	@echo "base ROM OK: $(BASEROM)"

extract: check-baserom $(ORIG_ARM9)

$(ORIG_ARM9): $(BASEROM) | $(NDSTOOL)
	@mkdir -p $(EXTRACT_DIR) $(ORIG_OVERLAYS)
	$(NDSTOOL) -x $(BASEROM) \
		-9 $(ORIG_ARM9) \
		-7 $(ORIG_ARM7) \
		-y9 $(ORIG_Y9) \
		-y7 $(ORIG_Y7) \
		-h $(ORIG_HEADER) \
		-t $(ORIG_BANNER) \
		-y $(ORIG_OVERLAYS)

$(NDSTOOL):
	@echo "error: $(NDSTOOL) not found. See INSTALL.md step 5."
	@exit 1

$(ORIG_ARM9_RAW): $(BASEROM) $(ARM9_CONFIG)
	@mkdir -p $(EXTRACT_DIR)
	@$(NDSDISASM) -c $(ARM9_CONFIG) -Du $@ $(BASEROM) > /dev/null

$(SYSCALL_LIB): $(SYSCALL_SRC)
	$(MW_ASSEMBLE) -o $(SYSCALL_OBJ) $<
	cd $(BUILD_DIR) && $(MW_LINK_LIB) -o $(@F) $(notdir $(SYSCALL_OBJ))

$(PACKED_ARM9): $(SBIN) $(OVL_POLICY)
	@$(PYTHON) $(SCRIPTS)/compress_modules.py --build $(BUILD_DIR) \
		--compstatic $(COMPSTATIC) --policy $(OVL_POLICY) \
		--outdir $(PACKED_DIR) --wine "$(WINE)"

$(BANNER): $(BANNER_DIR)/banner.meta $(wildcard $(BANNER_DIR)/*.png)
	@$(PYTHON) $(SCRIPTS)/banner.py build --dir $(BANNER_DIR) -o $@

$(SPECIES_STAMP): $(SPECIES_SRCS) $(SCRIPTS)/speciesproc.py $(SCRIPTS)/narc.py
	@$(PYTHON) $(SCRIPTS)/speciesproc.py -o $(DATA_DIR)
	@touch $@

check-data: $(SPECIES_STAMP)
	@$(PYTHON) $(SCRIPTS)/narc.py verify
	@$(PYTHON) $(SCRIPTS)/gen5text.py verify
	@$(PYTHON) $(SCRIPTS)/speciesproc.py -o $(DATA_DIR) --compare files

$(ROM): $(PACKED_ARM9) sub $(BANNER) $(SPECIES_STAMP)
	@$(PYTHON) $(SCRIPTS)/make_rom.py --build $(BUILD_DIR) \
		--header $(HEADER_TEMPLATE) --fnt $(FNT) --twl-tail $(TWL_TAIL) \
		--overlays $(PACKED_DIR) --arm9 $(PACKED_ARM9) --arm7 $(SUB_SBIN) \
		--banner $(BANNER) --table $(PACKED_DIR)/main_table.sbin \
		--files $(FILE_ORDER) --data-dir $(DATA_DIR) --data-dir $(buildname)/files \
		--data-dir files -o $@
ifeq ($(COMPARE),1)
	@$(SHA1SUM) --quiet -c $(ROM_SHA1) && echo "ROM matches $(ROM_SHA1)"
endif

compare-arm9: $(SBIN) $(ORIG_ARM9_RAW)
	@$(PYTHON) $(SCRIPTS)/compare_arm9.py $(SBIN) $(ORIG_ARM9_RAW)

# the link writes every OVY_<n>.sbin through the MEMORY block, so $(SBIN) covers them all
compare-overlays: $(SBIN) $(ORIG_ARM9)
	@$(PYTHON) $(SCRIPTS)/compare_overlays.py \
		--table $(ORIG_Y9) --overlays $(ORIG_OVERLAYS) --built $(BUILD_DIR)

compare-table: $(PACKED_ARM9) $(ORIG_ARM9)
	@$(PYTHON) $(SCRIPTS)/compare_overlay_table.py \
		$(PACKED_DIR)/main_table.sbin $(ORIG_Y9)

compare-arm7: sub $(ORIG_ARM9)
	@if cmp -s $(SUB_SBIN) $(ORIG_ARM7); then \
		echo "ARM7 matches $(ORIG_ARM7)"; \
	else \
		echo "ARM7 does not match $(ORIG_ARM7)"; \
		cmp -l $(SUB_SBIN) $(ORIG_ARM7) | wc -l | xargs echo "  differing bytes:"; \
		exit 1; \
	fi

OBJDIFF := $(TOOLSDIR)/objdiff/objdiff-cli

# decompilation progress for decomp.dev
report: $(SBIN)
	@$(PYTHON) $(SCRIPTS)/gen_objdiff_project.py --build $(BUILD_DIR)
	@$(OBJDIFF) report generate -p $(BUILD_DIR) -o $(BUILD_DIR)/report.json
	@echo "report: $(BUILD_DIR)/report.json"

compare-rom: $(ROM)
	@$(SHA1SUM) --quiet -c $(ROM_SHA1) && echo "ROM matches $(ROM_SHA1)"

compare-all: compare-arm9 compare-overlays compare-arm7 compare-table compare-rom
	@$(SHA1SUM) --quiet -c $(buildname)/overlays.sha1 \
		&& echo "overlays match $(buildname)/overlays.sha1"
	@$(SHA1SUM) --quiet -c $(buildname)/files.sha1 \
		&& echo "data files match $(buildname)/files.sha1"

CANARY_SRC  := test/toolchain_canary.c
CANARY_OBJ  := $(BUILD_DIR)/toolchain_canary.o
CANARY_TEXT := $(BUILD_DIR)/toolchain_canary.text
CANARY_SHA  := test/toolchain_canary.sha1

# frozen source, so this stays valid however much of the game gets decompiled
check-toolchain: MWCFLAGS += -W off
check-toolchain:
	@$(MW_COMPILE) -c -o $(CANARY_OBJ) $(CANARY_SRC)
	@$(OBJCOPY) -O binary --only-section=.text $(CANARY_OBJ) $(CANARY_TEXT)
	@actual=$$($(SHA1SUM) $(CANARY_TEXT) | cut -d' ' -f1); \
	if [ ! -f $(CANARY_SHA) ]; then \
		echo "$$actual" > $(CANARY_SHA); \
		echo "recorded new toolchain hash in $(CANARY_SHA): $$actual"; \
	elif [ "$$actual" = "$$(cat $(CANARY_SHA))" ]; then \
		echo "toolchain OK: canary matches $(CANARY_SHA)"; \
	else \
		echo "TOOLCHAIN MISMATCH"; \
		echo "  expected: $$(cat $(CANARY_SHA))"; \
		echo "  actual:   $$actual"; \
		echo "Likely a wrong mwccarm version (expect dsi/1.1), edited MWCFLAGS,"; \
		echo "or an unpatched mwasmarm. See INSTALL.md step 1."; \
		exit 1; \
	fi

info:
	@echo "mwcc:      $(MWCCVER)"
	@echo "proc:      $(PROC)"
	@echo "sdk:       $(SDK_ROOT)"
	@echo "rom:       $(TITLE_NAME) $(GAME_CODE) crc $(SECURE_CRC)"
	@echo "sources:   $(words $(C_SRCS)) C, $(words $(ASM_SRCS)) asm"
	@echo "build dir: $(BUILD_DIR)"

# Convenience targets
black:         ; @$(MAKE) GAME_VERSION=BLACK
compare_black: ; @$(MAKE) GAME_VERSION=BLACK COMPARE=1
clean_black:   ; @$(MAKE) GAME_VERSION=BLACK clean
white:         ; @$(MAKE) GAME_VERSION=WHITE
compare_white: ; @$(MAKE) GAME_VERSION=WHITE COMPARE=1
clean_white:   ; @$(MAKE) GAME_VERSION=WHITE clean

.PHONY: black compare_black clean_black white compare_white clean_white main compare-arm9
