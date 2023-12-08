# Template by Bruce A. Maxwell, 2015
#
# implements a simple assembler for the following assembly language
#
# - One instruction or label per line.
#
# - Blank lines are ignored.
#
# - Comments start with a # as the first character and all subsequent
# - characters on the line are ignored.
#
# - Spaces delimit instruction elements.
#
# - A label ends with a colon and must be a single symbol on its own line.
#
# - A label can be any single continuous sequence of printable
# - characters; a colon or space terminates the symbol.
#
# - All immediate and address values are given in decimal.
#
# - Address values must be positive
#
# - Negative immediate values must have a preceeding '-' with no space
# - between it and the number.
#

# Language definition:
#
# LOAD D A   - load from address A to destination D
# LOADA D A  - load using the address register from address A + RE to destination D
# STORE S A  - store value in S to address A
# STOREA S A - store using the address register the value in S to address A + RE
# BRA L      - branch to label A
# BRAZ L     - branch to label A if the CR zero flag is set
# BRAN L     - branch to label L if the CR negative flag is set
# BRAO L     - branch to label L if the CR overflow flag is set
# BRAC L     - branch to label L if the CR carry flag is set
# CALL L     - call the routine at label L
# RETURN     - return from a routine
# HALT       - execute the halt/exit instruction
# PUSH S     - push source value S to the stack
# POP D      - pop form the stack and put in destination D
# OPORT S    - output to the global port from source S
# IPORT D    - input from the global port to destination D
# ADD A B C  - execute C <= A + B
# SUB A B C  - execute C <= A - B
# AND A B C  - execute C <= A and B  bitwise
# OR  A B C  - execute C <= A or B   bitwise
# XOR A B C  - execute C <= A xor B  bitwise
# SHIFTL A C - execute C <= A shift left by 1
# SHIFTR A C - execute C <= A shift right by 1
# ROTL A C   - execute C <= A rotate left by 1
# ROTR A C   - execute C <= A rotate right by 1
# MOVE A C   - execute C <= A where A is a source register
# MOVEI V C  - execute C <= value V
#

# 2-pass assembler
# pass 1: read through the instructions and put numbers on each instruction location
#         calculate the label values
#
# pass 2: read through the instructions and build the machine instructions
#

import sys

# converts d to an 8-bit 2-s complement binary value


def dec2comp8(d, linenum):
    try:
        if d > 0:
            l = d.bit_length()
            v = "00000000"
            v = v[0:8-l] + format(d, 'b')
        elif d < 0:
            dt = 128 + d
            l = dt.bit_length()
            v = "10000000"
            v = v[0:8-l] + format(dt, 'b')[:]
        else:
            v = "00000000"
    except:
        print('Invalid decimal number on line %d' % (linenum), d)
        exit()

    return v

# converts d to an 8-bit unsigned binary value


def dec2bin8(d, linenum):
    if d > 0:
        l = d.bit_length()
        v = "00000000"
        v = v[0:8-l] + format(d, 'b')
    elif d == 0:
        v = "00000000"
    else:
        print('Invalid address on line %d: value is negative' % (linenum), d)
        exit()

    return v


# Tokenizes the input data, discarding white space and comments
# returns the tokens as a list of lists, one list for each line.
#
# The tokenizer also converts each character to lower case.
def tokenize(fp):
    tokens = []

    # start of the file
    fp.seek(0)

    lines = fp.readlines()

    # strip white space and comments from each line
    for line in lines:
        ls = line.strip()
        uls = ''
        for c in ls:
            if c != '#':
                uls = uls + c
            else:
                break

        # skip blank lines
        if len(uls) == 0:
            continue

        # split on white space
        words = uls.split()

        newwords = []
        for word in words:
            newwords.append(word.lower())

        tokens.append(newwords)

    return tokens


# reads through the file and returns a dictionary of all location
# labels with their line numbers
def pass1(tokens):
    labels = {}
    # generate label dictionary
    for i in range(len(tokens)):
        if len(tokens[i]) == 1:
            if tokens[i][0][-1] == ':':
                if tokens[i][0][:-1] in labels:  # Extension 1
                    print('Error in line', i,
                          ': \'%s\' is multiply defined' % (tokens[i][0][:-1]))
                    exit()
                else:
                    labels[tokens[i][0][:-1]] = i - len(labels)  # double check
    # remove the labels from the tokens
    for token in tokens:
        if len(token) == 1:
            if token[0][-1] == ':':
                tokens.remove(token)
    return labels, tokens


# tables of registers
table_reg = {'ra': '000', 'rb': '001', 'rc': '010',
             'rd': '011', 're': '100', 'sp': '101'}
table_pushpop = {'ra': '000', 'rb': '001', 'rc': '010',
                 'rd': '011', 're': '100', 'sp': '101', 'pc': '110', 'cr': '111'}
table_port = {'ra': '000', 'rb': '001', 'rc': '010', 'rd': '011',
              're': '100', 'sp': '101', 'pc': '110', 'ir': '111'}
