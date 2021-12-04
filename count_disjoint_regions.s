.text

## struct Lines {
##     unsigned int num_lines;
##     // An int* array of size 2, where first element is an array of start pos
##     // and second element is an array of end pos for each line.
##     // start pos always has a smaller value than end pos.
##     unsigned int* coords[2];
## };
## 
## struct Solution {
##     unsigned int length;
##     int* counts;
## };
## 
## // Count the number of disjoint empty area after adding each line.
## // Store the count values into the Solution struct. 
## void count_disjoint_regions(const Lines* lines, Canvas* canvas,
##                             Solution* solution) {
##     // Iterate through each step.
##     for (unsigned int i = 0; i < lines->num_lines; i++) {
##         unsigned int start_pos = lines->coords[0][i];
##         unsigned int end_pos = lines->coords[1][i];
##         // Draw line on canvas.
##         draw_line(start_pos, end_pos, canvas);
##         // Run flood fill algorithm on the updated canvas.
##         // In each even iteration, fill with marker 'A', otherwise use 'B'.
##         unsigned int count =
##                 count_disjoint_regions_step('A' + (i % 2), canvas);
##         // Update the solution struct. Memory for counts is preallocated.
##         solution->counts[i] = count;
##     }
##     solution->length = lines->num_lines;
## }

.globl count_disjoint_regions
count_disjoint_regions:
        # Your code goes here :)
        sub     $sp, $sp, 20
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)

        move    $s0, $a0                # line
        move    $s1, $a1                # canvas
        move    $s2, $a2                # solution

        li      $s3, 0                  # unsigned int i = 0;
loop:
        lw	$t0, 0($s0)		# $t0 = lines->num_lines
        bge     $s3, $t0, end           # i < lines->num_lines : fallthrough
        
        #lines->coords[0][i];
        lw	$t1, 4($s0)		# $t1 = &(lines->coords[0][0])
        lw	$t2, 8($s0)		# $t2 = &(lines->coords[1][0])

        mul     $t3, $s3, 4             # i * sizeof(int*)
        add     $t1, $t3, $t1           # $t1 = &(lines->coords[0][i])
        add     $t2, $t3, $t2           # $t2 = &(lines->coords[1][i])

        lw      $a0, 0($t1)             # $a0 = lines->coords[0][i] = start_pos
        lw      $a1, 0($t2)             # $a1 = lines->coords[0][i] = end_pos
        move    $a2, $s1                # $a2 = canvas
        jal     draw_line               # draw_line(start_pos, end_pos, canvas);

        li      $a0, 65                 # Immediate value A
        rem     $t1, $s3, 2             # i % 2
        add     $a0, $a0, $t1           # 'A' or 'B'
        move    $a1, $s1
        jal     count_disjoint_regions_step  # count_disjoint_regions_step('A' + (i % 2), canvas);
        # $v0 = count_disjoint_regions_step('A' + (i % 2), canvas);

        lw      $t0, 4($s2)             # &counts = &counts[0]
        mul     $t1, $s3, 4             #  i * sizeof(unsigned int)
        add     $t0, $t1, $t0           # *counts[i]
        sw      $v0, 0($t0)

##         // Update the solution struct. Memory for counts is preallocated.
##         solution->counts[i] = count;


        add     $s3, $s3, 1             # i++
        j       loop
end:
        lw      $t0, 0($s0)             # lines->num_lines
        sw      $t0, 0($s2)             # solution->length = lines->num_lines
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        add     $sp, $sp, 20
        jr      $ra
