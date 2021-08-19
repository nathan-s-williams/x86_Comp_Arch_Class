;==========================================================================
;                               Homework 5:
;Using the flat assembler (fasm), write an x86 assembly program that
;outputs four random numbers from 1-10 with no duplicates.  Next, output
;a random inspirational quote (out of at least 5).
;
;By Nathan Williams
;Date July 21, 2021
;==========================================================================
format PE console
include 'win32ax.inc'


;=======================================
section '.code' code readable executable
;=======================================
Start:
        cinvoke printf, "Here are four distinct (not duplicate) random numbers from 1-10: "
        cinvoke time, 0     ;Set time in EAX register by passing 0 to the C function.
        cinvoke srand, EAX  ;Set srand function using the time output in the EAX register.
;==========================================================================
;                               Random
;Random Number Algorithm:
;1. Call subroutine GetRandomNumber (Details in subroutine section)
;2. Move contents of EDX register into variable RandomOne and print.
;3. Call subroutine GetRandomNumber
;4. Compare EDX with RandomOne. If equal:
;     Jump back to Step 3.
;   Else
;     Move contents of EDX into RandomTwo and print.
;5. Call GetRandomNumber
;6. Compare EDX with RandomOne. If equal:
;     Jump back to Step 5.
;   If Else EDX is equal to RandomTwo:
;     Jump back to Step 5.
;   Else
;     Move contents of EDX into RandomThree and print.
;7. Call GetRandomNumber
;8. Compare EDX with RandomOne. If equal:
;     Jump back to Step 7.
;   If Else EDX is equal to RandomTwo:
;     Jump back to Step 7.
;   If Else EDX is equal to RandomThree:
;     Jump back to Step 7.
;   Else
;     Move contents of EDX into RandomFour and print.
;==========================================================================
        call GetRandomNumber
        mov [RandomOne], EDX
        cinvoke printf, "%c%d%c", [NewLine], [RandomOne], [NewLine]
SecondNum:
        call GetRandomNumber
        cmp EDX, [RandomOne]
        je SecondNum
        mov [RandomTwo], EDX
        cinvoke printf, "%d%c", [RandomTwo], [NewLine]
ThirdNum:
        call GetRandomNumber
        cmp EDX, [RandomOne]
        je ThirdNum
        cmp EDX, [RandomTwo]
        je ThirdNum
        mov [RandomThree], EDX
        cinvoke printf, "%d%c", [RandomThree], [NewLine]
FourthNum:
        call GetRandomNumber
        cmp EDX, [RandomOne]
        je FourthNum
        cmp EDX, [RandomTwo]
        je FourthNum
        cmp EDX, [RandomThree]
        je FourthNum
        mov [RandomFour], EDX
        cinvoke printf, "%d%c", [RandomFour], [NewLine]

;==========================================================================
;                               Quotes
;Quotes Algorithm:
;1. Call GetRandomNumber
;2. Compare EDX with 1. If equal:
;     Print Quote 1
;   Else
;     Jump to QuoteTwo
;3. Compare EDX with 2. If equal:
;     Print Quote 2
;   Else
;     Jump to QuoteThree
;4. Compare EDX with 3. If equal:
;     Print Quote 3
;   Else
;     Jump to QuoteFour
;5. Compare EDX with 4. If equal:
;     Print Quote 4
;   Else
;     Jump to QuoteFive
;6. Compare EDX with 5. If equal:
;     Print Quote 5
;   Else
;     Jump to QuoteSix
;7. Compare EDX with 6. If equal:
;     Print Quote 6
;   Else
;     Jump to QuoteSeven
;8. Compare EDX with 7. If equal:
;     Print Quote 7
;   Else
;     Jump to QuoteEight
;9. Compare EDX with 8. If equal:
;     Print Quote 8
;   Else
;     Jump to QuoteNine
;10. Compare EDX with 9. If equal:
;     Print Quote 9
;   Else
;     Jump to QuoteTen
;11. Compare EDX with 10. If equal:
;     Print Quote 10
;   Else
;     Jump to Ending
;==========================================================================
        call GetRandomNumber
Quotes:
        cmp EDX, 1
        jne QuoteTwo
        cinvoke printf, "Fall down seven times, get up eight."
QuoteTwo:
        cmp EDX, 2
        jne QuoteThree
        cinvoke printf, "What you love to do, you will learn to do well."
QuoteThree:
        cmp EDX, 3
        jne QuoteFour
        cinvoke printf, "We learn little from victory, much from defeat."
QuoteFour:
        cmp EDX, 4
        jne QuoteFive
        cinvoke printf, "No road is too long in the company of a friend."
QuoteFive:
        cmp EDX, 5
        jne QuoteSix
        cinvoke printf, "It does not matter how slowly you go as long as you do not stop."
QuoteSix:
        cmp EDX, 6
        jne QuoteSeven
        cinvoke printf, "One kind word can warm up three winter months."
QuoteSeven:
        cmp EDX, 7
        jne QuoteEight
        cinvoke printf, "Be not afraid of going slowly, be afraid only of standing still."
QuoteEight:
        cmp EDX, 8
        jne QuoteNine
        cinvoke printf, "We're fools whether we dance or not, so we might as well dance."
QuoteNine:
        cmp EDX, 9
        jne QuoteTen
        cinvoke printf, "It is the same life whether we spend it laughing or crying."
QuoteTen:
        cmp EDX, 10
        jne Ending
        cinvoke printf, "Even a fool has at least one talent."

Ending:
        cinvoke Sleep, -1



;==========================================================================
;                               Subroutine:
;1. Invoke random number function.
;2. Bridge EAX and EDX registers so as to create a 64 bit register for
;   division.
;3. Divide random number by Divisor variable (10).
;4. Increment EDX so that the remainder will be between 1-10 (inclusive).
;5. Return to calling function.
;==========================================================================
GetRandomNumber:
        cinvoke rand
        cdq
        idiv [Divisor]
        inc EDX
        ret

;======================================
section '.data' data readable writeable
;======================================
Divisor         dd 10 ;Divisor and maximum number for randomized ints
RandomOne       dd 0  ;First random number
RandomTwo       dd 0  ;Second random number
RandomThree     dd 0  ;Third random number
RandomFour      dd 0  ;Fourth random number
NewLine         dd 10 ;Constant for new line character

;====================================
section '.idata' import data readable
;====================================
library msvcrt,'msvcrt.dll',kernel32,'kernel32.dll'
import msvcrt,printf,'printf',time,'time',srand,'srand',rand,'rand'
import kernel32,Sleep,'Sleep'