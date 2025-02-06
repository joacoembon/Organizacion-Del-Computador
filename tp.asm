global main
extern gets
extern printf
extern sscanf
extern fopen
extern fwrite
extern fclose
extern fread
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

%macro mSscanf 1
    mov rdi,%1
    mov rsi,formato_numero
    mov rdx,numero
    sub rsp,8
    call sscanf
    add rsp,8
    mov qword[%1],0
%endmacro

%macro mGets 1
    mov    rdi,%1
    sub    rsp,8
    call   gets
    add    rsp,8
%endmacro

%macro mOpen 0
    mov rdi,nombre_archivo
    sub rsp,8
    call fopen
    add rsp,8
    cmp rax,0
    jle main
    mov qword[id_archivo],rax
%endmacro

%macro mClose 0
    mov rdi,[id_archivo]
    sub rsp,8
    call fclose
    add rsp,8
%endmacro

%macro mWrite 0
    mov rcx,[id_archivo]
    sub rsp,8
    call fwrite
    add rsp,8
%endmacro

%macro mRead 0
    mov rcx,[id_archivo]
    sub rsp,8
    call fread
    add rsp,8
%endmacro

%macro escribirByte 1
    mov rdi,%1
    mov rsi,1
    mov rdx,1
    mWrite
%endmacro

%macro leerByte 1
    mov rdi,%1
    mov rsi,1
    mov rdx,1
    mRead
%endmacro

