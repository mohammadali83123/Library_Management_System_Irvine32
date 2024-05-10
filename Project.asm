Title Libray Management System
include irvine32.inc
include Macros.inc
BUFFER_SIZE = 501

;-----------.Data-----------------

.data

	choice dword ?
	caption db "Dialog Title", 0
	HelloMsg BYTE "Welcome to Library Management System", 0
	adminstudentName byte BUFFER_SIZE DUP(0)
	adminPassword dword ?
	bookName BYTE BUFFER_SIZE DUP(0)
	studentName BYTE BUFFER_SIZE DUP(0)
	authorName BYTE BUFFER_SIZE DUP(0)
	getString BYTE BUFFER_SIZE DUP(0)
	space BYTE "     ",0
	del byte " ",0
	fileHandle Handle ?
	WriteToFile_1 DWORD 1 DUP(0)
	ReadFromFile_1 DWORD 1 DUP(0)
	stringLength DWORD ?
	stringLength_1 DWORD ?
	fileName byte "Content.txt",0
	hello dword ?

;------------.Data------------------

;------------.Code------------------

.code

seeContent proto, var:dword

addBook proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "Enter Book Information Below"
	mov dh, 7
	mov dl, 35
	call gotoxy
	mwrite "Enter Name: "
	mov edx, offset bookName
	mov ecx, BUFFER_SIZE
	call readstring
	mov stringLength, eax
	call CreateOutptFle
	.if eax != 0
		call WriteFle
		
		INVOKE CreateFile, addr fileName, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
		mov filehandle, eax
		INVOKE closehandle, filehandle

		INVOKE CreateFile, addr fileName, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
		mov filehandle, eax
		INVOKE SetFilePOinter, filehandle, 0,0, FIlE_END
		INVOKE WriteFile, filehandle, addr bookName, stringLength, ADDR WriteToFile_1, 0
		INVOKE WriteFile, filehandle, addr space, 5, ADDR WriteToFile_1, 0
		INVOKE CloseHandle, filehandle
		mov dh, 8
		mov dl, 35
		call gotoxy
		mwrite "Enter Author Name: "
		mov edx, offset authorName
		mov ecx, BUFFER_SIZE
		call readstring
		mov stringLength, eax
		call WriteTwoFle
		mov dh, 9
		mov dl, 35
		call gotoxy
		mwrite "Enter Quantity: "
		mov edx, offset authorName
		mov ecx, BUFFER_SIZE
		call readstring
		mov stringLength, eax
		call WriteTwoFle
		mov dh, 11
		mov dl, 30
		call gotoxy
		mwrite "Book Added Successfully"
		mov eax, 2000
		call delay
		call admin
	.else
		call ReadFrmFle
		.if getString == " "
			call WriteDelUpdFile
			mov dh, 8
			mov dl, 35
			call gotoxy
			mwrite "Enter Author Name: "
			mov edx, offset authorName
			mov ecx, BUFFER_SIZE
			call readstring
			mov stringLength, eax
			call WriteTwoFle
			mov dh, 9
			mov dl, 35
			call gotoxy
			mwrite "Enter Quantity: "
			mov edx, offset authorName
			mov ecx, BUFFER_SIZE
			call readstring
			mov stringLength, eax
			call WriteTwoFle
			mov dh, 11
			mov dl, 30
			call gotoxy
			mwrite "Book Added Successfully"
			mov eax, 2000
			call delay
			call admin
		.else
			mov dh, 9
			mov dl, 30
			call gotoxy
			mwrite "Book Already Added into Library"
			mov eax, 2000
			call delay
			call admin
		.endif
	.endif	
	ret
addBook endp

