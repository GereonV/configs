CEXT=.c
CC=gcc
SRC=src
ASM=asm
OBJ=obj
DIRS=$(SRC) $(OBJ) $(ASM)
SRCS=$(wildcard $(SRC)/*$(CEXT))
ASMS=$(patsubst $(SRC)/%$(CEXT),$(ASM)/%.s,$(SRCS))
OBJS=$(patsubst $(SRC)/%$(CEXT),$(OBJ)/%.o,$(SRCS))
EXT=
ifeq ($(OS),Windows_NT)
	EXT=.exe
endif
BINDEBUG=makemake-debug$(EXT)
BINRELEASE=makemake$(EXT)
TEMPLATE=MakefileTemplate
INSTALLPATH=/usr/local/bin/$(notdir $(BINRELEASE))
TEMPLATEPATH=/usr/local/share/$(notdir $(TEMPLATE))

CFLAGS=
LDFLAGS=
BIN=$(BINDEBUG)
all: debug

.PHONY: debug release install uninstall clean cleandebug cleanrelease installdirs

debug: CFLAGS+= -g -D _DEBUG
debug: LDFLAGS+= -g
debug: installdirs cleanrelease $(BIN)

release: CFLAGS+= -O2
release: LDFLAGS+=
release: BIN=$(BINRELEASE)
release: installdirs cleandebug $(BIN)

$(BIN): $(ASMS) $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(BIN)

$(OBJ)/%.o: $(SRC)/%$(CEXT)
	$(CC) $(CFLAGS) -c $< -o $@

$(ASM)/%.s: $(SRC)/%$(CEXT)
	$(CC) $(CFLAGS) -S $< -o $@

install: release
ifneq ($(OS),Windows_NT)
	install -m 755 $(BINRELEASE) $(INSTALLPATH)
	cp $(TEMPLATE) $(TEMPLATEPATH)
else
	$(info Windows-installation needs to be done manually)
	$(info Copy "$(BINRELEASE)" and "$(TEMPLATE)" into any directory in PATH)
	$(info DO NOT RENAME THESE FILES)
endif

uninstall:
ifneq ($(OS),Windows_NT)
	rm -f $(INSTALLPATH) $(TEMPLATEPATH)
endif

clean:
	rm -rf $(BINDEBUG) $(BINRELEASE) $(OBJ) $(ASM)

cleandebug:
ifeq ($(wildcard $(BINDEBUG)),$(BINDEBUG))
	rm -f $(BINDEBUG) $(OBJS) $(ASMS)
endif

cleanrelease:
ifeq ($(wildcard $(BINRELEASE)),$(BINRELEASE))
	rm -f $(BINRELEASE) $(OBJS) $(ASMS)
endif

installdirs:
ifneq ($(wildcard $(DIRS:=/.)),$(DIRS:=/.))
	mkdir -p $(DIRS)
endif