table_operate = {'ra': '000', 'rb': '001', 'rc': '010', 'rd': '011',
                 're': '100', 'sp': '101', '0000000000000000': '110', '1111111111111111': '111'}

# reads through the file and returns a list of machine instructions

def pass2(tokens, labels):
    machine = []
    for i in range(len(tokens)):
        # please forgive me for the pain this code causes your eyes

        if tokens[i][0] == 'load':
            if len(tokens[i]) == 3:
                if tokens[i][1] in table_reg:
                    machine.append(
                        '00000' + table_reg[tokens[i][1]] + dec2bin8(labels[tokens[i][2]], i))
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 3:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'loada':
            if len(tokens[i]) == 3:
                if tokens[i][1] in table_reg:
                    machine.append(
                        '00001' + table_reg[tokens[i][1]] + dec2bin8(labels[tokens[i][2]], i))
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 3:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts

        elif tokens[i][0] == 'store':
            if len(tokens[i]) == 3:
                if tokens[i][1] in table_reg:
                    machine.append(
                        '00010' + table_reg[tokens[i][1]] + dec2bin8(labels[tokens[i][2]], i))
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts

            elif len(tokens[i]) > 3:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'storea':
            if len(tokens[i]) == 3:
                if tokens[i][1] in table_reg:
                    machine.append(
                        '00011' + table_reg[tokens[i][1]] + dec2bin8(labels[tokens[i][2]], i))
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 3:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts

        elif tokens[i][0] == 'bra':
            if len(tokens[i]) == 2:
                if tokens[i][1] in labels:
                    machine.append(
                        '00100000' + dec2bin8(labels[tokens[i][1]], i))
                else:
                    print('Error in line %d: invalid label \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many labels' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: no destination label' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'braz':
            if len(tokens[i]) == 2:
                if tokens[i][1] in labels:
                    machine.append(
                        '00110000' + dec2bin8(labels[tokens[i][1]], i))
                else:
                    print('Error in line %d: invalid label \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many labels' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: no destination label' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'bran':
            if len(tokens[i]) == 2:
                if tokens[i][1] in labels:
                    machine.append(
                        '00110001' + dec2bin8(labels[tokens[i][1]], i))
                else:
                    print('Error in line %d: invalid label \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many labels' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: no destination label' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'brao':
            if len(tokens[i]) == 2:
                if tokens[i][1] in labels:
                    machine.append(
                        '00110010' + dec2bin8(labels[tokens[i][1]], i))
                else:
                    print('Error in line %d: invalid label \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many labels' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: no destination label' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'brac':
            if len(tokens[i]) == 2:
                if tokens[i][1] in labels:
                    machine.append(
                        '00110011' + dec2bin8(labels[tokens[i][1]], i))
                else:
                    print('Error in line %d: invalid label \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many labels' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: no destination label' % (i))
                machine.append('1111111111111111')  # Halts

        elif tokens[i][0] == 'call':
            if len(tokens[i]) == 2:
                if tokens[i][1] in labels:
                    machine.append(
                        '00110100' + dec2bin8(labels[tokens[i][1]], i))
                else:
                    print('Error in line %d: invalid label \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many labels' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: no destination label' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'return':
            if len(tokens[i]) == 1:
                machine.append('00111000' + '00000000')
            else:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'halt':
            if len(tokens[i]) == 1:
                machine.append('00111100' + '00000000')
            else:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts

        elif tokens[i][0] == 'push':
            if len(tokens[i]) == 2:
                if tokens[i][1] in table_pushpop:
                    machine.append(
                        '0100' + table_pushpop[tokens[i][1]] + '000000000')
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'pop':
            if len(tokens[i]) == 2:
                if tokens[i][1] in table_pushpop:
                    machine.append(
                        '0101' + table_pushpop[tokens[i][1]] + '000000000')
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'oport':
            if len(tokens[i]) == 2:
                if tokens[i][1] in table_port:
                    machine.append(
                        '0110' + table_port[tokens[i][1]] + '000000000')
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'iport':
            if len(tokens[i]) == 2:
                if tokens[i][1] in table_reg:
                    machine.append(
                        '0111' + table_reg[tokens[i][1]] + '000000000')
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 2:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts

        elif tokens[i][0] == 'add' or tokens[i][0] == 'sub' or tokens[i][0] == 'and' or tokens[i][0] == 'or' or tokens[i][0] == 'xor':
            if len(tokens[i]) == 4:
                if tokens[i][1] in table_operate and tokens[i][2] in table_operate and tokens[i][3] in table_reg:
                    if tokens[i][0] == 'add':
                        machine.append(
                            '1000' + table_operate[tokens[i][1]] + table_operate[tokens[i][2]] + '000' + table_reg[tokens[i][3]])
                    elif tokens[i][0] == 'sub':
                        machine.append(
                            '1001' + table_operate[tokens[i][1]] + table_operate[tokens[i][2]] + '000' + table_reg[tokens[i][3]])
                    elif tokens[i][0] == 'and':
                        machine.append(
                            '1010' + table_operate[tokens[i][1]] + table_operate[tokens[i][2]] + '000' + table_reg[tokens[i][3]])
                    elif tokens[i][0] == 'or':
                        machine.append(
                            '1011' + table_operate[tokens[i][1]] + table_operate[tokens[i][2]] + '000' + table_reg[tokens[i][3]])
                    elif tokens[i][0] == 'xor':
                        machine.append(
                            '1100' + table_operate[tokens[i][1]] + table_operate[tokens[i][2]] + '000' + table_reg[tokens[i][3]])
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 4:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts

        elif tokens[i][0] == 'shiftl' or tokens[i][0] == 'shiftr' or tokens[i][0] == 'rotl' or tokens[i][0] == 'rotr':
            if len(tokens[i]) == 3:
                if tokens[i][1] in table_operate and tokens[i][2] in table_reg:
                    if tokens[i][0] == 'shiftl':
                        machine.append(
                            '11010' + table_operate[tokens[i][1]] + '00000' + table_reg[tokens[i][2]])
                    elif tokens[i][0] == 'shiftr':
                        machine.append(
                            '11011' + table_operate[tokens[i][1]] + '00000' + table_reg[tokens[i][2]])
                    elif tokens[i][0] == 'rotl':
                        machine.append(
                            '11100' + table_operate[tokens[i][1]] + '00000' + table_reg[tokens[i][2]])
                    elif tokens[i][0] == 'rotr':
                        machine.append(
                            '11101' + table_operate[tokens[i][1]] + '00000' + table_reg[tokens[i][2]])
                elif tokens[i][2] in table_port:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    machine.append('1111111111111111')
                elif tokens[i][1] in table_reg:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][2]))
                    machine.append('1111111111111111')
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][1]))
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][2]))
                    machine.append('1111111111111111')
            elif len(tokens[i]) > 3:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')

        elif tokens[i][0] == 'move':
            if len(tokens[i]) == 3:
                if tokens[i][2] in table_port and tokens[i][2] in table_reg:
                    machine.append(
                        '11110' + table_port[tokens[i][1]] + '00000' + table_reg[tokens[i][2]])
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][2]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 3:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts
        elif tokens[i][0] == 'movei':
            if len(tokens[i]) == 3:
                if tokens[i][2] in table_reg:
                    machine.append(
                        '11111' + dec2comp8(int(tokens[i][1]), i) + table_reg[tokens[i][2]])
                else:
                    print('Error in line %d: invalid register \'%s\'' %
                          (i, tokens[i][2]))
                    machine.append('1111111111111111')  # Halts
            elif len(tokens[i]) > 3:
                print('Error in line %d: too many operands' % (i))
                machine.append('1111111111111111')  # Halts
            else:
                print('Error in line %d: too few operands' % (i))
                machine.append('1111111111111111')  # Halts

        else:
            print('Error in line %d: invalid instruction \'%s\'' %
                  (i, ' '.join(tokens[i])))
            machine.append('1111111111111111')  # Halts

    return machine


