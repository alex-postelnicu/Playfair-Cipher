.data
    operatie: .space 100
    cheie: .space 100
    mesaj: .space 100
    matrix: .space 25
    used: .space 26
    fscanf: .asciz "%s"
    fprintf: .asciz "%s"
    newLine: .asciz "\n"
    mesaj_nou: .space 100
    perechi: .space 100
    x: .space 1
    y: .space 1
    r1: .space 4
    c1: .space 4
    r2: .space 4
    c2: .space 4
    indexX: .space 4
    indexY: .space 4
.text
.global main
main:
    pushl $operatie
    pushl $fscanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $cheie
    pushl $fscanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $mesaj
    pushl $fscanf
    call scanf
    popl %ebx
    popl %ebx

    lea used, %edi
    movl $0, %ecx

et_used:
    cmp $26, %ecx
    je et_matrice

    movb $0, (%edi, %ecx, 1)
    incl %ecx
    jmp et_used

et_matrice:
    lea matrix, %edi
    lea cheie, %esi
    movl $0, %ecx

et_cheie:
    movb (%esi), %al
    cmpb $0, %al
    je et_umplere_matrice

    cmpb $'J', %al
    jne et_cheie_fara_j

    movb $'I', %al

et_cheie_fara_j:
    subb $'A', %al
    movzbl %al, %ebx
    cmpb $1, used(%ebx)
    je et_cheie_next

    movb $1, used(%ebx)
    addb $'A', %al
    movb %al, (%edi, %ecx, 1)
    incl %ecx

et_cheie_next:
    incl %esi
    jmp et_cheie

et_umplere_matrice:
    movl %ecx, %eax
    movl $0, %ecx

et_for_litera:
    cmp $26, %ecx
    je et_codare_mesaj

    cmp $9, %ecx
    je et_skip_litera

    cmpb $1, used(%ecx)
    je et_skip_litera

    movb $1, used(%ecx)
    movl %ecx, %ebx
    addb $'A', %bl
    movb %bl, (%edi, %eax, 1)
    incl %eax

et_skip_litera:
    incl %ecx
    jmp et_for_litera

et_codare_mesaj:
    lea mesaj, %esi
    lea mesaj_nou, %edi

et_for_mesaj:
    movb (%esi), %al
    cmpb $0, %al
    je et_perechi

    cmpb $' ', %al
    je et_skip_mesaj

    cmpb $'J', %al
    jne et_mesaj_nou

    movb $'I', %al

et_mesaj_nou:
    movb %al, (%edi)
    incl %edi

et_skip_mesaj:
    incl %esi
    jmp et_for_mesaj

et_perechi:
    movb $0, (%edi)
    lea mesaj_nou, %esi
    lea perechi, %edi

et_for_perechi:
    movb (%esi), %al
    cmpb $0, %al
    je et_afisare

    movb 1(%esi), %bl
    cmpb $0, %bl
    je et_ult_litera

    cmpb %al, %bl
    je et_x

    movb %al, (%edi)
    movb %bl, 1(%edi)
    addl $2, %edi
    addl $2, %esi
    jmp et_for_perechi

et_ult_litera:
    movb %al, (%edi)
    movb $'X', 1(%edi)
    addl $2, %edi
    incl %esi
    jmp et_for_perechi

et_x:
    movb %al, (%edi)
    movb $'X', 1(%edi)
    addl $2, %edi
    incl %esi
    jmp et_for_perechi

et_afisare:
    movb $0, (%edi)
    lea perechi, %esi
    lea matrix, %edi

et_for_encodare:
    movb (%esi), %al
    cmpb $0, %al
    je et_exit

    movb (%esi), %al
    movb %al, x
    movb 1(%esi), %al
    movb %al, y
    movl $0, %ecx

et_for_x:
    movb x, %al
    cmpb (%edi, %ecx, 1), %al
    je et_x_gasit

    incl %ecx
    jmp et_for_x

et_x_gasit:
    movl %ecx, %eax
    xorl %edx, %edx
    movl $5, %ebx
    divl %ebx
    movl %eax, r1
    movl %edx, c1
    xorl %ecx, %ecx

et_for_y:
    movb y, %al
    cmpb (%edi, %ecx, 1), %al
    je et_y_gasit

    incl %ecx
    jmp et_for_y

et_y_gasit:
    movl %ecx, %eax
    xorl %edx, %edx
    movl $5, %ebx
    divl %ebx
    movl %eax, r2
    movl %edx, c2

et_el_gasite:
    movl $5, %ebx
    movl r1, %eax
    xorl %edx, %edx
    mull %ebx
    addl c1, %eax
    movl %eax, indexX

    movl $5, %ebx
    movl r2, %eax
    xorl %edx, %edx
    mull %ebx
    addl c2, %eax
    movl %eax, indexY

    movl r1, %eax
    cmpl %eax, r2
    je et_linie

    movl c1, %eax
    cmpl %eax, c2
    je et_coloana

    jmp et_dreptunghi

et_linie:
    movl indexX, %ecx
    movl c1, %eax
    cmpl $4, %eax
    je et_x_linie

    incl %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, (%esi)

et_verif_linie_y:
    movl indexY, %ecx
    movl c2, %eax
    cmpl $4, %eax
    je et_y_linie

    incl %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, 1(%esi)
    jmp et_loop

et_x_linie:
    subl $4, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, (%esi)
    jmp et_verif_linie_y

et_y_linie:
    subl $4, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, 1(%esi)
    jmp et_loop

et_coloana:
    movl indexX, %ecx
    movl r1, %eax
    cmpl $4, %eax
    je et_x_coloana

    addl $5, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, (%esi)

et_verif_coloana_y:
    movl indexY, %ecx
    movl r2, %eax
    cmpl $4, %eax
    je et_y_coloana

    addl $5, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, 1(%esi)
    jmp et_loop

et_x_coloana:
    subl $20, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, (%esi)
    jmp et_verif_coloana_y

et_y_coloana:
    subl $20, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, 1(%esi)
    jmp et_loop

et_dreptunghi:
    movl c1, %eax
    cmp c2, %eax
    jb et_c1_c2
    
    movl c1, %ebx
    subl c2, %ebx
    movl indexX, %ecx
    subl %ebx, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, (%esi)
    movl indexY, %ecx
    addl %ebx, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, 1(%esi)
    jmp et_loop

et_c1_c2:
    movl c2, %ebx
    subl c1, %ebx
    movl indexX, %ecx
    addl %ebx, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, (%esi)
    movl indexY, %ecx
    subl %ebx, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, 1(%esi)
    jmp et_loop

et_loop:
    addl $2, %esi
    jmp et_for_encodare

et_exit:
    movb $0, (%esi)
    pushl $perechi
    pushl $fprintf
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx

    mov $4, %eax
    mov $1, %ebx
    mov $newLine, %ecx
    mov $2, %edx
    int $0x80
    
    movl $1, %eax
    movl $0, %ebx
    int $0x80
