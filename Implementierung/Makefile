# Add additional compiler flags here
CFLAGS=-O2

all: main
main: birthday_num_series.S birthday_num_tab.S assembler_vergleich.S Rahmenprogramm.c
	$(CC) $(CFLAGS) -o $@ $^ -lm -Wno-unused-result
clean:
	rm -f main

