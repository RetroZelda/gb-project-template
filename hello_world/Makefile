NAME		:= hello-world

ASSEMBLER	:= rgbasm
LINKER		:= rgblink
FIXER		:= rgbfix

OUT_DIR = ./bin
TOOLS_DIR = ./tools
SOURCE_DIR = ./source
WORKING_DIR = ./intermediate

SOURCES := $(shell find $(SOURCE_DIR) -name '*.asm')
OBJECTS := $(patsubst $(SOURCE_DIR)/%.asm, $(WORKING_DIR)/%.o, $(SOURCES))

SOURCES := $(patsubst $(PWD)/%.asm, ./%.asm, $(SOURCES))
OBJECTS := $(patsubst $(PWD)/%.o, ./%.o, $(OBJECTS))

ASM_FLAGS	:= -i $(SOURCE_DIR)
LNK_FLAGS	:=
FIX_FLAGS	:= -v -p 0

BINARY	:= $(OUT_DIR)/$(NAME).bin
ROM	:= $(OUT_DIR)/$(NAME).gb

# for running
EMULATOR		:= $(TOOLS_DIR)/SameBoy/build/bin/SDL/sameboy
EMULATOR_PATH	:= $(TOOLS_DIR)/SameBoy
EMULATOR_SOURCE	:= https://github.com/LIJI32/SameBoy.git

all: $(ROM)
	@echo done.

dbg:
	@echo $(OUT_DIR)
	@echo $(SOURCES)
	@echo $(OBJECTS)

clean:
	@echo cleaning \'$(OBJECTS)\'
	@rm -f $(OBJECTS)
	@echo cleaning \'$(BINARY)\'
	@rm -f $(BINARY)
	@echo cleaning \'$(ROM)\'
	@rm -f $(ROM)
	@echo cleaning \'$(WORKING_DIR)\'
	@rm -f -d -r $(WORKING_DIR)
	@echo cleaning \'$(TOOLS_DIR)\'
	@rm -f -d -r $(TOOLS_DIR)
	@echo cleaning \'$(OUT_DIR)\'
	@rm -f -d -r $(OUT_DIR)
	@echo done

$(WORKING_DIR)/%.o: $(SOURCE_DIR)/%.asm $(WORKING_DIR)
	@echo assembling \'$@\' from \'$<\'
	@$(ASSEMBLER) $(ASM_FLAGS) -o $@ $<

$(BINARY) : $(OBJECTS) $(OUT_DIR)
	@echo building \'$@\' from \'$<\'
	@$(LINKER) $(LNK_ARGS) -o $@ $<

$(ROM) : $(BINARY)
	@echo finalizing \'$@\' from \'$<\'
	@cp $< $@
	@$(FIXER) $(FIX_FLAGS) $@

$(WORKING_DIR):
	@mkdir -p $@

$(OUT_DIR):
	@mkdir -p $@

$(TOOLS_DIR):
	@mkdir -p $@

$(EMULATOR): $(EMULATOR_PATH)
	@echo building \'$@\' to run $(BINARY)
	@cd $(EMULATOR_PATH) && make --silent

$(EMULATOR_PATH): $(TOOLS_DIR)
	@echo cloning \'$(EMULATOR_SOURCE)\'
	@mkdir -p $@
	@git clone $(EMULATOR_SOURCE) $@

run: $(ROM) $(EMULATOR)
	@echo running \'$@\'
	@$(EMULATOR) $(PWD)/$<