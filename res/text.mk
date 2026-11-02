TEXT_BUILD_DIR  := $(BUILD_DIR)/res/text
$(shell mkdir -p $(TEXT_BUILD_DIR))
TEXT_A002_NARC  := $(TEXT_BUILD_DIR)/a002.narc
TEXT_A003_NARC  := $(TEXT_BUILD_DIR)/a003.narc
TEXT_A002_DIR   := res/text/a/0/0/2
TEXT_A003_DIR   := res/text/a/0/0/3
TEXT_A002_BANKS := $(wildcard $(TEXT_A002_DIR)/*.json)
TEXT_A003_BANKS := $(wildcard $(TEXT_A003_DIR)/*.json)

MOVE_NAMES_JSON := $(MOVES_BUILD_DIR)/move_names.json

$(TEXT_A002_NARC): $(TEXT_A002_BANKS) $(MOVES_NARC) $(SCRIPTS)/gen5text.py $(SCRIPTS)/narc.py
	$(PYTHON) $(SCRIPTS)/gen5text.py pack -o $@ $(TEXT_A002_DIR) --prepend 203:$(MOVE_NAMES_JSON)

$(TEXT_A003_NARC): $(TEXT_A003_BANKS) $(SCRIPTS)/gen5text.py $(SCRIPTS)/narc.py
	$(PYTHON) $(SCRIPTS)/gen5text.py pack -o $@ $(TEXT_A003_DIR)

.PHONY: text clean-text

text: $(TEXT_A002_NARC) $(TEXT_A003_NARC)

clean-text:
	$(RM) -R $(TEXT_BUILD_DIR)
