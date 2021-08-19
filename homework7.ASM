;==========================================================================
;                               Homework 7:
;Using the flat assembler (fasm), write a program that plays tic-tac-toe
;against the computer.
;
;By Nathan Williams
;Date July 29, 2021
;
;==========================================================================
format PE console
include 'win32ax.inc'

;=======================================
section '.code' code readable executable
;=======================================

;==========================================================================
;==========================================================================
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Game Loop>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;==========================================================================
;==========================================================================

cinvoke time,0         ;Prepare random number generator
cinvoke srand, EAX
GameStart:             ;Welcome user and explain rules.
        cinvoke printf, "Welcome to x86 Assembly Tic-tac-toe!%c", [NewLine]
        cinvoke printf, "You will be X's and the computer will be O's.%c", [NewLine]
        cinvoke printf, "The squares are number 1 - 9 starting with the top left.%c%c", [NewLine], [NewLine]
        Call FirstPlayerValidation      ;Allow user to choose who goes first.
        cmp [FirstPlayer], 1
        jne Computer

;==========================================================================
;                               Main gameplay
;1.If User is first:
;     Print board
;     Move PlayerMoveFlag to 1 to indicate it is the user's turn.
;     Request user to make a move between 1 through 9.
;     Store input in Input variable and then move into EBX register.
;     Move EBX value into CheckSpaceValue.
;     Call CheckSpace to check if input overlaps a previous input.
;     Move X into EDX register.
;     Call PlaceXO to place X onto the board.
;     Check if user won.
;     Check if there is a tie.
;     Move 0 into PlayerMoveFlag to indicate it is the computer's turn.
;     Move O into EDX register.
;     Call ComputerMove which calculates where O should be placed.
;     Place O on board based off of calculation.
;     Check if computer won.
;     Check if there is a tie.
;     Print board.
;     Jump to beginning of loop and repeat.
;  Else:
;     Move 0 into PlayerMoveFlag to indicate it is the computer's turn.
;     Move O into EDX register.
;     Call ComputerMove which calculates where O should be placed.
;     Place O on board based off of calculation.
;     Check if computer won.
;     Check if there is a tie.
;     Print board.
;     Jump to beginning of loop and repeat including user this time.
;==========================================================================
GamePlay:
        Call PrintBoard
GameLoop:
User:
        mov [PlayerMoveFlag], 1         ;Player's turn
        cinvoke printf, "Your move (1-9): "
        cinvoke scanf, "%d", Input
        mov EBX, [Input]
        mov [CheckSpaceValue], EBX
        Call CheckSpace
        mov EDX, "X"
        Call PlaceXO
        Call CheckWin
        Call CheckTie
Computer:
        mov [PlayerMoveFlag], 0         ;Computer's turn
        mov EDX, "O"
        Call ComputerMove
        Call PlaceXO
        Call CheckWin
        Call CheckTie
        Call PrintBoard
        jmp GameLoop

;==========================================================================
;                               End Game
;If PlayerMoveFlag is 1:
;   Print "Congratulations! You win!
;   Print board.
;   Jump to final message.
;   Ask user if he/she wants to play again - 1 for yes and 0 for no.
;   Store input in Input variable
;   If Input is 1:
;      Restore all variables and registers to default values.
;      Jump to GameStart.
;   Else:
;      End game.
;Else:
;   Print "Computer wins!"
;   Print board
;   Jump to final message
;   Ask user if he/she wants to play again - 1 for yes and 0 for no.
;   Store input in Input variable
;   If Input is 1:
;      Restore all variables and registers to default values.
;      Jump to GameStart.
;   Else:
;      End game.
;If Tie:
;   Print "It's a tie!"
;   Print board
;   Ask user if he/she wants to play again - 1 for yes and 0 for no.
;   Store input in Input variable
;   If Input is 1:
;      Restore all variables and registers to default values.
;      Jump to GameStart.
;   Else:
;      End game.
;==========================================================================
GameEnd:
        cmp [PlayerMoveFlag], 1
        jne ComputerWin
