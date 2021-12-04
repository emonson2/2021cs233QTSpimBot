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
## // Count the number of disjoint empty area in a given canvas.
## unsigned int count_disjoint_regions_step(unsigned char marker,
##                                          Canvas* canvas) {
##     unsigned int region_count = 0;
##     for (unsigned int row = 0; row < canvas->height; row++) {
##         for (unsigned int col = 0; col < canvas->width; col++) {
##             unsigned char curr_char = canvas->canvas[row][col];
##             if (curr_char != canvas->pattern && curr_char != marker) {
##                 region_count ++;
##                 flood_fill(row, col, marker, canvas);
##             }
##         }
##     }
##     return region_count;
## }

.globl count_disjoint_regions_step
count_disjoint_regions_step:
        # Your code goes here :)
        sub	$sp, $sp, 24
	sw	$ra, 0 ($sp)
	sw	$s0, 4 ($sp)                    # marker
        sw      $s1, 8 ($sp)                    # canvas
        sw      $s2, 12($sp)                    # region_count
        sw      $s3, 16($sp)                    # row
        sw      $s4, 20($sp)                    # col
	
        move    $s0, $a0
        move    $s1, $a1
	li	$s2, 0			        # unsigned int region_count = 0;
        
        
        li      $s3, 0                          # row = 0
outer_loop:                                     # for (unsigned int row = 0; row < canvas->height; row++) {
        lw      $t0, 0($s1)                     # canvas->height
        bge     $s3, $t0, end_outer_loop        # row < canvas->height : fallthrough

        li      $s4, 0                          # col = 0
inner_loop:                                     # for (unsigned int col = 0; col < canvas->width; col++) {
        lw      $t0, 4($s1)                     # canvas->width
        bge     $s4, $t0, end_inner_loop        # col < canvas->width : fallthrough

        
        # unsigned char curr_char = canvas->canvas[row][col];
        lw      $t1, 12($s1)                    # &(canvas->canvas)
        mul     $t2, $s3, 4                     # $t2 = row * 4
        add     $t2, $t2, $t1                   # $t2 = canvas->canvas + row * sizeof(char*) = canvas[row]
        lw	$t1, 0($t2)		        # $t1 = &char = char* = & canvas[row][0]
        add	$t1, $s4, $t1           	# $t1 = &canvas[row][col]
        lb	$t1, 0($t1)		        # $t1 = canvas[row][col] = curr_char

        lb      $t2, 8($s1)                     # $t2 = canvas->pattern 

        # temps:        $t1 = curr_char         $t2 = canvas->pattern

        # if (curr_char != canvas->pattern && curr_char != marker) {
        beq     $t1, $t2, endif                 # if (curr_char != canvas->pattern) fall
        beq	$t1, $s0, endif                 # if (curr_char != marker)          fall
        
        add     $s2, $s2, 1                     # region_count ++;
        move    $a0, $s3                        # (row,
        move    $a1, $s4                        #  col,
        move    $a2, $s0                        #  marker,
        move    $a3, $s1                        #  canvas);
        jal     flood_fill                      # flood_fill(row, col, marker, canvas);
 
endif:


        add     $s4, $s4, 1                     # col++
        j       inner_loop                      # loop again
end_inner_loop:


        add     $s3, $s3, 1                     # row++
        j       outer_loop                      # loop again
end_outer_loop:

	move	$v0, $s2		# Copy return val
	lw	$ra, 0($sp)
	lw	$s0, 4 ($sp)                    # marker
        lw      $s1, 8 ($sp)                    # canvas
        lw      $s2, 12($sp)                    # region_count
        lw      $s3, 16($sp)                    # row
        lw      $s4, 20($sp)                    # col

	add	$sp, $sp, 24
	jr      $ra
