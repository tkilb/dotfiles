#include "tap_dance.h"

void u_td_fn_lbrc(tap_dance_state_t *state, void *user_data) {
    tap_code(KC_LBRC);
    if (state->count >= 2) {
        tap_code(KC_RBRC);

        tap_code(KC_LEFT);
        reset_tap_dance(state);
    }
}

void u_td_fn_lprn(tap_dance_state_t *state, void *user_data) {
    register_code(KC_LSFT);
    tap_code(KC_9);
    unregister_code(KC_LSFT);
    if (state->count >= 2) {
        register_code(KC_LSFT);
        tap_code(KC_0);
        unregister_code(KC_LSFT);

        tap_code(KC_LEFT);
        reset_tap_dance(state);
    }
}

