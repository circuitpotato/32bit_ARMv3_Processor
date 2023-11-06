# Correct Output - 7 seg
- 0x00000000  --> Configure 7seg to all zeroes 
- 0x00000008  --> AND
- 0x00000002  --> EOR
- 0x00000007  --> SUB
- 0xFFFFFFFE  --> RSB
- 0x00000012  --> ADD
- 0x00000013  --> ADC
- 0x00000001  --> SBC
- 0xFFFFFFFD  --> RSC
- 0x00000C18  --> TST flag up--> placeholder value to show it branched
- 0x00000C04  --> TEQ flag up--> placeholder value to show it branched
- 0x00000C18  --> CMP flag up--> placeholder value to show it branched
- 0x00000C04  --> CMN flag up--> placeholder value to show it branched
- 0x0000000A  --> ORR
- 0x00000001  --> MOV
- 0xFFFFFFFE  --> BIC
- 0xFFFFFFF5  --> MVN