def main(argv):
    if len(argv) < 2:
        print('Usage: python %s <filename>' % (argv[0]))
        exit()

    fp = open(argv[1], 'r+')

    tokens = tokenize(fp)
    fp.close()

    labels, tokens = pass1(tokens)
    # print(tokens, labels)
    machine = pass2(tokens, labels)

    comments = []
    for i in tokens:
        temp = ''
        for j in i:
            if j in labels:
                temp += '%02X ' % (labels[j])
            else:
                temp += j + ' '
        comments.append(temp)

    # prints out the machine code
    print('\n-- program memory file for %s.a' % (argv[1][:-4]))
    print('DEPTH = 256;')
    print('WIDTH = 16;')
    print('ADDRESS_RADIX = HEX;')
    print('DATA_RADIX = BIN;')
    print('CONTENT')
    print('BEGIN')
    for i in range(len(machine)):
        print('%02X : %s;' % (i, machine[i]) + ' -- ' + str(comments[i]))
    print('[%02X..FF] : 1111111111111111;' % (len(machine)))
    print('END')

    # write to MIF file
    print('\nGenerated %s.mif' % (argv[1][:-4]))  # print out the file name

    f = open(argv[1][:-4] + '.mif', 'w+')
    f.write('-- program memory file for %s.a' % (argv[1][:-4]) + '\n')
    f.write('DEPTH = 256;' + '\n')
    f.write('WIDTH = 16;' + '\n')
    f.write('ADDRESS_RADIX = HEX;' + '\n')
    f.write('DATA_RADIX = BIN;' + '\n')
    f.write('CONTENT' + '\n')
    f.write('BEGIN' + '\n')
    for i in range(len(machine)):
        f.write('%02X : %s;' %
                (i, machine[i]) + ' -- ' + str(comments[i]) + '\n')
    f.write('[%02X..FF] : 1111111111111111;' % (len(machine)) + '\n')
    f.write('END' + '\n')
    f.close()
    return


if __name__ == "__main__":
    main(sys.argv)
