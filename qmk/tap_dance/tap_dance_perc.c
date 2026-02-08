#include "tap_dance.h"

static td_state_t td_state;

void perc_finished(tap_dance_state_t *state, void *user_data) {
    td_state = cur_dance(state);
    switch (td_state) {
        case TD_SINGLE_TAP:
            register_mods(MOD_BIT(KC_LSFT));
            register_code16(KC_5);
            break;
        case TD_SINGLE_HOLD:
            register_mods(MOD_BIT(KC_LALT));
            break;
        default:
            break;
    }
}

void perc_reset(tap_dance_state_t *state, void *user_data) {
    switch (td_state) {
        case TD_SINGLE_TAP:
            unregister_mods(MOD_BIT(KC_LSFT));
            unregister_code16(KC_5);
            break;
        case TD_SINGLE_HOLD:
            unregister_mods(MOD_BIT(KC_LALT));
            break;
        default:
            break;
    }
}
