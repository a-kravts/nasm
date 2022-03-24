ASM = nasm
ASM_FLAGS = -f elf -g
LD_FLAGS = -m elf_i386

SRC_MODULES = diamond.asm \
              print_diamond.asm \
              put_string.asm \
              read_uint8.asm \
              string_length.asm
OBJ_MODULES = $(SRC_MODULES:.asm=.o)

%.o: %.asm
		$(ASM) $(ASM_FLAGS) $<

diamond: $(OBJ_MODULES)
		ld $(LD_FLAGS) $^ -o $@

check: check.o put_string.o string_length.o
		ld $(LD_FLAGS) $^ -o $@