PlayerWin:
        cinvoke printf, "%c%c==============================================================%c", [NewLine], [NewLine], [NewLine], [NewLine]
        cinvoke printf, "Congratulations! You win!%c%c", [NewLine], [NewLine]
        Call PrintBoard
        cinvoke printf, "%c", [NewLine]
        cinvoke printf, "==============================================================%c%c", [NewLine], [NewLine]
        jmp FinalMessage
ComputerWin:
        cinvoke printf, "%c%c==============================================================%c%c", [NewLine], [NewLine], [NewLine], [NewLine]
        cinvoke printf, "Computer wins!%c%c", [NewLine], [NewLine]
        Call PrintBoard
        cinvoke printf, "%c", [NewLine]
        cinvoke printf, "==============================================================%c%c", [NewLine], [NewLine]
        jmp FinalMessage
Tie:
        cinvoke printf, "%c%c==============================================================%c%c", [NewLine], [NewLine], [NewLine], [NewLine]
        cinvoke printf, "It's a tie!%c%c", [NewLine], [NewLine]
        Call PrintBoard
        cinvoke printf, "%c", [NewLine]
        cinvoke printf, "==============================================================%c%c", [NewLine], [NewLine]
FinalMessage:
        cinvoke printf, "Play again? Choose 1 for yes or 0 for no: "
        cinvoke scanf, "%d", Input
        cmp [Input], 1
        jne Ending
        mov [S1], 0
        mov [S2], 0
        mov [S3], 0
        mov [S4], 0
        mov [S5], 0
        mov [S6], 0
        mov [S7], 0
        mov [S8], 0
        mov [S9], 0
        mov [FirstPlayer], 0
        mov [PlayerMoveFlag], 0
        mov [Input], 0
        mov [ComputersMove], 0
        mov [CheckSpaceFlag], 0
        xor EAX, EAX
        xor EBX, EBX
        xor ECX, ECX
        xor EDX, EDX
        jmp GameStart
Ending:
        cinvoke printf, "%c%cGame Over. Thanks for playing!", [NewLine], [NewLine]
        invoke Sleep, -1

;==========================================================================
;==========================================================================
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Game Subroutines>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;==========================================================================
;==========================================================================

;=======================================
;Print board
;=======================================
PrintBoard:
        cinvoke printf, " %1.1c | %1.1c | %1.1c %c", [S1], [S2], [S3], [NewLine]
        cinvoke printf, "---|---|--- %c", [NewLine]
        cinvoke printf, " %1.1c | %1.1c | %1.1c %c", [S4], [S5], [S6], [NewLine]
        cinvoke printf, "---|---|--- %c", [NewLine]
        cinvoke printf, " %1.1c | %1.1c | %1.1c %c", [S7], [S8], [S9], [NewLine]
        ret

;==========================================================================
;                               Validation
;Validate First Player:
;1. Request user to input 1 for user or 2 for computer.
;2. Store input in FirstPlayer variable
;3. If FirstPlayer value is less than 1:
;      Jump to FirstPlayerValidation.
;4. If FirstPlayer value is greater than 2:
;      Jump to FirstPlayerValidation.
;
;Validate User's Input:
;1. If CheckSpaceValue is less than 1:
;      Jump to RequestReInput.
;      Request user to reinput a number.
;      Store input in Input variable.
;      Move Input value into EBX register.
;      Move EBX register into CheckSpaceValue variable.
;1. If CheckSpaceValue is more than 9:
;      Jump to RequestReInput.
;      Request user to reinput a number.
;      Store input in Input variable.
;      Move Input value into EBX register.
;      Move EBX register into CheckSpaceValue variable.
;
;
;CheckSpace:
;1. Move 0 into CheckSpaceFlag variable.
;2. Call ValidateUserInput
;3. If CheckSpaceValue is 1:
;      If variable S1 is 0:
;         Return to calling function.
;      Else:
;         Jump to Overlap.
;         Move CheckSpace flag to 1.
;         If PlayerMoveFlag is 0:
;            Return to calling function.
;         Else:
;            Push EAX,ECX and EDX registers to the stack.
;            Display message noting that the space is taken to the user.
;            Store new input in Input variable.
;            Move Input value to EBX register.
;            Move EBX value to CheckSpaceValue.
;            Jump to beginning of loop.
;   Else:
;      Jump to CheckS2
;4... Continue the same logic until S9 variable is reached.
;
;==========================================================================

