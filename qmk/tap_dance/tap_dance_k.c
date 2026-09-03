#include "tap_dance.h"

static td_state_t td_state;

void k_finished(tap_dance_state_t *state, void *user_data) {
    td_state = cur_dance(state);
    switch (td_state) {
        case TD_SINGLE_TAP:
            register_code16(KC_K);
            break;
        case TD_SINGLE_HOLD:
            register_mods(MOD_BIT(KC_LGUI));
            break;
        default:
            break;
    }
}

void k_reset(tap_dance_state_t *state, void *user_data) {
    switch (td_state) {
        case TD_SINGLE_TAP:
            unregister_code16(KC_K);
            break;
        case TD_SINGLE_HOLD:
            unregister_mods(MOD_BIT(KC_LGUI));
            break;
        default:
            break;
    }
}

