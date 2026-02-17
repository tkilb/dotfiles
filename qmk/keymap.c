// Copyright 2023 QMK
// SPDX-License-Identifier: GPL-2.0-or-later

// Docs: https://docs.qmk.fm/#/keycodes
// Docs: https://docs.qmk.fm/#/feature_advanced_keycodes

#include "keymap.h"
#include "override/override.c"
#include "features/achordion.h"
#include "features/process_record_user.h"

#include QMK_KEYBOARD_H

#pragma once 

// Thumbs
#define U_LT1 LGUI_T(KC_ESC)
#define U_LT2 LT(U_NAV, KC_SPC) // LSFT_T(KC_SPC)
#define U_LT3 ALL_T(KC_ENT)

#define U_RT3 LT(U_NUM, KC_BSPC)
#define U_RT2 KC_LSFT
#define U_RT1 LT(U_FUN, KC_DEL)

// Edge Keys
// Left
#define EDGE_Q      LT(U_MEDIA, KC_Q)
#define EDGE_Z      LALT_T(KC_Z)
#define EDGE_X      LCTL_T(KC_X)
#define EDGE_C      LGUI_T(KC_C)
#define EDGE_D      LSFT_T(KC_D)
#define EDGE_V      KC_V
// Right
#define EDGE_QUOTE  MT(MOD_LALT | MOD_LCTL | MOD_LGUI, KC_QUOTE)
#define KC_O      KC_O
#define EDGE_K      KC_K
#define EDGE_H      LSFT_T(KC_H)
#define EDGE_COMM   LGUI_T(KC_COMM)
#define EDGE_DOT    LCTL_T(KC_DOT)
#define EDGE_SLSH   CUST_ALT_QUE
#define NAV_EDGE_H      LSFT_T(KC_F1)
#define NAV_EDGE_COMM   LGUI_T(KC_F2)
#define NAV_EDGE_DOT   LCTL_T(KC_F3)

// Combos
#define _C_  COMBO
#define __   COMBO_END

const key_override_t override_colon_key = ko_make_basic(MOD_MASK_SHIFT, KC_COLN, KC_SCLN); // Shift : is ;
const key_override_t override_double_quote_key = ko_make_basic(MOD_MASK_SHIFT, TD(U_TD_DQUO), KC_QUOT); // Shift " is '
const key_override_t override_equals_combo = ko_make_basic(MOD_MASK_SHIFT, U_RT3, KC_EQL);
const key_override_t override_window_switch = ko_make_basic(MOD_MASK_GUI, ALL_T(KC_MINS), G(KC_GRV));

const key_override_t override_shift_left_paren = ko_make_basic(MOD_MASK_SHIFT, KC_LPRN, KC_LABK); // Shift , is ;
const key_override_t override_shift_right_paren = ko_make_basic(MOD_MASK_SHIFT, KC_RPRN, KC_RABK); // Shift , is ;

const key_override_t override_shift_semi = ko_make_basic(MOD_MASK_SHIFT, EDGE_COMM, KC_SCLN); // Shift , is ;
const key_override_t override_shift_colon = ko_make_basic(MOD_MASK_SHIFT, EDGE_DOT, KC_COLN); // Shift . is :

// EDGE_SLSH: unmodified tap = ?, shift+tap = !
const key_override_t override_slash_to_question = ko_make_with_layers_and_negmods(0, LALT_T(KC_SLSH), LSFT(KC_SLSH), ~0, MOD_MASK_SHIFT); // No shift: / becomes ?
const key_override_t override_shift_question = ko_make_basic(MOD_MASK_SHIFT, LALT_T(KC_SLSH), KC_EXLM); // Shift+/ is !

const key_override_t *key_overrides[] = {
    &override_window_switch,
    &override_shift_left_paren,
    &override_shift_right_paren,
    &override_shift_semi,
    &override_shift_colon,
    &override_slash_to_question,
    &override_shift_question
};

