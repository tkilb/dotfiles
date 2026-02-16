#include "process_record_user.h"

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case CUST_ALT_QUE:
    if (record->event.pressed) {
      // Act as Alt immediately on press
      register_mods(MOD_BIT(KC_LALT));
    } else {
      // Release Alt on release
      unregister_mods(MOD_BIT(KC_LALT));

      // If it's a tap, decide which character to send
      if (record->tap.count > 0) {
        if (get_mods() & MOD_MASK_SHIFT) {
          // Shift is held: send '!'
          // tap_code16 handles the internal shift state for you
          tap_code16(KC_EXLM);
        } else {
          // No shift: send '?'
          tap_code16(KC_QUES);
        }
      }
    }
    return false; // Don't process this key further
  }
  return true;
}
