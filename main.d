import std.stdio;

/// The memory size.
const int MEMORY_SIZE = 32;

/// Represents the kind of the opcode.
enum OpcodeKind {
    Loadi, // Loadi rx l1
    Addi, // Addi rx ra l1
    Compare, // Compare rx ra rb
    Jump, // Jump l1
    Branch, // Branch ra l1
    Exit // Exit
}

/// Represents an opcode with 3 operands.
class Opcode
{
    /// Kind represents the opcode kind.
    OpcodeKind kind;
    /// Represents the operand 1.
    long op1;
    /// Represents the operand 2.
    long op2;
    /// Represents the operand 3.
    long op3;
    /// Creates a new opcode.
    this(OpcodeKind kind, long op1 = 0, long op2 = 0, long op3 = 0) {
        this.kind = kind;
        this.op1 = op1;
        this.op2 = op2;
        this.op3 = op3;
    }
}

/// Entry point.
void main() {
    // Program memory (registers)
    long[MEMORY_SIZE] memory;
    // Program code to execute.
    const Opcode[] code = [
        new Opcode(OpcodeKind.Loadi, 0, 1_000_000_000), // r0 = 1000000000;
        new Opcode(OpcodeKind.Loadi, 1, 0), // r1 = 0;
        new Opcode(OpcodeKind.Compare, 2, 0, 1), // r2 = r0 == r1;
        new Opcode(OpcodeKind.Branch, 2, 2), // if (r2 == 0) goto +2;
        new Opcode(OpcodeKind.Addi, 1, 1, 1), // r0 = r0 + 1;
        new Opcode(OpcodeKind.Jump, -4), // goto -4;
        new Opcode(OpcodeKind.Exit)
    ];
    // Program Counter.
    uint pc = 0;
    // The VM itself.
    for (;;) {
        const Opcode op = code[pc];
        // printf("(%u) Kind = %u\n\tr0=%d\tr1=%d\tr2=%d\n", pc, op.kind, memory[0], memory[1], memory[2]);
        final switch (op.kind) {
            case OpcodeKind.Loadi: { memory[cast(uint) op.op1] = op.op2; break; }
            case OpcodeKind.Addi: { memory[cast(uint) op.op1] = memory[cast(uint) op.op2] + op.op3; break; }
            case OpcodeKind.Compare: { memory[cast(uint) op.op1] = memory[cast(uint)op.op2] == memory[cast(uint) op.op3]; break; }
            case OpcodeKind.Jump: { pc += cast(uint)op.op1; break; }
            case OpcodeKind.Branch: { if (memory[cast(uint) op.op1] != 0) pc += cast(uint) op.op1; break; }
            case OpcodeKind.Exit: { goto end; }
        }
        pc++;
    }
    end: writef("Result: %d", memory[1]);
}