section .data
    ;MENSAJES
    coordenada_y_oca    db "Ingrese numero de fila de la oca (1 a 7 de arriba hacia abajo): ",0
    coordenada_x_oca    db "Ingrese numero de columna de la oca (1 a 7 de izquierda a derecha): ",0
    ingreso_zorro   db "1) Arriba",10,"2) Abajo",10,"3) Izquierda",10,"4) Derecha",10,"5) Arriba/Izquierda",10,"6) Arriba/Derecha",10,"7) Abajo/Izquierda",10,"8) Abajo/Derecha",10,"Escribir 'exit' para salir",10,0
    ingreso_ocas   db "1) Abajo",10,"2) Izquierda",10,"3) Derecha",10,"Escribir 'exit' para salir",10,0
    pedir_movimiento db "Ingrese el movimiento que quiera realizar (indice numerico): ",0
    pedir_movimiento_o db "Ingrese el movimiento que quiera realizar (indice numerico) (para volver al menu anterior ingrese back): ",0
    pedir_posicion db "Por favor ingrese a donde moverse: ",0
    mensaje_error_posicion db "Error: no se puede mover a esa posicion",10,0
    mensaje_comando_invalido db "Por favor ingrese un comando valido",10,0
    mensaje_oca_error db "Por favor ingrese una posicion valida",10,0
    mensaje_oca_error_acorralada db "Error: la oca ingresada no puede moverse",10,0
    mensajeTurnoZorro db "Turno del Zorro",10,"Escribir 'exit' para salir",10,0
    mensajeTurnoOcas db "Turno de las Ocas",10,"Escribir 'exit' para salir",10,0
    mensajeGanoZorro db "La partida finalizo, gano el zorro!",10,0
    mensajeGanaronOcas db "La partida finalizo, ganaron las ocas!",10,0
    mensajeOpcionalGrilla db "(Escriba 'exit' para salir)",10,"Quiere personalizar la grilla? (s/n): ",0
    mensajeElegirGrilla db "Por favor elija una de las opciones (indice numerico): ",0
    mensajeOpcionesGrilla db "1) Grilla original",10,"2) Grilla rotada 90 grados hacia la derecha",10,"3) Grilla rotada 90 grados hacia la izquierda",10,"4) Grilla rotada 180 grados",10,0
    mensajeOpcionalZorro db "(Escriba 'exit' para salir)",10,"Quiere personalizar al zorro? (s/n): ",0
    mensajeOpcionesZorro db "1) X",10,"2) x",10,"3) *",10,"4) $",10,0
    mensajeOpcionalOcas db "(Escriba 'exit' para salir)",10,"Quiere personalizar a las ocas? (s/n): ",0
    mensajeOpcionesOcas db "1) O",10,"2) o",10,"3) ^",10,"4) C",10,0
    mensajeGuardarPartida db "Desea guardar la partida? (s/n): ",0
    mensajeGuardadoExitoso db "La partida se ha guardado con exito.",10,0
    mensajeCargarPartida db "(Escriba 'exit' para salir)",10,"Se detecto una partida guardada ¿Desea cargarla? (s/n): ",0
    
    salir dq "exit"
    longitud_grilla dq 49
    mensaje db "|%c|", 0
    mensaje_vacio db "   ",0
    salto_de_linea db 10,0
    cant_filas dw 7
    fila_actual dw 0
    desplazamiento dw 0
    long_elem dq 1
    long_fila dw 7
    caracter_invalido db -1
    numero_vacio db 0
    numero_zorro db 1
    numero_oca db 2
    caracter_vacio db 32
    caracter_zorro db 88
    caracter_oca db 79
    posicion_zorro_x db 3
    posicion_zorro_y db 4
    turno db 0
    es_valido db 0
    pos_oca_valida db 1
    formato_numero db "%hhi",0
    arriba db 1
    abajo db 2
    izquierda db 3
    derecha db 4
    volver_atras dq "back"
    arriba_izquierda db 5
    arriba_derecha db 6
    abajo_izquierda db 7
    abajo_derecha db 8
    ocas_comidas db 0
    contador_validacion_acorralado db 1
    contador_validacion_oca_acorralada db 1
    ;ESTADISTICAS
    texto_movs_zorro db "Estadisticas de movimiento del zorro",10,0
    movs_zorro_Arriba_texto db "Hacia Arriba: %hhi",10,0
    movs_zorro_Arriba db 0
    movs_zorro_Abajo_texto db "Hacia Abajo: %hhi",10,0
    movs_zorro_Abajo db 0
    movs_zorro_Izquierda_texto db "Hacia Izquierda: %hhi",10,0
    movs_zorro_Izquierda db 0
    movs_zorro_Derecha_texto db "Hacia Derecha: %hhi",10,0
    movs_zorro_Derecha db 0
    movs_zorro_ArribaIzquierda_texto db "Hacia Arriba/Izquierda: %hhi",10,0
    movs_zorro_ArribaIzquierda db 0
    movs_zorro_ArribaDerecha_texto db "Hacia Arriba/Derecha: %hhi",10,0
    movs_zorro_ArribaDerecha db 0
    movs_zorro_AbajoIzquierda_texto db "Hacia Abajo/Izquierda: %hhi",10,0
    movs_zorro_AbajoIzquierda db 0
    movs_zorro_AbajoDerecha_texto db "Hacia Abajo/Derecha: %hhi",10,0
    movs_zorro_AbajoDerecha db 0
    ;PERSONALIZACION
    comando_si dq "s"
    comando_no dq "n"
    opcion_2 db 2
    opcion_3 db 3
    opcion_4 db 4
    nombre_archivo db "savegame",0
    modo_leer db "r",0
    modo_escribir db "w",0
    se_cargo_partida db 0
    ;GRILLAS
    grilla_default db -1,-1,2,2,2,-1,-1
    fila2 db -1,-1,2,2,2,-1,-1
    fila3 db 2,2,2,2,2,2,2
    fila4 db 2,0,0,0,0,0,2
    fila5 db 2,0,0,1,0,0,2
    fila6 db -1,-1,0,0,0,-1,-1
    fila7 db -1,-1,0,0,0,-1,-1
    grilla_der db -1,-1,2,2,2,-1,-1
    f_2 db -1,-1,0,0,2,-1,-1
    f_3 db 0,0,0,0,2,2,2
    f_4 db 0,0,1,0,2,2,2
    f_5 db 0,0,0,0,2,2,2
    f_6 db -1,-1,0,0,2,-1,-1
    f_7 db -1,-1,2,2,2,-1,-1
    grilla_izq db -1,-1,2,2,2,-1,-1
    fil_2 db -1,-1,2,0,0,-1,-1
    fil_3 db 2,2,2,0,0,0,0,
    fil_4 db 2,2,2,1,0,0,0
    fil_5 db 2,2,2,0,0,0,0
    fil_6 db -1,-1,2,0,0,-1,-1
    fil_7 db -1,-1,2,2,2,-1,-1
    grilla_180 db -1,-1,0,0,0,-1,-1
    fi_2 db -1,-1,0,0,0,-1,-1
    fi_3 db 2,0,0,1,0,0,2
    fi_4 db 2,0,0,0,0,0,2
    fi_5 db 2,2,2,2,2,2,2
    fi_6 db -1,-1,2,2,2,-1,-1
    fi_7 db -1,-1,2,2,2,-1,-1
    opcion_default db 1
    girar_derecha db 2
    girar_izquierda db 3
    girar_180 db 4
    ;VARIABLES PARA OPCIONES INICIALES Y SALIDA
    personalizo_elementos db 0
    partida_empezada db 0
    salio_partida db 0
