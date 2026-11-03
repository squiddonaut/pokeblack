## Common defines for ARM9 and ARM7 Makefiles ##

COMPARE ?= 1

default: all

PROJECT_ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifeq ($(OS),Windows_NT)
REALPATH := realpath
else
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
REALPATH ?= grealpath
else
REALPATH := realpath
endif
endif

# Because mwldarm expects absolute paths to be WIN32 paths all paths referring up from BUILD_DIR must be relative
WORK_DIR   := $(shell $(REALPATH) --relative-to $(CURDIR) $(PROJECT_ROOT))
$(shell mkdir -p $(BUILD_DIR))
BACK_REL   := $(shell $(REALPATH) --relative-to $(BUILD_DIR) $(CURDIR))

# Recursive wildcard function
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

TOOLSDIR     := $(PROJECT_ROOT)/tools
TOOLSREL     := $(BACK_REL)/tools
SCRIPTS      := $(TOOLSDIR)/scripts

include $(WORK_DIR)/platform.mk
include $(WORK_DIR)/binutils.mk

# NitroSDK
SDK_ROOT      := $(WORK_DIR)/lib/NitroSDK/TwlSDK
SDK_TOOLS     := $(SDK_ROOT)/tools/bin
SDK_SPECFILES := $(SDK_ROOT)/include/nitro/specfiles

# Metroskrew
SKREW_GET := tools/devtools/get_metroskrew.sh
SKREW_VER := 0.1.3
SKREW_DIR := $(TOOLSDIR)/metroskrew
SKREW_FLAGS = -wrap:sdk $(MWCCVER)

ifneq (,$(findstring Linux,$(UNAME_S)))
  ifeq (0,$(WSL_ACCESSING_WINDOWS))
    NATIVE := native.ini
    CROSS := cross.ini
    SKREW_SYS := windows
    SKREW_EXE := $(SKREW_DIR)/bin/skrewrap.exe
  else
    NATIVE := native.ini
    CROSS := cross_unix.ini
    SKREW_SYS := linux
    SKREW_EXE := $(SKREW_DIR)/bin/skrewrap
  endif
else
  ifneq (,$(findstring Darwin,$(UNAME_S)))
    NATIVE := native_macos.ini
    CROSS := cross_unix.ini
    SKREW_SYS := wine
    SKREW_EXE := $(SKREW_DIR)/bin/skrewrap
  else
    ifneq (,$(findstring BSD, $(UNAME_S)))
      NATIVE := native.ini
      CROSS := cross_unix.ini
      SKREW_SYS := linux
      SKREW_EXE := $(SKREW_DIR)/bin/skrewrap
    else
      NATIVE := native.ini
      CROSS := cross.ini
      SKREW_SYS := windows
      SKREW_EXE := $(SKREW_DIR)/bin/skrewrap.exe
    endif
  endif
endif

skrew: $(SKREW_EXE)

skrewrm:
	rm -rf $(SKREW_DIR)

skrewup: skrewrm skrew

$(SKREW_EXE):
	SKREW_SYS=$(SKREW_SYS) SKREW_VER=$(SKREW_VER) SKREW_DIR=$(SKREW_DIR) $(SKREW_GET)

MWCC          = $(SKREW_DIR)/bin/mwccarm $(SKREW_FLAGS)
MWAS          = $(SKREW_DIR)/bin/mwasmarm $(SKREW_FLAGS)
MWLD          = $(SKREW_DIR)/bin/mwldarm $(SKREW_FLAGS)
MAKELCF      := $(SDK_TOOLS)/makelcf.exe
COMPSTATIC   := $(SDK_TOOLS)/compstatic.exe

export LM_LICENSE_FILE := $(TOOLSDIR)/mwccarm/license.dat

# Native tools
NDSTOOL      := $(TOOLSDIR)/ndstool/ndstool$(EXE)
NDSDISASM    := $(TOOLSDIR)/ndsdisasm/ndsdisasm$(EXE)
ASM_PROCESSOR := bash $(TOOLSDIR)/asm_processor/compile.sh
PYTHON        := python3

MOVEPROC	 := $(TOOLSDIR)/dataproc/moveproc

NATIVE_TOOLS := $(MOVEPROC)

TOOLDIRS := $(sort $(foreach tool,$(NATIVE_TOOLS),$(dir $(tool))))

# Directories
SRC_SUBDIR                := src
ASM_SUBDIR                ?= asm
ALL_SUBDIRS               := $(SRC_SUBDIR) $(ASM_SUBDIR)

SRC_BUILDDIR              := $(addprefix $(BUILD_DIR)/,$(SRC_SUBDIR))
ASM_BUILDDIR              := $(addprefix $(BUILD_DIR)/,$(ASM_SUBDIR))

