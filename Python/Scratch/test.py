"""
Mitchell is learning some python basics!
"""
import sys

import glob

# jpegs = glob.glob('../../db/Synthesized Sherds/*/Marked/*.jpg')

# sys.stdout.write(str(jpegs) + "\n\r")


# Specimen start letter
spec_begin = 'A'
# Specimen end letter
spec_end ='Z'

# Generate specimen lookup table
specs = map(chr, range(ord(spec_begin),ord(spec_end)+1))
sys.stdout.write(str(specs) + "\n\r")

# List spec numbers
for i in range(0, len(specs)):
    label = i
    sys.stdout.write(specs[i] + "=" + str(i) + ", ")
sys.stdout.write("\n\r")