// Base Left Side
const uint16_t PROGMEM _Q_W[]      = {EDGE_Q, KC_W,   COMBO_END};
const uint16_t PROGMEM _W_F[]      = {KC_W, KC_F,     COMBO_END};
const uint16_t PROGMEM _F_P[]      = {KC_F, KC_P,     COMBO_END};
const uint16_t PROGMEM _P_B[]      = {KC_P, KC_B,     COMBO_END};
//
const uint16_t PROGMEM _Q_A[]      = {EDGE_Q, KC_A,   COMBO_END};
const uint16_t PROGMEM _W_R[]      = {KC_W, KC_R,     COMBO_END};
const uint16_t PROGMEM _F_S[]      = {KC_F, KC_S,     COMBO_END};
const uint16_t PROGMEM _P_T[]      = {KC_P, KC_T,     COMBO_END};
const uint16_t PROGMEM _B_G[]      = {KC_B, KC_G,     COMBO_END};
//
const uint16_t PROGMEM _R_S[]      = {KC_R, KC_S,     COMBO_END};
const uint16_t PROGMEM _S_T[]      = {KC_S, KC_T,     COMBO_END};
const uint16_t PROGMEM _T_G[]      = {KC_T, KC_G,     COMBO_END};
//
const uint16_t PROGMEM _A_Z[]      = {KC_A, EDGE_Z,   COMBO_END};
const uint16_t PROGMEM _R_X[]      = {KC_R, EDGE_X,   COMBO_END};
const uint16_t PROGMEM _S_C[]      = {KC_S, EDGE_C,   COMBO_END};
const uint16_t PROGMEM _T_D[]      = {KC_T, EDGE_D,   COMBO_END};
const uint16_t PROGMEM _G_V[]      = {KC_G, EDGE_V,   COMBO_END};
//
const uint16_t PROGMEM _Z_X[]      = {EDGE_Z, EDGE_X, COMBO_END};
const uint16_t PROGMEM _X_C[]      = {EDGE_X, EDGE_C, COMBO_END};
const uint16_t PROGMEM _C_D[]      = {EDGE_C, EDGE_D, COMBO_END};
const uint16_t PROGMEM _D_V[]      = {EDGE_D, EDGE_V, COMBO_END};

// Base Right Side
const uint16_t PROGMEM _L_U[]      = {KC_L, KC_U, COMBO_END};
const uint16_t PROGMEM _U_Y[]      = {KC_U, KC_Y, COMBO_END};
//
const uint16_t PROGMEM _J_M[]      = {KC_J, KC_M, COMBO_END};
const uint16_t PROGMEM _L_N[]      = {KC_L, KC_N, COMBO_END};
const uint16_t PROGMEM _U_E[]      = {KC_U, KC_E, COMBO_END};
const uint16_t PROGMEM _Y_I[]      = {KC_Y, KC_I, COMBO_END};
const uint16_t PROGMEM _QUOT_O[]   = {EDGE_QUOTE, KC_O, COMBO_END};
//
const uint16_t PROGMEM _M_N[]      = {KC_M, KC_N, COMBO_END};
const uint16_t PROGMEM _N_E[]      = {KC_N, KC_E, COMBO_END};
const uint16_t PROGMEM _E_I[]      = {KC_E, KC_I, COMBO_END};
//
const uint16_t PROGMEM _M_K[]      = {KC_M, EDGE_K, COMBO_END};
const uint16_t PROGMEM _N_H[]      = {KC_N, EDGE_H, COMBO_END};
const uint16_t PROGMEM _E_COMM[]   = {KC_E, EDGE_COMM, COMBO_END};
const uint16_t PROGMEM _I_DOT[]    = {KC_I, EDGE_DOT, COMBO_END};
const uint16_t PROGMEM _O_EXCL[]    = {KC_O, EDGE_SLSH, COMBO_END};
//
const uint16_t PROGMEM _H_COMM[]   = {EDGE_H, EDGE_COMM, COMBO_END};
const uint16_t PROGMEM _COMM_DOT[] = {EDGE_COMM, EDGE_DOT, COMBO_END};

// Num Right Side
const uint16_t PROGMEM _7_4[]   = {KC_7, KC_4, COMBO_END};
const uint16_t PROGMEM _8_5[]   = {KC_8, KC_5, COMBO_END};
//
const uint16_t PROGMEM _4_1[]   = {KC_4, KC_1, COMBO_END};
const uint16_t PROGMEM _5_2[]   = {KC_5, KC_2, COMBO_END};


