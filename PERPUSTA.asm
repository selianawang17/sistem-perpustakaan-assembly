.model small
.stack 100h
.data

;================ MENU ================
msg_menu db 13,10,'=============================='
         db 13,10,' PERPUSTAKAAN SELIA NAWANG '
         db 13,10,'=============================='
         db 13,10,'1. Daftar Buku'
         db 13,10,'2. Pinjam Buku'
         db 13,10,'3. Kembalikan Buku'
         db 13,10,'4. Riwayat Peminjam'
         db 13,10,'5. Statistik'
         db 13,10,'6. Keluar'
         db 13,10,'Pilih : $'

msg_nama db 13,10,'Nama Peminjam : $'
msg_pilih db 13,10,'Pilih Buku (1-3) : $'
msg_hari db 13,10,'Telat (0-9 hari) : $'
msg_kond db 13,10,'Kondisi (1.Baik 2.Rusak) : $'

msg_denda db 13,10,'Total Denda : Rp $'
msg_sukses db 13,10,'Buku berhasil dipinjam!$'
msg_gagal db 13,10,'Buku sudah dipinjam orang lain!$'
msg_riwayat db 13,10,'=== RIWAYAT PEMINJAM ===$'
txt_nama db 'Nama    : $'
txt_buku db 'Buku    : $'
txt_tgl  db 'Tanggal : $'
garis    db '------------------------$'
msg_belum db 13,10,'Belum pinjam buku!$'


;================ LOGIN =================

user_admin db 'admin$'
pass_admin db '123$'

user_user db 'user$'
pass_user db '123$'

msg_login db 13,10,'=== LOGIN ===$'
msg_pilih_login db 13,10,'1. Admin'
                db 13,10,'2. User'
                db 13,10,'Pilih : $'

msg_user db 13,10,'Username : $'
msg_pass db 13,10,'Password : $'

msg_login_ok db 13,10,'Login Berhasil!$'
msg_login_gagal db 13,10,'Login Gagal!$'
enter db 13,10,'$'

input_user db 20
           db ?
           db 20 dup('$')

input_pass db 20
           db ?
           db 20 dup('$')

role db 0

;================ BUKU ================
b1 db 13,10,'1. Algoritma$'
b2 db 13,10,'2. Basis Data$'
b3 db 13,10,'3. Jaringan Komputer$'

;================ STATUS BUKU ================
pinjam1 db 0
pinjam2 db 0
pinjam3 db 0

;================ INPUT =================
nama db 20
     db ?
     db 20 dup('$')

buku db 30
     db ?
     db 30 dup('$') 
selected_buku db 30 dup('$')

;================ RIWAYAT =================
r_nama1 db 20 dup('$')
r_buku1 db 30 dup('$')
r_tgl1  db 15 dup ('$')
r_kembali1 db 15 dup('$')

r_nama2 db 20 dup('$') 
r_buku2 db 30 dup('$')
r_tgl2  db 15 dup ('$') 
r_kembali2 db 15 dup('$')

r_nama3 db 20 dup('$')
r_buku3 db 30 dup('$')
r_tgl3  db 15 dup ('$')  
r_kembali3 db 15 dup('$')

riwayat_index db 0
denda dw 0 

msg_tglpinjam db 13,10,'Tanggal Pinjam (dd/mm/yyyy): $'
msg_tglkembali db 13,10,'Tanggal Kembali (dd/mm/yyyy): $'

tgl_pinjam db 11,?,11 dup('$')
tgl_kembali db 11,?,11 dup('$')

;================ STATISTIK =================
total_pinjam db 0
total_kembali db 0
total_denda dw 0

msg_stat db 13,10,'=== STATISTIK PERPUSTAKAAN ===$'
msg_tp db 13,10,'Total Pinjam : $'
msg_tk db 13,10,'Total Kembali : $'
msg_td db 13,10,'Total Denda : Rp $'


;================ STRING BUKU =================
alg db 'Algoritma$'
bas db 'Basis Data$'
jar db 'Jaringan Komputer$'
 
.code

main proc
mov ax,@data
mov ds,ax

jmp login 


login_admin:

    lea dx,msg_user
    mov ah,09h
    int 21h

    mov ah,0Ah
    lea dx,input_user
    int 21h

    lea dx,msg_pass
    mov ah,09h
    int 21h

    mov ah,0Ah
    lea dx,input_pass
    int 21h

    mov al,input_user+2
    cmp al,'a'
    jne admin_gagal

    mov al,input_pass+2
    cmp al,'1'
    jne admin_gagal

    mov role,1

    lea dx,msg_login_ok
    mov ah,09h
    int 21h

    jmp menu

admin_gagal:
    lea dx,msg_login_gagal
    mov ah,09h
    int 21h
    jmp login
    
