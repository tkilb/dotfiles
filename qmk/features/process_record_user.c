
#include "process_record_user.h"

// 1. Define a timer at the top of your keymap.c (outside the function)
static uint16_t alt_sent_timer;

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case ALT_SENT:
    if (record->event.pressed) {
      // Log the time when pressed and start Alt
      alt_sent_timer = timer_read();
      register_mods(MOD_BIT(KC_LALT));
    } else {
      // Stop Alt immediately on release
      unregister_mods(MOD_BIT(KC_LALT));

      // If released within the TAPPING_TERM, it's a tap
      if (timer_elapsed(alt_sent_timer) < TAPPING_TERM) {
        // Temporarily clear Alt to send the clean symbol
        uint8_t temp_mods = get_mods();
        del_mods(MOD_BIT(KC_LALT));

        if (temp_mods & (MOD_BIT(KC_LSFT) | MOD_BIT(KC_RSFT))) {
          tap_code16(KC_EXLM); // Sends '!'
        } else {
          tap_code16(KC_QUES); // Sends '?'
        }

        // Put back whatever mods were active (like Shift)
        set_mods(temp_mods);
      }
    }
    return false; // Skip default handling
  }
  return true;
}
