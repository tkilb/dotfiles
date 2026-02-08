#include "tap_dance.h"

static td_state_t td_state;

void dquo_finished(tap_dance_state_t *state, void *user_data) {
    td_state = cur_dance(state);
    switch (td_state) {
        case TD_SINGLE_TAP:
            register_mods(MOD_BIT(KC_LSFT));
            register_code16(KC_QUOT);
            break;
        case TD_SINGLE_HOLD:
            layer_on(U_FUN);
            break;
        case TD_DOUBLE_TAP:
            register_mods(MOD_BIT(KC_LSFT));
            tap_code(KC_QUOT);
            tap_code(KC_QUOT);
            unregister_mods(MOD_BIT(KC_LSFT));
            break;
        default:
            break;
    }
}

void dquo_reset(tap_dance_state_t *state, void *user_data) {
    switch (td_state) {
        case TD_SINGLE_TAP:
            unregister_mods(MOD_BIT(KC_LSFT));
            unregister_code16(KC_QUOT);
            break;
        case TD_SINGLE_HOLD:
            layer_off(U_FUN);
            break;
        case TD_DOUBLE_TAP:
            unregister_mods(MOD_BIT(KC_LSFT));
        default:
            break;
    }
}
