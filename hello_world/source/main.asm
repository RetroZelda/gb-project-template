INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]
ENTRYPOINT:
    di ; disable interrupts
    jp START

REPT $150 - $104
    db 0
ENDR

SECTION "Font", ROM0
FontTiles:
INCBIN "resource/font.chr"
FontTilesEnd:

SECTION "Strings", ROM0
HelloWorldStr:
    db "Hello World!", 0

SECTION "Game COde", ROM0
START:
    ; turn off LCD
.waitvblank
    ld a, [rLY]
    cp 144 ; checks if the scanline is past the bottom line before vblank
    jr c, .waitvblank

    ; we are in vblank so we can turn off the lcd(bit 7)
    xor a ; 0 works too - current data in LCDC is irrelevant at this point
    ld [rLCDC], a

    ; lcd is off so we can copy our font to vram
    ld hl, $9000
    ld de, FontTiles ; data source
    ld bc, FontTilesEnd - FontTiles ; data counter
.copyFont
    ld a, [de]  ; load data
    ld [hli], a ; copy to vram, incrementing the vram pointer
    inc de  ; move to next data addr
    dec bc  ; update the counter
    ld a, b ; set z if b == 0
    or c    ; set z i c == 0
    jr nz, .copyFont

    ld hl, $9800    ; the top left of the screen
    ld de, HelloWorldStr
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a ; set z if we copied the null terminator
    jr nz, .copyString

    ; init display registers
    ld a, %11100100
    ld [rBGP], a

    ; reset BG scroll
    xor a
    ld [rSCX], a
    ld [rSCY], a

    ; disable sound
    ld [rNR52], a

    ; enable screen with background
    ld a, %10000001
    ld [rLCDC], a

    ; lock execution
.executionLock
    jr .executionLock
