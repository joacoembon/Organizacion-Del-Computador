global main
extern puts
extern gets
extern printf
%macro mPrintf 1
    mov    rdi,%1 
    sub    rsp,8
    call   printf
    add    rsp,8
%endmacro

%macro transformarAxRax 0
    cwd
    cwde
    cdq
%endmacro

%macro mGets 1
    mov    rdi,%1
    sub    rsp,8
    call   gets
    add    rsp,8
%endmacro

section .data
    pedir_comando db "Por favor ingrese un movimiento: "
    pedir_posicion db "Por favor ingrese a donde moverse: "
    mensaje_error_posicion db "Error: no se puede mover a esa posicion"
    comando_arriba db "arriba"
    grilla db -1,-1,79,79,79,-1,-1
    fila2 db -1,-1,79,79,79,-1,-1
    fila3 db 79,79,79,79,79,79,79
    fila4 db 79,32,32,32,32,32,79
    fila5 db 79,32,32,88,32,32,79
    fila6 db -1,-1,32,32,32,-1,-1
    fila7 db -1,-1,32,32,32,-1,-1
    longitud_grilla dq 49
    mensaje db "|%c|", 0
    mensaje_vacio db "   ",0
    salto_de_linea db 10,0
    cant_filas dw 7
    fila_actual dw 0
    desplazamiento dw 0
    long_elem db 1
    long_fila dw 7
    caracter_invalido db -1
    caracter_vacio db 0
    caracter_zorro db 1
    caracter_oca db 2
    posicion_zorro_x dw 3
    posicion_zorro_y dw 4
section .bss
    comando resb 100
section .text
main:
    sub rsp,8
    call loopArray
    add rsp,8
    ret

loopArray:
    mov ax, [fila_actual]
    cmp ax, [cant_filas]
    je finalizarLoop
    mov ax, [desplazamiento]
    cmp ax, [long_fila]
    je proxima_fila
    mov ax, [fila_actual]
    imul ax, [long_fila]
    add ax, [desplazamiento]
    transformarAxRax
    mov rbx, grilla
    add rbx, rax
    mov si,-1
mov al, [caracter_invalido]
    mov cl, [rbx]
    cmp cl, al
    je imprimir_vacio
    mov al, [rbx]
    cbw
    transformarAxRax
    mov rsi, rax
    mPrintf mensaje
    jmp continuarLoop

imprimir_vacio:
    mPrintf mensaje_vacio
    jmp continuarLoop

continuarLoop:
    mov ax, [desplazamiento]
    inc ax
    mov [desplazamiento], ax
    jmp loopArray

finalizarLoop:
    ret

proxima_fila:
    mPrintf salto_de_linea
    mov ax, [fila_actual]
    inc ax
    mov [fila_actual], ax
    mov word[desplazamiento], 0
    jmp loopArray