MOVES_BUILD_DIR := $(BUILD_DIR)/res/moves
$(shell mkdir -p $(MOVES_BUILD_DIR))
MOVES_NARC      := $(MOVES_BUILD_DIR)/moves.narc
MOVES_DEPFILE   := $(MOVES_BUILD_DIR)/moves.d
MOVE_JSON_FILES := $(shell find res/moves -name *.json)

$(MOVES_NARC): $(MOVE_JSON_FILES) $(MOVEPROC)
	$(MOVEPROC) -o $(MOVES_BUILD_DIR) -M $(MOVES_DEPFILE) include/constants/moves.h res/moves

.PHONY: moves clean-moves

moves: $(MOVES_NARC)

clean-moves:
	$(RM) -R $(MOVES_BUILD_DIR)