SearchBook proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "Search Book"
	mov dh, 7
	mov dl, 35
	call gotoxy
	mWrite "Enter Book Name: "
	mov edx, OFFSET bookName
	mov ecx, BUFFER_SIZE
	call ReadString
	call ReadFrmFle
	.if eax == 0
		mov dh, 9
		mov dl, 30
		call gotoxy
		mwrite "Searched Book Not Available in Library"
		mov eax, 2000
		call delay
		call admin
	.else
		.if getString == " "
			mov dh, 9
			mov dl, 30
			call gotoxy
			mwrite "Searched Book Not Available in Library"
			mov eax, 2000
			call delay
			call admin
		.else
			mov dh, 9
			mov dl, 30
			call gotoxy
			mwrite "Searched Book Information Below"
			mov dh, 11
			mov dl, 35
			call gotoxy
			mwrite "BookName     AuthorName     Quantity"
			mov dh, 13
			mov dl, 35
			call gotoxy
			mov edx, OFFSET getString
			call WriteString
			mov eax, 3000
			call delay
			call admin
		.endif
	.endif
	ret
SearchBook endp

seeContent proc, var:dword
	call clrscr
	call ReadFle
	.if eax == 0
		mov dh, 5
		mov dl, 30
		call gotoxy
		mwrite "There is no Book in Library"
		mov eax, 2000
		call delay
		.if choice == 7
			call admin
		.else
			call user
		.endif
	.else
		mov dh, 5
		mov dl, 30
		call gotoxy
		mwrite "Available Books in Library"
		mov dh, 7
		mov dl, 30
		call gotoxy
		mov edx, OFFSET getString
		call WriteString
		mov eax, 3000
		call delay
		.if choice == 7
			call admin
		.else
			call user
		.endif
	.endif
	ret
seeContent endp

seeContentBorrowBook proc
	call ReadFle
	.if eax == 0
		mov dh, 11
		mov dl, 30
		call gotoxy
		mwrite "There is no Book in Library"
		mov dh, 13
		mov dl, 30
		call gotoxy
		mwrite "First You Need to Add Book"
		mov eax, 2000
		call delay
		call admin
	.else
		mov dh, 12
		mov dl, 30
		call gotoxy
		mov eax, white
		call SetTextColor
		mwrite "Available Books in Library"
		mov dh, 13
		mov dl, 30
		call gotoxy
		mov edx, OFFSET getString
		call WriteString
		mov eax, 3000
		call delay
	.endif
	ret
seeContentBorrowBook endp

borrowBook proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "Borrow Book"
	mov dh, 7
	mov dl, 35
	call gotoxy
	mwrite "Enter Student Name: "
	mov edx, offset studentName
	mov ecx, BUFFER_SIZE
	call readstring
	mov stringLength_1, eax
	mov dh, 8
	mov dl, 35
	call gotoxy
p:	.if hello == 1
		mov dh, 15
		mov dl, 35
		call gotoxy
	.endif
	mov eax, green
	call SetTextColor
	mwrite "Enter Book Name: "
	mov edx, offset bookName
	mov ecx, BUFFER_SIZE
	call readstring
	mov stringLength, eax
	call ReadFrmFle
	.if eax == 0
		mov dh, 10
		mov dl, 30
		call gotoxy
		mwrite "Book Not Available in Library"
		mov eax, 2000
		call delay
		call seeContentBorrowBook
		mov hello, 1
		mov eax, 1000
		call delay
		jmp p
	.else
		.if getString == " "
			mov dh, 10
			mov dl, 30
			call gotoxy
			mwrite "Book Not Available in Library"
			mov eax, 2000
			call delay
			call seeContentBorrowBook
			mov hello, 1
			mov eax, 1000
			call delay
			jmp p
		.else
			call CreateBorrowFile
			.if eax != 0
				call WriteFleUser
				call WriteBorrowFle
			.else
				call ReadStudentFile
				.if getString == " "
					;call CreateBorrowFile
					call WriteStudentFile
					call WriteBorrowFle
				.else
					mov dh, 10
					mov dl, 30
					call gotoxy
					mwrite "Student already Borrowed a Book"
					mov eax, 2000
					call delay
					call admin	
				.endif
			.endif
		.endif
	.endif
	.if hello == 1
		mov dh, 16
		mov dl, 35
		call gotoxy
	.else
		mov dh, 9
		mov dl, 35
		call gotoxy
	.endif
	mwrite "Enter Dept Name: "
	mov edx, offset authorName
	mov ecx, BUFFER_SIZE
	call readstring
	mov stringLength, eax
	call WriteUserInfo
	.if hello == 1
		mov dh, 17
		mov dl, 35
		call gotoxy
	.else
		mov dh, 10
		mov dl, 35
		call gotoxy
	.endif
	mwrite "Enter Reg No: "
	mov edx, offset authorName
	mov ecx, BUFFER_SIZE
	call readstring
	mov stringLength, eax
	call WriteUserInfo
	.if hello == 1
		mov dh, 19
		mov dl, 30
		call gotoxy
	.else
		mov dh, 12
		mov dl, 30
		call gotoxy
	.endif
	mwrite "Book Borrowed Successfully"
	mov eax, 2000
	call delay
	call admin
	ret
