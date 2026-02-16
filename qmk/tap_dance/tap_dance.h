// Docs: https://docs.qmk.fm/#/feature_tap_dance

#pragma once
#include "keymap.h"

enum td_keycodes {
  U_TD_COLN,
  U_TD_K,
  U_TD_V,
  U_TD_DQUO,
  U_TD_PERC,
  U_TD_LBRC,
  U_TD_LPRN,
  U_TD_LCBR,
  U_TD_RCBR,
  U_TD_EXLM,
  U_TD_QUES,
  U_TD_BSPC,
  U_TD_DEL,
};

typedef enum {
    TD_NONE,
    TD_UNKNOWN,
    TD_SINGLE_TAP,
    TD_SINGLE_HOLD,
    TD_DOUBLE_TAP,
    TD_DOUBLE_HOLD,
    TD_TRIPLE_TAP,
    TD_TRIPLE_HOLD
} td_state_t;

// Global
td_state_t cur_dance(tap_dance_state_t *state);
extern tap_dance_action_t tap_dance_actions[11];

// Simple
void u_td_fn_lbrc(tap_dance_state_t *state, void *user_data);
void u_td_fn_lprn(tap_dance_state_t *state, void *user_data);

// Complex - K
void k_finished(tap_dance_state_t *state, void *user_data);
void k_reset(tap_dance_state_t *state, void *user_data);

// Complex - V
void v_finished(tap_dance_state_t *state, void *user_data);
void v_reset(tap_dance_state_t *state, void *user_data);

// Complex - COLN
void coln_finished(tap_dance_state_t *state, void *user_data);
void coln_reset(tap_dance_state_t *state, void *user_data);

// Complex - DQOU
void dquo_finished(tap_dance_state_t *state, void *user_data);
void dquo_reset(tap_dance_state_t *state, void *user_data);

// Complex - PERC
void perc_finished(tap_dance_state_t *state, void *user_data);
void perc_reset(tap_dance_state_t *state, void *user_data);

// Complex - EXLM
void exlm_finished(tap_dance_state_t *state, void *user_data);
void exlm_reset(tap_dance_state_t *state, void *user_data);

// Complex - QUES
void ques_finished(tap_dance_state_t *state, void *user_data);
void ques_reset(tap_dance_state_t *state, void *user_data);

// Complex - LCBR
void lcbr_finished(tap_dance_state_t *state, void *user_data);
void lcbr_reset(tap_dance_state_t *state, void *user_data);

// Complex - RCBR
void rcbr_finished(tap_dance_state_t *state, void *user_data);
void rcbr_reset(tap_dance_state_t *state, void *user_data);