;=======================================
;Validate First Player
;=======================================
FirstPlayerValidation:
        cinvoke printf, "Choose who goes first (1 for you and 2 for computer): "
        cinvoke scanf, "%d", FirstPlayer
        cmp [FirstPlayer], 1
        jl FirstPlayerValidation
        cmp [FirstPlayer], 2
        jg FirstPlayerValidation
        ret

;=======================================
;Validate User's Input
;=======================================
RequestReInput:
        cinvoke printf, "You must enter a number between 1 and 9: "
        cinvoke scanf, "%d", Input
        mov EBX, [Input]
        mov [CheckSpaceValue], EBX
ValidateUserInput:
        cmp [CheckSpaceValue], 1
        jl RequestReInput
        cmp [CheckSpaceValue], 9
        jg RequestReInput
        ret

;=======================================
;Validate Input Doesn't Overlap X & O's
;Parameter: CheckSpaceValue must be
;populated with number to check.
;=======================================
CheckSpace:
        mov [CheckSpaceFlag], 0
        Call ValidateUserInput
        CheckS1:
                        cmp [CheckSpaceValue], 1
                        jne CheckS2
                        cmp [S1], 0
                        jne Overlap
                        ret
        CheckS2:
                        cmp [CheckSpaceValue], 2
                        jne CheckS3
                        cmp [S2], 0
                        jne Overlap
                        ret
        CheckS3:
                        cmp [CheckSpaceValue], 3
                        jne CheckS4
                        cmp [S3], 0
                        jne Overlap
                        ret
        CheckS4:
                        cmp [CheckSpaceValue], 4
                        jne CheckS5
                        cmp [S4], 0
                        jne Overlap
                        ret
        CheckS5:
                        cmp [CheckSpaceValue], 5
                        jne CheckS6
                        cmp [S5], 0
                        jne Overlap
                        ret
        CheckS6:
                        cmp [CheckSpaceValue], 6
                        jne CheckS7
                        cmp [S6], 0
                        jne Overlap
                        ret
        CheckS7:
                        cmp [CheckSpaceValue], 7
                        jne CheckS8
                        cmp [S7], 0
                        jne Overlap
                        ret
        CheckS8:
                        cmp [CheckSpaceValue], 8
                        jne CheckS9
                        cmp [S8], 0
                        jne Overlap
                        ret
        CheckS9:
                        cmp [CheckSpaceValue], 9
                        cmp [S9], 0
                        jne Overlap
                        ret
        Overlap:
                        mov [CheckSpaceFlag], 1
                        cmp [PlayerMoveFlag], 0
                        jne OverlapMessage
                        ret
        OverlapMessage:
                        push EAX
                        push ECX
                        push EDX
                        cinvoke printf, "That spot has already been played. Please choose another: ", [NewLine]
                        cinvoke scanf, "%d", Input
                        mov EBX, [Input]
                        mov [CheckSpaceValue], EBX
                        pop EDX
                        pop ECX
                        pop EAX
                        jmp CheckSpace

;==========================================================================
;                               Check Win
;Note: The total sum for a row, column or diagonal is 15.
;
;1. Call CalculateRow
;2. If EAX register is 15:
;      Jump to GameEnd.
;   Else:
;      Jump to SecondRow.
;3. If EBX register is 15:
;      Jump to GameEnd.
;   Else:
;      Jump to ThirdRow.
;4. If ECX register is 15:
;      Jump to GameEnd.
;   Else:
;      Jump to CheckWinColumn
;5... Same logic for column and diagonal.
;6. Return to calling function.
;==========================================================================
CheckWin:
        CheckWinRow:
                        Call CalculateRow
                        FirstRow:
                                        cmp EAX, 15
                                        jne SecondRow
                                        jmp GameEnd
                        SecondRow:
                                        cmp EBX, 15
                                        jne ThirdRow
                                        jmp GameEnd
                        ThirdRow:
                                        cmp ECX, 15
                                        jne CheckWinColumn
                                        jmp GameEnd

        CheckWinColumn:
                        Call CalculateColumn
                        FirstColumn:
                                        cmp EAX, 15
                                        jne SecondColumn
                                        jmp GameEnd
                        SecondColumn:
                                        cmp EBX, 15
                                        jne ThirdColumn
                                        jmp GameEnd
                        ThirdColumn:
                                        cmp ECX, 15
                                        jne CheckWinDiagonal
                                        jmp GameEnd


        CheckWinDiagonal:
                        Call CalculateDiagonal
                        FirstDiagonal:
                                        cmp EAX, 15
                                        jne SecondDiagonal
                                        jmp GameEnd
                        SecondDiagonal:
                                        cmp EBX, 15
                                        jne NoWin
                                        jmp GameEnd
        NoWin:
                        ret