section .bss
    grilla resq 1
    puede_moverse resb 1
    movimiento_x resb 1
    movimiento_y resb 1
    posicion_oca_x resb 1
    posicion_oca_y resb 1
    comando resb 100
    num_fila resb 100
    num_columna resb 100 
    numero resb 1
    id_archivo resq 1
section .text
main:
    cmp byte[se_cargo_partida],0
    je cargar_partida
    cmp byte[personalizo_elementos],0
    je personalizar_elementos
    sub rsp,8
    call loopArray
    add rsp,8
    mov byte[puede_moverse],0
    mov byte[contador_validacion_acorralado],1
    sub rsp,8
    call validar_zorro_acorralado
    add rsp,8
    cmp byte[puede_moverse],0
    je perdio_zorro
    cmp byte[ocas_comidas],12
    jge gano_zorro
    cmp byte[turno],0
    je turnoZorro
    jne turnoOcas
    ret

gano_zorro:
    mPrintf mensajeGanoZorro
    jmp estadisticas_zorro

perdio_zorro:
    mPrintf mensajeGanaronOcas
    jmp estadisticas_zorro

estadisticas_zorro:
    mPrintf texto_movs_zorro
    mov rsi,[movs_zorro_Arriba]
    mPrintf movs_zorro_Arriba_texto
    mov rsi,[movs_zorro_Abajo]
    mPrintf movs_zorro_Abajo_texto
    mov rsi,[movs_zorro_Izquierda]
    mPrintf movs_zorro_Izquierda_texto
    mov rsi,[movs_zorro_Derecha]
    mPrintf movs_zorro_Derecha_texto
    mov rsi,[movs_zorro_ArribaIzquierda]
    mPrintf movs_zorro_ArribaIzquierda_texto
    mov rsi,[movs_zorro_ArribaDerecha]
    mPrintf movs_zorro_ArribaDerecha_texto
    mov rsi,[movs_zorro_AbajoIzquierda]
    mPrintf movs_zorro_AbajoIzquierda_texto
    mov rsi,[movs_zorro_AbajoDerecha]
    mPrintf movs_zorro_AbajoDerecha_texto
    jmp finalizar_movimiento


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
    mov rbx, [grilla]
    add rbx, rax
    mov al, [rbx]
    cmp al, [caracter_invalido]
    je imprimir_vacio
    cmp al, [numero_zorro]
    je imprimir_zorro
    cmp al, [numero_oca]
    je imprimir_oca
    cmp al, [numero_vacio]
    je imprimir_espacio
    jmp continuarLoop

imprimir_zorro:
    mov al, [caracter_zorro]
    cbw
    transformarAxRax
    mov rsi, rax
    mPrintf mensaje
    jmp continuarLoop

imprimir_oca:
    mov al, [caracter_oca]
    cbw
    transformarAxRax
    mov rsi, rax
    mPrintf mensaje
    jmp continuarLoop

imprimir_espacio:
    mov al, [caracter_vacio]
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
    mov word[fila_actual],0
    mov word[desplazamiento],0
    ret

proxima_fila:
    mPrintf salto_de_linea
    mov ax, [fila_actual]
    inc ax
    mov [fila_actual],ax
    mov word[desplazamiento],0
    jmp loopArray

turnoZorro:
    mPrintf mensajeTurnoZorro
    mPrintf ingreso_zorro
    mPrintf pedir_movimiento
    mGets comando
    mov rax,[comando]
    mov rcx,[salir]
    cmp rax,rcx
    je  terminar_partida
    mSscanf comando
    cmp rax,1
    jl comando_invalido
    mov al,[numero]
    cmp byte[numero],0
    jle comando_invalido
    cmp byte[numero],8
    jg comando_invalido
    sub rsp,8
    call procesar_comando_zorro
    add rsp,8
    sub rsp,8
    call validar_movimiento_zorro
    add rsp,8
    sub rsp,8
    call mover_zorro
    add rsp,8
    cmp byte[es_valido],0
    je main
    sub rsp,8
    call sumar_estadistica
    add rsp,8
    inc byte[turno]
    jmp main

comando_invalido:
    mPrintf mensaje_comando_invalido
    jmp main

