CEXT=.cpp
CC=g++
SRC=src
ASM=asm
OBJ=obj
DIRS=$(SRC) $(OBJ) $(ASM)
SRCS=$(wildcard $(SRC)/*$(CEXT))
ASMS=$(patsubst $(SRC)/%$(CEXT),$(ASM)/%.s,$(SRCS))
OBJS=$(patsubst $(SRC)/%$(CEXT),$(OBJ)/%.o,$(SRCS))
BINDEBUG=debug.exe
BINRELEASE=release.exe

CFLAGS=
LDFLAGS=-shared-libgcc
BIN=
all: debug

.PHONY: debug release clean cleandebug cleanrelease installdirs

debug: CFLAGS=-g
debug: LDFLAGS:= -g
debug: BIN=$(BINDEBUG)
debug: installdirs cleanrelease $(BIN)

release: CFLAGS=-O2
release: LDFLAGS:=
release: BIN=$(BINRELEASE)
release: installdirs cleandebug $(BIN)

$(BIN): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(BIN)

$(OBJ)/%.o: $(SRC)/%$(CEXT)
	$(CC) $(CFLAGS) -c $< -o $@

$(ASM)/%.s: $(SRC)/%$(CEXT)
	$(CC) $(CFLAGS) -S $< -o $@

clean:
	rm -rf $(BINDEBUG) $(BINRELEASE) $(OBJS) $(ASMS)

cleandebug:
ifeq ($(wildcard $(BINDEBUG)),$(BINDEBUG))
	rm -f $(BINDEBUG) $(OBJS)/* $(ASMS)/*
endif

cleanrelease:
ifeq ($(wildcard $(BINRELEASE)),$(BINRELEASE))
	rm -f $(BINRELEASE) $(OBJS)/* $(ASMS)/*
endif

installdirs:
ifneq ($(wildcard $(DIRS:=/.)),$(DIRS:=/.))
	mkdir -p $(DIRS)
endif
