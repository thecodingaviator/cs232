# Mapping for instructions to their opcodes
instruction_mapping = {
    "MOVE": "00",
    "BINARY": "01",
    "BRANCH": "10",
    "CONDITIONAL_BRANCH": "11",
}

# Mapping for binary operations to their codes
binary_operation_mapping = {
    "ADD": "000",
    "SUB": "001",
    "SHIFT_LEFT": "010",
    "SHIFT_RIGHT": "011",
    "XOR": "100",
    "AND": "101",
    "ROTATE_LEFT": "110",
    "ROTATE_RIGHT": "111",
}

def assemble_instruction(instruction):
    """Convert a human-readable instruction to its machine code representation."""
    
    parts = instruction.split()
    opcode = instruction_mapping.get(parts[0])

    if opcode is None:
        return None

    if opcode == "00" and len(parts) == 4:  # MOVE operation
        dest_map = {"ACC": "00", "LR": "01", "ACC_LOW": "10", "ACC_HIGH": "11"}
        src_map = {"ACC": "00", "LR": "01", "IR_LOW": "10", "ALL_ONES": "11"}

        dest_code = dest_map.get(parts[1])
        src_code = src_map.get(parts[2])

        if dest_code is None or src_code is None:
            return None

        value = format(int(parts[3]), '04b')  # Value is 4 bits for MOVE operation
        return f"{opcode}{dest_code}{src_code}{value}"

    elif opcode == "01" and len(parts) == 5:  # BINARY operation
        dest_map = {"ACC": "0", "LR": "1"}
        src_map = {"ACC": "00", "LR": "01", "IR_LOW": "10", "ALL_ONES": "11"}

        operation_code = binary_operation_mapping.get(parts[1])
        src_code = src_map.get(parts[2])
        dest_code = dest_map.get(parts[3])

        if dest_code is None or src_code is None or operation_code is None:
            return None

        value = format(int(parts[4]), '02b')  # Value is 2 bits for BINARY operation
        return f"{opcode}{operation_code}{src_code}{dest_code}{value}"

    return None

# Example usage:
instruction = "MOVE LR ACC 10"
machine_code = assemble_instruction(instruction)
print(f"Machine Code: {machine_code}" if machine_code else "Invalid instruction.")

instruction = "BINARY ADD ACC ACC 1"
machine_code = assemble_instruction(instruction)
print(f"Machine Code: {machine_code}" if machine_code else "Invalid instruction.")
