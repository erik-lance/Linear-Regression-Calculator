.globl main # Erik Lance L. Tiongquico - S14

.macro bye
	li a7, 10
	ecall
.end_macro

.macro new_line
	li a7, 11
	li a0, 10
	ecall
.end_macro

.macro print_int(%x)
	li a7, 1
	mv a0, %x
	ecall
	new_line
.end_macro

.data
x_vals: .word 1, 2, 3, 4, 5
y_vals: .word 10, 15, 30, 40, 50
n_elements: .word 5

x_sum: .word 0
y_sum: .word 0
x_sum_squared: .word 0
y_sum_squared: .word 0
xy_sum_product: .word 0

.text
main:
	la t1, x_vals		# (t1) Pointer to x_vals
	la t2, y_vals		# (t2) Pointer to y_vals
	la t3, n_elements	# (t3) Pointer to n_elements

	lw s11, (t3)		# n_elements limit

	# Grabs the summation of x_vals using n_elements as the limit
	# and stores it in t6
	# t1 - Pointer to x_vals
	# t3 - Pointer to n_elements
	# t6 - Summation of x_vals
	
	addi s0, x0, 0		# (s0) Counter
	addi s1, x0, 0		# (s1) Summation of x_vals

summation_x:
	beq s0, s11, summation_x_end
	lw s6, (t1)			# (t4) x_vals

	addi s0, s0, 1		# Increment counter
	add s1, s1, s6		# Add x_vals to summation
	addi t1, t1, 4		# Increment pointer to x_vals
	j summation_x


summation_x_end:
	la t4, x_sum
	sw s1, (t4)

	print_int(s1)		# Prints summation of x_vals

	# Grabs the summation of y_vals using n_elements as the limit
	# and stores it in t7
	# t2 - Pointer to y_vals
	# t3 - Pointer to n_elements
	# t7 - Summation of y_vals

	addi s0, x0, 0		# (s0) Counter
	addi s1, x0, 0		# (s1) Summation of y_vals
summation_y:
	beq, s0, s11, summation_y_end
	lw s6, (t2)			# (t6) y_vals

	addi s0, s0, 1 		# Increment counter
	add s1, s1, s6		# Add y_vals to summation
	addi t2, t2, 4		# Increment pointer to y_vals
	j summation_y

summation_y_end:
	la t4, y_sum
	sw s1, (t4)

	print_int(s1)		# Prints summation of y_vals


	bye