;==========================================================================
;                               Check Tie
;1. If S1 value is 0:
;      Return to calling function.
;   Else:
;      Move to Position2.
;2... Continue the same logic through variable S9.
;3. If S9 value is 0:
;      Return to calling function.
;   Else:
;      Jump to TieConfirmed.
;4. Jump to Tie
;==========================================================================
CheckTie:
        Position1:
                        cmp [S1], 0
                        jne Position2
                        ret
        Position2:
                        cmp [S2], 0
                        jne Position3
                        ret
        Position3:
                        cmp [S3], 0
                        jne Position4
                        ret
        Position4:
                        cmp [S4], 0
                        jne Position5
                        ret
        Position5:
                        cmp [S5], 0
                        jne Position6
                        ret
        Position6:
                        cmp [S6], 0
                        jne Position7
                        ret
        Position7:
                        cmp [S7], 0
                        jne Position8
                        ret
        Position8:
                        cmp [S8], 0
                        jne Position9
                        ret
        Position9:
                        cmp [S9], 0
                        jne TieConfirmed
                        ret
        TieConfirmed:
                        jmp Tie

;==========================================================================
;                               Player Move
;Parameters:
;Load EDX register with an X or O for it to be placed on board.
;
;1. If EBX register is 1:
;      Move EDX value into S1.
;      Return to calling function.
;   Else:
;      Jump to PlaceS2.
;2... Continue logic to variable S9.
;==========================================================================

;=======================================
;Place X or O on board
;=======================================
PlaceXO:
        PlaceS1:
                        cmp EBX, 1
                        jne PlaceS2
                        mov [S1], EDX
                        ret
        PlaceS2:
                        cmp EBX, 2
                        jne PlaceS3
                        mov [S2], EDX
                        ret
        PlaceS3:
                        cmp EBX, 3
                        jne PlaceS4
                        mov [S3], EDX
                        ret
        PlaceS4:
                        cmp EBX, 4
                        jne PlaceS5
                        mov [S4], EDX
                        ret
        PlaceS5:
                        cmp EBX, 5
                        jne PlaceS6
                        mov [S5], EDX
                        ret
        PlaceS6:
                        cmp EBX, 6
                        jne PlaceS7
                        mov [S6], EDX
                        ret
        PlaceS7:
                        cmp EBX, 7
                        jne PlaceS8
                        mov [S7], EDX
                        ret
        PlaceS8:
                        cmp EBX, 8
                        jne PlaceS9
                        mov [S8], EDX
                        ret
        PlaceS9:
                        mov [S9], EDX
                        ret

;==========================================================================
;                               Computer Logic
;General logic for computer.
;1. Look for winning move.
;2. Look for blocking move.
;3. If above not available then prioritize corners.
;4. If corners are filled then prioritize sides.
;5. If all sides and corners are filled then fill in center space.
;==========================================================================
ComputerMove:
        mov [ComputersMove], 0
        Call ComputerLogic
        mov EBX, [ComputersMove]
        ret