login_user:

    lea dx,msg_user
    mov ah,09h
    int 21h

    mov ah,0Ah
    lea dx,input_user
    int 21h

    lea dx,msg_pass
    mov ah,09h
    int 21h

    mov ah,0Ah
    lea dx,input_pass
    int 21h

    mov al,input_user+2
    cmp al,'u'
    jne user_gagal

    mov al,input_pass+2
    cmp al,'1'
    jne user_gagal

    mov role,2

    lea dx,msg_login_ok
    mov ah,09h
    int 21h

    jmp menu

user_gagal:
    lea dx,msg_login_gagal
    mov ah,09h
    int 21h
    jmp login

login:

    lea dx,msg_login
    mov ah,09h
    int 21h

    lea dx,msg_pilih_login
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h

    cmp al,'1'
    je login_admin

    cmp al,'2'
    je login_user

    jmp login
    
menu:
    lea dx,msg_menu
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h

    cmp al,'1'
    je daftar
    cmp al,'2'
    je pinjam
    cmp al,'3'
    je kembali
    cmp al,'4'
    je riwayat
    cmp al,'5'
    je cek_stat
    cmp al,'6'
    je keluar
    jmp menu
    
cek_stat:
    cmp role,1
    jne menu
    jmp statistik  
   
;================ DAFTAR =================
daftar:
    lea dx,b1
    mov ah,09h
    int 21h

    lea dx,b2
    mov ah,09h
    int 21h

    lea dx,b3
    mov ah,09h
    int 21h

    jmp menu

;================ PINJAM =================
pinjam:

    lea dx,msg_nama
    mov ah,09h
    int 21h

    mov ah,0Ah
    lea dx,nama 
    int 21h
    
    lea dx,msg_tglpinjam
    mov ah,09h
    int 21h
    
    mov si,offset nama 
    mov bl,[si+1]
    xor bh,bh
    mov byte ptr [si+bx+2],'$'
    
    mov ah,0Ah
    lea dx,tgl_pinjam 
    int 21h
    mov si,offset tgl_pinjam 
    mov bl,[si+1]
    xor bh,bh
    mov byte ptr [si+bx+2],'$'
    
    
    lea dx,msg_pilih
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h

    cmp al,'1'
    je p1
    cmp al,'2'
    je p2
    cmp al,'3'
    je p3
    jmp menu

p1:
    mov pinjam1,1

    ; ambil nama
    lea si,nama+2
    lea di,r_nama1
    call copy

    ; ambil buku (Algoritma)
    lea si,alg
    lea di,selected_buku
    call copy

    ; pindahkan ke riwayat
    lea si,selected_buku
    lea di,r_buku1
    call copy

    ; ambil tanggal
    lea si,tgl_pinjam+2
    lea di,r_tgl1
    call copy

    jmp simpan
 
p2:
    mov pinjam2,1

    ; ambil nama
    lea si,nama+2
    lea di,r_nama2
    call copy

    ; ambil buku (Basis Data)
    lea si,bas
    lea di,selected_buku
    call copy

    ; pindahkan ke riwayat
    lea si,selected_buku
    lea di,r_buku2
    call copy

    ; ambil tanggal
    lea si,tgl_pinjam+2
    lea di,r_tgl2
    call copy

    jmp simpan
    
p3:
    mov pinjam3,1

    ; ambil nama
    lea si,nama+2
    lea di,r_nama3
    call copy

    ; ambil buku (Jaringan Komputer)
    lea si,jar
    lea di,selected_buku
    call copy

    ; pindahkan ke riwayat
    lea si,selected_buku
    lea di,r_buku3
    call copy

    ; ambil tanggal
    lea si,tgl_pinjam+2
    lea di,r_tgl3
    call copy

    jmp simpan
   
gagal:
    lea dx,msg_gagal
    mov ah,09h
    int 21h
    jmp menu

simpan: 

    mov al,riwayat_index

    cmp al,0
    je s1
    cmp al,1
    je s2
    cmp al,2
    je s3
    jmp ok

s1:
    lea si,nama+2
    lea di,r_nama1
    call copy

    lea si,tgl_pinjam+2
    lea di,r_tgl1
    call copy

    jmp addi

s2:
    lea si,nama+2
    lea di,r_nama2
    call copy

    lea si,tgl_pinjam+2
    lea di,r_tgl2
    call copy

    jmp addi

s3:
    lea si,nama+2
    lea di,r_nama3
    call copy 

    lea si,tgl_pinjam+2
    lea di,r_tgl3
    call copy

    jmp addi

addi:
    inc riwayat_index
    inc total_pinjam
    jmp ok

ok:
    lea dx,msg_sukses
    mov ah,09h
    int 21h
    jmp menu