sumar_estadistica:
    cmp byte[es_valido],0
    je finalizar_movimiento
    cmp byte[numero],1
    je sumar_arriba
    cmp byte[numero],2
    je sumar_abajo
    cmp byte[numero],3
    je sumar_izquierda
    cmp byte[numero],4
    je sumar_derecha
    cmp byte[numero],5
    je sumar_arriba_izquierda
    cmp byte[numero],6
    je sumar_arriba_derecha
    cmp byte[numero],7
    je sumar_abajo_izquierda
    cmp byte[numero],8
    je sumar_abajo_derecha
    ret

sumar_arriba:
    inc byte[movs_zorro_Arriba]
    ret

sumar_abajo:
    inc byte[movs_zorro_Abajo]
    ret

sumar_izquierda:
    inc byte [movs_zorro_Izquierda]
    ret

sumar_derecha:
    inc byte[movs_zorro_Derecha]
    ret

sumar_arriba_izquierda:
    inc byte[movs_zorro_ArribaIzquierda]
    ret

sumar_arriba_derecha:
    inc byte[movs_zorro_ArribaDerecha]
    ret

sumar_abajo_izquierda:
    inc byte[movs_zorro_AbajoIzquierda]
    ret

sumar_abajo_derecha:
    inc byte[movs_zorro_AbajoDerecha]
    ret

mover_zorro:
    cmp byte[es_valido],0
    je finalizar_movimiento
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    cbw
    mov cx,ax
    imul cx,[long_fila]
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    cbw
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,[numero_zorro]
    mov byte[rbx],al
    mov al,[posicion_zorro_y]
    cbw
    imul ax,[long_fila]
    mov cx,ax
    mov al,[posicion_zorro_x]
    cbw
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,[numero_vacio]
    mov byte[rbx],al
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    mov byte[posicion_zorro_x],al
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    mov byte[posicion_zorro_y],al
    jmp finalizar_movimiento

terminar_partida:
    mov qword[comando],0 ;limpio el comando para evitar errores
    cmp byte[partida_empezada],0
    je finalizar_movimiento
    mPrintf mensajeGuardarPartida
    mGets comando
    mov rax,[comando]
    cmp rax,[comando_si]
    je guardar_partida
    cmp rax,[comando_no]
    je finalizar_movimiento
    mPrintf mensaje_comando_invalido
    jmp terminar_partida

finalizar_movimiento:
    ret

validar_movimiento_zorro:
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    cmp al,0
    jl movimiento_invalido
    cmp al,7
    jge movimiento_invalido
    mov cl,[posicion_zorro_y]
    add cl,[movimiento_y]
    cmp cl,0
    jl movimiento_invalido
    cmp cl,7 
    jge movimiento_invalido
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    cbw
    mov cx,ax
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    cbw
    imul ax,[long_fila]
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,byte[rbx]
    cmp al,[caracter_invalido]
    je movimiento_invalido
    cmp al,[numero_oca]
    je verificar_comer_oca
    mov byte[es_valido],1
    ret
    

verificar_comer_oca:
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    add al,[movimiento_x]
    cmp al,0
    jl movimiento_invalido
    cmp al,7
    jge movimiento_invalido
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    add al,[movimiento_y]
    cmp al,0
    jl movimiento_invalido
    cmp al,7
    jge movimiento_invalido
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    add al,[movimiento_x]
    cbw
    mov cx,ax
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    add al,[movimiento_y]
    cbw
    imul ax,[long_fila]
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,byte[rbx]
    cmp al,[numero_vacio]
    jne movimiento_invalido
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    cbw
    mov cx,ax
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    cbw
    imul ax,[long_fila]
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,[numero_vacio]
    mov [rbx],al
    mov al,[movimiento_x]
    add al,[movimiento_x]
    mov byte[movimiento_x],al
    mov al,[movimiento_y]
    add al,[movimiento_y]
    mov byte[movimiento_y],al
    mov byte[es_valido],1
    inc byte[ocas_comidas]
    dec byte[turno]
    ret

movimiento_invalido:
    mov byte[es_valido],0
    mPrintf mensaje_error_posicion
    ret

validar_zorro_acorralado:
    cmp byte[contador_validacion_acorralado],8
    jg finalizarLoop
    mov al,[contador_validacion_acorralado]
    mov byte[numero],al
    sub rsp,8
    call procesar_comando_zorro
    add rsp,8
    sub rsp,8
    call validar_movimiento
    add rsp,8
    cmp byte[es_valido],1
    je zorro_libre
    inc byte[contador_validacion_acorralado]
    jmp validar_zorro_acorralado

