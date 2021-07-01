.intel_syntax noprefix
.global assembler_vergleich
.section .rodata
.Lone:
	.float 1
.Ltwo:
    .float 2
.Lconstant:
    .float 5.545177444
.LhighestBit:
    .float 9223372036854775808
.text
assembler_vergleich:
cmp rdi, 0
jl negative
cvtsi2ss xmm0, rdi
jmp .Lformula
negative:
mov r10, 0x7fffffffffffffff     # Bitmask for throwing out last bit
and rdi, r10
cvtsi2ss xmm0, rdi
movss xmm1, [rip + .LhighestBit]
addss xmm0, xmm1
.Lformula:
movss xmm1, [rip + .Lconstant]
mulss xmm0, xmm1
movss xmm1, [rip + .Lone]
addss xmm0, xmm1
sqrtss xmm0, xmm0
movss xmm1, [rip + .Lone]
addss xmm0, xmm1
movss xmm1, [rip + .Ltwo]
divss xmm0, xmm1
ret