;==========================================================================
;                               Computer Logic
;The total sum for each row, column, and diagonal is 15. Therefore, certain
;sums tell us what positions are picked and what is left. The below further
;explains this:
;
;Position sums: 1 | 5 | 9  = 15
;
;For sum 14, positions 5 and 9 are taken and 1 is empty.
;For sum 10, positions 1 and 9 are taken and 5 is empty.
;For sum 6, positions 1 and 5 are taken and 9 is empty.
;
;1. Call ReactiveLogic
;2. If ComputersMove is 0:
;      Jump to CheckForBlock (move to block user from winning).
;      Push EDX value onto stack.
;      Move X into EDX register.
;      Call ReactiveLogic.
;      Pop value from stack back into EDX register.
;      If ComputersMove is 0:
;         Jump to RandomizerForCorner
;         Call RandomNumberGenerator
;         If RandomNumber is 1:
;            Move CheckSpaceValue to 1.
;            Call CheckSpace.
;            If CheckSpaceFlag is 1:
;               Move to SecondCorner.
;               Continue same logic for other 3 corners.
;               Continue looping until all 3 corners are filled.
;               Once all 3 corners filled, move to similar logic for all 4 sides.
;               If all sides are filled, finish by placing O in center.
;            Else:
;               Move 1 into ComputersMove variable.
;               Return to calling function.
;         Else:
;            Move to SecondCorner.
;            Continue same logic for other 3 corners.
;            Continue looping until all 3 corners are filled.
;            Once all 3 corners filled, move to similar logic for all 4 sides.
;            If all sides are filled, finish by placing O in center.
;      Else:
;         Return to calling function.
;   Else:
;      Return to calling function.
;==========================================================================



ComputerLogic:  ;Critical sums are 14, 10, 6
        Call ReactiveLogic
        cmp [ComputersMove], 0
        je CheckForBlock
        ret
CheckForBlock:
        push EDX
        mov EDX, "X"
        Call ReactiveLogic
        pop EDX
        cmp [ComputersMove], 0
        je RandomizerForCorner
        ret

RandomizerForCorner:
        Call RandomNumberGenerator
FirstCorner:
        cmp [RandomNumber], 1
        jne SecondCorner
        mov [CheckSpaceValue], 1
        Call CheckSpace
        cmp [CheckSpaceFlag], 1
        je SecondCorner
        mov [ComputersMove], 1
        ret
SecondCorner:
        cmp [RandomNumber], 2
        jne ThirdCorner
        mov [CheckSpaceValue], 3
        Call CheckSpace
        cmp [CheckSpaceFlag], 1
        je ThirdCorner
        mov [ComputersMove], 3
        ret
ThirdCorner:
        cmp [RandomNumber], 3
        jne FourthCorner
        mov [CheckSpaceValue], 7
        Call CheckSpace
        cmp [CheckSpaceFlag], 1
        je FourthCorner
        mov [ComputersMove], 7
        ret
FourthCorner:
        cmp [RandomNumber], 4
        jne LookForOtherCorners
        mov [CheckSpaceValue], 9
        Call CheckSpace
        cmp [CheckSpaceFlag], 1
        je LookForOtherCorners
        mov [ComputersMove], 9
        ret
LookForOtherCorners:
        cmp [S1], 0
        je RandomizerForCorner
        cmp [S3], 0
        je RandomizerForCorner
        cmp [S7], 0
        je RandomizerForCorner
        cmp [S9], 0
        je RandomizerForCorner
RandomizerForSide:
        Call RandomNumberGenerator
FirstSide:
        cmp [RandomNumber], 1
        jne SecondSide
        mov [CheckSpaceValue], 2
        Call CheckSpace
        cmp [CheckSpaceFlag], 1
        je SecondSide
        mov [ComputersMove], 2
        ret
SecondSide:
        cmp [RandomNumber], 2
        jne ThirdSide
        mov [CheckSpaceValue], 4
        Call CheckSpace
        cmp [CheckSpaceFlag], 1
        je ThirdSide
        mov [ComputersMove], 4
        ret
ThirdSide:
        cmp [RandomNumber], 3
        jne FourthSide
        mov [CheckSpaceValue], 6
        Call CheckSpace
        cmp [CheckSpaceFlag], 1
        je FourthSide
        mov [ComputersMove], 6
        ret
FourthSide:
        cmp [RandomNumber], 4
        jne LookForOtherSides
        mov [CheckSpaceValue], 8
        Call CheckSpace
        cmp [CheckSpaceFlag], 1
        je LookForOtherSides
        mov [ComputersMove], 8
        ret