borrowBook endp
	
returnBook proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "Return Book"
	mov dh, 7
	mov dl, 35
	call gotoxy
	mWrite "Enter Student Name: "
	mov edx, OFFSET bookName
	mov ecx, BUFFER_SIZE
	call ReadString
	call ReadFrmFle
	.if eax == 0
		mov dh, 9
		mov dl, 30
		call gotoxy
		mwrite "Student Not Found"
		mov eax, 2000
		call delay
		call admin
	.else
		.if getString == " "
			mov dh, 9
			mov dl, 30
			call gotoxy
			mwrite "Book already Returned by Student"
			mov eax, 2000
			call delay
			call admin
		.else
			mov dh, 9
			mov dl, 30
			call gotoxy
			mwrite "Student Information Below"
			mov dh, 11
			mov dl, 35
			call gotoxy
			mwrite "StudentName     BookName     DeptName     RegNo"
			mov dh, 13
			mov dl, 35
			call gotoxy
			mov edx, OFFSET getString
			call WriteString
			call DeleteFle
			mov dh, 15
			mov dl, 30
			call gotoxy
			mwrite "Book Returned Successfully"
			mov eax, 3000
			call delay
			call admin
		.endif
	.endif
	ret
returnBook endp

deleteBook proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "Delete Book"
	mov dh, 7
	mov dl, 35
	call gotoxy
	mWrite "Enter Book Name: "
	mov edx, OFFSET bookName
	mov ecx, BUFFER_SIZE
	call ReadString
	call CreateDelFile
	.if eax == 0
		mov dh, 9
		mov dl, 30
		call gotoxy
		mwrite "Book Not Available in Library"
		mov eax, 2000
		call delay
		call admin
	.else
		call ReadFrmFle
		.if getString == " "
			mov dh, 9
			mov dl, 30
			call gotoxy
			mwrite "Book Not Available in Library"
			mov eax, 2000
			call delay
			call admin
		.else
			call DeleteFle
			mov dh, 9
			mov dl, 30
			call gotoxy
			mwrite "Book is Removed from Library"
			mov eax, 2000
			call delay
			call admin
		.endif
	.endif
	ret
deleteBook endp

