//
//  ProcessorOpcodeParser.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 12/22/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Foundation

extension Processor {
    // Command processor
    func processCommand(_ command: [UInt8]) {
        switch(command[0]) {
        case 0x00: // NOP
            return
        case 0x01: // LD BC,$aabb
            LD(source: makeWord(low: command[1], high: command[2]), destination: &registers.BC)
        case 0x02: // LD (BC),A
            LD(source: registers.A, destinationAddress: registers.BC)
        case 0x03: //INC BC
            INC(destination: &registers.BC)
        case 0x04: //INC B
            INC(destination: &registers.B)
        case 0x05: //DEC B
            DEC(destination: &registers.B)
        case 0x06: //LD B,$xx
            LD(source: command[1], destination: &registers.B)
        case 0x07: //RLCA
            RLC(operand: &registers.A)
        case 0x08: //LD ($aabb),SP
            LD(source: UInt8(registers.SP), destinationAddress: makeWord(low: command[1], high: command[2]))
        case 0x09: //ADD HL,BC
            ADD(destination: &registers.HL, source: registers.BC)
        case 0x0A: //LD A,(BC)
            LD(sourceAddress: registers.BC, destination: &registers.A)
        case 0x0B: //DEC BC
            DEC(destination: &registers.BC)
        case 0x0C: //INC C
            INC(destination: &registers.C)
        case 0x0D: //DEC C
            DEC(destination: &registers.C)
        case 0x0E: //LD C,$xx
            LD(source: command[1], destination: &registers.C)
        case 0x0F: //RRCA
            RRC(operand: &registers.A)
        case 0x10: //STOP
            STOP()
        case 0x11: //LD DE,$aabb
            LD(source: makeWord(low: command[1], high: command[2]), destination: &registers.DE)
        case 0x12: //LD (DE),A
            LD(source: registers.A, destinationAddress: registers.DE)
        case 0x13: //INC DE
            INC(destination: &registers.DE)
        case 0x14: //INC D
            INC(destination: &registers.D)
        case 0x15: //DEC D
            DEC(destination: &registers.D)
        case 0x16: //LD D,$xx
            LD(source: command[1], destination: &registers.D)
        case 0x17: //RLA
            RL(operand: &registers.A)
        case 0x18: //JR $xx
            JR(offset: command[1])
        case 0x19: //ADD HL,DE
            ADD(destination: &registers.HL, source: registers.DE)
        case 0x1A: //LD A,(DE)
            LD(sourceAddress: registers.DE, destination: &registers.A)
        case 0x1B: //DEC DE
            DEC(destination: &registers.DE)
        case 0x1C: //INC E
            INC(destination: &registers.E)
        case 0x1D: //DEC E
            DEC(destination: &registers.E)
        case 0x1E: //LD E,$xx
            LD(source: command[1], destination: &registers.E)
        case 0x1F: //RRA
            RR(operand: &registers.A)
        case 0x20: //JR NZ,$xx
            JR(offset: command[1], condition: .NZ)
        case 0x21: //LD HL,$aabb
            LD(source: makeWord(low: command[1], high: command[2]), destination: &registers.HL)
        case 0x22: //LD (HLI),A
            LDI(source: &registers.A, destinationAddress: &registers.HL)
        case 0x23: //INC HL
            INC(destination: &registers.HL)
        case 0x24: //INC H
            INC(destination: &registers.H)
        case 0x25: //DEC H
            DEC(destination: &registers.H)
        case 0x26: //LD H,$xx
            LD(source: command[1], destination: &registers.H)
        case 0x27: //DAA
            DAA(destination: &registers.A)
        case 0x28: //JR Z,$xx
            JR(offset: command[1], condition: .Z)
        case 0x29: //ADD HL,HL
            ADD(destination: &registers.HL, source: registers.HL)
        case 0x2A: //LD A,(HLI)
            LDI(sourceAddress: &registers.HL, destination: &registers.A)
        case 0x2B: //DEC HL
            DEC(destination: &registers.HL)
        case 0x2C: //INC L
            INC(destination: &registers.L)
        case 0x2D: //DEC L
            DEC(destination: &registers.L)
        case 0x2E: //LD L,$xx
            LD(source: command[1], destination: &registers.L)
        case 0x2F: //CPL
            CPL(destination: &registers.A)
        case 0x30: //JR NC,$xx
            JR(offset: command[1], condition: .NC)
        case 0x31: //LD SP,$aabb
            LD(source: makeWord(low: command[1], high: command[2]), destination: &registers.SP)
        case 0x32: //LD (HLD),A
            LDD(source: &registers.A, destinationAddress: &registers.HL)
        case 0x33: //INC SP
            INC(destination: &registers.SP)
        case 0x34: //INC (HL)
            INC(destinationAddress: registers.HL)
        case 0x35: //DEC (HL)
            DEC(destinationAddress: registers.HL)
        case 0x36: //LD (HL),$xx
            LD(source: command[1], destinationAddress: registers.HL)
        case 0x37: //SCF
            SCF()
        case 0x38: //JR C,$xx
            JR(offset: command[1], condition: .C)
        case 0x39: //ADD HL,SP
            ADD(destination: &registers.HL, source: registers.SP)
        case 0x3A: //LD A,(HLD)
            LDD(sourceAddress: &registers.HL, destination: &registers.A)
        case 0x3B: //DEC SP
            DEC(destination: &registers.SP)
        case 0x3C: //INC A
            INC(destination: &registers.A)
        case 0x3D: //DEC A
            DEC(destination: &registers.A)
        case 0x3E: //LD A,$xx
            LD(source: command[1], destination: &registers.A)
        case 0x3F: //CCF
            CCF()
        case 0x40: //LD B,B
            LD(source: registers.B, destination: &registers.B)
        case 0x41: //LD B,C
            LD(source: registers.C, destination: &registers.B)
        case 0x42: //LD B,D
            LD(source: registers.D, destination: &registers.B)
        case 0x43: //LD B,E
            LD(source: registers.E, destination: &registers.B)
        case 0x44: //LD B,H
            LD(source: registers.H, destination: &registers.B)
        case 0x45: //LD B,L
            LD(source: registers.L, destination: &registers.B)
        case 0x46: //LD B,(HL)
            LD(sourceAddress: registers.HL, destination: &registers.B)
        case 0x47: //LD B,A
            LD(source: registers.A, destination: &registers.B)
        case 0x48: //LD C,B
            LD(source: registers.B, destination: &registers.C)
        case 0x49: //LD C,C
            LD(source: registers.C, destination: &registers.C)
        case 0x4A: //LD C,D
            LD(source: registers.D, destination: &registers.C)
        case 0x4B: //LD C,E
            LD(source: registers.E, destination: &registers.C)
        case 0x4C: //LD C,H
            LD(source: registers.H, destination: &registers.C)
        case 0x4D: //LD C,L
            LD(source: registers.L, destination: &registers.C)
        case 0x4E: //LD C,(HL)
            LD(sourceAddress: registers.HL, destination: &registers.C)
        case 0x4F: //LD C,A
            LD(source: registers.A, destination: &registers.C)
        case 0x50: //LD D,B
            LD(source: registers.B, destination: &registers.D)
        case 0x51: //LD D,C
            LD(source: registers.C, destination: &registers.D)
        case 0x52: //LD D,D
            LD(source: registers.D, destination: &registers.D)
        case 0x53: //LD D,E
            LD(source: registers.E, destination: &registers.D)
        case 0x54: //LD D,H
            LD(source: registers.H, destination: &registers.D)
        case 0x55: //LD D,L
            LD(source: registers.L, destination: &registers.D)
        case 0x56: //LD D,(HL)
            LD(sourceAddress: registers.HL, destination: &registers.D)
        case 0x57: //LD D,A
            LD(source: registers.A, destination: &registers.D)
        case 0x58: //LD E,B
            LD(source: registers.B, destination: &registers.E)
        case 0x59: //LD E,C
            LD(source: registers.C, destination: &registers.E)
        case 0x5A: //LD E,D
            LD(source: registers.D, destination: &registers.E)
        case 0x5B: //LD E,E
            LD(source: registers.E, destination: &registers.E)
        case 0x5C: //LD E,H
            LD(source: registers.H, destination: &registers.E)
        case 0x5D: //LD E,L
            LD(source: registers.L, destination: &registers.E)
        case 0x5E: //LD E,(HL)
            LD(sourceAddress: registers.HL, destination: &registers.E)
        case 0x5F: //LD E,A
            LD(source: registers.A, destination: &registers.E)
        case 0x60: //LD H,B
            LD(source: registers.B, destination: &registers.H)
        case 0x61: //LD H,C
            LD(source: registers.C, destination: &registers.H)
        case 0x62: //LD H,D
            LD(source: registers.D, destination: &registers.H)
        case 0x63: //LD H,E
            LD(source: registers.E, destination: &registers.H)
        case 0x64: //LD H,H
            LD(source: registers.H, destination: &registers.H)
        case 0x65: //LD H,L
            LD(source: registers.L, destination: &registers.H)
        case 0x66: //LD H,(HL)
            LD(sourceAddress: registers.HL, destination: &registers.H)
        case 0x67: //LD H,A
            LD(source: registers.A, destination: &registers.H)
        case 0x68: //LD L,B
            LD(source: registers.B, destination: &registers.L)
        case 0x69: //LD L,C
            LD(source: registers.C, destination: &registers.L)
        case 0x6A: //LD L,D
            LD(source: registers.D, destination: &registers.L)
        case 0x6B: //LD L,E
            LD(source: registers.E, destination: &registers.L)
        case 0x6C: //LD L,H
            LD(source: registers.H, destination: &registers.L)
        case 0x6D: //LD L,L
            LD(source: registers.L, destination: &registers.L)
        case 0x6E: //LD L,(HL)
            LD(sourceAddress: registers.HL, destination: &registers.L)
        case 0x6F: //LD H,A
            LD(source: registers.A, destination: &registers.H)
        case 0x70: //LD (HL),B
            LD(source: registers.B, destinationAddress: registers.HL)
        case 0x71: //LD (HL),C
            LD(source: registers.C, destinationAddress: registers.HL)
        case 0x72: //LD (HL),D
            LD(source: registers.D, destinationAddress: registers.HL)
        case 0x73: //LD (HL),E
            LD(source: registers.E, destinationAddress: registers.HL)
        case 0x74: //LD (HL),H
            LD(source: registers.H, destinationAddress: registers.HL)
        case 0x75: //LD (HL),L
            LD(source: registers.L, destinationAddress: registers.HL)
        case 0x76: //HALT
            HALT()
        case 0x77: //LD (HL),A
            LD(source: registers.A, destinationAddress: registers.HL)
        case 0x78: //LD A,B
            LD(source: registers.B, destination: &registers.A)
        case 0x79: //LD A,C
            LD(source: registers.C, destination: &registers.A)
        case 0x7A: //LD A,D
            LD(source: registers.D, destination: &registers.A)
        case 0x7B: // LD A,E
            LD(source: registers.E, destination: &registers.A)
        case 0x7C: // LD A,H
            LD(source: registers.H, destination: &registers.A)
        case 0x7D: // LD A,L
            LD(source: registers.L, destination: &registers.A)
        case 0x7E: // LD A,(HL)
            LD(sourceAddress: registers.HL, destination: &registers.A)
        case 0x7F: // LD A,A
            LD(source: registers.A, destination: &registers.A)
        case 0x80: // ADD A,B
            ADD(destination: &registers.A, source: registers.B)
        case 0x81: // ADD A,C
            ADD(destination: &registers.A, source: registers.C)
        case 0x82: // ADD A,D
            ADD(destination: &registers.A, source: registers.D)
        case 0x83: // ADD A,E
            ADD(destination: &registers.A, source: registers.E)
        case 0x84: // ADD A,H
            ADD(destination: &registers.A, source: registers.H)
        case 0x85: // ADD A,L
            ADD(destination: &registers.A, source: registers.L)
        case 0x86: // ADD A,(HL)
            ADD(destination: &registers.A, sourceAddress: registers.HL)
        case 0x87: // ADD A,A
            ADD(destination: &registers.A, source: registers.A)
        case 0x88: // ADC A,B
            ADD(destination: &registers.A, source: registers.B)
        case 0x89: // ADC A,C
            ADC(destination: &registers.A, source: registers.C)
        case 0x8A: // ADC A,D
            ADC(destination: &registers.A, source: registers.D)
        case 0x8B: // ADC A,E
            ADC(destination: &registers.A, source: registers.E)
        case 0x8C: // ADC A,H
            ADC(destination: &registers.A, source: registers.H)
        case 0x8D: // ADC A,L
            ADC(destination: &registers.A, source: registers.L)
        case 0x8E: // ADC A,(HL)
            ADC(destination: &registers.A, sourceAddress: registers.HL)
        case 0x8F: // ADC A,A
            ADC(destination: &registers.A, source: registers.A)
        case 0x90: // SUB B
            SUB(destination: &registers.A, source: registers.B)
        case 0x91: // SUB C
            SUB(destination: &registers.A, source: registers.C)
        case 0x92: // SUB D
            SUB(destination: &registers.A, source: registers.D)
        case 0x93: // SUB E
            SUB(destination: &registers.A, source: registers.E)
        case 0x94: // SUB H
            SUB(destination: &registers.A, source: registers.H)
        case 0x95: // SUB L
            SUB(destination: &registers.A, source: registers.L)
        case 0x97: // SUB A
            SUB(destination: &registers.A, source: registers.A)
        case 0x98: // SBC A,B
            SBC(destination: &registers.A, source: registers.B)
        case 0x99: // SBC A,C
            SBC(destination: &registers.A, source: registers.C)
        case 0x9A: // SBC A,D
            SBC(destination: &registers.A, source: registers.D)
        case 0x9B: // SBC A,E
            SBC(destination: &registers.A, source: registers.E)
        case 0x9C: // SBC A,H
            SBC(destination: &registers.A, source: registers.H)
        case 0x9D: // SBC A,L
            SBC(destination: &registers.A, source: registers.L)
        case 0x9E: // SBC A,(HL)
            SBC(destination: &registers.A, sourceAddress: registers.HL)
        case 0x9F: // SBC A,A
            SBC(destination: &registers.A, source: registers.A)
        case 0xA0: // AND B
            AND(destination: &registers.A, source: registers.B)
        case 0xA1: // AND C
            AND(destination: &registers.A, source: registers.C)
        case 0xA2: // AND D
            AND(destination: &registers.A, source: registers.D)
        case 0xA3: // AND E
            AND(destination: &registers.A, source: registers.E)
        case 0xA4: // AND H
            AND(destination: &registers.A, source: registers.H)
        case 0xA5: // AND L
            AND(destination: &registers.A, source: registers.L)
        case 0xA6: // AND (HL)
            AND(destination: &registers.A, sourceAddress: registers.HL)
        case 0xA7: // AND A
            AND(destination: &registers.A, source: registers.A)
        case 0xA8: // XOR B
            XOR(destination: &registers.A, source: registers.B)
        case 0xA9: // XOR C
            XOR(destination: &registers.A, source: registers.C)
        case 0xAA: // XOR D
            XOR(destination: &registers.A, source: registers.D)
        case 0xAB: // XOR E
            XOR(destination: &registers.A, source: registers.E)
        case 0xAC: // XOR H
            XOR(destination: &registers.A, source: registers.H)
        case 0xAD: // XOR L
            XOR(destination: &registers.A, source: registers.L)
        case 0xAE: // XOR (HL)
            XOR(destination: &registers.A, sourceAddress: registers.HL)
        case 0xAF: // XOR A
            XOR(destination: &registers.A, source: registers.A)
        case 0xB0: // OR B
            OR(destination: &registers.A, source: registers.B)
        case 0xB1: // OR C
            OR(destination: &registers.A, source: registers.C)
        case 0xB2: // OR D
            OR(destination: &registers.A, source: registers.D)
        case 0xB3: // OR E
            OR(destination: &registers.A, source: registers.E)
        case 0xB4: // OR H
            OR(destination: &registers.A, source: registers.H)
        case 0xB5: // OR L
            OR(destination: &registers.A, source: registers.L)
        case 0xB6: // OR (HL)
            OR(destination: &registers.A, sourceAddress: registers.HL)
        case 0xB7: // OR A
            OR(destination: &registers.A, source: registers.A)
        case 0xB8: // CP B
            CP(sourceA: registers.A, sourceB: registers.B)
        case 0xB9: // CP C
            CP(sourceA: registers.A, sourceB: registers.C)
        case 0xBA: // CP D
            CP(sourceA: registers.A, sourceB: registers.D)
        case 0xBB: // CP E
            CP(sourceA: registers.A, sourceB: registers.E)
        case 0xBC: // CP H
            CP(sourceA: registers.A, sourceB: registers.H)
        case 0xBD: // CP L
            CP(sourceA: registers.A, sourceB: registers.L)
        case 0xBE: // CP (HL)
            CP(sourceA: registers.A, sourceBAddress: registers.HL)
        case 0xBF: // CP A
            CP(sourceA: registers.A, sourceB: registers.A)
        case 0xC0: // RET NZ
            RET(condition: .NZ)
        case 0xC1: // POP BC
            POP(destination: &registers.BC)
        case 0xC2: // JP NZ,$aabb
            JP(address: makeWord(low: command[1], high: command[2]), condition: .NZ)
        case 0xC3: // JP $aabb
            JP(address: makeWord(low: command[1], high: command[2]))
        case 0xC4: // CALL NZ,$aabb
            CALL(address: makeWord(low: command[1], high: command[2]), condition: .NZ)
        case 0xC5: // PUSH BC
            PUSH(value: registers.BC)
        case 0xC6: // ADD A,$xx
            ADD(destination: &registers.A, source: command[1])
        case 0xC7: // RST $00
            RST(destinationAddress: 0x00)
        case 0xC8: // RET Z
            RET(condition: .Z)
        case 0xC9: // RET
            RET()
        case 0xCA: // JP Z,$aabb
            JP(address: makeWord(low: command[1], high: command[2]), condition: .Z)
        case 0xCB: //
            switch(command[1]) {
            case 0x00: // RLC B
                RLC(operand: &registers.B)
            case 0x01: // RLC C
                RLC(operand: &registers.C)
            case 0x02: // RLC D
                RLC(operand: &registers.D)
            case 0x03: // RLC E
                RLC(operand: &registers.E)
            case 0x04: // RLC H
                RLC(operand: &registers.H)
            case 0x05: // RLC L
                RLC(operand: &registers.L)
            case 0x06: // RLC (HL)
                RLC(operandAddress: registers.HL)
            case 0x07: // RLC A
                RLC(operand: &registers.A)
            case 0x08: // RRC B
                RRC(operand: &registers.B)
            case 0x09: // RRC C
                RRC(operand: &registers.C)
            case 0x0A: // RRC D
                RRC(operand: &registers.D)
            case 0x0B: // RRC E
                RRC(operand: &registers.E)
            case 0x0C: // RRC H
                RRC(operand: &registers.H)
            case 0x0D: // RRC L
                RRC(operand: &registers.L)
            case 0x0E: // RRC (HL)
                RRC(operandAddress: registers.HL)
            case 0x0F: // RRC A
                RRC(operand: &registers.A)
            case 0x10: // RL B
                RL(operand: &registers.B)
            case 0x11: // RL C
                RL(operand: &registers.C)
            case 0x12: // RL D
                RL(operand: &registers.D)
            case 0x13: // RL E
                RL(operand: &registers.E)
            case 0x14: // RL H
                RL(operand: &registers.H)
            case 0x15: // RL L
                RL(operand: &registers.L)
            case 0x16: // RL (HL)
                RL(operandAddress: registers.HL)
            case 0x17: // RLA
                RL(operand: &registers.A)
            case 0x18: // RR B
                RR(operand: &registers.B)
            case 0x19: // RR C
                RR(operand: &registers.C)
            case 0x1A: // RR D
                RR(operand: &registers.D)
            case 0x1B: // RR E
                RR(operand: &registers.E)
            case 0x1C: // RR H
                RR(operand: &registers.H)
            case 0x1D: // RR L
                RR(operand: &registers.L)
            case 0x1E: // RR (HL)
                RR(operandAddress: registers.HL)
            case 0x1F: // RRA
                RR(operand: &registers.A)
            case 0x20: // SLA B
                SLA(operand: &registers.B)
            case 0x21: // SLA C
                SLA(operand: &registers.C)
            case 0x22: // SLA D
                SLA(operand: &registers.D)
            case 0x23: // SLA E
                SLA(operand: &registers.E)
            case 0x24: // SLA H
                SLA(operand: &registers.H)
            case 0x25: // SLA L
                SLA(operand: &registers.L)
            case 0x26: // SLA (HL)
                SLA(operandAddress: registers.HL)
            case 0x27: // SLA A
                SLA(operand: &registers.A)
            case 0x28: // SRA B
                SRA(operand: &registers.B)
            case 0x29: // SRA C
                SRA(operand: &registers.C)
            case 0x2A: // SRA D
                SRA(operand: &registers.D)
            case 0x2B: // SRA
                SRA(operand: &registers.E)
            case 0x2C: // SRA H
                SRA(operand: &registers.H)
            case 0x2D: // SRA L
                SRA(operand: &registers.L)
            case 0x2E: // SRA (HL)
                SRA(operandAddress: registers.HL)
            case 0x2F: // SRA A
                SRA(operand: &registers.A)
            case 0x37: // SWAP A
                SWAP(destination: &registers.A)
            case 0x38: // SRL B
                SRL(operand: &registers.B)
            case 0x39: // SRL C
                SRL(operand: &registers.C)
            case 0x3A: // SRL D
                SRL(operand: &registers.D)
            case 0x3B: // SRL E
                SRL(operand: &registers.E)
            case 0x3C: // SRL H
                SRL(operand: &registers.H)
            case 0x3D: // SRL L
                SRL(operand: &registers.L)
            case 0x3E: // SRL (HL)
                SRL(operandAddress: registers.HL)
            case 0x3F: // SRL A
                SRL(operand: &registers.A)
            case 0x40: // BIT 0,B
                BIT(bit: 0, source: registers.B)
            case 0x41: // BIT 0,C
                BIT(bit: 0, source: registers.C)
            case 0x42: // BIT 0,D
                BIT(bit: 0, source: registers.D)
            case 0x43: // BIT 0,E
                BIT(bit: 0, source: registers.E)
            case 0x44: // BIT 0,H
                BIT(bit: 0, source: registers.H)
            case 0x45: // BIT 0,L
                BIT(bit: 0, source: registers.L)
            case 0x46: // BIT 0,(HL)
                BIT(bit: 0, sourceAddress: registers.HL)
            case 0x47: // BIT 0,A
                BIT(bit: 0, source: registers.A)
            case 0x48: // BIT 1,B
                BIT(bit: 1, source: registers.B)
            case 0x49: // BIT 1,C
                BIT(bit: 1, source: registers.C)
            case 0x4A: // BIT 1,D
                BIT(bit: 1, source: registers.D)
            case 0x4B: // BIT 1,E
                BIT(bit: 1, source: registers.E)
            case 0x4C: // BIT 1,H
                BIT(bit: 1, source: registers.H)
            case 0x4D: // BIT 1,L
                BIT(bit: 1, source: registers.L)
            case 0x4E: // BIT 1,(HL)
                BIT(bit: 1, sourceAddress: registers.HL)
            case 0x4F: // BIT 1,A
                BIT(bit: 1, source: registers.A)
            case 0x50: // BIT 2,B
                BIT(bit: 2, source: registers.B)
            case 0x51: // BIT 2,C
                BIT(bit: 2, source: registers.C)
            case 0x52: // BIT 2,D
                BIT(bit: 2, source: registers.D)
            case 0x53: // BIT 2,E
                BIT(bit: 2, source: registers.E)
            case 0x54: // BIT 2,H
                BIT(bit: 2, source: registers.H)
            case 0x55: // BIT 2,L
                BIT(bit: 2, source: registers.L)
            case 0x56: // BIT 2,(HL)
                BIT(bit: 2, sourceAddress: registers.HL)
            case 0x57: // BIT 2,A
                BIT(bit: 2, source: registers.A)
            case 0x58: // BIT 3,B
                BIT(bit: 3, source: registers.B)
            case 0x59: // BIT 3,C
                BIT(bit: 3, source: registers.C)
            case 0x5A: // BIT 3,D
                BIT(bit: 3, source: registers.D)
            case 0x5B: // BIT 3,E
                BIT(bit: 3, source: registers.E)
            case 0x5C: // BIT 3,H
                BIT(bit: 3, source: registers.H)
            case 0x5D: // BIT 3,L
                BIT(bit: 3, source: registers.L)
            case 0x5E: // BIT 3,(HL)
                BIT(bit: 3, sourceAddress: registers.HL)
            case 0x5F: // BIT 3,A
                BIT(bit: 3, source: registers.A)
            case 0x60: // BIT 4,B
                BIT(bit: 4, source: registers.B)
            case 0x61: // BIT 4,C
                BIT(bit: 4, source: registers.C)
            case 0x62: // BIT 4,D
                BIT(bit: 4, source: registers.D)
            case 0x63: // BIT 4,E
                BIT(bit: 4, source: registers.E)
            case 0x64: // BIT 4,H
                BIT(bit: 4, source: registers.H)
            case 0x65: // BIT 4,L
                BIT(bit: 4, source: registers.L)
            case 0x66: // BIT 4,(HL)
                BIT(bit: 4, sourceAddress: registers.HL)
            case 0x67: // BIT 4,A
                BIT(bit: 4, source: registers.A)
            case 0x68: // BIT 5,B
                BIT(bit: 5, source: registers.B)
            case 0x69: // BIT 5,C
                BIT(bit: 5, source: registers.C)
            case 0x6A: // BIT 5,D
                BIT(bit: 5, source: registers.D)
            case 0x6B: // BIT 5,E
                BIT(bit: 5, source: registers.E)
            case 0x6C: // BIT 5,H
                BIT(bit: 5, source: registers.H)
            case 0x6D: // BIT 5,L
                BIT(bit: 5, source: registers.L)
            case 0x6E: // BIT 5,(HL)
                BIT(bit: 5, sourceAddress: registers.HL)
            case 0x6F: // BIT 5,A
                BIT(bit: 5, source: registers.A)
            case 0x70: // BIT 6,B
                BIT(bit: 6, source: registers.B)
            case 0x71: // BIT 6,C
                BIT(bit: 6, source: registers.C)
            case 0x72: // BIT 6,D
                BIT(bit: 6, source: registers.D)
            case 0x73: // BIT 6,E
                BIT(bit: 6, source: registers.E)
            case 0x74: // BIT 6,H
                BIT(bit: 6, source: registers.H)
            case 0x75: // BIT 6,L
                BIT(bit: 6, source: registers.L)
            case 0x76: // BIT 6,(HL)
                BIT(bit: 6, sourceAddress: registers.HL)
            case 0x77: // BIT 6,A
                BIT(bit: 6, source: registers.A)
            case 0x78: // BIT 7,B
                BIT(bit: 7, source: registers.B)
            case 0x79: // BIT 7,C
                BIT(bit: 7, source: registers.C)
            case 0x7A: // BIT 7,D
                BIT(bit: 7, source: registers.D)
            case 0x7B: // BIT 7,E
                BIT(bit: 7, source: registers.E)
            case 0x7C: // BIT 7,H
                BIT(bit: 7, source: registers.H)
            case 0x7D: // BIT 7,L // Todo: Verify this. It was ommitted in the cheat-sheet, but I assume that's wrong
                BIT(bit: 7, source: registers.L)
            case 0x7E: // BIT 7,(HL) // Todo: See 0x7D
                BIT(bit: 7, sourceAddress: registers.HL)
            case 0x7F: // BIT 7,A
                BIT(bit: 7, source: registers.A)
            case 0x80: // RES 0,B
                RES(bit: 0, destination: &registers.B)
            case 0x81: // RES 0,C
                RES(bit: 0, destination: &registers.C)
            case 0x82: // RES 0,D
                RES(bit: 0, destination: &registers.D)
            case 0x83: // RES 0,E
                RES(bit: 0, destination: &registers.E)
            case 0x84: // RES 0,H
                RES(bit: 0, destination: &registers.H)
            case 0x85: // RES 0,L
                RES(bit: 0, destination: &registers.L)
            case 0x86: // RES 0,(HL)
                RES(bit: 0, destinationAddress: registers.HL)
            case 0x87: // RES 0,A
                RES(bit: 0, destination: &registers.A)
            case 0x88: // RES 1,B
                RES(bit: 1, destination: &registers.B)
            case 0x89: // RES 1,C
                RES(bit: 1, destination: &registers.C)
            case 0x8A: // RES 1,D
                RES(bit: 1, destination: &registers.D)
            case 0x8B: // RES 1,E
                RES(bit: 1, destination: &registers.E)
            case 0x8C: // RES 1,H
                RES(bit: 1, destination: &registers.H)
            case 0x8D: // RES 1,L
                RES(bit: 1, destination: &registers.L)
            case 0x8E: // RES 1,(HL)
                RES(bit: 1, destinationAddress: registers.HL)
            case 0x8F: // RES 1,A
                RES(bit: 1, destination: &registers.A)
            case 0x90: // RES 2,B
                RES(bit: 2, destination: &registers.B)
            case 0x91: // RES 2,C
                RES(bit: 2, destination: &registers.C)
            case 0x92: // RES 2,D
                RES(bit: 2, destination: &registers.D)
            case 0x93: // RES 2,E
                RES(bit: 2, destination: &registers.E)
            case 0x94: // RES 2,H
                RES(bit: 2, destination: &registers.H)
            case 0x95: // RES 2,L
                RES(bit: 2, destination: &registers.L)
            case 0x96: // RES 2,(HL)
                RES(bit: 2, destinationAddress: registers.HL)
            case 0x97: // RES 2,A
                RES(bit: 2, destination: &registers.A)
            case 0x98: // RES 3,B
                RES(bit: 3, destination: &registers.B)
            case 0x99: // RES 3,C
                RES(bit: 3, destination: &registers.C)
            case 0x9A: // RES 3,D
                RES(bit: 3, destination: &registers.D)
            case 0x9B: // RES 3,E
                RES(bit: 3, destination: &registers.E)
            case 0x9C: // RES 3,H
                RES(bit: 3, destination: &registers.H)
            case 0x9D: // RES 3,L
                RES(bit: 3, destination: &registers.L)
            case 0x9E: // RES 3,(HL)
                RES(bit: 3, destinationAddress: registers.HL)
            case 0x9F: // RES 3,A
                RES(bit: 3, destination: &registers.A)
            case 0xA0: // RES 4,B
                RES(bit: 4, destination: &registers.B)
            case 0xA1: // RES 4,C
                RES(bit: 4, destination: &registers.C)
            case 0xA2: // RES 4,D
                RES(bit: 4, destination: &registers.D)
            case 0xA3: // RES 4,E
                RES(bit: 4, destination: &registers.E)
            case 0xA4: // RES 4,H
                RES(bit: 4, destination: &registers.H)
            case 0xA5: // RES 4,L
                RES(bit: 4, destination: &registers.L)
            case 0xA6: // RES 4,(HL)
                RES(bit: 4, destinationAddress: registers.HL)
            case 0xA7: // RES 4,A
                RES(bit: 4, destination: &registers.A)
            case 0xA8: // RES 5,B
                RES(bit: 5, destination: &registers.B)
            case 0xA9: // RES 5,C
                RES(bit: 5, destination: &registers.C)
            case 0xAA: // RES 5,D
                RES(bit: 5, destination: &registers.D)
            case 0xAB: // RES 5,E
                RES(bit: 5, destination: &registers.E)
            case 0xAC: // RES 5,H
                RES(bit: 5, destination: &registers.H)
            case 0xAD: // RES 5,L
                RES(bit: 5, destination: &registers.L)
            case 0xAE: // RES 5,(HL)
                RES(bit: 5, destinationAddress: registers.HL)
            case 0xAF: // RES 5,A
                RES(bit: 5, destination: &registers.A)
            case 0xB0: // RES 6,B
                RES(bit: 6, destination: &registers.B)
            case 0xB1: // RES 6,C
                RES(bit: 6, destination: &registers.C)
            case 0xB2: // RES 6,D
                RES(bit: 6, destination: &registers.D)
            case 0xB3: // RES 6,E
                RES(bit: 6, destination: &registers.E)
            case 0xB4: // RES 6,H
                RES(bit: 6, destination: &registers.H)
            case 0xB5: // RES 6,L
                RES(bit: 6, destination: &registers.L)
            case 0xB6: // RES 6,(HL)
                RES(bit: 6, destinationAddress: registers.HL)
            case 0xB7: // RES 6,A
                RES(bit: 6, destination: &registers.A)
            case 0xB8: // RES 7,B
                RES(bit: 7, destination: &registers.B)
            case 0xB9: // RES 7,C
                RES(bit: 7, destination: &registers.C)
            case 0xBA: // RES 7,D
                RES(bit: 7, destination: &registers.D)
            case 0xBB: // RES 7,E
                RES(bit: 7, destination: &registers.E)
            case 0xBC: // RES 7,H
                RES(bit: 7, destination: &registers.H)
            case 0xBD: // RES 7,L
                RES(bit: 7, destination: &registers.L)
            case 0xBE: // RES 7,(HL)
                RES(bit: 7, destinationAddress: registers.HL)
            case 0xBF: // RES 7,A
                RES(bit: 7, destination: &registers.A)
            case 0xC0: // SET 0,B
                SET(bit: 0, destination: &registers.B)
            case 0xC1: // SET 0,C
                SET(bit: 0, destination: &registers.C)
            case 0xC2: // SET 0,D
                SET(bit: 0, destination: &registers.D)
            case 0xC3: // SET 0,E
                SET(bit: 0, destination: &registers.E)
            case 0xC4: // SET 0,H
                SET(bit: 0, destination: &registers.H)
            case 0xC5: // SET 0,L
                SET(bit: 0, destination: &registers.L)
            case 0xC6: // SET 0,(HL)
                SET(bit: 0, destinationAddress: registers.HL)
            case 0xC7: // SET 0,A
                SET(bit: 1, destination: &registers.A)
            case 0xC8: // SET 1,B
                SET(bit: 1, destination: &registers.B)
            case 0xC9: // SET 1,C
                SET(bit: 1, destination: &registers.C)
            case 0xCA: // SET 1,D
                SET(bit: 1, destination: &registers.D)
            case 0xCB: // SET 1,E
                SET(bit: 1, destination: &registers.E)
            case 0xCC: // SET 1,H
                SET(bit: 1, destination: &registers.H)
            case 0xCD: // SET 1,L
                SET(bit: 1, destination: &registers.L)
            case 0xCE: // SET 1,(HL)
                SET(bit: 1, destinationAddress: registers.HL)
            case 0xCF: // SET 1,A
                SET(bit: 1, destination: &registers.A)
            case 0xD0: // SET 2,B
                SET(bit: 2, destination: &registers.B)
            case 0xD1: // SET 2,C
                SET(bit: 2, destination: &registers.C)
            case 0xD2: // SET 2,D
                SET(bit: 2, destination: &registers.D)
            case 0xD3: // SET 2,E
                SET(bit: 2, destination: &registers.E)
            case 0xD4: // SET 2,H
                SET(bit: 2, destination: &registers.H)
            case 0xD5: // SET 2,L
                SET(bit: 2, destination: &registers.L)
            case 0xD6: // SET 2,(HL)
                SET(bit: 2, destinationAddress: registers.HL)
            case 0xD7: // SET 2,A
                SET(bit: 2, destination: &registers.A)
            case 0xD8: // SET 3,B
				SET(bit: 3, destination: &registers.B)
            case 0xD9: // SET 3,C
                SET(bit: 3, destination: &registers.C)
            case 0xDA: // SET 3,D
                SET(bit: 3, destination: &registers.D)
            case 0xDB: // SET 3,E
                SET(bit: 3, destination: &registers.E)
            case 0xDC: // SET 3,H
                SET(bit: 3, destination: &registers.H)
            case 0xDD: // SET 3,L
                SET(bit: 3, destination: &registers.L)
            case 0xDE: // SET 3,(HL)
                SET(bit: 3, destinationAddress: registers.HL)
            case 0xDF: // SET 3,A
                SET(bit: 3, destination: &registers.A)
            case 0xE0: // SET 4,B
                SET(bit: 4, destination: &registers.B)
            case 0xE1: // SET 4,C
                SET(bit: 4, destination: &registers.C)
            case 0xE2: // SET 4,D
                SET(bit: 4, destination: &registers.D)
            case 0xE3: // SET 4,E
                SET(bit: 4, destination: &registers.E)
            case 0xE4: // SET 4,H
                SET(bit: 4, destination: &registers.H)
            case 0xE5: // SET 4,L
                SET(bit: 4, destination: &registers.L)
            case 0xE6: // SET 4,(HL)
                SET(bit: 4, destinationAddress: registers.HL)
            case 0xE7: // SET 4,A
                SET(bit: 4, destination: &registers.A)
            case 0xE8: // SET 5,B
                SET(bit: 5, destination: &registers.B)
            case 0xE9: // SET 5,C
                SET(bit: 5, destination: &registers.C)
            case 0xEA: // SET 5,D
                SET(bit: 5, destination: &registers.D)
            case 0xEB: // SET 5,E
                SET(bit: 5, destination: &registers.E)
            case 0xEC: // SET 5,H
                SET(bit: 5, destination: &registers.H)
            case 0xED: // SET 5,L
                SET(bit: 5, destination: &registers.L)
            case 0xEE: // SET 5,(HL)
                SET(bit: 5, destinationAddress: registers.HL)
            case 0xEF: // SET 5,A
                SET(bit: 5, destination: &registers.A)
            case 0xF0: // SET 6,B
                SET(bit: 6, destination: &registers.B)
            case 0xF1: // SET 6,C
                SET(bit: 6, destination: &registers.C)
            case 0xF2: // SET 6,D
                SET(bit: 6, destination: &registers.D)
            case 0xF3: // SET 6,E
                SET(bit: 6, destination: &registers.E)
            case 0xF4: // SET 6,H
                SET(bit: 6, destination: &registers.H)
            case 0xF5: // SET 6,L
                SET(bit: 6, destination: &registers.L)
            case 0xF6: // SET 6,(HL)
                SET(bit: 6, destinationAddress: registers.HL)
            case 0xF7: // SET 6,A
                SET(bit: 6, destination: &registers.A)
            case 0xF8: // SET 7,B
                SET(bit: 7, destination: &registers.B)
            case 0xF9: // SET 7,C
                SET(bit: 7, destination: &registers.C)
            case 0xFA: // SET 7,D
                SET(bit: 7, destination: &registers.D)
            case 0xFB: // SET 7,E
                SET(bit: 7, destination: &registers.E)
            case 0xFC: // SET 7,H
                SET(bit: 7, destination: &registers.H)
            case 0xFD: // SET 7,L
                SET(bit: 7, destination: &registers.L)
            case 0xFE: // SET 7,(HL)
                SET(bit: 7, destinationAddress: registers.HL)
            case 0xFF: // SET 7,A
                SET(bit: 7, destination: &registers.A)
            default:
                return
            }
        case 0xCC: // CALL Z,$aabb
            CALL(address: makeWord(low: command[1], high: command[2]), condition: .Z)
        case 0xCD: // CALL $aabb
            CALL(address: makeWord(low: command[1], high: command[2]))
        case 0xCE: // ADC A,$xx
            ADC(destination: &registers.A, source: command[1])
        case 0xCF: // RST $08
            RST(destinationAddress: 0x08)
        case 0xD0: // RET NC
            RET(condition: .NC)
        case 0xD1: // POP DE
            POP(destination: &registers.DE)
        case 0xD2: // JP NC,$aabb
            JP(address: makeWord(low: command[1], high: command[2]), condition: .NC)
        case 0xD4: // CALL NC,$aabb
            CALL(address: makeWord(low: command[1], high: command[2]), condition: .NC)
        case 0xD5: // PUSH DE
            PUSH(value: registers.DE)
        case 0xD6: // SUB $xx
            SUB(destination: &registers.A, source: command[1])
        case 0xD7: // RST $10
            RST(destinationAddress: 0x10)
        case 0xD8: // RET C
            RET(condition: .C)
        case 0xD9: // RETI
            RETI()
        case 0xDA: // JP C,$aabb
            JP(address: makeWord(low: command[1], high: command[2]), condition: .C)
        case 0xDC: // CALL C,$aabb
            CALL(address: makeWord(low: command[1], high: command[2]), condition: .C)
        case 0xDE: // SBC A,$xx
            SBC(destination: &registers.A, source: command[1])
        case 0xDF: // RST $18
            RST(destinationAddress: 0x18)
        case 0xE0: // LD ($xx),A
            // Todo: Assuming this is supposed to be LDH?
            LDH(source: registers.A, destinationAddress: command[1])
        case 0xE1: // POP HL
            POP(destination: &registers.HL)
        case 0xE2: // LD (C),A
            // Todo: How is this 8-bit value supposed to be turned into an address?
            LD(sourceAddress: UInt16(registers.C), destination: &registers.A)
        case 0xE5: // PUSH HL
            PUSH(value: registers.HL)
        case 0xE6: // AND $xx
            AND(destination: &registers.A, source: command[1])
        case 0xE7: // RST $20
            RST(destinationAddress: 0x20)
        case 0xE8: // ADD SP,xx
            ADD(destination: &registers.SP, source: UInt16(command[1]))
        case 0xE9: // JP (HL)
            JP(addressAtAddress: registers.HL)
        case 0xEA: // LD ($aabb),A
            LD(sourceAddress: makeWord(low: command[1], high: command[2]), destination: &registers.A)
        case 0xEE: // XOR $xx
            XOR(destination: &registers.A, source: command[1])
        case 0xEF: // RST $28
            RST(destinationAddress: 0x28)
        case 0xF0: // LD A,($xx)
            LDH(sourceAddress: command[1], destination: &registers.A)
        case 0xF1: // POP AF
            POP(destination: &registers.AF)
        case 0xF2: // LD A,(C)
            // Todo: How is this 8-bit value supposed to be turned into an address?
            LD(sourceAddress: UInt16(registers.C), destination: &registers.A)
        case 0xF3: // DI
            DI()
        case 0xF5: // PUSH AF
            PUSH(value: registers.AF)
        case 0xF6: // OR $xx
            OR(destination: &registers.A, source: command[1])
        case 0xF7: // RST $30
            RST(destinationAddress: 0x30)
        case 0xF8: // LD HL,SP
            LD(source: registers.SP, destination: &registers.HL)
        case 0xF9: // LD SP,HL
            LD(source: registers.HL, destination: &registers.SP)
        case 0xFA: // LD A,($aabb)
            LD(sourceAddress: makeWord(low: command[1], high: command[2]), destination: &registers.A)
        case 0xFB: // EI
            EI()
        case 0xFE: // CP $xx
            CP(sourceA: registers.A, sourceB: command[1])
        case 0xFF: // RST $38
            RST(destinationAddress: 0x38)
        default:
            return
        }
    }
}
