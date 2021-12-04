.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;
##     unsigned int width;
##     // The pattern to draw on the canvas.
##     unsigned char pattern;
##     // Each char* is null-terminated and has same length.
##     char** canvas;
## };
## 
## // Mark an empty region as visited on the canvas using flood fill algorithm.
## void flood_fill(int row, int col, unsigned char marker, Canvas* canvas) {
##     // Check the current position is valid.
##     if (row < 0 || col < 0 ||
##         row >= canvas->height || col >= canvas->width) {
##         return;
##     }
##     unsigned char curr = canvas->canvas[row][col];
##     if (curr != canvas->pattern && curr != marker) {
##         // Mark the current pos as visited.
##         canvas->canvas[row][col] = marker;
##         // Flood fill four neighbors.
##         flood_fill(row - 1, col, marker, canvas);
##         flood_fill(row, col + 1, marker, canvas);
##         flood_fill(row + 1, col, marker, canvas);
##         flood_fill(row, col - 1, marker, canvas);
##     }
## }

.globl flood_fill
flood_fill:
        # Your code goes here :)
	blt	$a0, $zero, end		# row < 0 
	blt	$a1, $zero, end		# col < 0
	lw	$t0, 0($a3)		# $t0 = canvas->height
	bge	$a0, $t0, end		# row >= canvas->height
	lw	$t0, 4($a3)		# $t0 = canvas->width
	bge	$a1, $t0, end		# col >= canvas->width
	j 	recur			# NONE TRUE

recur:
	# Find curr
	lw	$t0, 12($a3)		# canvas->canvas
	mul	$t1, $a0, 4		# row * sizeof(char*)
	add	$t1, $t1, $t0		# $t1 = canvas->canvas + row * sizeof(char*) = canvas[row]
	lw	$t2, 0($t1)		# $t2 = &char = char* = & canvas[row][0]
	add	$t2, $a1, $t2		# $t2 = &canvas[row][col]
	lb	$t3, 0($t2)		# $t3 = curr
	
	lb	$t4, 8($a3)		# $t4 = canvas->pattern
	
	beq	$t3, $t4, end		# curr == canvas->pattern : break 
	beq	$t3, $a2, end		# curr == marker          : break
	
	#FLOODFILL
	sb	$a2, ($t2) 
	
	# Save depenedecies
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	move	$s0, $a0
	move	$s1, $a1
	
	sub	$a0, $s0, 1
	move	$a1, $s1
	jal	flood_fill

	move	$a0, $s0
	add	$a1, $s1, 1
	jal	flood_fill

	add	$a0, $s0, 1
	move	$a1, $s1
	jal	flood_fill

	move	$a0, $s0
	sub	$a1, $s1, 1
	jal	flood_fill
	
	# Restore VARS
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
end:
	jr 	$ra