combo_t key_combos[] = {
  // Base Left Side
  _C_(_Q_W, A(C(G(KC_SLSH)))), _C_(_W_F, S(KC_TAB)), _C_(_F_P, KC_TAB), _C_(_P_B, KC_BSPC),
  _C_(_Q_A, G(KC_GRV)), _C_(_W_R, KC_AT), _C_(_F_S, KC_HASH), _C_(_P_T, KC_DLR), _C_(_B_G, KC_PERC),
  _C_(_R_S, KC_LABK), _C_(_S_T, KC_RABK), _C_(_T_G, A(KC_SPC)),
  _C_(_A_Z, G(KC_Z)), _C_(_R_X, KC_GRV), _C_(_S_C, KC_BSLS), _C_(_T_D, KC_EQL), _C_(_G_V, KC_TILD),
  _C_(_Z_X, U_SCREENSHOT), _C_(_X_C, U_CPY), _C_(_C_D, U_PST), _C_(_D_V, S(U_PST)),

  // Base Right Side
  _C_(_L_U, KC_LCBR), _C_(_U_Y, KC_RCBR),
  _C_(_J_M, KC_CIRC),  _C_(_L_N, KC_PLUS), _C_(_U_E, KC_ASTR), _C_(_Y_I, KC_AMPR), _C_(_QUOT_O, KC_GRV),
  _C_(_M_N, A(KC_M)), _C_(_N_E, KC_LPRN), _C_(_E_I, KC_RPRN),
  _C_(_M_K, KC_UNDS), _C_(_N_H, KC_MINS), _C_(_E_COMM, KC_SLSH), _C_(_I_DOT, KC_PIPE), _C_(_O_EXCL, KC_ENT),
  _C_(_H_COMM, KC_LBRC),  _C_(_COMM_DOT, KC_RBRC),

  // Num Right Side
  _C_(_7_4, KC_PLUS), _C_(_8_5, KC_ASTR),
  _C_(_4_1, KC_MINS), _C_(_5_2, KC_SLSH)
};