validar_movimiento:
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    cmp al,0
    jl movimiento_prohibido
    cmp al,7
    jge movimiento_prohibido
    mov cl,[posicion_zorro_y]
    add cl,[movimiento_y]
    cmp cl,0
    jl movimiento_prohibido
    cmp cl,7 
    jge movimiento_prohibido
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    cbw
    mov cx,ax
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    cbw
    imul ax,[long_fila]
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,byte[rbx]
    cmp al,[caracter_invalido]
    je movimiento_prohibido
    cmp al,[numero_oca]
    je verificar_comer
    mov byte[es_valido],1
    ret
    

verificar_comer:
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    add al,[movimiento_x]
    cmp al,0
    jl movimiento_prohibido
    cmp al,7
    jge movimiento_prohibido
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    add al,[movimiento_y]
    cmp al,0
    jl movimiento_prohibido
    cmp al,7
    jge movimiento_prohibido
    mov al,[posicion_zorro_x]
    add al,[movimiento_x]
    add al,[movimiento_x]
    cbw
    mov cx,ax
    mov al,[posicion_zorro_y]
    add al,[movimiento_y]
    add al,[movimiento_y]
    cbw
    imul ax,[long_fila]
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,byte[rbx]
    cmp al,[numero_vacio]
    jne movimiento_prohibido
    mov byte[es_valido],1
    ret

movimiento_prohibido:
    mov byte[es_valido],0
    ret

zorro_libre:
    mov byte[puede_moverse],1
    ret

procesar_comando_zorro:
    mov al,[arriba]
    cmp [numero],al
    je mover_arriba
    mov al,[abajo]
    cmp [numero],al
    je mover_abajo
    mov al,[izquierda]
    cmp [numero],al
    je mover_izquierda
    mov al,[derecha]
    cmp [numero],al
    je mover_derecha
    mov al,[arriba_derecha]
    cmp [numero],al
    je mover_arriba_derecha
    mov al,[arriba_izquierda]
    cmp [numero],al
    je mover_arriba_izquierda
    mov al,[abajo_izquierda]
    cmp [numero],al
    je mover_abajo_izquierda
    mov al,[abajo_derecha]
    cmp [numero],al
    je mover_abajo_derecha
    ret

mover_arriba:
    mov byte[movimiento_x], 0
    mov byte[movimiento_y], -1
    ret

mover_abajo:
    mov byte[movimiento_x], 0
    mov byte[movimiento_y], 1
    ret

mover_izquierda:
    mov byte[movimiento_x], -1
    mov byte[movimiento_y], 0
    ret

    
mover_derecha:
    mov byte[movimiento_x], 1
    mov byte[movimiento_y], 0
    ret
    
mover_abajo_derecha:
    mov byte[movimiento_x], 1
    mov byte[movimiento_y], 1
    ret
    
mover_abajo_izquierda:
    mov byte[movimiento_x], -1
    mov byte[movimiento_y], 1
    ret
    
mover_arriba_derecha:
    mov byte[movimiento_x], 1
    mov byte[movimiento_y], -1
    ret
    
mover_arriba_izquierda:
    mov byte[movimiento_x], -1
    mov byte[movimiento_y], -1
    ret
    
turnoOcas:
    mPrintf mensajeTurnoOcas
    mPrintf coordenada_y_oca
    mGets num_fila
    mov rax,[num_fila]
    cmp rax,[salir]
    je  terminar_partida
    mSscanf num_fila
    cmp rax,1
    jl comando_invalido
    mov al,[numero]
    cmp al,0      ;menor igual a 0
    jle comando_invalido
    cmp al,7      ;mayor a 7
    jg comando_invalido
    dec al
    mov byte[posicion_oca_y],al
    
    mPrintf coordenada_x_oca
    mGets num_columna
    mov rax,[num_columna]
    cmp rax,[salir]
    je  terminar_partida
    mSscanf num_columna
    cmp rax,1
    jl comando_invalido
    mov al,[numero]
    cmp al,0      ;menor igual a 0
    jle comando_invalido
    cmp al,7      ;mayor a 7
    jg comando_invalido
    dec al
    mov byte[posicion_oca_x],al

    sub rsp,8
    call validar_posicion_oca
    add rsp,8
    cmp byte[pos_oca_valida],0
    je main

    mPrintf ingreso_ocas
    mPrintf pedir_movimiento_o
    mGets comando
    mov rax,[comando]
    cmp rax,[salir]
    je  terminar_partida
    cmp rax,[volver_atras]
    je main
    mSscanf comando
    cmp rax,1
    jl comando_invalido
    mov al,[numero]
    inc al
    mov [numero],al
    cmp byte[numero],1
    jle comando_invalido
    cmp byte[numero],4
    jg comando_invalido
    sub rsp,8
    call procesar_comando_oca
    add rsp,8
    sub rsp,8
    call validar_movimiento_oca
    add rsp,8
    sub rsp,8
    call mover_oca
    add rsp,8

    cmp byte[es_valido],0
    je main
    dec byte[turno]
    jmp main

