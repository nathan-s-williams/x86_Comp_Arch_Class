;=================================================
;Homework 3:
;By Nathan Williams
;Date July 15, 2021
;=================================================
format PE console
include 'win32ax.inc'

;=======================================
section '.code' code readable executable
;=======================================

Start:                                   ;State purpose of program and ask user to enter a number between -100 and 100
        cinvoke printf, "This x86 assembly program converts an integer to text.%c%c", 10, 10
ValidateInput:                           ;Check input. If user enters a number less than -100 or greater than 100, request user to reenter.
        cinvoke printf, "Enter an integer from -100 to 100: "
        cinvoke scanf, "%d", Num
        cinvoke printf, "%c", 10
        cmp [Num], -100                  ;Loop if < -100
        jl ValidateInput
        cmp [Num], 100                   ;Loop if > 100
        jg ValidateInput

;=======================================
;Check sign and limits (-100,100)
;=======================================

        cmp [Num], 0                     ;Print "Zero" if = 0
        jne Negative
        cinvoke printf, "Zero"
        jmp Ending
Negative:                                ;Print "Negative" if < 0
        cmp  [Num], 0
        jge OneHundred
        cinvoke printf, "Negative "
        neg [Num]                        ;Set number = positive if negative
OneHundred:                              ;Print "One Hundred" if = 0
        cmp [Num], 100
        jne OneOnly
        cinvoke printf, "One Hundred"
        jmp Ending

;=======================================
;Check for single digit input
;=======================================

OneOnly:
        cmp [Num], 1                     ;Print 1 if 1
        jne TwoOnly
        cinvoke printf, "One"
        jmp Ending
TwoOnly:                                 ;Print 2 if 2
        cmp [Num], 2
        jne ThreeOnly
        cinvoke printf, "Two"
        jmp Ending
ThreeOnly:                               ;Print 3 if 3
        cmp [Num], 3
        jne FourOnly
        cinvoke printf, "Three"
        jmp Ending
FourOnly:                                ;Print 4 if 4
        cmp [Num], 4
        jne FiveOnly
        cinvoke printf, "Four"
        jmp Ending
FiveOnly:                                ;Print 5 if 5
        cmp [Num], 5
        jne SixOnly
        cinvoke printf, "Five"
        jmp Ending
SixOnly:                                 ;Print 6 if 6
        cmp [Num], 6
        jne SevenOnly
        cinvoke printf, "Six"
        jmp Ending
SevenOnly:                               ;Print 7 if 7
        cmp [Num], 7
        jne EightOnly
        cinvoke printf, "Seven"
        jmp Ending
EightOnly:                               ;Print 8 if 8
        cmp [Num], 8
        jne NineOnly
        cinvoke printf, "Eight"
        jmp Ending
NineOnly:                                ;Print 9 if 9
        cmp [Num], 9
        jne Ten
        cinvoke printf, "Nine"
        jmp Ending

;=======================================
;Special Exceptions (10 through 19)
;=======================================

Ten:                                     ;Print 10 if 10
        cmp [Num], 10
        jg Eleven
        cinvoke printf, "Ten"
        jmp Ending
Eleven:                                  ;Print 11 if 11
        cmp [Num], 11
        jg Twelve
        cinvoke printf, "Eleven"
        jmp Ending
Twelve:                                  ;Print 12 if 12
        cmp [Num], 12
        jg Thirteen
        cinvoke printf, "Twelve"
        jmp Ending
Thirteen:                                ;Print 13 if 13
        cmp [Num], 13
        jg Fourteen
        cinvoke printf, "Thirteen"
        jmp Ending
Fourteen:                                ;Print 14 if 14
        cmp [Num], 14
        jg Fifteen
        cinvoke printf, "Fourteen"
        jmp Ending
Fifteen:                                 ;Print 15 if 15
        cmp [Num], 15
        jg Sixteen
        cinvoke printf, "Fifteen"
        jmp Ending
Sixteen:                                 ;Print 16 if 16
        cmp [Num], 16
        jg Seventeen
        cinvoke printf, "Sixteen"
        jmp Ending
Seventeen:                               ;Print 17 if 17
        cmp [Num], 17
        jg Eighteen
        cinvoke printf, "Seventeen"
        jmp Ending