// Layout Maps
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [U_BASE] = LAYOUT_split_3x6_3(
    /*  _ Tab _            __ Q __            __ W __            __ E __            __ R __            __ T __      |      __ Y __            __ U __             __ I __            __ O __            __ P __                __ [ __ */ \
        XXX,               EDGE_Q,            KC_W,              KC_F,              KC_P,              KC_B,               KC_J,              KC_L,               KC_U,              KC_Y,              EDGE_QUOTE,                ___,       \
    /*  _ Cap _            __ A __            __ S __            __ D __            __ F __            __ G __      |      __ H __            __ J __             __ K __            __ L __            __ ; __                __ ' __ */ \
        XXX,               KC_A,              KC_R,              KC_S,              KC_T,              KC_G,               KC_M,              KC_N,               KC_E,              KC_I,              KC_O,                  ___,       \
    /*  _ Shf _            __ Z __            __ X __            __ C __            __ V __            __ B __      |      __ N __            __ M __             __ , __            __ . __            __ / __                _ Shf _ */ \
        XXX,               EDGE_Z,            EDGE_X,            EDGE_C,            EDGE_D,            EDGE_V,             EDGE_K,            EDGE_H,             EDGE_COMM,         EDGE_DOT,          EDGE_SLSH,             ___,       \
    /*  __ _ __            __ _ __            __ _ __            __ L1 __           __ L2 __           __ L3 __     |      __ R3 __           __ R2 __            __ R1 __           __ _ __            __ _ __                __ _ __ */ \
                                                                 U_LT1,             U_LT2,             U_LT3,              U_RT3,             U_RT2,              U_RT1
  ),
  [U_NUM] = LAYOUT_split_3x6_3(
    /*  _ Tab _            __ Q __            __ W __            __ E __            __ R __            __ T __      |      __ Y __            __ U __             __ I __            __ O __            __ P __                __ [ __ */ \
        XXX,               ___,               ___,              ___,                ___,               ___,                ___,               KC_7,               KC_8,              KC_9,              ___,                   ___,       \
    /*  _ Cap _            __ A __            __ S __            __ D __            __ F __            __ G __      |      __ H __            __ J __             __ K __            __ L __            __ ; __                __ ' __ */ \
        XXX,               ___,               ___,              ___,                ___,               S(KC_G),            ___,               KC_4,               KC_5,              KC_6,              KC_0,                  ___,       \
    /*  _ Shf _            __ Z __            __ X __            __ C __            __ V __            __ B __      |      __ N __            __ M __             __ , __            __ . __            __ / __                _ Shf _ */ \
        XXX,               KC_LALT,           KC_LCTL,           KC_LGUI,           KC_LSFT,           ___,                KC_0,              KC_1,               KC_2,              KC_3,              KC_DOT,                ___,       \
    /*  __ _ __            __ _ __            __ _ __            __ L1 __           __ L2 __           __ L3 __     |      __ R3 __           __ R2 __            __ R1 __           __ _ __            __ _ __                __ _ __ */ \
                                                                 U_LT1,             U_LT2,             KC_DOT,             XXX,               U_RT2,              KC_DOT
  ),//
  [U_FUN] = LAYOUT_split_3x6_3(
    /*  _ Tab _            __ Q __            __ W __            __ E __            __ R __            __ T __      |      __ Y __            __ U __             __ I __            __ O __            __ P __                __ [ __ */ \
        XXX,               ___,               ___,               ___,               ___,               ___,                ___,               KC_F7,              KC_F8,             KC_F9,             KC_F10,                XXX,       \
    /*  _ Cap _            __ A __            __ S __            __ D __            __ F __            __ G __      |      __ H __            __ J __             __ K __            __ L __            __ ; __                __ ' __ */ \
        XXX,               ___,               ___,               ___,               ___,               ___,                ___,               KC_F4,              KC_F5,             KC_F6,             KC_F11,                XXX,       \
    /*  _ Shf _            __ Z __            __ X __            __ C __            __ V __            __ B __      |      __ N __            __ M __             __ , __            __ . __            __ / __                _ Shf _ */ \
        XXX,               KC_LALT,           KC_LCTL,           KC_LGUI,           KC_LSFT,           ___,                ___,               KC_F1,              KC_F2,             KC_F3,             KC_F12,                XXX,       \
    /*  __ _ __            __ _ __            __ _ __            __ L1 __           __ L2 __           __ L3 __     |      __ R3 __           __ R2 __            __ R1 __           __ _ __            __ _ __                __ _ __ */ \
                                                                 U_LT1,             U_LT2,             U_LT3,              U_RT3,             U_RT2,              U_RT1
  ),
  [U_NAV] = LAYOUT_split_3x6_3(
    /*  _ Tab _            __ Q __            __ W __            __ E __            __ R __            __ T __      |      __ Y __            __ U __             __ I __            __ O __            __ P __                __ [ __ */ \
        XXX,               ___,               ___,               KC_UP,             KC_PGUP,           KC_HOME,            ___,               KC_F7,              KC_F8,             KC_F9,             ___,                   XXX,       \
    /*  _ Cap _            __ A __            __ S __            __ D __            __ F __            __ G __      |      __ H __            __ J __             __ K __            __ L __            __ ; __                __ ' __ */ \
        XXX,               KC_HOME,           KC_LEFT,           KC_DOWN,           KC_RGHT,           KC_END,             KC_F12,            KC_F4,              KC_F5,             KC_F6,             KC_F10,               XXX,       \
    /*  _ Shf _            __ Z __            __ X __            __ C __            __ V __            __ B __      |      __ N __            __ M __             __ , __            __ . __            __ / __                _ Shf _ */ \
        XXX,               KC_LALT,           KC_LCTL,           KC_LGUI,           KC_PGDN,           KC_END,             ___,               NAV_EDGE_H,         NAV_EDGE_COMM,     NAV_EDGE_DOT,      KC_LALT,                   XXX,       \
    /*  __ _ __            __ _ __            __ _ __            __ L1 __           __ L2 __           __ L3 __     |      __ R3 __           __ R2 __            __ R1 __           __ _ __            __ _ __                __ _ __ */ \
                                                                 U_LT1,             U_LT2,             U_LT3,              U_RT3,             U_RT2,              U_RT1
  ),
  [U_MEDIA] = LAYOUT_split_3x6_3(
    /*  _ Tab _            __ Q __            __ W __            __ E __            __ R __            __ T __      |      __ Y __            __ U __             __ I __            __ O __            __ P __                __ [ __ */ \
        XXX,               ___,               ___,               KC_MUTE,           ___,               ___,                ___,               ___,                ___,               ___,               ___,                   XXX,       \
    /*  _ Cap _            __ A __            __ S __            __ D __            __ F __            __ G __      |      __ H __            __ J __             __ K __            __ L __            __ ; __                __ ' __ */ \
        XXX,               ___,               ___,               KC_VOLU,           KC_MPLY,           KC_MNXT,            ___,               ___,                ___,               ___,               ___,                   XXX,       \
    /*  _ Shf _            __ Z __            __ X __            __ C __            __ V __            __ B __      |      __ N __            __ M __             __ , __            __ . __            __ / __                _ Shf _ */ \
        XXX,               ___,               ___,               KC_VOLD,           KC_MSTP,           KC_MPRV,            ___,               ___,                ___,               ___,               ___,                   XXX,       \
    /*  __ _ __            __ _ __            __ _ __            __ L1 __           __ L2 __           __ L3 __     |      __ R3 __           __ R2 __            __ R1 __           __ _ __            __ _ __                __ _ __ */ \
                                                                 U_LT1,             U_LT2,             U_LT3,              U_RT3,             U_RT2,              U_RT1
  )
};
