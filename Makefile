CFLAGS=-std=c11 -g -fno-common -Wall -Wno-switch

SRCS=$(wildcard *.c)
OBJS=$(SRCS:.c=.o)

# Stage 1

comp: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(OBJS): comp.h

# Stage 2

stage2/comp: $(OBJS:%=stage2/%)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

stage2/%.o: comp %.c
	mkdir -p stage2/test
	./comp -c -o $(@D)/$*.o $*.c

# Misc.

clean:
	rm -rf comp tmp* stage2
	find * -type f '(' -name '*~' -o -name '*.o' ')' -exec rm {} ';'

.PHONY: clean

