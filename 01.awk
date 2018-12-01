# Use with files inputs/01 inputs/01 inputs/01 ...
# awk -f 01.awk $(for i in {0..200}; do echo "inputs/01"; done)
BEGIN {
	sum = 0
	hist[0] = 1
	found2 = 0
}

{
	sum += $1
	if (NR == FNR)
		p1 = sum
	if (sum in hist && !found2) {
		found2 = 1
		p2 = sum
	}
	hist[sum] = 1
}

END {
	printf("p1: %d, p2: ", p1)
	if (found2)
		printf("%d\n", p2)
	else
		printf("not found, please run with more arguments\n")
}
