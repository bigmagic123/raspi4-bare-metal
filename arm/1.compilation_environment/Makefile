SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)
CFLAGS = -march=armv8-a -mtune=cortex-a72 -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles

all: clean kernel7.img

start.o: start.S
	arm-none-eabi-gcc $(CFLAGS) -c start.S -o start.o

%.o: %.c
	arm-none-eabi-gcc $(CFLAGS) -c $< -o $@

kernel7.img: start.o $(OBJS)
	arm-none-eabi-ld -nostdlib -nostartfiles start.o $(OBJS) -T link.ld -o kernel7.elf
	arm-none-eabi-objcopy -O binary kernel7.elf kernel7.img

clean:
	rm kernel7.elf kernel7.img *.o >/dev/null 2>/dev/null || true