updateBookInfo proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "Update Book Info" 
	mov dh, 7
	mov dl, 35
	call gotoxy
	mwrite "Enter BookName: "
	mov edx, offset bookName
	mov ecx, BUFFER_SIZE
	call readstring
	mov stringLength, eax
	call ReadFrmFle
	.if eax == 0
		mov dh, 9
		mov dl, 30
		call gotoxy
		mwrite "Book Not Available in Library"
		mov eax, 2000
		call delay
		call admin
	.else
		.if getString == " "
			mov dh, 9
			mov dl, 30
			call gotoxy
			mwrite "Book Not Available in Library"
			mov eax, 2000
			call delay
			call admin
		.else 
			call WriteDelUpdFile
			mov dh, 8
			mov dl, 35
			call gotoxy
			mwrite "Enter Author Name: "
			mov edx, offset authorName
			mov ecx, BUFFER_SIZE
			call readstring
			mov stringLength, eax
			call WriteTwoFle
			mov dh, 9
			mov dl, 35
			call gotoxy
			mwrite <"Enter Quantity: ",0>
			mov edx, offset authorName
			mov ecx, BUFFER_SIZE
			call readstring
			mov stringLength, eax
			call WriteTwoFle
			mov dh, 11
			mov dl, 30
			call gotoxy
			mwrite "Book Info Updated Successfully"
			mov eax, 2000
			call delay
			call admin
		.endif
	.endif
	ret
updateBookInfo endp

CreateOutptFle PROC
	INVOKE CreateFile, addr bookName, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, 0
	mov fileHandle, eax
	.if eax == INVALID_HANDLE_VALUE
		MOV EAX, 0
		RET
	.ENDIF
	INVOKE closehandle, filehandle
	ret
CreateOutptFle ENDP

CreateDelFile proc
	INVOKE CreateFile, addr bookName, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov fileHandle, eax
	.if eax == INVALID_HANDLE_VALUE
		MOV EAX, 0
		RET
	.ENDIF
	INVOKE closehandle, filehandle
	ret
CreateDelFile endp

CreateBorrowFile proc
	INVOKE CreateFile, addr studentName, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, 0
	mov fileHandle, eax
	.if eax == INVALID_HANDLE_VALUE
		MOV EAX, 0
		RET
	.ENDIF
	INVOKE closehandle, filehandle
	ret
CreateBorrowFile endp

DeleteFle proc
	INVOKE CreateFile, addr bookName, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	INVOKE WriteFile, filehandle, addr del, 1, ADDR WriteToFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
DeleteFle endp

WriteTwoFle PROC
	INVOKE CreateFile, addr bookName, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	INVOKE SetFilePOinter, filehandle, 0,0, FIlE_END
	INVOKE WriteFile, filehandle, addr authorName, stringLength, ADDR WriteToFile_1, 0
	INVOKE WriteFile, filehandle, addr space, 5, ADDR WriteToFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
WriteTwoFle ENDP

WriteFle proc
	INVOKE CreateFile, addr bookName, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	INVOKE SetFilePOinter, filehandle, 0,0, FIlE_END
	INVOKE WriteFile, filehandle, addr bookName, stringLength, ADDR WriteToFile_1, 0
	INVOKE WriteFile, filehandle, addr space, 5, ADDR WriteToFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
WriteFle endp

WriteFleUser proc
	INVOKE CreateFile, addr studentName, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	INVOKE SetFilePOinter, filehandle, 0,0, FIlE_END
	INVOKE WriteFile, filehandle, addr studentName, stringLength_1, ADDR WriteToFile_1, 0
	INVOKE WriteFile, filehandle, addr space, 5, ADDR WriteToFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
WriteFleUser endp

WriteStudentFile proc
	INVOKE CreateFile, addr studentName, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	INVOKE SetFilePOinter, filehandle, 0,0, FIlE_END
	INVOKE WriteFile, filehandle, addr studentName, stringLength_1, ADDR WriteToFile_1, 0
	INVOKE WriteFile, filehandle, addr space, 5, ADDR WriteToFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
WriteStudentFile endp

WriteBorrowFle proc
	INVOKE CreateFile, addr studentName, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	INVOKE SetFilePOinter, filehandle, 0,0, FIlE_END
	INVOKE WriteFile, filehandle, addr bookName, stringLength, ADDR WriteToFile_1, 0
	INVOKE WriteFile, filehandle, addr space, 5, ADDR WriteToFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
WriteBorrowFle endp

