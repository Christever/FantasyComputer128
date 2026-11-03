local Instructions     = {}

Instructions.NOP       = 0x00
Instructions.HALT      = 0x01

Instructions.LDA       = 0x10
Instructions.LDB       = 0x11

Instructions.ADD       = 0x20
Instructions.SUB       = 0x21

Instructions.JMP       = 0x30
Instructions.JZ        = 0x31
Instructions.JNZ       = 0x32
Instructions.JC        = 0x33
Instructions.JNC       = 0x34

Instructions.CALL      = 0x40
Instructions.RET       = 0x41

Instructions.PUSH      = 0x50
Instructions.POP       = 0x51

Instructions.INC       = 0x60
Instructions.DEC       = 0x61

Instructions.AND       = 0x70
Instructions.OR        = 0x71
Instructions.XOR       = 0x72
Instructions.NOT       = 0x73

Instructions.CMP       = 0x80

Instructions.LDA_M     = 0x90
Instructions.STA_M     = 0x91
Instructions.LDB_M     = 0x92
Instructions.STB_M     = 0x93

Instructions.LDHL      = 0xA0
Instructions.LDDE      = 0xA1
Instructions.LDIX      = 0xA2
Instructions.LDIY      = 0xA3
Instructions.LDSP      = 0xA4
Instructions.LDPC      = 0xA5
Instructions.LDHL_M    = 0xA6
Instructions.LDDE_M    = 0xA7
Instructions.LDIX_M    = 0xA8
Instructions.LDIY_M    = 0xA9
Instructions.LDSP_M    = 0xAA
Instructions.STHL_M    = 0xAB
Instructions.STDE_M    = 0xAC
Instructions.STIX_M    = 0xAD
Instructions.STIY_M    = 0xAE
Instructions.STSP_M    = 0xAF

Instructions.LDA_B     = 0xB0
Instructions.LDB_A     = 0xB1
-- Transferts entre registres 8 bits
Instructions.LDA_C     = 0xB2
Instructions.LDA_D     = 0xB3
Instructions.LDA_E     = 0xB4
Instructions.LDA_H     = 0xB5
Instructions.LDA_L     = 0xB6

Instructions.LDB_C     = 0xB7
Instructions.LDB_D     = 0xB8
Instructions.LDB_E     = 0xB9
Instructions.LDB_H     = 0xBA
Instructions.LDB_L     = 0xBB

Instructions.LDC_A     = 0xBC
Instructions.LDC_B     = 0xBD
Instructions.LDD_A     = 0xBE
Instructions.LDD_B     = 0xBF

Instructions.LDE_A     = 0xC0
Instructions.LDE_B     = 0xC1
Instructions.LDH_A     = 0xC2
Instructions.LDH_B     = 0xC3
Instructions.LDL_A     = 0xC4
Instructions.LDL_B     = 0xC5

-- Transferts entre registres 16 bits
Instructions.LDHL_DE   = 0xC6
Instructions.LDDE_HL   = 0xC7

Instructions.LDHL_IX   = 0xC8
Instructions.LDIX_HL   = 0xC9

Instructions.LDHL_IY   = 0xCA
Instructions.LDIY_HL   = 0xCB

Instructions.LDDE_IX   = 0xCC
Instructions.LDIX_DE   = 0xCD

Instructions.LDDE_IY   = 0xCE
Instructions.LDIY_DE   = 0xCF

-- Chargement indirect via HL
Instructions.LDA_HL    = 0xD0
Instructions.LDB_HL    = 0xD1
Instructions.LDC_HL    = 0xD2
Instructions.LDD_HL    = 0xD3
Instructions.LDE_HL    = 0xD4
Instructions.LDH_HL    = 0xD5
Instructions.LDL_HL    = 0xD6

-- Écriture indirecte via HL
Instructions.STA_HL    = 0xD7
Instructions.STB_HL    = 0xD8
-- Chargement indirect via DE
Instructions.LDA_DE    = 0xD9
Instructions.LDB_DE    = 0xDA
Instructions.STA_DE    = 0xDB
Instructions.STB_DE    = 0xDC

-- Chargement indirect via IX
Instructions.LDA_IX    = 0xDD
Instructions.LDB_IX    = 0xDE
Instructions.STA_IX    = 0xDF
Instructions.STB_IX    = 0xE0
-- Chargement indirect via IY
Instructions.LDA_IY    = 0xE1
Instructions.LDB_IY    = 0xE2
Instructions.STA_IY    = 0xE3
Instructions.STB_IY    = 0xE4
-- Incrémentation / décrémentation 16 bits
Instructions.INC_HL    = 0xE5
Instructions.DEC_HL    = 0xE6
Instructions.INC_DE    = 0xE7
Instructions.DEC_DE    = 0xE8
Instructions.INC_IX    = 0xE9
Instructions.DEC_IX    = 0xEA
Instructions.INC_IY    = 0xEB
Instructions.DEC_IY    = 0xEC
Instructions.INC_SP    = 0xED
Instructions.DEC_SP    = 0xEE
-- Arithmétique 16 bits
Instructions.ADD_HL_DE = 0xEF
Instructions.ADD_HL_IX = 0xF0
Instructions.ADD_HL_IY = 0xF1
Instructions.SUB_HL_DE = 0xF2
Instructions.SUB_HL_IX = 0xF3
Instructions.SUB_HL_IY = 0xF4
Instructions.AND_HL_DE = 0xF5
Instructions.OR_HL_DE  = 0xF6
Instructions.XOR_HL_DE = 0xF7
Instructions.NOT_HL    = 0xF8
Instructions.NOT_DE    = 0xF9
Instructions.SHL_HL    = 0xFA
Instructions.SHR_HL    = 0xFB
Instructions.SHL_DE    = 0xFC
Instructions.SHR_DE    = 0xFD
return Instructions
