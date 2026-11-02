TEXT_BUILD_DIR  := $(BUILD_DIR)/res/text
$(shell mkdir -p $(TEXT_BUILD_DIR))
TEXT_A002_NARC  := $(TEXT_BUILD_DIR)/a002.narc
TEXT_A003_NARC  := $(TEXT_BUILD_DIR)/a003.narc
TEXT_A002_BANKS := $(sort $(wildcard res/text/a/0/0/2/*.json))
TEXT_A003_BANKS := $(sort $(wildcard res/text/a/0/0/3/*.json))

MOVE_NAMES_BANK := res/text/a/0/0/2/203.json
MOVE_NAMES_JSON := $(MOVES_BUILD_DIR)/move_names.json

$(TEXT_A002_NARC): $(TEXT_A002_BANKS) $(MOVES_NARC) $(SCRIPTS)/gen5text.py $(SCRIPTS)/narc.py
	$(PYTHON) $(SCRIPTS)/gen5text.py pack -o $@ $(patsubst $(MOVE_NAMES_BANK),$(MOVE_NAMES_JSON)+$(MOVE_NAMES_BANK),$(TEXT_A002_BANKS))

$(TEXT_A003_NARC): $(TEXT_A003_BANKS) $(SCRIPTS)/gen5text.py $(SCRIPTS)/narc.py
	$(PYTHON) $(SCRIPTS)/gen5text.py pack -o $@ $(TEXT_A003_BANKS)

.PHONY: text clean-text

text: $(TEXT_A002_NARC) $(TEXT_A003_NARC)

clean-text:
	$(RM) -R $(TEXT_BUILD_DIR)
