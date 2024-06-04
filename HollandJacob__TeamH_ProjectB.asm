
;CIS-11 22953
;Jacob Holland  (Team H)
;Project B - Test Score Calculator
;Description: User inputs 5 test scores
;		and the program outputs the user scores
;		as well as the minimum, maximum & average test score
;		+ their letter grades
;	Inputs: 5 test scores
;	Outputs: 5 test scores
;		- Minimum/maximum/average test score
;		- Their respective letter grades
;	Side Effects: None
;	Run:	Assemble the program
;		Open the Simulate software
;		Load the assembled program (.obj file)
;		Run code and see output on the console

.ORIG x3000				;Start program at x3000

LD R1, INPUTS				;Load address of INPUTS to R1
LD R2, COUNTER				;Load COUNTER to R2 (#5)
LD R6, ASCII2DEC			;Load ASCII2DEC to R6 (#-48)

;1. Enter test scores into INPUTS
STEP1
ADD R2, R2, #-1				;Decrement R2__COUNTER by 1
BRn STEP2			;If R2__COUNTER is negative, branch to OUTPUT_SCORES
ADD R3, R3, #2				;R3 = 2 (Place marker flag for when 2 characters are entered)
LEA R0, PROMPT				;Load PROMPT string to R0
PUTS					;Output PROMPT
INPUT_SCORES			;Loop to inputs & store characters into INPUTS
GETC					;Input character
OUT					;Output character
JSR CHECK_INPUT			;Jump to CHECK_INPUT subroutine
STR R0, R1, #0				;Store character into INPUTS
ADD R1, R1, #1				;Increment index of INPUTS by 1
ADD R3, R3, #-1				;Decrement R3__Marker by 1
BRp INPUT_SCORES		;If R3___Marker is positive, branch to INPUT_SCORES (For second character)
BRz STEP1			;If R3___Marker is zero, branch to STEP1 (For next score input)

;2. Convert values to decimals and store into SCORES array
STEP2
LD R1, COUNTER				;Load COUNTER to R1
LD R2, INPUTS				;Load address of INPUTS to R2
LD R3, SCORES				;Load address of SCORES to R3
JSR STORE_SCORES		;Jump to STORE_SCORES subroutine
LEA R0, NEWLINE				;Load NEWLINE string
PUTS					;Output NEWLINE
PUTS					;Output NEWLINE
LD R1, INPUTS				;Load address of INPUTS to R1
LD R3, SCORES				;Load address of SCORES to R3
LD R2, COUNTER				;Load COUNTER to R2 (#5)

;3. Output test scores and letter grade
STEP3
BRz STEP4			;If COUNTER is zero, branch to STEP4
JSR OUTPUT_SCORE		;Jump to OUTPUT_SCORE subroutine
ADD R1, R1, #1				;Increment index in INPUTS by 1
JSR LETTERGRADE			;Jump to LETTERGRADE subroutine
ADD R3, R3, #1				;Increment index in SCORES by 1
ADD R2, R2, #-1				;Decrement COUNTER by 1
BR STEP3			;Branch to STEP 3

;4a. Find minimum test score
STEP4
AND R0, R0, #0				;Clear R0
AND R6, R6, #0				;Clear R6
LD R1, INPUTS				;Load address of INPUTS to R1
LD R2, SCORES				;Load address of SCORES to R2
LD R3, SCORES				;Load address of SCORES to R3 (Address of minimum score)
LDR R4, R3, #0				;R4 = Value of SCORES[0] (Minimum score)
LD R6, COUNTER				;Load COUNTER to R6 (#5)
MIN_LOOP			;Loop that iterates through SCORES to find minimum score
ADD R6, R6, #-1				;Decrement COUNTER by 1
BRz OUTPUT_MIN			;If COUNTER is zero, branch to OUTPUT_MIN
ADD R0, R0, #1				;Add #1 to R0 (Place marker)
ADD R2, R2, #1				;Increment index of R2__SCORES by 1
LDR R5, R2, #0				;Load value of R2__SCORES to R5
NOT R5, R5				;1s complement of R5
ADD R5, R5, #1				;2s complement of R5
ADD R7, R4, R5				;R7 = R4 - R5
BRnz MIN_LOOP			;If R7 is negative or zero, branch to MIN_LOOP
BRp NEW_MIN			;If R7 is positive, branch to NEW_MIN
NEW_MIN				;Loop to shift R1__INPUTS and R3__SCORES to new minimum score
ADD R1, R1, #2				;Increment index of R1__INPUTS by 2
ADD R3, R3, #1				;Increment index of R3__SCORES by 1
ADD R0, R0, #-1				;Decrement R0__marker by 1	
BRp NEW_MIN			;If R0__marker is positive, branch to NEW_MIN
LDR R4, R2, #0				;Load value of R2__SCORES to R4 (New minimum score)
BR MIN_LOOP			;Branch to MIN_LOOP

;4b. Output minimum test score and its letter grade
OUTPUT_MIN
LEA R0, MINOUT				;Load MINOUT string to R0
PUTS					;Output MINOUT
JSR OUTPUT_SCORE		;Jump to OUTPUT_SCORE subroutine
JSR LETTERGRADE			;Jump to LETTERGRADE subroutine

;5a. Find maximum test score
AND R0, R0, #0				;Clear R0
AND R6, R6, #0				;Clear R6
LD R1, INPUTS				;Load address of INPUTS to R1
LD R2, SCORES				;Load address of SCORES to R2
LD R3, SCORES				;Load address of SCORES to R3 (Address of maximum score)
LDR R4, R3, #0				;R4 = Value of SCORES[0] (Maximum score)
NOT R4, R4				;1s complement of R4
ADD R4, R4, #-1				;2s complement of R4
LD R6, COUNTER				;Load COUNTER to R6 (#5)
MAX_LOOP			;Loop that iterates through SCORES to find maximum score
ADD R6, R6, #-1				;Decrement COUNTER by 1
BRz OUTPUT_MAX			;If COUNTER is zero, branch to OUTPUT_MAX
ADD R0, R0, #1				;Add #1 to R0 (Place marker)
ADD R2, R2, #1				;Increment index of R2__SCORES by 1
LDR R5, R2, #0				;Load value of R2__SCORES to R5
ADD R7, R4, R5				;R7 = R5 - R4
BRnz MAX_LOOP			;If R7 is negative or zero, branch to MAX_LOOP
BRp NEW_MAX			;If R7 is positive, branch to NEW_MAX
NEW_MAX				;Loop to shift R1__INPUTS and R3__SCORES to new maximum score
ADD R1, R1, #2				;Increment index of R2__INPUTS by 2
ADD R3, R3, #1				;Increment index of R3__SCORES by 1
ADD R0, R0, #-1				;Decrement R0__marker by 1
BRp NEW_MAX			;If R0__marker is positive, branch to NEW_MAX
LDR R4, R2, #0				;Load value of R2__SCORES to R4
NOT R4, R4				;1s complement of R4
ADD R4, R4, #-1				;2s complement of R4 (New maximum score)
BR MAX_LOOP			;Branch to MAX_LOOP

;5b. Output maxiumum test score and letter grade
OUTPUT_MAX
LEA R0, MAXOUT				;Load MAXOUT string to R0
PUTS					;Output MAXOUT
JSR OUTPUT_SCORE		;Jump to OUTPUT_SCORE subroutine
JSR LETTERGRADE			;Jump to LETTERGRADE subroutine

;6. Calculate/Output average test score and letter grade
AND R3, R3, #0				;Clear R3
LD R1, SCORES				;Load address of SCORES to R1
LD R0, COUNTER				;Load COUNTER to R0 (#5)
JSR AVERAGE			;Jump to AVERAGE subroutine
ADD R1, R1, #10				;Increment SCORES by 10
LD R6, DEC2ASCII			;Load DEC2ASCII to R6 (#48)
ADD R0, R0, R6				;Add R6__DEC2ASCII to R0__AVG1
OUT					;Output R0__AVG1
ADD R0, R1, R6				;Add R6_DEC2ASCII to R0__AVG2
OUT					;Output R0__AVG2
JSR LETTERGRADE			;Jump to LETTERGRADE subroutine
HALT				;Stop program


;Checks if input is between "0" and "9"
CHECK_INPUT
ST R7, SAVE7				;Store R7 to SAVE7
AND R4, R4, #0				;Clear R4
ADD R4, R4, R0				;Add R0__Input to R4
ADD R4, R4, R6				;Convert R4 to decimal  (R4 - #48)
BRn INVALID_INPUT			;If R4 is negative, branch to INVALID_INPUT
ADD R4, R4, #-9				;Subtract 9 from R4   (R4 - #57)
BRp INVALID_INPUT			;If R4 is positive, branch to INVALID_INPUT
LD R7, SAVE7				;Load SAVE7 to R7
RET					;Return to instruction
INVALID_INPUT			;Alert user of invalid character input
LEA R0, INVALID				;Lead INVALID string
PUTS					;Output INVALID
LEA R0, PROMPT				;Load PROMPT string
PUTS					;Output PROMPT
ADD R3, R3, #-1				;Decrement R3__Marker by 1
BRp FIRST_INPUT			;If R3__Marker is positive, branch to FIRST_INPUT
BRz SECOND_DIGIT		;If R3__Marker is zero, branch to FIRST_INPUT
FIRST_INPUT			;Start new input
ADD R3, R3, #1				;Increment R3__Marker by 1
BR INPUT_SCORES			;Branch to INPUT_SCORES
SECOND_DIGIT			;Start new input
ADD R1, R1, #-1				;Decrement index of R1__INPUTS by 1
ADD R3, R3, #2				;Add RE__Marker by 2
BR INPUT_SCORES			;Branch to INPUT_SCORES

;Output test scores
OUTPUT_SCORE
ST R7, SAVE7				;Store R7 to SAVE7
LDR R0, R1, #0				;Load character in R1__INPUTS to R0
OUT					;Output character
ADD R1, R1, #1				;Increment index of INPUTS by 1
LDR R0, R1, #0				;Load character in R1__INPUTS to R0
OUT					;Output character
LD R7, SAVE7				;Load SAVE7 to R7
RET					;Return to instruction

;Determine/output letter grade for a given score
LETTERGRADE
ST R7, SAVE7				;Store R7 to SAVE7
LEA R0, LETTERS				;Load LETTERS string to R0
ADD R5, R5, #4				;R5 = Loop counter (#4)
LDR R4, R3, #0				;Load value from SCORES to R4
LD R6, ASCII2DEC			;Load ASCII2DEC to R6 (#-48)
ADD R4, R4, R6				;Add R6_ASCII2DEC to R4 (R4__SCORE - 48)
ADD R4, R4 #-11				;Subtract 11 from R4 (R4__SCORE - 59)
BRnz OUTPUT_GRADE		;If R4__SCORE is negative or zero, branch to OUTPUT_GRADE
GRADE_LOOP			;Loop to determine the letter grade of the score
ADD R0, R0, #8				;Add 8 to R0__LETTERS string (Next grade in LETTERS)
ADD R5, R5, #-1				;Decrement R5__Counter by 1
BRz OUTPUT_GRADE		;If R5__Counter is zero, branch to OUTPUT_GRADE
ADD R4, R4, #-10			;Add 10 to R4__SCORE
BRnz OUTPUT_GRADE		;If R4__SCORE is zero or negative, branch to OUTPUT_GRADE
BR GRADE_LOOP			;Branch to GRADE_LOOP
OUTPUT_GRADE			;Output letter grade
AND R6, R6, #0				;Clear R6
PUTS					;Output LETTERS
LEA R0, NEWLINE				;Load NEWLINE string to R0
PUTS					;Output NEWLINE
LD R7, SAVE7				;Load SAVE7 to R7
RET					;Return to instruction

;Store test scores into array
STORE_SCORES
ST R7, SAVE7				;Store R7 to SAVE7
AND R4, R4, #0				;Clear R4  (To store decimal value of score)
LDR R0, R2, #0				;Load value of INPUTS[x] into R0
ADD R0, R0, R6				;Add R6__ASCII2DEC to R0__INPUTvalue (Decimal conversion)
TENSPLACE			;Loop to add 10 in the first digit column
ADD R4, R4, #10				;Add #10 to R4
ADD R0, R0, #-1				;Decrement value in R0__INPUTvalue by 1
BRp TENSPLACE			;If R0 is positive, branch to TENSPLACE
ADD R2, R2, #1				;Increment index of INPUTS by 1
LDR R0, R2, #0				;Load value of INPUTS into R0__INPUTvalue
ADD R0, R0, R6				;Add R6__ASCII2DEC to R0__INPUTvalue (Decimal conversion)
ADD R4, R4, R0				;Add value in R0__INPUTvalue to R4__DecScore
STR R4, R3, #0				;Store R4__DecScore to address of SCORES
ADD R2, R2, #1				;Increment index of INPUTS by 1
ADD R3, R3, #1				;Increment index of SCORES by 1
ADD R1, R1, #-1				;Decrement counter by 1
BRp STORE_SCORES		;If R1__marker is positive, branch to STORE_SCORES
LD R7, SAVE7				;Load SAVE7 to R7
RET					;Return to instruction

;Calculates the average of 5 test scores
AVERAGE
ST R7, SAVE7				;Store R7 to SAVE7
SUM_SCORES			;Loop to sum all scores in SCORES
LDR R2, R1, #0				;Load value of SCORES to R2
ADD R3, R3, R2				;Add value in R2__SCORES to R3 (R3 = Sum of SCORES)
ADD R1, R1, #1				;Increment index in SCORES by 1
ADD R0, R0, #-1				;Decrement COUNTER by 1
BRp SUM_SCORES			;Branch to SUM_SCORES
AND R1, R1, #0				;Clear R1
DIVIDE_SUM			;Loop to divide the sum by 5
ADD R1, R1, #1				;Add 1 to R1 (Divison counter)
ADD R3, R3, #-5				;Subtract 5 from R3__Sum
BRp DIVIDE_SUM			;If R3__Sum is positive, Branch to DIVIDE_SUM
BRn OUTPUT_AVERAGE_GRADE	;If sum is negative or zero, branch to STORE_AVG
OUTPUT_AVERAGE_GRADE		;Output the average score and its letter grade
LEA R0, AVGOUT				;Load AVGOUT string
PUTS					;Output AVGOUT string
AND R0, R0, #0				;Clear R0
LD R3, AVG_DEC				;Load AVG_DEC to R3
STR R1, R3, #0				;Store value of R3__AVGDEC to R1
AVG_TENSPLACE			;Loop to add 10 in the first digit column
ADD R1, R1, #-10			;Subtract 10 from R1__AVGDEC
BRn END_AVERAGE			;If R1__AVGDEC is negative, branch to END_AVERAGE
ADD R0, R0, #1				;Increment COUNTER by 1
BRp AVG_TENSPLACE			;If COUNTER is positive, branch to AVG_TENSPLACE
END_AVERAGE
LD R7, SAVE7				;Load SAVE7 to R7
RET					;Return to instruction


INPUTS		.FILL		x5000			;Array of 10 elements, 2 for each score (For inputs & outputs)
SCORES		.FILL		x500A			;Array of 5 elements, 1 for each score (For min/max/avg/grade calculations)
AVG_DEC		.FILL		x5011			;Stores average test score in decimal
COUNTER		.FILL		#5			;Loop counter
DEC2ASCII       .FILL           #48			;For converting decimal to ASCII
ASCII2DEC	.FILL		#-48			;For converting ASCII to decimal
SAVE7		.FILL		x7			;For saving/restoring instructions in subroutines
PROMPT		.STRINGZ	"\nEnter test score: "
INVALID		.STRINGZ	"\n\nInvalid input."
NEWLINE		.STRINGZ	"\n"
MINOUT		.STRINGZ	"\nMinimum test score\n"
MAXOUT		.STRINGZ	"\nMaximum test score\n"
AVGOUT      	.STRINGZ        "\nAverage score\n"
LETTERS		.STRINGZ	"      F"
		.STRINGZ	"      D"
		.STRINGZ	"      C"
		.STRINGZ	"      B"
		.STRINGZ	"      A"


.END					;End program