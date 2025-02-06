global main
extern puts
extern gets


%macro pedir_movimiento 0
    mov al, [turno]
    cmp al, 0
    je zorro_turno  ; Si turno es 0, salta a zorro_turno
    cmp al, 1
    je ocas_turno   ; Si turno es 1, salta a ocas_turno

zorro_turno:
    mPuts movimientos_zorro
    mGets comando
    call validar_comando
    jmp terminado      ; Salta al final después de imprimir el mensaje del zorro

ocas_turno:
    mPuts movimientos_ocas
    mGets comando
    call validar_comando

terminado:

%endmacro

%macro validar_comando 0

    mov rcx, 0

inicio_validar_comando:
    cmp rcx,[comando]
    je fin_validar_comando
    inc rcx
    cmp rcx,8
    je comando_invalido
    jmp inicio
fin_validar_comando:
%endmacro

%macro mPuts 0
    sub    rsp,8
    call   puts
    add    rsp,8
%endmacro

%macro mGets 1
    mov    rdi,%1
    sub    rsp,8
    call   gets
    add    rsp,8
%endmacro

section .data
    ingreso_zorro   db "1) Arriba",10,"2) Abajo",10,"3) Izquierda",10,"4) Derecha",10,"5) Arriba/Izquierda",10,"6) Arriba/Derecha",10,"7) Abajo/Izquierda",10,"8) Abajo/Derecha",0
    ingreso_ocas   db "1) Arriba",10,"2) Abajo",10,"3) Izquierda",10,"4) Derecha",0
    movimientos db "Ingrese el movimiento que quiera realizar (indice numerico): ",0
    turno db 0

section .bss
    comando resb 100

section .text
main:
    mov     rdi,ingreso_zorro
    mPuts
    mov     rdi,movimientos
    mPuts
    mov     rdi,ingreso_ocas
    mPuts   
    mov     rdi,movimientos
    mPuts
    ret



    ddd     db  "<"
    val1    db 0,0,0,0


    mov     cl,[ddd]
    lea     rbx,[mat]
    mov     rdx,0
ne:
    add     dx,[mat+rsi]
    add     rsi,122
    loop    ne