;================ KEMBALI + DENDA (STABIL 1 DIGIT) =================

kembali: 

    lea dx,msg_tglkembali
    mov ah,09h
    int 21h

    mov ah,0Ah
    lea dx,tgl_kembali
    int 21h  
    
    lea dx,msg_hari
    mov ah,09h
    int 21h

    ;==== INPUT HARI 0-9 ====
    mov ah,01h
    int 21h
    sub al,'0'
    mov bl,al

    ;==== KONDISI ====
    lea dx,msg_kond
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    mov cl,al

    ;==== HITUNG DENDA ====
    xor ax,ax
    mov al,bl

    cmp cl,'2'
    je rusak

baik:
    mov bx,500
    mul bx
    jmp tampil

rusak:
    mov bx,1500
    mul bx

tampil:
    mov denda,ax
    
    inc total_kembali

    mov ax,total_denda
    add ax,denda
    mov total_denda,ax
    
    lea dx,msg_denda
    mov ah,09h
    int 21h

    mov ax,denda
    call print_number

    jmp menu

;================ RIWAYAT =================
riwayat:

    cmp riwayat_index,0
    jne tampil_riwayat

    lea dx,msg_belum
    mov ah,09h
    int 21h
    jmp menu

tampil_riwayat:
   
    lea dx,msg_riwayat
    mov ah,09h
    int 21h
    call newline

    ; DATA 1
    
    mov ah,09h 
    lea dx, txt_nama
    int 21h
    
    mov ah,09h
    lea dx,r_nama1
    int 21h
    call newline
    
    mov ah, 09h
    lea dx,txt_buku
    int 21h
    
    mov ah,09h
    lea dx,r_buku1
    int 21h
    call newline
    
     mov ah, 09h
    lea dx,txt_tgl
    int 21h
    
    mov ah,09h
    lea dx,r_tgl1
    int 21h
    call newline

    lea dx,garis
    int 21h
    call newline
    call newline

    ; DATA 2  
     mov ah, 09h
    lea dx,txt_nama
    int 21h
    
    mov ah,09h
    lea dx,r_nama2
    int 21h
    call newline
    
     mov ah, 09h
    lea dx,txt_buku
    int 21h
    
    mov ah,09h
    lea dx,r_buku2
    int 21h
    call newline 
    
    mov ah, 09h
    lea dx,txt_tgl
    int 21h
    
    mov ah,09h
    lea dx,r_tgl2
    int 21h
    call newline

    lea dx,garis
    int 21h
    call newline
    call newline

    ; DATA 3 
    mov ah, 09h
    lea dx,txt_nama
    int 21h
    
    mov ah,09h
    lea dx,r_nama3
    int 21h
    call newline
    
    mov ah, 09h
    lea dx,txt_buku
    int 21h
    
    mov ah,09h
    lea dx,r_buku3
    int 21h
    call newline
    
    mov ah, 09h
    lea dx,txt_tgl
    int 21h
    
    mov ah,09h
    lea dx,r_tgl3
    int 21h
    call newline

    lea dx,garis
    int 21h
    call newline

    jmp menu
    
    

;================ COPY =================
copy proc
cpy:
    mov al,[si]
    cmp al,'$'
    je selesai

    mov [di],al
    inc si
    inc di
    jmp cpy

selesai:
    mov byte ptr [di],'$'
    ret
copy endp
;================ COMPARE =================
compare proc
    push si
    push di
    push ax
    push bx

ulang:
    mov al,[si]
    mov bl,[di]

    cmp al,bl
    jne salah

    cmp al,'$'
    je benar

    inc si
    inc di
    jmp ulang

benar:
    mov al,1
    jmp done

salah:
    mov al,0

done:
    pop bx
    pop ax
    pop di
    pop si
    ret
compare endp

;================ PRINT NUMBER =================
print_number proc
    mov cx,0
    mov bx,10

lagi:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne lagi

cetak:
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    loop cetak
    ret
print_number endp                                

;================ NEW LINE =================
newline proc
    mov dl,13
    mov ah,02h
    int 21h
    mov dl,10
    int 21h
    ret
newline endp

;================ STATISTIK =================

statistik:

    lea dx,msg_stat
    mov ah,09h
    int 21h

    lea dx,msg_tp
    mov ah,09h
    int 21h

    xor ax,ax
    mov al,total_pinjam
    call print_number

    call newline

    lea dx,msg_tk
    mov ah,09h
    int 21h

    xor ax,ax
    mov al,total_kembali
    call print_number

    call newline

    lea dx,msg_td
    mov ah,09h
    int 21h

    mov ax,total_denda
    call print_number

    call newline
    jmp menu
           
;================ KELUAR =================
keluar:
    mov ah,4Ch
    int 21h
end main