WriteUserInfo proc
	INVOKE CreateFile, addr studentName, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	INVOKE SetFilePOinter, filehandle, 0,0, FIlE_END
	INVOKE WriteFile, filehandle, addr authorName, stringLength, ADDR WriteToFile_1, 0
	INVOKE WriteFile, filehandle, addr space, 5, ADDR WriteToFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
WriteUserInfo endp

WriteDelUpdFile PROC
	INVOKE CreateFile, addr bookName, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	INVOKE SetFilePOinter, filehandle, 0,0, FIlE_END
	INVOKE WriteFile, filehandle, addr bookName, stringLength, ADDR WriteToFile_1, 0
	INVOKE WriteFile, filehandle, addr space, 5, ADDR WriteToFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
WriteDelUpdFile ENDP

ReadFrmFle proc
	INVOKE CreateFile, addr bookName, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	.if eax == INVALID_HANDLE_VALUE
		mov eax, 0
		ret
	.endif
	INVOKE ReadFile, filehandle, addr getString, BUFFER_SIZE, ADDR ReadFromFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
ReadFrmFle ENDP

ReadFle proc
	INVOKE CreateFile, addr fileName, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	.if eax == INVALID_HANDLE_VALUE
		mov eax, 0
		ret
	.endif
	INVOKE ReadFile, filehandle, addr getString, BUFFER_SIZE, ADDR ReadFromFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
ReadFle endp

ReadStudentFile proc
	INVOKE CreateFile, addr studentName, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov filehandle, eax
	.if eax == INVALID_HANDLE_VALUE
		mov eax, 0
		ret
	.endif
	INVOKE ReadFile, filehandle, addr getString, BUFFER_SIZE, ADDR ReadFromFile_1, 0
	INVOKE CloseHandle, filehandle
	ret
ReadStudentFile ENDP

;-----------------menu PROC--------------

menu proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mov eax, green
	call SetTextColor
	mwrite "!!!! Welcome to Library Management System !!!!"
	mov dh, 7
	mov dl, 30
	call gotoxy
	mwrite "Main Menu of System"
	mov dh, 8
	mov dl, 30
	call gotoxy
	mwrite "1. Admin"
	mov dh, 9
	mov dl, 30
	call gotoxy
	mwrite "2. User"
	mov dh, 10
	mov dl, 30
	call gotoxy
	mwrite "0. Exit"
	mov dh, 11
	mov dl, 30
	call gotoxy
	mwrite "Select Your Status in Library : "
	call readint
	mov choice, eax
	.if choice == 1
		call login
	.elseif choice == 2
		call user
	.elseif choice == 0
		exit
	.else
		mov dh, 13
		mov dl, 35
		call gotoxy
		call invalid
		mov eax, 1000
		call delay
		call menu
	.endif
	ret
menu endp

;------------menu endp-------------------

;-----------login proc-------------------

login proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "!!!! LogIn Section !!!!"
	mov dh, 7
	mov dl, 35
	call gotoxy
	mwrite "Enter userName : "
	mov edx, offset adminstudentName
	mov ecx, sizeof adminstudentName
	call readstring
	mov dh, 9
	mov dl, 35
	call gotoxy
	mwrite "Enter Password : "
	call readint
	mov adminPassword, eax
	.if adminPassword == 123 && adminstudentName == "a"
		mov eax, 1500
		call delay
		mov dh, 11
		mov dl, 30
		call gotoxy
		mwrite "Login Successfully"
		mov eax, 500
		call delay
		call admin
	.else
		mov eax, 1500
		call delay
		mov dh, 11
		mov dl, 30
		call gotoxy
		mwrite "Your Password/userName is Incorrect !!!!!!!"
		mov eax, 1000
		call delay
		call loginAgain
	.endif
	ret
login endp
;-----------login endp-----------------------

