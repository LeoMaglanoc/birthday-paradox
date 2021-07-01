.intel_syntax noprefix
.global birthday_num_series
.section .rodata
.Lsub:
    .float 1.25
.Lzero:
    .float 1.118033989
.Lfirst:
    .float 0.4472135955
.Lsecond:
    .float -0.0894427191
.Lthird:
    .float 0.03577708764
.Lfourth:
    .float -0.01788854382
.Lfifth:
    .float 0.01001758454
.Lsixth:
    .float -0.006010550724
.Lseventh:
    .float 0.00377860455
.Leigth:
    .float -0.002455739296
.LhighestBit:
    .float 9223372036854775808
.Lconstant:
    .float 5.54517744447
.Lone:
    .float 1.0
.Ltwo:
    .float 2.0
.text
birthday_num_series:
#check if n would be negative as signed int because cvtsi2ss only converts signed ints
cmp rdi, 0
jl .LsignedNegative
cvtsi2ss xmm0, rdi
jmp .Lformula
.LsignedNegative:
mov rsi, 0x7fffffffffffffff
and rdi, rsi
cvtsi2ss xmm0, rdi
addss xmm0, [rip + .LhighestBit]

.Lformula:
mulss xmm0, [rip + .Lconstant]
addss xmm0, [rip + .Lone]
call series_implementation
addss xmm0, [rip + .Lone]
divss xmm0, [rip + .Ltwo]
ret

series_implementation:
mov rax, 0x0000000200000000 #start: 2^33
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g33
shr rax, 16 #2^17
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g17
shr rax, 8 #2^9
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g9
shr rax, 4 #2^5
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g5
shr rax, 3 #2^2
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g2
mov rdi, 0x2 #Bereich gefunden; Konstante = 2^1
jmp .Lseries
.g2:
mov rdi, 0x4 #Bereich gefunden; Konstante = 2^2
jmp .Lseries
.g5:
shl rax, 2 #2^7
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g7
mov rdi, 0x8 #Bereich gefunden; Konstante = 2^3
jmp .Lseries
.g7:
mov rdi, 0x10 #Bereich gefunden; Konstante = 2^4
jmp .Lseries
.g9:
shl rax, 4 #2^13
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g13
shr rax, 2 #2^11
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g11
mov rdi, 0x20 #Bereich gefunden; Konstante = 2^5
jmp .Lseries
.g11:
mov rdi, 0x40 #Bereich gefunden; Konstante = 2^6
jmp .Lseries
.g13:
shl rax, 2 #2^15
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g15
mov rdi, 0x80 #Bereich gefunden; Konstante = 2^7
jmp .Lseries
.g15:
mov rdi, 0x100 #Bereich gefunden; Konstante = 2^8
jmp .Lseries

.g17:
shl rax, 8 #2^25
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g25
shr rax, 4 #2^21
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g21
shr rax, 2 #2^19
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g19
mov rdi, 0x200 #Bereich gefunden; Konstante = 2^9
jmp .Lseries
.g19:
mov rdi, 0x400 #Bereich gefunden; Konstante = 2^10
jmp .Lseries
.g21:
shl rax, 2 #2^23
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g23
mov rdi, 0x800 #Bereich gefunden; Konstante = 2^11
jmp .Lseries
.g23:
mov rdi, 0x1000 #Bereich gefunden; Konstante = 2^12
jmp .Lseries
.g25:
shl rax, 4 #2^29
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g29
shr rax, 2 #2^27
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g27
mov rdi, 0x2000 #Bereich gefunden; Konstante = 2^13
jmp .Lseries
.g27:
mov rdi, 0x4000 #Bereich gefunden; Konstante = 2^14
jmp .Lseries
.g29:
shl rax, 2 #2^31
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g31
mov rdi, 0x8000 #Bereich gefunden; Konstante = 2^15
jmp .Lseries
.g31:
mov rdi, 0x10000 #Bereich gefunden; Konstante = 2^16
jmp .Lseries

.g33:
shl rax, 16 #2^49
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g49
shr rax, 8 #2^41
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g41
shr rax, 4 #2^37
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g37
shr rax, 2 #2^35
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g35
mov rdi, 0x20000 #Bereich gefunden; Konstante = 2^17
jmp .Lseries
.g35:
mov rdi, 0x40000 #Bereich gefunden; Konstante = 2^18
jmp .Lseries
.g37:
shl rax, 2 #2^39
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g39
mov rdi, 0x80000 #Bereich gefunden; Konstante = 2^19
jmp .Lseries
.g39:
mov rdi, 0x100000 #Bereich gefunden; Konstante = 2^20
jmp .Lseries
.g41:
shl rax, 4 #2^45
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g45
shr rax, 2 #2^43
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g43
mov rdi, 0x200000 #Bereich gefunden; Konstante = 2^21
jmp .Lseries
.g43:
mov rdi, 0x400000 #Bereich gefunden; Konstante = 2^22
jmp .Lseries
.g45:
shl rax, 2 #2^47
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g47
mov rdi, 0x800000 #Bereich gefunden; Konstante = 2^23
jmp .Lseries
.g47:
mov rdi, 0x1000000 #Bereich gefunden; Konstante = 2^24
jmp .Lseries

