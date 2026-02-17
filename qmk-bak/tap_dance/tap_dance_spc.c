#include "tap_dance.h"

static td_state_t td_state;

void spc_finished(tap_dance_state_t *state, void *user_data) {
    td_state = cur_dance(state);
    switch (td_state) {
        case TD_SINGLE_TAP:

            break;
        case TD_SINGLE_HOLD:

            break;
        case TD_DOUBLE_TAP:

            break;
        case TD_TRIPLE_TAP:

            break;
        default:
            break;
    }
}

void spc_reset(tap_dance_state_t *state, void *user_data) {
    switch (td_state) {
        case TD_SINGLE_TAP:

            break;
        case TD_SINGLE_HOLD:

            break;
        case TD_DOUBLE_TAP:

            break;
        case TD_TRIPLE_TAP:

            break;
        default:
            break;
    }
}
