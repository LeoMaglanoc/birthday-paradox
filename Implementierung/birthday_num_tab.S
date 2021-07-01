.intel_syntax noprefix
.global birthday_num_tab

.section .rodata
.Lone:
	.float 1

.Ltwo:
    .float 2

.Lformula_ln_constant:
    .float 5.54517744447

.Ltwo_power_63:
    .float 9223372036854775808

.Llog2kConstant:
    .float 0.00101429

.LbeginningConstant:
    .float 363408.749




.section .text
# whole birthday-formula without sqrt-part
# Input: 
# rdi = unsigned long n
# rsi = Table-Pointer
# Output: xmm0 = float
birthday_num_tab:
    call .Lbirthday_sqrt_tab 
    movss xmm1, [rip + .Lone]
    addss xmm0, xmm1
    movss xmm1, [rip + .Ltwo]
    divss xmm0, xmm1
    ret

# sqrt-part of birthday-formula
# Input:
# rdi = unsigned long n
# rsi = Table-Pointer
# Output: xmm0 = float
.Lbirthday_sqrt_tab:
    cmp rdi, 65536
    jae .Lheron
    # lookup_table has the directly calculated value
    movss xmm0, [rsi + rdi * 4]
    ret
.Lheron:
    call .Lconvert_unsigned
    # preparing number like in the formula under square
    movss xmm1, [rip + .Lformula_ln_constant]
    mulss xmm0, xmm1
    movss xmm1, [rip + .Lone]
    addss xmm0, xmm1
    movss xmm4, xmm0
    # using lookup_table as a first approximation
    mov rdi, rsi
    lea rdi, [rdi + 262144] # (2^16) * 4
    call .LcalculateIndexIfExponential 
    # applying actual heron formula
    mov ecx, 3     # how many iterations of heron
    movss xmm1, xmm0    # save first approximation
    movss xmm0, xmm4
    movss xmm3, [rip + .Ltwo]     # halving constant
.Lloop:
    cmp ecx, 0
    jle .Lend_birthday_sqrt_tab
    movss xmm2, xmm0    # xmm0 = number we want the sqrt of
    divss xmm2, xmm1    # xmm1 = current approximation
    addss xmm2, xmm1    # xmm2 = next approximation
    divss xmm2, xmm3
    movss xmm1, xmm2
    dec ecx
    jmp .Lloop
.Lend_birthday_sqrt_tab:
    movss xmm0, xmm2
    ret

# converts unsigned long to float
# Input: rdi = unsigned long n
# Output: xmm0 = float
.Lconvert_unsigned:
    cmp rdi, 0
    jl .Lnegative
    cvtsi2ss xmm0, rdi
    ret
.Lnegative:
    mov r10, 0x7fffffffffffffff     # Bitmask for throwing out last bit
    and rdi, r10
    cvtsi2ss xmm0, rdi
    movss xmm1, [rip + .Ltwo_power_63] # add last bit
    addss xmm0, xmm1
    ret

# returns value from table by directly calculating index if table is exponentially spaced
# Input: 
# xmm0 = find that number
# rdi = Pointer of table
# Output: xmm0 = value of number in table
.LcalculateIndexIfExponential:
    subss xmm0, [rip + .LbeginningConstant]
    call .LgetExponent
    cvtsi2ss xmm0, rax
    movss xmm1, [rip + .Llog2kConstant]
    divss xmm0, xmm1
    cvtss2si rax, xmm0
    movss xmm0, [rdi + rax * 4]
    ret

# returns exponent of float-value
# Input: xmm0 = number with exponent
# Output: rax = exponent
.LgetExponent:
    mov r10, 0b01111111100000000000000000000000 # bitmask for exponent
    movd xmm1, r10 
    pand xmm0, xmm1
    movd rax, xmm0
    shr rax, 23
    sub rax, 127
    ret