.g49:
shl rax, 8 #2^57
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g57
shr rax, 4 #2^53
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g53
shr rax, 2 #2^51
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g51
mov rdi, 0x2000000 #Bereich gefunden; Konstante = 2^25
jmp .Lseries
.g51:
mov rdi, 0x4000000 #Bereich gefunden; Konstante = 2^26
jmp .Lseries
.g53:
shl rax, 2 #2^55
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g55
mov rdi, 0x8000000 #Bereich gefunden; Konstante = 2^27
jmp .Lseries
.g55:
mov rdi, 0x10000000 #Bereich gefunden; Konstante = 2^28
jmp .Lseries
.g57:
shl rax, 4 #2^61
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g61
shr rax, 2 #2^59
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g59
mov rdi, 0x20000000 #Bereich gefunden; Konstante = 2^29
jmp .Lseries
.g59:
mov rdi, 0x40000000 #Bereich gefunden; Konstante = 2^30
jmp .Lseries
.g61:
shl rax, 2 #2^63
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g63
mov rdi, 0x80000000 #Bereich gefunden; Konstante = 2^31
jmp .Lseries
.g63:
shl rax, 1 #2^64
cvtsi2ss xmm1, rax
ucomiss xmm0, xmm1
ja .g64
mov rdi, 0x100000000 #Bereich gefunden; Konstante = 2^32
jmp .Lseries
.g64:
mov rdi, 0x200000000 #Bereich gefunden; Konstante = 2^33
.Lseries:
#xmm0: x^1
#xmm1: x^2
#xmm3: x^4
#xmm4: x^8
#xmm5: x^3
#xmm6: x^5
#xmm7: x^6
#xmm8: x^7
cvtsi2ss xmm1, rdi
movss xmm2, xmm1 #save für später
mulss xmm1, xmm1
divss xmm0, xmm1 #xmm0 = xmm0/xmm1^2
subss xmm0, [rip + .Lsub] #x^1
movss xmm1, xmm0 
mulss xmm1, xmm1 
movss xmm3, xmm1
mulss xmm3, xmm3 
movss xmm4, xmm3 
mulss xmm4, xmm4 
movss xmm5, xmm0 
mulss xmm5, xmm1 
movss xmm6, xmm5
mulss xmm6, xmm1
movss xmm7, xmm5
mulss xmm7, xmm7
movss xmm8, xmm5
mulss xmm8, xmm3

#xmm0 auf simd vorbereiten xmm0 = [x^1, x^2, x^3, x^4]
#xmm6 auf simd vorbereiten xmm6 = [x^5, x^6, x^7, x^8]
#xmm3 auf simd vorbereiten xmm3 = [first, second, third, fourth]
#xmm4 auf simd vorbereiten xmm4 = [fifth, sixth, seventh, eighth]
shufps xmm0, xmm0, 0x24
movss xmm0, xmm1 
shufps xmm0, xmm0, 0xc8
movss xmm0, xmm5
shufps xmm0, xmm0, 0xe0
movss xmm0, xmm3

shufps xmm6, xmm6, 0x24
movss xmm6, xmm7 
shufps xmm6, xmm6, 0xc8
movss xmm6, xmm8
shufps xmm6, xmm6, 0xe0
movss xmm6, xmm4

movss xmm1, [rip + .Lfirst]
movss xmm3, xmm1
shufps xmm3, xmm3, 0x24
movss xmm1, [rip + .Lsecond]
movss xmm3, xmm1
shufps xmm3, xmm3, 0xc8
movss xmm1, [rip + .Lthird]
movss xmm3, xmm1
shufps xmm3, xmm3, 0xe0
movss xmm1, [rip + .Lfourth]
movss xmm3, xmm1

movss xmm1, [rip + .Lfifth]
movss xmm4, xmm1
shufps xmm4, xmm4, 0x24
movss xmm1, [rip + .Lsixth]
movss xmm4, xmm1
shufps xmm4, xmm4, 0xc8
movss xmm1, [rip + .Lseventh]
movss xmm4, xmm1
shufps xmm4, xmm4, 0xe0
movss xmm1, [rip + .Leigth]
movss xmm4, xmm1

mulps xmm0, xmm3
mulps xmm6, xmm4

addps xmm0, xmm6
haddps xmm0, xmm0
haddps xmm0, xmm0

addss xmm0, [rip + .Lzero]
mulss xmm0, xmm2
ret
