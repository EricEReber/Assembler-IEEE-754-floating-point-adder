@ The two numbers we want to add
num2:   .word   0x40600000
num1:   .word   0x40400000
expmask: .word   0x807FFFFF

.text
.global main
main:
    @ Load numbers
    LDR r0, num1
    LDR r1, num2
    @ ! Perform addition here !
    
    LDR r6, expmask    @ expmask er mer enn 8 bits, og må dermed lastes inn
    BIC r2, r0, r6     @ Maskerer ut eksponent via BIC
    BIC r3, r1, r6
    
    AND r4, r0, r6     @ Maskerer ut brøkdel via AND siden vi vil maskere det motsatte av eksponenten. Husk at "sign" alltid er 0 i denne oppgaven uansett
    AND r5, r1, r6
    ADD r4, #0x800000  @ Tallet vi adderer med er mindre enn 8 bit, så vi kan bruke det uten å laste inn
    ADD r5, #0x800000  @ Setter på ledende ener
    
    SUBS r7, r2, r3    @ Subtraherer og setter flagg
    LSR r7, r7, #23    @ Finner differansen ved å subtrahere og shifte slik differansen blir de mest signifikante bitene
    MOVPL r8, r2       @ Dersom differansen er positiv, er den største eksponenten r2
    LSRPL r5, r5, r7   @ Shifter den mindre brøkdelen med differansen
    MOVMI r8, r3
    NEGMI r7, r7       @ Inverterer r7 dersom negativ
    LSRMI r4, r4, r7
    
    ADD r7, r4, r5     @ Adderer brøkdelene
    CMP r7, #0x1000000 @ Dersom den har "carry", vil den være større eller lik 0x1000000, fordi brøkdelene ikke ikke ligger på de mest signifikante bitene
    LSRPL r7, #1       @ Dersom carry, shifter r7 med 1 og øker eksponenten (som ikke ligger på den mest signifikante biten) med en
    ADDPL r8, #0x800000
    BIC r7, #0x800000  @ Setter posisjonen der ledende ener er til 0
    
    ORR r0, r8, r7     @ Badaboom
    
    @ When done, return
    BX lr
