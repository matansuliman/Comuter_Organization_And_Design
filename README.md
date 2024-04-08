# Comuter_Organization_And_Design


## Q3:
* This code stores in the data segment  in buf a string literal with max size of 20 letters (using syscall 8)
* we compare the ASCII value of each index with the one to his right.
* if the diff is positive then we write to the corresponding index in buf1 a '+'
* if the diff is negative then we write to the corresponding index in buf1 a '-'
* if the diff is zero then we write to the corresponding index in buf1 a '='
* then we print buf1 and the number of times we wrote '='

## Q4:
* This code runs through lines of commands and counts how many of each type and the register usage.
* The types are R-type, lw, sw, beq.
* The commands are stored in a hexadecimal form in the data segment as an array with the label TheCode.
* at the end of the array, there is a word in the form 0xFFFFFFFF.
### addons:
* We note if the rt field in lw is 0.
* We note if the rd field in R-type is 0.
* We note if the rt, rd fields are equal in beq.
* We note if there is an Illegal command in TheCode.
