#include "tap_dance.h"

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    //        case SFT_T(KC_SPC):
    //            return TAPPING_TERM + 1250;
    //        case LT(1, KC_GRV):
    //            return 130;
  case U_TD_EXLM:
    return 80;
  case U_TD_QUES:
    return 80;
  default:
    return TAPPING_TERM;
  }
}

tap_dance_action_t tap_dance_actions[] = {
    [U_TD_LBRC] = ACTION_TAP_DANCE_FN(u_td_fn_lbrc),
    [U_TD_LPRN] = ACTION_TAP_DANCE_FN(u_td_fn_lprn),
    [U_TD_K] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, k_finished, k_reset),
    [U_TD_V] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, v_finished, v_reset),
    [U_TD_DQUO] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, dquo_finished, dquo_reset),
    [U_TD_PERC] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, perc_finished, perc_reset),
    [U_TD_COLN] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, coln_finished, coln_reset),
    [U_TD_LCBR] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, lcbr_finished, lcbr_reset),
    [U_TD_RCBR] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, rcbr_finished, rcbr_reset),
    [U_TD_EXLM] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, exlm_finished, exlm_reset),
    [U_TD_QUES] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, ques_finished, ques_reset)
};
