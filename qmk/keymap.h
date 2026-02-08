// Docs: https://docs.qmk.fm/#/keycodes
// Docs: https://docs.qmk.fm/#/feature_advanced_keycodes

#include QMK_KEYBOARD_H
#include "quantum.h"

// #include "combo/combo.h"
#include "override/override.h"
#include "tap_dance/tap_dance.h"

// Layers
#define U_BASE  0
#define U_NUM   1
#define U_FUN   2
#define U_NAV   3
#define U_MEDIA 4

// Empties
#define U_NP KC_NO
#define U_NA KC_NO
#define U_NU KC_NO
#define XXX  KC_NO
#define ___  KC_NO

// Buttons
#define U_RDO SCMD(KC_Z)
#define U_PST LCMD(KC_V)
#define U_CPY LCMD(KC_C)
#define U_CUT LCMD(KC_X)
#define U_UND LCMD(KC_Z)
#define U_SAVE LGUI(KC_S)
#define U_SCREENSHOT S(G(KC_5))