validar_posicion_oca:
    mov al,[posicion_oca_y]
    cbw
    imul ax,[long_fila]
    mov cx,ax
    mov al,[posicion_oca_x]
    cbw
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,byte[rbx]
    cmp al,[numero_oca]
    jne mensaje_oca_invalida
    mov byte[puede_moverse],0
    mov byte[contador_validacion_oca_acorralada],1
    sub rsp,8
    call validar_oca_acorralada
    add rsp,8
    cmp byte[puede_moverse],0
    je mensaje_oca_acorralado
    mov byte[pos_oca_valida],1
    ret

mensaje_oca_acorralado:
    mPrintf mensaje_oca_error_acorralada
    mov byte[pos_oca_valida],0
    ret

validar_oca_acorralada:
    cmp byte[contador_validacion_oca_acorralada],4
    jge finalizarLoop
    mov al,[contador_validacion_oca_acorralada]
    mov byte[numero],al
    inc byte[numero]
    sub rsp,8
    call procesar_comando_oca
    add rsp,8
    sub rsp,8
    call validar_movimiento_o
    add rsp,8
    cmp byte[es_valido],1
    je oca_libre
    inc byte[contador_validacion_oca_acorralada]
    jmp validar_oca_acorralada

oca_libre:
    mov byte[puede_moverse],1
    ret

validar_movimiento_o:
    mov al,[posicion_oca_x]
    add al,[movimiento_x]
    cmp al,0
    jl movimiento_prohibido
    cmp al,7
    jge movimiento_prohibido
    mov cl,[posicion_oca_y]
    add cl,[movimiento_y]
    cmp cl,0
    jl movimiento_prohibido
    cmp cl,7 
    jge movimiento_prohibido
    cbw
    mov cx,ax
    mov al,[posicion_oca_y]
    add al,[movimiento_y]
    cbw
    imul ax,[long_fila]
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,byte[rbx]
    cmp al,[numero_vacio]
    jne movimiento_prohibido
    mov byte[es_valido],1
    ret

mensaje_oca_invalida:
    mPrintf mensaje_oca_error
    mov byte[pos_oca_valida],0
    ret

procesar_comando_oca:
    mov al,[abajo]
    cmp [numero],al
    je mover_abajo
    mov al,[izquierda]
    cmp [numero],al
    je mover_izquierda
    mov al,[derecha]
    cmp [numero],al
    je mover_derecha
    ret

validar_movimiento_oca:
    mov al,[posicion_oca_x]
    add al,[movimiento_x]
    cmp al,0
    jl movimiento_invalido
    cmp al,7
    jge movimiento_invalido
    mov cl,[posicion_oca_y]
    add cl,[movimiento_y]
    cmp cl,0
    jl movimiento_invalido
    cmp cl,7 
    jge movimiento_invalido
    mov al,[posicion_oca_y]
    add al,[movimiento_y]
    cbw
    imul ax,word[long_fila]
    mov cx,ax
    mov al,[posicion_oca_x]
    add al,[movimiento_x]
    cbw
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,byte[rbx]
    cmp al,[numero_vacio]
    jne movimiento_invalido
    mov byte[es_valido],1
    ret

mover_oca:
    cmp byte[es_valido],0
    je finalizar_movimiento
    mov al,[posicion_oca_y]
    add al,[movimiento_y]
    cbw
    mov cx,ax
    imul cx,word[long_fila]
    mov al,[posicion_oca_x]
    add al,[movimiento_x]
    cbw
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,[numero_oca]
    mov byte[rbx],al
    mov al,[posicion_oca_y]
    cbw
    imul ax,word[long_fila]
    mov cx,ax
    mov al,[posicion_oca_x]
    cbw
    add ax,cx
    transformarAxRax
    mov rbx,[grilla]
    add rbx,rax
    mov al,[numero_vacio]
    mov byte[rbx],al
    jmp finalizar_movimiento