LookForOtherSides:
        cmp [S2], 0
        je RandomizerForSide
        cmp [S4], 0
        je RandomizerForSide
        cmp [S6], 0
        je RandomizerForSide
        cmp [S8], 0
        je RandomizerForSide
Center:
        mov [ComputersMove], 5
        ret
;=======================================
;Reactive Logic
;=======================================
ReactiveLogic:
        Call CalculateRow
        RowLogic:
                RowS1:
                        cmp EAX, 14
                        jne RowS2
                        mov [CheckSpaceValue], 1
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je RowS2
                        mov [ComputersMove], 1
                        ret
                RowS2:
                        cmp EAX, 10
                        jne RowS3
                        mov [CheckSpaceValue], 2
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je RowS3
                        mov [ComputersMove], 2
                        ret
                RowS3:
                        cmp EAX, 6
                        jne RowS4
                        mov [CheckSpaceValue], 3
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je RowS4
                        mov [ComputersMove], 3
                        ret
                RowS4:
                        cmp EBX, 14
                        jne RowS5
                        mov [CheckSpaceValue], 4
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je RowS5
                        mov [ComputersMove], 4
                        ret
                RowS5:
                        cmp EBX, 10
                        jne RowS6
                        mov [CheckSpaceValue], 5
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je RowS6
                        mov [ComputersMove], 5
                        ret
                RowS6:
                        cmp EBX, 6
                        jne RowS7
                        mov [CheckSpaceValue], 6
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je RowS7
                        mov [ComputersMove], 6
                        ret
                RowS7:
                        cmp ECX, 14
                        jne RowS8
                        mov [CheckSpaceValue], 7
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je RowS8
                        mov [ComputersMove], 7
                        ret
                RowS8:
                        cmp ECX, 10
                        jne RowS9
                        mov [CheckSpaceValue], 8
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je RowS9
                        mov [ComputersMove], 8
                        ret
                RowS9:
                        cmp ECX, 6
                        jne ColumnLogic
                        mov [CheckSpaceValue], 9
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnLogic
                        mov [ComputersMove], 9
                        ret
        ColumnLogic:
        Call CalculateColumn
                ColumnS1:
                        cmp EAX, 14
                        jne ColumnS4
                        mov [CheckSpaceValue], 1
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnS4
                        mov [ComputersMove], 1
                        ret
                ColumnS4:
                        cmp EAX, 10
                        jne ColumnS7
                        mov [CheckSpaceValue], 4
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnS7
                        mov [ComputersMove], 4
                        ret
                ColumnS7:
                        cmp EAX, 6
                        jne ColumnS2
                        mov [CheckSpaceValue], 7
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnS2
                        mov [ComputersMove], 7
                        ret
                ColumnS2:
                        cmp EBX, 14
                        jne ColumnS5
                        mov [CheckSpaceValue], 2
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnS5
                        mov [ComputersMove], 2
                        ret
                ColumnS5:
                        cmp EBX, 10
                        jne ColumnS8
                        mov [CheckSpaceValue], 5
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnS8
                        mov [ComputersMove], 5
                        ret
                ColumnS8:
                        cmp EBX, 6
                        jne ColumnS3
                        mov [CheckSpaceValue], 8
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnS3
                        mov [ComputersMove], 8
                        ret
                ColumnS3:
                        cmp ECX, 14
                        jne ColumnS6
                        mov [CheckSpaceValue], 3
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnS6
                        mov [ComputersMove], 3
                        ret
                ColumnS6:
                        cmp ECX, 10
                        jne ColumnS9
                        mov [CheckSpaceValue], 6
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je ColumnS9
                        mov [ComputersMove], 6
                        ret
                ColumnS9:
                        cmp ECX, 6
                        jne DiagonalLogic
                        mov [CheckSpaceValue], 9
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je DiagonalLogic
                        mov [ComputersMove], 9
                        ret
        DiagonalLogic:
        Call CalculateDiagonal
                DiagonalS1:
                        cmp EAX, 14
                        jne DiagonalS5
                        mov [CheckSpaceValue], 1
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je DiagonalS5
                        mov [ComputersMove], 1
                        ret
                DiagonalS5:
                        cmp EAX, 10
                        jne DiagonalS9
                        mov [CheckSpaceValue], 5
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je DiagonalS9
                        mov [ComputersMove], 5
                        ret
                DiagonalS9:
                        cmp EAX, 6
                        jne DiagonalS7
                        mov [CheckSpaceValue], 9
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je DiagonalS7
                        mov [ComputersMove], 9
                        ret
                DiagonalS7:
                        cmp EBX, 14
                        jne DiagonalS5_2
                        mov [CheckSpaceValue], 7
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je DiagonalS5_2
                        mov [ComputersMove], 7
                        ret
                DiagonalS5_2:
                        cmp EBX, 10
                        jne DiagonalS3
                        mov [CheckSpaceValue], 5
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je DiagonalS3
                        mov [ComputersMove], 5
                        ret
                DiagonalS3:
                        cmp EBX, 6
                        jne ReactiveLogicReturn
                        mov [CheckSpaceValue], 3
                        Call CheckSpace
                        cmp [CheckSpaceFlag], 1
                        je  ReactiveLogicReturn
                        mov [ComputersMove], 3
                        ret
