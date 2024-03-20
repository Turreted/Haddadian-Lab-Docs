import sys

res = int(sys.argv[1])
chains = int(sys.argv[2])

if res not in [42, 40]:
    print("Error: first argument must be 40 or 42")

short_res = """>2M4J_REPLACEME|Chains A, B, C, D, E, F, G, H, I|Amyloid beta A4 protein|Homo sapiens (9606)
DAEFRHDSGYEVHHQKLVFFAEDVGSNKGAIIGLMVGGVV
"""

long_res=""">2MXU_REPLACEME|Chains A, B, C, D, E, F, G, H, I, J, K, L|Amyloid beta A4 protein|Homo sapiens (9606)
DAEFRHDSGYEVHHQKLVFFAEDVGSNKGAIIGLMVGGVVIA
"""

fasta_str = short_res if res == 40 else long_res
output = ""

for i in range(1, chains+1):
    output += fasta_str.replace("REPLACEME", str(i))

print(output)
