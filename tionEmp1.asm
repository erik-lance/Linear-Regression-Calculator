.globl main

.macro bye
	li a7, 10
	ecall
.end_macro

.macro new_line
	li a7, 11
	li a0, 10
	ecall
.end_macro

.macro print_str(%s)
	li a7, 4
	la a0, %s
	ecall
.end_macro

.macro print_int(%w, %x)
	print_str(%w)

	li a7, 1
	mv a0, %x
	ecall
	new_line
.end_macro

.macro print_float(%w, %x)
	print_str(%w)

	li a7, 2
	fmv.s fa0, %x
	ecall
	new_line
.end_macro

.macro reset_counters
	addi s0, x0, 0
	addi s1, x0, 0
.end_macro

.macro reset_pointers
	la t1, x_vals
	la t2, y_vals
.end_macro

.macro summation(%t, %s)
	lw s6, (%t)			# Loads pointer
	addi s0, s0, 1		# increment counter
	add %s, %s, s6		# adds summation
	move_ptr(%t)
.end_macro

.macro sum_square(%t, %s)
	lw s6, (%t)			# s6 <-- x_vals
	
	addi s0, s0, 1 		# Increment counter
	mul s6, s6, s6		# Square
	add %s, %s, s6		# Add val to summation
	move_ptr(%t)
.end_macro

.macro move_ptr(%t)
	addi %t, %t, 4		# Moves pointer up
.end_macro

.macro check_incr_values

.end_macro

.data
x_vals: .word 1, 2, 3, 4, 5
y_vals: .word 10, 15, 30, 40, 50
n_elements: .word 5

print_program: .asciz "Linear regression solver"
print_x_sum: .asciz "x_sum:"
print_y_sum: .asciz "y_sum:"
print_x_sum2: .asciz "x_sum_2:"
print_y_sum2: .asciz "y_sum_2:"
print_xy_sum: .asciz "xy_sum:"
print_m: .asciz "m:"
print_b: .asciz "b:"

error_inputs: .asciz "Error: 3 or more inputs required"
error_linear: .asciz "Error: Input is not linear. Input values should be increasing"

x_sum: .word 0
y_sum: .word 0
x_sum_squared: .word 0
y_sum_squared: .word 0
xy_sum_product: .word 0

.text
main:
	la t1, x_vals		# Erik Lance L. Tiongquico - S14
	la t2, y_vals		# (t2) Pointer to y_vals
	la t3, n_elements	# (t3) Pointer to n_elements

	lw s11, (t3)		# n_elements limit
	
	reset_counters		# sets s0, s1 to 0
	
	print_str(print_program)
	new_line
	
	# Error Checker
	
	addi s10, x0, 0	# X counter
	addi s9, x0, 0 	# Y counter
	
check_x:
	beq t1, t2, check_y
	move_ptr(t1)
	addi s10, s10, 1	# Add X counter
	j check_x

check_y:
	beq t2, t3, eval_xy_check
	move_ptr(t2)
	addi s9, s9, 1	# Add Y counter
	j check_y
	
eval_xy_check:
	addi s8, x0, 3				# Less than 3
	blt s10, s8, end_fail_size	# Fail if x < 3
	blt s9, s8, end_fail_size	# Fail if y < 3

	reset_pointers

store_incr:
	lw s5, (t2)		# cur_number
	
incr_check:
	move_ptr(t2)		# Check y_val
	beq t2, t3, begin	# Reached counter
	lw s6, (t2)
	ble s6, s5, end_fail_incr
	j store_incr

	# Begin program #
begin:	
	reset_pointers
	reset_counters
	
summation_x:
	beq s0, s11, summation_x_end
	summation(t1, s1)
	j summation_x

summation_x_end:
	la t4, x_sum
	sw s1, (t4)

	print_int(print_x_sum, s1)		# Prints summation of x_vals

	reset_counters		# sets s0, s1 to 0

summation_y:
	beq, s0, s11, summation_y_end
	summation(t2, s1)
	j summation_y

summation_y_end:
	la t4, y_sum
	sw s1, (t4)

	print_int(print_y_sum, s1)		# Prints summation of y_vals

	# ------- Summation of Squares ------- #
	
	reset_pointers
	reset_counters

sum_x_square:
	beq, s0, s11, sum_x_square_end
	sum_square(t1, s1)
	j sum_x_square
			
sum_x_square_end:

	la t4, x_sum_squared
	sw s1, (t4)

	print_int(print_x_sum2, s1)		# Prints summation of x_vals

	addi s0, x0, 0		# (s0) Counter
	addi s1, x0, 0		# (s1) Summation of square of y_vals

sum_y_square:
	beq, s0, s11, sum_y_square_end
	sum_square(t2, s1)
	j sum_y_square
			
sum_y_square_end:

	la t4, y_sum_squared
	sw s1, (t4)

	print_int(print_y_sum2, s1)		# Prints summation of y_vals

	reset_pointers
	reset_counters

sum_xy_product:
	beq, s0, s11, sum_xy_product_end
	lw s6, (t1)		# x_val
	lw s7, (t2)		# y_val
	
	addi s0, s0, 1		# incr counter
	mul s6, s6, s7		# product xy
	add s1, s1, s6		# add product
	
	addi t1, t1, 4		# move pointer
	addi t2, t2, 4		# move pointer
	
	j sum_xy_product
	
sum_xy_product_end:

	la t4, xy_sum_product
	sw s1, (t4)
	print_int(print_xy_sum, s1)

	reset_pointers
	reset_counters

slope:
	# m = n * sum_xy - sum_x * sum_y
	la t1, x_sum
	la t2, y_sum
	la t3, xy_sum_product
	
	lw s3, (t1)
	lw s4, (t2)
	lw s5, (t3)
	
	mul s1, s5, s11		# num_elements * xy_sum_product
	mul s2, s3, s4
	sub s1, s1, s2
	
	# Denominator
	la t2, x_sum_squared
	lw s2, (t2)
	
	mul s2, s2, s11		# num_elements * x_sum_squared
	mul s3, s3, s3		# Square x sum
	sub s2 s2, s3
	
	fcvt.s.w f1, s1		# Convert numerator to float
	fcvt.s.w f2, s2		# Convert denominator to float
	
	fdiv.s f0, f1, f2	# m
	print_float(print_m,f0)

intercept:
	# sum_y - m * sum_x / n
	la t1, y_sum
	la t2, x_sum
	
	lw s2, (t1)
	lw s3, (t2)
	
	fcvt.s.w f1, s2
	fcvt.s.w f2, s3
	fcvt.s.w f3, s11
	
	fmul.s f2, f2, f0	# m * sum_x
	fsub.s f1, f1, f2	# sum_y - m * sum_x
	
	fdiv.s f1, f1, f3	# divide by num_elements

end_success:
	print_float(print_b, f1)
	bye

end_fail_size:
	print_str(error_inputs)
	bye

end_fail_incr:
	print_str(error_linear)
	bye
