#include "process_record_user.h"

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case CUST_ALT_QUE:
    if (record->event.pressed) {
      // Key pressed: Start timer to distinguish tap vs hold
      record->event.time = timer_read();
      register_mods(MOD_BIT(KC_LALT));
    } else {
      // Key released: Unregister Alt
      unregister_mods(MOD_BIT(KC_LALT));

      // If released quickly (a tap), send the character
      if (timer_elapsed(record->event.time) < TAPPING_TERM) {
        if (get_mods() & (MOD_BIT(KC_LSHIFT) | MOD_BIT(KC_RSHIFT))) {
          // Shift is held: Send '!' (Shift + 1)
          del_mods(MOD_BIT(KC_LSHIFT) | MOD_BIT(KC_RSHIFT));
          tap_code16(KC_EXLM);
          set_mods(get_mods()); // Restore shift state
        } else {
          // Shift not held: Send '?' (Shift + /)
          tap_code16(KC_QUES);
        }
      }
    }
    return false; // Skip default handling
  }
  return true;
}
