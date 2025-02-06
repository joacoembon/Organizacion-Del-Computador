global main
extern puts
extern gets
extern printf
%macro mPuts 1
    mov    rdi,%1 
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

%macro procesar_movimiento 3 ;recibe la grilla, una columna, una fila y el nuevo caracter
    calcular_posicion %2, %3 ;deja la posicion a moverse en rcx
    verificar_posicion %2, %3 ;verifica que la posicion sea valida
    es_valido ;verifica que se pueda mover a esa posicion
    modificar_grilla %4 ;mueve el caracte recibido a la posicion dada.
%endmacro

%macro calcular_posicion 2 ;recibe una columna y una fila
    mov rcx, %1
    mov rbx, %2
    imul rcx, qword[long_elem]
    imul rbx, qword[long_fila]
    add rcx, rbx 
%endmacro

%macro verificar_posicion 0 ;verifica que la posicion indicada este dentro de la grilla
    cmp rcx, qword[longitud_grilla]
    jge invalido
    cmp rcx, 0
    jl invalido
%endmacro

%macro es_valido 0
    mov rbx, grilla
    add rbx, rcx
    cmp [rbx], caracter_invalido
    je invalido
%endmacro

%macro invalido 0
    mPuts mensaje_error_posicion
    ret
%endmacro

%macro modificar_grilla 1
    mov byte[rbx], %1
    ret
%endmacro

section .data
    pedir_comando db "Por favor ingrese un movimiento: "
    pedir_posicion db "Por favor ingrese a donde moverse: "
    mensaje_error_posicion db "Error: no se puede mover a esa posicion"
    comando_arriba db "arriba"
    grilla db -1,-1,2,2,2,-1,-1
    fila2 db -1,-1,2,2,2,-1,-1
    fila3 db 2,2,2,2,2,2,2
    fila4 db 2,0,0,0,0,0,2
    fila5 db 2,0,0,1,0,0,2
    fila6 db -1,-1,0,0,0,-1,-1
    fila7 db -1,-1,0,0,0,-1,-1
    longitud_grilla dq 49
    long_elem dq 1
    long_fila dq 7
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
    mPuts pedir_comando
    mGets comando
    call procesar_comando_zorro 
    ret

procesar_comando_zorro:
    cmp comando, comando_arriba
    je moverse_arriba_zorro
    mPuts pedir_posicion
    mGets comando
    cmp comando, comando_arriba
    je moverse_arriba_zorro
    ret
moverse_arriba_zorro:
    procesar_movimiento grilla, posicion_zorro_x, posicion_zorro_y, caracter_vacio
    add posicion_zorro_x, 1
    procesar_movimiento grilla, posicion_zorro_x, posicion_zorro_y, caracter_zorro
