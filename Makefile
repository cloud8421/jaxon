ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

UNAME := $(shell uname)

CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter
CC ?= $(CROSSCOMPILE)-gcc

# CFLAGS += -std=gnu99

# ifeq ($(UNAME), Darwin)
# 	CC := clang
# 	CFLAGS := -undefined dynamic_lookup -dynamiclib
# endif

# ifeq ($(UNAME), Linux)
	# CC := gcc
CFLAGS := -shared -fpic -D_POSIX_C_SOURCE=199309L -O3 -Wall -Wextra -Wno-unused-parameter -std=gnu99
# endif

all: priv/decoder.so

priv/decoder.so: c_src/decoder_nif.c c_src/decoder.c
	mkdir -p priv
	$(CC) $(CFLAGS) -I$(ERL_INCLUDE_PATH) c_src/decoder*.c -o priv/decoder.so

clean:
	@rm -rf priv/decoder.so