;----------loginAgain proc-------------------
loginAgain proc
	call clrscr
	mov dh, 6
	mov dl, 30
	call gotoxy
	mwrite "1. Login Again"
	mov dh, 7
	mov dl, 30
	call gotoxy
	mwrite "2. Main Menu"
	mov dh, 8
	mov dl, 30
	call gotoxy
	mwrite "0. Exit"
	mov dh, 9
	mov dl, 30
	call gotoxy
	mwrite "Enter Your Choice : "
	call readint
	mov choice, eax
	.if choice == 1
		call login
	.elseif choice == 2
		call menu
	.elseif choice == 0
		exit
	.else
		mov dh, 11
		mov dl, 35
		call gotoxy
		call invalid
		mov eax, 1000
		call delay
		call loginAgain
	.endif
	ret
loginAgain endp
;---------loginAgain endp--------------------

;-----------admin proc-----------------------

admin proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "!!!! Tasks List that You can perform as Admin !!!!"
	mov dh, 7
	mov dl, 35
	call gotoxy
	mwrite "1. Add Book"
	mov dh, 8
	mov dl, 35
	call gotoxy
	mwrite "2. Search Book"
	mov dh, 9
	mov dl, 35
	call gotoxy
	mwrite "3. Delete Book"
	mov dh, 10
	mov dl, 35
	call gotoxy
	mwrite "4. Borrow Book"
	mov dh, 11
	mov dl, 35
	call gotoxy
	mwrite "5. Return Book"
	mov dh, 12
	mov dl, 35
	call gotoxy
	mwrite "6. Update Book Info"
	mov dh, 13
	mov dl, 35
	call gotoxy
	mwrite "7. See Content"
	mov dh, 14
	mov dl, 35
	call gotoxy
	mwrite "8. Main Menu"
	mov dh, 15
	mov dl, 35
	call gotoxy
	mwrite "0. Logout"
	mov dh, 17
	mov dl, 30
	call gotoxy
	mwrite "Enter Your Choice : "
	call readint
	mov choice, eax
	.if choice == 1
		call addBook
	.elseif choice == 2
		call SearchBook
	.elseif choice == 3
		call deleteBook
	.elseif choice == 4
		call borrowBook
	.elseif choice == 5
		call returnBook
	.elseif choice == 6
		call updateBookInfo
	.elseif choice == 7
		invoke seeContent, choice
	.elseif choice == 8
		call menu
	.elseif choice == 0
		call loginAgain
	.else
		mov dh, 18
		mov dl, 35
		call gotoxy
		call invalid
		mov eax, 1000
		call delay
		call admin
	.endif
	ret
admin endp
;-----------admin proc-------------------

;-----------user proc--------------------
user proc
	call clrscr
	mov dh, 5
	mov dl, 30
	call gotoxy
	mwrite "!!!! Tasks List that You can perform as User !!!!"
	mov dh, 7
	mov dl, 35
	call gotoxy
	mwrite "1. See Content"
	mov dh, 8
	mov dl, 35
	call gotoxy
	mwrite "2. Main Menu"
	mov dh, 9
	mov dl, 35
	call gotoxy
	mwrite "0. Exit"
	mov dh, 11
	mov dl, 30
	call gotoxy
	mwrite "Enter Your Choice : "
	call readint
	mov choice, eax
	.if choice == 1
		invoke seeContent, choice
	.elseif choice == 2
		call menu
	.elseif choice == 0
		exit
	.else
		mov dh, 13
		mov dl, 35
		call gotoxy
		call invalid
		mov eax, 1000
		call delay
		call user
	.endif
	ret
user endp
;-----------user proc--------------------

;----------invalid proc------------------

invalid proc
	mwrite "Invalid Choice !!!!"
	ret
invalid endp

;----------invalid proc------------------

;----------main proc---------------------

main proc
	mov ebx,OFFSET caption
	mov edx,OFFSET HelloMsg
	call MsgBox
	call menu
	call crlf
exit
main endP
end main

;------------main proc-------------------s