# asm/ covers the whole module including what src/ decompiles, so a source file joins the build only once its range is carved out and its object is listed in the LSF
C_SRCS                    := $(filter $(addprefix $(SRC_SUBDIR)/,$(LINKED_C_SRCS)),$(call rwildcard,$(SRC_SUBDIR),*.c))
ASM_SRCS                  := $(foreach dname,$(ASM_SUBDIR),$(wildcard $(dname)/*.s))
GLOBAL_ASM_SRCS           != grep -rl 'GLOBAL_ASM(' $(C_SRCS) 2>/dev/null || true
ALL_SRCS                  := $(C_SRCS) $(ASM_SRCS) $(GLOBAL_ASM_SRCS)

C_OBJS                    = $(C_SRCS:%.c=$(BUILD_DIR)/%.o)
ASM_OBJS                  = $(ASM_SRCS:%.s=$(BUILD_DIR)/%.o)
GLOBAL_ASM_OBJS           = $(GLOBAL_ASM_SRCS:%.c=$(BUILD_DIR)/%.o)
ALL_GAME_OBJS             = $(C_OBJS) $(ASM_OBJS) $(GLOBAL_ASM_OBJS)
ALL_OBJS                  = $(ALL_GAME_OBJS)

ALL_BUILDDIRS             := $(sort $(ALL_BUILDDIRS) $(foreach obj,$(ALL_OBJS),$(dir $(obj))))

ELF               := $(BUILD_DIR)/$(ELFNAME).elf
LCF               := $(ELF:%.elf=%.lcf)
RESPONSE          := $(ELF:%.elf=%.response)
SBIN              := $(ELF:%.elf=%.sbin)
XMAP              := $(ELF).xMAP

EXCCFLAGS         := -Cpp_exceptions off

MWCFLAGS           = $(DEFINES) $(OPTFLAGS) -sym on -enum int -lang c99 $(EXCCFLAGS) -gccext,on -proc $(PROC) -msgstyle gcc -gccinc -i ./src -i ./include -i ./include/msl -i $(WORK_DIR)/include -I$(WORK_DIR)/$(SDK_ROOT)/include -ipa file -interworking -inline on,noauto -char signed -thumb -W all -W pedantic -W noimpl_signedunsigned -W noimplicitconv -W nounusedarg -W nomissingreturn -W error

MWASFLAGS          = $(DEFINES) -proc $(PROC_S) -g -gccinc -i . -i $(WORK_DIR) -i ./include -i $(WORK_DIR)/asm -i $(WORK_DIR)/asm/macros -i $(WORK_DIR)/asm/include -i $(WORK_DIR)/include -I$(WORK_DIR)/$(SDK_ROOT)/include -DSDK_ASM
MWLDFLAGS         := -proc $(PROC) -sym on -nopic -nopid -interworking -map closure,unused -symtab sort -m _start -msgstyle gcc
ARFLAGS           := rcS

MW_COMPILE  = $(MWCC) $(MWCFLAGS)
MW_ASSEMBLE = $(MWAS) $(MWASFLAGS)
MW_LINK     = $(MWLD) $(MWLDFLAGS) $(LIBS)
MW_LINK_LIB = $(MWLD) -library -nodead -w off -proc $(PROC_LD)

export MWCIncludes := $(SDK_ROOT)/include

LSF_SRC           := $(addsuffix .lsf,$(ELFNAME))
OVERLAY_BASE      := $(wildcard $(buildname)/overlay_base.txt)
ifneq ($(OVERLAY_BASE),)
LSF               := $(BUILD_DIR)/$(LSF_SRC)
else
LSF               := $(LSF_SRC)
endif
ifneq ($(LSF),)
OVERLAYS          := $(shell $(GREP) -o "^Overlay \w+" $(LSF_SRC) | cut -d' ' -f2)
else
OVERLAYS          :=
endif

# Make sure build directories exist before compiling anything
DUMMY := $(shell mkdir -p $(ALL_BUILDDIRS))

.SECONDARY:
.DELETE_ON_ERROR:
.PHONY: all tidy clean tools clean-tools update purge skrew skrewrm skrewup $(TOOLDIRS)
.PRECIOUS: $(SBIN)

ifeq ($(NODEP),)
ifneq ($(WINPATH),)
PROJECT_ROOT_NT := $(shell $(WINPATH) -w $(PROJECT_ROOT) | $(SED) 's/\\/\//g')
define fixdep
$(SED) -i 's/\r//g; s/\\/\//g; s/\/$$/\\/g; s#$(PROJECT_ROOT_NT)#$(PROJECT_ROOT)#g' $(1)
touch -r $(1:%.d=%.o) $(1)
endef
else
define fixdep
$(SED) -i 's/\r//g; s/\\/\//g; s/\/$$/\\/g' $(1)
touch -r $(1:%.d=%.o) $(1)
endef
endif
DEPFLAGS := -gccdep -MD
DEPFILES := $(ALL_OBJS:%.o=%.d)
MW_COMPILE += $(DEPFLAGS)
$(GLOBAL_ASM_OBJS): BUILD_C := $(ASM_PROCESSOR) "$(MW_COMPILE)" "$(MW_ASSEMBLE)"
BUILD_C ?= $(MW_COMPILE) -c -o

$(DEPFILES):

$(BUILD_DIR)/%.o: %.c
$(BUILD_DIR)/%.o: %.c $(BUILD_DIR)/%.d
	@echo "Compiling $<..."
	@$(BUILD_C) $@ $< || { rm -f $(BUILD_DIR)/$*.d; exit 1; }
	@$(call fixdep,$(BUILD_DIR)/$*.d)

$(BUILD_DIR)/%.o: %.s
$(BUILD_DIR)/%.o: %.s $(BUILD_DIR)/%.d
	@echo "Assembling $<..."
	@$(MW_ASSEMBLE) $(DEPFLAGS) -o $@ $< || { rm -f $(BUILD_DIR)/$*.d; exit 1; }
	@$(call fixdep,$(BUILD_DIR)/$*.d)

include $(wildcard $(DEPFILES))
else
$(GLOBAL_ASM_OBJS): BUILD_C := $(ASM_PROCESSOR) "$(MW_COMPILE)" "$(MW_ASSEMBLE)"
BUILD_C ?= $(MW_COMPILE) -c -o

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling $<..."
	$(BUILD_C) $@ $<

$(BUILD_DIR)/%.o: %.s
	@echo "Assembling $<..."
	$(MW_ASSEMBLE) -o $@ $<
endif

$(NATIVE_TOOLS): tools ;

tools: $(TOOLDIRS) $(SKREW_EXE)

$(TOOLDIRS):
	@$(MAKE) -C $@

clean-tools:
	$(foreach tool,$(TOOLDIRS),$(MAKE) -C $(tool) clean;)

update: skrewup

purge:
	rm -rf build
	rm -rf $(SKREW_DIR)

# addresses the module calls but does not contain, defined for the linker because the assembler cannot turn an absolute address into a PC-relative branch
FORCE_ACTIVE_LIST := $(BUILD_DIR)/force_active.txt

$(FORCE_ACTIVE_LIST): $(ASM_SRCS) $(C_SRCS)
	@$(PYTHON) $(SCRIPTS)/gen_force_active.py $(SYM_GLOBS) --provided $(C_SRCS) -o $@

ifeq ($(EXTERN_SYMS),)
EXTERN_SYMS := $(BUILD_DIR)/extern_syms.lcf

ADDR_SHIFT := $(wildcard $(buildname)/addr_shift.txt)
OVL_DELTA := $(wildcard $(buildname)/overlay_delta.txt)
OVL_SHIFT := $(wildcard $(buildname)/overlay_shift.txt)

$(EXTERN_SYMS): $(ASM_SRCS) $(C_SRCS) $(ADDR_SHIFT) $(OVL_DELTA) $(OVL_SHIFT)
	@$(PYTHON) $(SCRIPTS)/gen_extern_syms.py $(SYM_GLOBS) --provided $(C_SRCS) $(if $(ADDR_SHIFT),--shift $(ADDR_SHIFT)) $(if $(OVL_DELTA),--overlay-delta $(OVL_DELTA)) $(if $(OVL_SHIFT),--overlay-shift $(OVL_SHIFT)) -o $@
endif

LCF_TEMPLATE_PATH    := $(SDK_SPECFILES)/$(LCF_TEMPLATE)
RESPONSE_TEMPLATE    := $(SDK_SPECFILES)/mwldarm.response.template

$(BUILD_DIR)/$(LSF_SRC): $(LSF_SRC) $(OVERLAY_BASE)
	@$(PYTHON) $(SCRIPTS)/gen_lsf.py $< $(OVERLAY_BASE) -o $@

$(LCF): $(LSF) $(LCF_TEMPLATE_PATH) $(EXTERN_SYMS) $(FORCE_ACTIVE_LIST)
	$(WINE) $(MAKELCF) $(MAKELCF_FLAGS) $< $(LCF_TEMPLATE_PATH) $@
	@$(PYTHON) $(SCRIPTS)/inject_lcf_syms.py $@ $(EXTERN_SYMS) $(FORCE_ACTIVE_LIST)

$(RESPONSE): $(LSF) $(RESPONSE_TEMPLATE)
	$(WINE) $(MAKELCF) $(MAKELCF_FLAGS) $< $(RESPONSE_TEMPLATE) $@

# mwldarm writes the sbin itself through the LCF MEMORY block, the ELF holds only symbols and debug info, so do not add an objcopy step here, it produces an empty file
$(SBIN): build/%.sbin: build/%.elf
	@test -s $@ || { \
		echo "error: linker did not write $@"; \
		echo "       check the MEMORY block in $(LCF) for the '> $(@F)' directive"; \
		exit 1; \
	}
	@echo "$(ELFNAME) binary: $@ ($$(stat -c %s $@) bytes)"
ifeq ($(COMPARE),1)
	@$(SHA1SUM) --quiet -c $*.sha1 && echo "$(@F) matches $*.sha1"
endif

$(ELF): $(ALL_OBJS) $(LCF) $(RESPONSE) $(LINK_DEPS)
	cd $(BUILD_DIR) && \
	$(MW_LINK) $(LDSEARCH) \
	-o $(BACK_REL)/$(ELF) \
	$(LCF:$(BUILD_DIR)/%=%) \
	@$(RESPONSE:$(BUILD_DIR)/%=%) \
	$(CRT0_OBJ)

print-% : ; $(info $* is a $(flavor $*) variable set to [$($*)]) @true