ReactiveLogicReturn:
ret

;==========================================================================
;                        Calculate Board Score
;Parameters:
;Load EDX register with an X or O depending on which needs to be counted.
;
;Array structure:
;Base memory address + 4 = Row value.
;Base memory address + 8 = Column value.
;Base memory address + 12 = Diagonal value.
;
;Calculate Row:
;1. Clear EAX, EBX and ECX registers.
;2. If S1 value is equal to value in EDX register:
;      Add EAX to value stored in the S1 array that is 4 bytes from base memory location.
;   Else:
;      Jump to FirstRowSecondColumn (next row location).
;3... Continue logic until all row values are stored in EAX, EBX, ECX.
;4. Return to calling function.
;
;Similar logic is applied to CalculateColumn and CalculateDiagonal.
;==========================================================================
;EAX = first row, EBX = second row, ECX = third row
CalculateRow:
        xor EAX, EAX
        xor EBX, EBX
        xor ECX, ECX
        FirstRowFirstColumn:
                cmp [S1], EDX
                jne FirstRowSecondColumn
                add EAX, [S1+4]
        FirstRowSecondColumn:
                cmp [S2], EDX
                jne FirstRowThirdColumn
                add EAX, [S2+4]
        FirstRowThirdColumn:
                cmp [S3], EDX
                jne SecondRowFirstColumn
                add EAX, [S3+4]
        SecondRowFirstColumn:
                cmp [S4], EDX
                jne SecondRowSecondColumn
                add EBX, [S4+4]
        SecondRowSecondColumn:
                cmp [S5], EDX
                jne SecondRowThirdColumn
                add EBX, [S5+4]
        SecondRowThirdColumn:
                cmp [S6], EDX
                jne ThirdRowFirstColumn
                add EBX, [S6+4]
        ThirdRowFirstColumn:
                cmp [S7], EDX
                jne ThirdRowSecondColumn
                add ECX, [S7+4]
        ThirdRowSecondColumn:
                cmp [S8], EDX
                jne ThirdRowThirdColumn
                add ECX, [S8+4]
        ThirdRowThirdColumn:
                cmp [S9], EDX
                jne CalculateHorizontalReturn
                add ECX, [S9+4]
        CalculateHorizontalReturn:
                ret
;EAX = first column, EBX = second column, ECX = third column
CalculateColumn:
        xor EAX, EAX
        xor EBX, EBX
        xor ECX, ECX
        FirstColumnFirstRow:
                cmp [S1], EDX
                jne FirstColumnSecondRow
                add EAX, [S1+8]
        FirstColumnSecondRow:
                cmp [S4], EDX
                jne FirstColumnThirdRow
                add EAX, [S4+8]
        FirstColumnThirdRow:
                cmp [S7], EDX
                jne SecondColumnFirstRow
                add EAX, [S7+8]
        SecondColumnFirstRow:
                cmp [S2], EDX
                jne SecondColumnSecondRow
                add EBX, [S2+8]
        SecondColumnSecondRow:
                cmp [S5], EDX
                jne SecondColumnThirdRow
                add EBX, [S5+8]
        SecondColumnThirdRow:
                cmp [S8], EDX
                jne ThirdColumnFirstRow
                add EBX, [S8+8]
        ThirdColumnFirstRow:
                cmp [S3], EDX
                jne ThirdColumnSecondRow
                add ECX, [S3+8]
        ThirdColumnSecondRow:
                cmp [S6], EDX
                jne ThirdColumnThirdRow
                add ECX, [S6+8]
        ThirdColumnThirdRow:
                cmp [S9], EDX
                jne CalculateVerticalReturn
                add ECX, [S9+8]
        CalculateVerticalReturn:
                ret
