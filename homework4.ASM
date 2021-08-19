;==========================================================================
;                               Homework 4:
;Using the flat asembler (fasm), write a program that converts an 8-bit
;integer to binary and hexidecimal using bitwise operators.
;
;By Nathan Williams
;Date July 20, 2021
;==========================================================================
format PE console
include 'win32ax.inc'

;=======================================
section '.code' code readable executable
;=======================================

Start:
        cinvoke printf, "This x86 assembly program converts an integer to binary and hex.%c%c", [NewLine], [NewLine]
        cinvoke printf, "Enter an integer from 0 - 255: "
        cinvoke scanf, '%d', Num
;==========================================================================
;                               Binary Number
;Algorithm:
;1. Retrieve input from user.
;2. Initiate Counter variable to 0 and load temp variable using the load
;   temp sub routine.
;3. And Num and 128 to isolate the first bit in the byte.
;4. If the first bit is 0:
;      Print 0 and jump to EvalBinLoop
;   Else
;      Print 1
;5. Shift contents in EBX to the left by 1 to double the value.
;6. Move the new EBX value into Temp.
;7. Increment counter and compare it to 8.
;8. If Counter less than 8:
;      Return to start of loop - BinaryLoop
;   Else
;      Continue to Hex code
;==========================================================================
         mov [Counter], 0
         call LoadTemp
         cinvoke printf, "Binary:%c", [Tab]
BinaryLoop:
        and [Temp], 128
        jnz BinOne
BinZero:                        ;Label's purpose is to help distingiush code, not help with control flow.
        cinvoke printf, "0"
        jmp EvalBinLoop
BinOne:
        cinvoke printf, "1"
EvalBinLoop:
        shl EBX, 1
        mov [Temp], EBX
        inc [Counter]
        cmp [Counter], 8
        jl BinaryLoop


;==========================================================================
                                ;Hex Number
;1. Call LoadTemp to reset Temp variable with user input.
;2. Shift Temp right four spaces to isolate the first 4 bits of the byte.
;   This should be a number between 0 and 15.
;3. Call PrintHexValue to print hex. (See subroutine for details)
;4. Call LoadTemp to reset Temp variable.
;5. And Temp value with 15 to isolate the right-four bits.
;6. Call PrintHexValue to print hex. (See subroutine for details)
;==========================================================================
        cinvoke printf, "%c", [NewLine]
        cinvoke printf, "Hex:%c", [Tab]
        call LoadTemp
        shr [Temp], 4
        call PrintHexValue
        call LoadTemp
        and [Temp], 15
        call PrintHexValue


Ending:
        cinvoke Sleep, -1

;==========================================================================
                                ;Subroutines
;LoadTemp:
;1. Move user input stored in Num to EBX.
;2. Move EBX to Temp variable
;3. Return to calling instruction
;
;PrintHexValue:
;1. Compare Temp and immediate 9.
;2. If greater than:
;      Move to HexChar
;      Add immediate 55 to Temp
;      Print the char value of ASCII value at Temp (A - F)
;   Else
;      Print the contents of Temp (0 - 9)
;==========================================================================
LoadTemp:
        mov EBX, [Num]
        mov [Temp], EBX
        ret

PrintHexValue:
        cmp [Temp], 9
        jg HexChar
        cinvoke printf, "%d", [Temp]
        ret
HexChar:
        add [Temp], 55
        cinvoke printf, "%c", [Temp]
        ret

;======================================
section '.data' data readable writeable
;======================================
Num     dd 0            ;Holds user input.
Temp    dd 0            ;Temp value.
Divisor dd 128          ;Divides input to get correct bit.
Counter dd 0            ;Counter variable used in loop.
Tab     dd 9            ;Constant used to print a tab in the console.
NewLine dd 10           ;Constant used to print new line character to the console.

;====================================
section '.idata' import data readable
;====================================
library msvcrt,'msvcrt.dll',kernel32,'kernel32.dll'
import msvcrt,printf,'printf',scanf,'scanf'
import kernel32,Sleep,'Sleep'