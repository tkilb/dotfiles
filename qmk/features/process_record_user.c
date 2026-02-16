
#include "process_record_user.h"

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case CUST_ALT_QUE:
    if (record->event.pressed) {
      // Start timer to distinguish tap vs hold
      record->tap.interrupted = false;
      register_mods(MOD_BIT(KC_LALT));
    } else {
      unregister_mods(MOD_BIT(KC_LALT));
      // If it was a tap (not held long enough to be Alt)
      if (record->tap.count > 0 && !record->tap.interrupted) {
        if (get_mods() & (MOD_BIT(KC_LSFT) | MOD_BIT(KC_RSFT))) {
          // Shift is held: send '!'
          tap_code16(KC_EXLM);
        } else {
          // No shift: send '?'
          tap_code16(KC_QUES);
        }
      }
    }
    return false;
  }
  return true;
};