Eighteen:                                ;Print 18 if 18
        cmp [Num], 18
        jg Nineteen
        cinvoke printf, "Eighteen"
        jmp Ending
Nineteen:                                ;Print 19 if 19
        cmp [Num], 19
        jg Division
        cinvoke printf, "Nineteen"
        jmp Ending

;============================================================
;Divide Num by 10 to evaluate the 10's digit and 1's digit.
;============================================================

Division:                                ;Divide by 10 to split the 10's digit and 1's digit.
        mov EAX, [Num]
        cdq
        idiv [Divisor]
        mov [Quotient], EAX              ;Store 10's digit in Quotient
        mov [Remainder], EDX             ;Store 1's digit in Remainder

;=======================================
;Evaluate Quotient
;=======================================

Twenty:                                  ;Print 20 if 20
        cmp [Quotient], 2
        jg Thirty
        cinvoke printf, "Twenty"
        jmp OnesDigit
Thirty:                                  ;Print 30 if 30
        cmp [Quotient], 3
        jg Forty
        cinvoke printf, "Thirty"
        jmp OnesDigit
Forty:                                   ;Print 40 if 40
        cmp [Quotient], 4
        jg Fifty
        cinvoke printf, "Forty"
        jmp OnesDigit
Fifty:                                   ;Print 50 if 50
        cmp [Quotient], 5
        jg Sixty
        cinvoke printf, "Fifty"
        jmp OnesDigit
Sixty:                                   ;Print 60 if 60
        cmp [Quotient], 6
        jg Seventy
        cinvoke printf, "Sixty"
        jmp OnesDigit
Seventy:                                 ;Print 70 if 70
        cmp [Quotient], 7
        jg Eighty
        cinvoke printf, "Seventy"
        jmp OnesDigit
Eighty:                                  ;Print 80 if 80
        cmp [Quotient], 8
        jg Ninety
        cinvoke printf, "Eighty"
        jmp OnesDigit
Ninety:                                  ;Print 90 if 90
        cinvoke printf, "Ninety"

;======================================
;Evaluate Remainder
;======================================
OnesDigit:                               ;If Quotient != 0 and Remainder = 0 then print Quotient without Remainder (Ex. Twenty, Thirty, etc.)
        cmp [Remainder], 0
        je Ending
One:                                     ;Append -One if Remainder = 1
        cmp [Remainder], 1
        jne Two
        cinvoke printf, "-One"
        jmp Ending
Two:                                     ;Append -Two if Remainder = 2
        cmp [Remainder], 2
        jne Three
        cinvoke printf, "-Two"
        jmp Ending
Three:                                   ;Append -Three if Remainder = 3
        cmp [Remainder], 3
        jne Four
        cinvoke printf, "-Three"
        jmp Ending
Four:                                    ;Append -Four if Remainder = 4
        cmp [Remainder], 4
        jne Five
        cinvoke printf, "-Four"
        jmp Ending
Five:                                    ;Append -Five if Remainder = 5
        cmp [Remainder], 5
        jne Six
        cinvoke printf, "-Five"
        jmp Ending
Six:                                     ;Append -Six if Remainder = 6
        cmp [Remainder], 6
        jne Seven
        cinvoke printf, "-Six"
        jmp Ending
Seven:                                   ;Append -Seven if Remainder = 7
        cmp [Remainder], 7
        jne Eight
        cinvoke printf, "-Seven"
        jmp Ending
Eight:                                   ;Append -Eight if Remainder = 8
        cmp [Remainder], 8
        jne Nine
        cinvoke printf, "-Eight"
        jmp Ending
Nine:                                    ;Append -Nine if Remainder = 9
        cinvoke printf, "-Nine"
Ending:
       invoke Sleep, -1

;======================================
section '.data' data readable writeable
;======================================
Num        dd 0                          ;Used to collect number from user
Divisor    dd 10                         ;Divides user input by 10
Quotient   dd 0                          ;Stores quotient after division by 10
Remainder  dd 0                          ;Stores remainder after division by 10

;====================================
section '.idata' import data readable
;====================================
library msvcrt,'msvcrt.dll',kernel32,'kernel32.dll'
import msvcrt,printf,'printf',scanf,'scanf'
import kernel32,Sleep,'Sleep'