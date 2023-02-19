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
	la t1, x_vals		# (t1) Pointer to x_vals
	la t2, y_vals		# (t2) Pointer to y_vals
	la t3, n_elements	# (t3) Pointer to n_elements


	# Grabs the summation of x_vals using n_elements as the limit
	# and stores it in t6
	# t1 - Pointer to x_vals
	# t3 - Pointer to n_elements
	# t6 - Summation of x_vals
	
	addi s0, x0, 0		# (s0) Counter
	addi s1, x0, 0		# (s1) Summation of x_vals

summation_x:
	beq s0, t3, summation_x_end
	lw t4, (t1)			# (t4) x_vals

	addi s0, s0, 1		# Increment counter
	add s1, s1, t4		# Add x_vals to summation
	addi t1, t1, 4		# Increment pointer to x_vals
	j summation_x


summation_x_end:

	# Grabs the summation of y_vals using n_elements as the limit
	# and stores it in t7
	# t2 - Pointer to y_vals
	# t3 - Pointer to n_elements
	# t7 - Summation of y_vals

	addi s0, x0, 0		# (s0) Counter
	addi s2, x0, 0		# (s2) Summation of y_vals
summation_y:
	beq, s0, t3, summation_y_end
	lw t5, (t2)			# (t5) y_vals

	addi s0, s0, 1 		# Increment counter
	add s2, s2, t5		# Add y_vals to summation
	addi t2, t2, 4		# Increment pointer to y_vals
	j summation_y

summation_y_end:



	bye