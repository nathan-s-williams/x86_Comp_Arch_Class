;==========================================================================
;                               Homework 6:
;Using the flat assembler (fasm), write a program that reads in a string
;of various parentheses, brackets, and braces.  Output whether or not the
;parentheses, brackets, and braces are balanced.
;
;By Nathan Williams
;Date July 27, 2021
;==========================================================================
format PE console
include 'win32ax.inc'

;=======================================
section '.code' code readable executable
;=======================================
Start:
        cinvoke printf, "This program checks if the parentheses, brackets, and braces are balanced.%c", [NewLine]
        cinvoke printf, "Enter a string: "
        cinvoke scanf, "%s", Input       ;Store input into Input variable.
        mov [InitialPointer], ESP        ;Set InitialPointer variable equal to the pointer at the start of the program.
        mov EAX, 0                       ;Set EAX to 0
        mov EBX, 0                       ;Set EBX to 0

;==========================================================================
;                               Algorithm:
;1. Move the memory address at the location of Input + the value in EBX
;   such that the AL contains the 8 bit character.
;2. Increment EBX for the next move into register AL.
;3. If AL is equal to the space character ' ':
;      Jump to end of loop.
;      If the InitialPointer is equal to the current stack pointer meaning
;      the stack is empty:
;          Jump to Balanced
;          Set EBX to 0.
;          Call PrintInput.
;          Print "This string is balanced."
;          Jump to Ending.
;      Else:
;          Continue onto Unbalanced.
;          Set EBX to 0.
;          Call PrintInput.
;          Print "This string is unbalanced."
;          Jump to Ending.
;   Else:
;      Move on to OpenParenthesis code block.
;4. If AL is equal to an open parenthesis, bracket or brace
;   ( "(","[","{") ):
;      Push the value in EAX which contains the byte value in AL and jump to
;      beginning of loop.
;   Else
;      Move to next section to evaluate closed characters.
;5. If AL is equal to a closed parenthesis, bracket or brace
;   ( "(","[","{") ):
;      If the InitialPointer is equal to the current stack pointer meaning
;      the stack is empty:
;          Jump to unbalanced section.
;          Set EBX to 0.
;          Call PrintInput.
;          Print "This string is unbalanced."
;          Jump to Ending.
;      Else:
;          Pop from stack into ECX
;          If the popped open character in ECX does not match the current
;          closed character:
;               Jump to unbalanced section.
;               Set EBX to 0.
;               Call PrintInput.
;               Print "This string is unbalanced."
;               Jump to Ending.
;          Else:
;               Jump to beginning of loop.
;==========================================================================
BeginLoop:
        mov AL, [Input + EBX]
        inc EBX
        cmp AL, ' '
        jne OpenParenthesis
        jmp EndLoop
;================================================
;Evaluate open parenthesis, brackets and braces
;================================================
OpenParenthesis:
        cmp AL, '('
        jne OpenBrackets
        push EAX
        jmp BeginLoop
OpenBrackets:
        cmp AL, '['
        jne OpenBraces
        push EAX
        jmp BeginLoop
OpenBraces:
        cmp AL, '{'
        jne ClosedParenthesis
        push EAX
        jmp BeginLoop

;================================================
;Evaluate closed parenthesis, brackets and braces
;================================================

ClosedParenthesis:
        cmp AL, ')'
        jne ClosedBrackets
        cmp ESP, [InitialPointer]
        je Unbalanced
        pop ECX
        cmp ECX, '('
        jne Unbalanced
        jmp BeginLoop
ClosedBrackets:
        cmp AL, ']'
        jne ClosedBraces
        cmp ESP, [InitialPointer]
        je Unbalanced
        pop ECX
        cmp ECX, '['
        jne Unbalanced
        jmp BeginLoop
ClosedBraces:
        cmp AL, '}'
        jne EndLoop
        cmp ESP, [InitialPointer]
        je Unbalanced
        pop ECX
        cmp ECX, '{'
        jne Unbalanced
        jmp BeginLoop

EndLoop:
        cmp ESP, [InitialPointer]
        je Balanced
Unbalanced:
        mov EBX, 0
        Call PrintInput
        cinvoke printf, "%cThis string is not balanced.", [NewLine]
        jmp Ending
Balanced:
        mov EBX, 0
        Call PrintInput
        cinvoke printf, "%cThis string is balanced.", [NewLine]
        jmp Ending
Ending:
        cinvoke Sleep, -1

;==========================================================================
;                               Subroutine
;1. Move the memory address at the location of Input + the value in EBX
;   such that the AL contains the 8 bit character.
;2. Increment EBX
;3. If AL is equal to ' ':
;      Jump to EndPrintInput.
;      return to calling function location.
;   Else:
;      Print the character in EAX.
;      Jump back to PrintInput.
;==========================================================================
PrintInput:
        mov AL, [Input + EBX]
        inc EBX
        cmp AL, ' '
        je EndPrintInput
        cinvoke printf, "%c", EAX
        jmp PrintInput
EndPrintInput:
        ret


;======================================
section '.data' data readable writeable
;======================================
Input           db '                                        '  ;Variable used to store user input.
InitialPointer  dd 0                                           ;Stores the pointer address at the beginning of the program.
NewLine         dd 10                                          ;Constant used to print new line character.
;====================================
section '.idata' import data readable
;====================================
library msvcrt,'msvcrt.dll',kernel32,'kernel32.dll'
import msvcrt,printf,'printf',scanf,'scanf'
import kernel32,Sleep,'Sleep'