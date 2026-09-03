#include "tap_dance.h"

// Handle the possible states for each tapdance keycode you define:
static td_state_t td_state;

void lcbr_finished(tap_dance_state_t *state, void *user_data) {
    td_state = cur_dance(state);
    switch (td_state) {
        case TD_SINGLE_TAP:
            register_mods(MOD_BIT(KC_LSFT));
            register_code16(KC_LBRC);
            break;
        case TD_SINGLE_HOLD:
            register_mods(MOD_BIT(KC_LGUI)); // For a layer-tap key, use `layer_on(_MY_LAYER)` here
            break;
        case TD_DOUBLE_TAP: // Allow nesting of 2 parens `((` within tapping term
            register_mods(MOD_BIT(KC_LSFT));
            tap_code(KC_LBRC);
            tap_code(KC_RBRC);
            unregister_mods(MOD_BIT(KC_LSFT));
            tap_code(KC_LEFT);
            break;
        default:
            break;
    }
}

void lcbr_reset(tap_dance_state_t *state, void *user_data) {
    switch (td_state) {
        case TD_SINGLE_TAP:
            unregister_mods(MOD_BIT(KC_LSFT));
            unregister_code16(KC_LBRC);
            break;
        case TD_SINGLE_HOLD:
            unregister_mods(MOD_BIT(KC_LGUI)); // For a layer-tap key, use `layer_off(_MY_LAYER)` here
            break;
        case TD_DOUBLE_TAP:
            unregister_mods(MOD_BIT(KC_LSFT));
            break;
        default:
            break;
    }
}

