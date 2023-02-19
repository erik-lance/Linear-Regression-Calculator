.globl main # Erik Lance L. Tiongquico - S14

.macro bye
	li a7, 10
	ecall
.end_macro

.data
x_vals: .word 1, 2, 3, 4, 5
y_vals: .word 10, 15, 30, 40, 50
n_elements: .word 5

.text
main:



	bye