;PERSONALIZACION DE LA GRILLA
personalizar_elementos:
    mov byte[personalizo_elementos],1
    sub rsp,8
    call personalizar_grilla
    add rsp,8
    cmp byte[salio_partida],1
    je terminar_partida
    sub rsp,8
    call personalizar_zorro
    add rsp,8
    cmp byte[salio_partida],1
    je terminar_partida
    sub rsp,8
    call personalizar_oca
    add rsp,8
    cmp byte[salio_partida],1
    je terminar_partida
    inc byte[partida_empezada]
    jmp main
    
salir_partida_ya:
    inc byte[salio_partida]
    ret

personalizar_grilla:
    mPrintf mensajeOpcionalGrilla
    mGets comando
    mov rax,[comando]
    mov qword[comando], 0
    mov rcx,[salir]
    cmp rax,rcx
    je salir_partida_ya
    cmp rax,[comando_si]
    je elegir_grilla
    cmp rax,[comando_no]
    je no_personalizo
    jmp error_comando_g

error_comando_g:
    mPrintf mensaje_comando_invalido
    jmp personalizar_grilla

no_personalizo:
    mov rbx,grilla_default
    mov qword[grilla],rbx
    ret

elegir_grilla:
    mPrintf mensajeOpcionesGrilla
    mPrintf mensajeElegirGrilla
    mGets comando
    mov rax,[comando]
    mov rcx,[salir]
    cmp rax,rcx
    je  terminar_partida
    mSscanf comando
    cmp rax,1
    jl comando_erroneo_g
    mov al,[numero]
    cmp byte[numero],0
    jle comando_erroneo_g
    cmp byte[numero],4
    jg comando_erroneo_g
    jmp procesar_comando_grilla

comando_erroneo_g:
    mPrintf mensaje_comando_invalido
    jmp elegir_grilla

procesar_comando_grilla:
    mov al,[numero]
    cmp al,[opcion_default]
    je no_personalizo
    cmp al,[girar_derecha]
    je elegir_derecha
    cmp al,[girar_izquierda]
    je elegir_izquierda
    cmp al,[girar_180]
    je elegir_180
    jmp comando_erroneo_g

elegir_derecha:
    mov byte[posicion_zorro_x],2
    mov byte[posicion_zorro_y],3
    mov rbx,grilla_der
    mov qword[grilla],rbx
    ret

elegir_izquierda:
    mov byte[posicion_zorro_x],3
    mov byte[posicion_zorro_y],3
    mov rbx,grilla_izq
    mov qword[grilla],rbx
    ret

elegir_180:
    mov byte[posicion_zorro_x],3
    mov byte[posicion_zorro_y],2
    mov rbx,grilla_180
    mov qword[grilla],rbx
    ret

elegir_zorro:
    mPrintf mensajeOpcionesZorro
    mPrintf mensajeElegirGrilla
    mGets comando
    mSscanf comando
    cmp rax,1
    jl comando_erroneo_z
    mov al,[numero]
    cmp byte[numero],0
    jle comando_erroneo_z
    cmp byte[numero],4
    jg comando_erroneo_z
    jmp procesar_comando_z

procesar_comando_z:
    mov al,[numero]
    cmp al,[opcion_default]
    je elegir_1_z
    cmp al,[opcion_2]
    je elegir_2_z
    cmp al,[opcion_3]
    je elegir_3_z
    cmp al,[opcion_4]
    je elegir_4_z
    jmp comando_erroneo_z

elegir_1_z:
    mov byte[caracter_zorro],"X"
    ret

elegir_2_z:
    mov byte[caracter_zorro],"x"
    ret

elegir_3_z:
    mov byte[caracter_zorro],"*"
    ret

elegir_4_z:
    mov byte[caracter_zorro],"$"
    ret

comando_erroneo_z:
    mPrintf mensaje_comando_invalido
    jmp elegir_zorro

personalizar_zorro:
    mPrintf mensajeOpcionalZorro
    mGets comando
    mov rax,[comando]
    mov qword[comando],0
    mov rcx,[salir]
    cmp rax,rcx
    je salir_partida_ya
    cmp rax,[comando_si]
    je elegir_zorro
    cmp rax,[comando_no]
    je no_personalizo_z
    jmp error_comando_z