;EAX = first diagonal(1,5,9), EBX = second diagonal(7,5,3)
CalculateDiagonal:
        xor EAX, EAX
        xor EBX, EBX
        xor ECX, ECX
        FirstRowFirstColumnDiag:
                cmp [S1], EDX
                jne SecondRowSecondColumnDiag
                add EAX, [S1+12]
        SecondRowSecondColumnDiag:
                cmp [S5], EDX
                jne ThirdRowThirdColumnDiag
                add EAX, [S5+12]
        ThirdRowThirdColumnDiag:
                cmp [S9], EDX
                jne ThirdRowFirstColumnDiag
                add EAX, [S9+12]
        ThirdRowFirstColumnDiag:
                cmp [S7], EDX
                jne SecondRowSecondColumnDiag2
                add EBX, [S7+12]
        SecondRowSecondColumnDiag2:
                cmp [S5], EDX
                jne FirstRowThirdColumnDiag
                add EBX, [S5+12]
        FirstRowThirdColumnDiag:
                cmp [S3], EDX
                jne CalculateDiagReturn
                add EBX, [S3+12]
        CalculateDiagReturn:
                ret


;==========================================================================
;                        Random Space Generator
;Function uses registers EAX and EDX. Push these variables to the stack
;before running the function to save the data.
;
;1. Push EAX and EDX values onto stack.
;2. Invoke rand function.
;3. Divide EAX|EDX registers by Divisor constant.
;4. Move Remainder into RandomNumber variable.
;5. Pop values for EAX and EDX from stack.
;6. Return to calling function.
;==========================================================================
RandomNumberGenerator:
        push EAX
        push EDX
        cinvoke rand
        cdq
        idiv [Divisor]
        inc EDX
        mov [RandomNumber], EDX
        pop EDX
        pop EAX
        ret



;==========================================================================
;                        Debugging Message
;Use to help debug program with checkpoints that appear throughout
;the programs runtime.
;
;Use by calling "Debug". Comment out when not in use.
;==========================================================================

        ;Debug:
        ;push EAX
        ;push ECX
        ;push EDX
        ;cinvoke printf, "Checkpoint reached.%c", [NewLine]
        ;pop EDX
        ;pop ECX
        ;pop EAX
        ;ret
;======================================
section '.data' data readable writeable
;======================================
FirstPlayer             dd 0    ;Denotes first player
PlayerMoveFlag          dd 0    ;Denotes if it's the user's turn or computer's turn.
Input                   dd 0    ;Stores input from user.
ComputersMove           dd 0    ;Stores the location for the computer's next move.
CheckSpaceValue         dd 0    ;Stores the location to check if an X/O already exists.
CheckSpaceFlag          dd 0    ;Flags if location already holds X/O.
RandomNumber            dd 0    ;Stores random number from random number generator.
;Position Array: Marker(X,O), Row, Column, Diagonal
S1                      dd 0,1,1,1
S2                      dd 0,5,1,0
S3                      dd 0,9,1,9
S4                      dd 0,1,5,0
S5                      dd 0,5,5,5
S6                      dd 0,9,5,0
S7                      dd 0,1,9,1
S8                      dd 0,5,9,0
S9                      dd 0,9,9,9
;Constants used in subroutines.
Divisor                 dd 4
NewLine                 dd 10
;====================================
section '.idata' import data readable
;====================================
library msvcrt,'msvcrt.dll',kernel32,'kernel32.dll'
import msvcrt,printf,'printf',scanf,'scanf',time,'time',srand,'srand',rand,'rand'
import kernel32,Sleep,'Sleep'