error_comando_z:
    mPrintf mensaje_comando_invalido
    jmp personalizar_zorro

no_personalizo_z:
    ret

elegir_oca:
    mPrintf mensajeOpcionesOcas
    mPrintf mensajeElegirGrilla
    mGets comando
    mSscanf comando
    cmp rax,1
    jl comando_erroneo_o
    mov al,[numero]
    cmp byte[numero],0
    jle comando_erroneo_o
    cmp byte[numero],4
    jg comando_erroneo_o
    jmp procesar_comando_o

personalizar_oca:
    mPrintf mensajeOpcionalOcas
    mGets comando
    mov rax,[comando]
    mov qword[comando],0
    mov rcx,[salir]
    cmp rax,rcx
    je salir_partida_ya
    cmp rax,[comando_si]
    je elegir_oca
    cmp rax,[comando_no]
    je no_personalizo_o
    jmp error_comando_o

no_personalizo_o:
    ret

procesar_comando_o:
    mov al,[numero]
    cmp al,[opcion_default]
    je elegir_1_o
    cmp al,[opcion_2]
    je elegir_2_o
    cmp al,[opcion_3]
    je elegir_3_o
    cmp al,[opcion_4]
    je elegir_4_o
    jmp comando_erroneo_o

elegir_1_o:
    mov byte[caracter_oca],"O"
    ret

elegir_2_o:
    mov byte[caracter_oca],"o"
    ret

elegir_3_o:
    mov byte[caracter_oca],"^"
    ret

elegir_4_o:
    mov byte[caracter_oca],"C"
    ret

error_comando_o:
    mPrintf mensaje_comando_invalido
    jmp personalizar_oca

comando_erroneo_o:
    mPrintf mensaje_comando_invalido
    jmp elegir_oca

;GUARDADO DE PARTIDA

guardar_partida:
    mov rsi,modo_escribir
    mOpen
    mov rdi,[grilla]
    mov rsi,[long_elem]
    mov rdx,[longitud_grilla]
    mWrite
    escribirByte posicion_zorro_x
    escribirByte posicion_zorro_y
    escribirByte ocas_comidas
    escribirByte caracter_oca
    escribirByte caracter_zorro
    escribirByte turno
    escribirByte movs_zorro_Arriba
    escribirByte movs_zorro_Abajo
    escribirByte movs_zorro_Izquierda
    escribirByte movs_zorro_Derecha
    escribirByte movs_zorro_ArribaIzquierda
    escribirByte movs_zorro_ArribaDerecha
    escribirByte movs_zorro_AbajoIzquierda
    escribirByte movs_zorro_AbajoDerecha
    mPrintf mensajeGuardadoExitoso
    mClose
    ret

;CARGADO DE PARTIDA

cargar_partida:
    inc byte[se_cargo_partida]
    mov rsi,modo_leer
    mOpen
    jmp preguntar_cargar

preguntar_cargar:
    mPrintf mensajeCargarPartida
    mGets comando
    mov rax,[comando]
    mov qword[comando],0
    mov rcx,[salir]
    cmp rax,rcx
    je  terminar_partida
    cmp rax,[comando_si]
    je cargar_datos
    cmp rax,[comando_no]
    je finalizar_carga
    mPrintf mensaje_comando_invalido
    jmp preguntar_cargar

finalizar_carga:
    mClose
    jmp main

cargar_datos:
    inc byte[personalizo_elementos]
    mov rbx,grilla_default ;necesito usar alguna grilla para sobreescribirla con la grilla a cargar.
    mov [grilla],rbx
    mov rdi,[grilla]
    mov rsi,[long_elem]
    mov rdx,[longitud_grilla]
    mRead
    leerByte posicion_zorro_x
    leerByte posicion_zorro_y
    leerByte ocas_comidas
    leerByte caracter_oca
    leerByte caracter_zorro
    leerByte turno
    leerByte movs_zorro_Arriba
    leerByte movs_zorro_Abajo
    leerByte movs_zorro_Izquierda
    leerByte movs_zorro_Derecha
    leerByte movs_zorro_ArribaIzquierda
    leerByte movs_zorro_ArribaDerecha
    leerByte movs_zorro_AbajoIzquierda
    leerByte movs_zorro_AbajoDerecha
    jmp finalizar_carga