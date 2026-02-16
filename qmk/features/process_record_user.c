
#include "process_record_user.h"

static uint16_t alt_sent_timer;

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case ALT_SENT:
    if (record->event.pressed) {
      alt_sent_timer = timer_read();
      register_mods(MOD_BIT(KC_LALT));
    } else {
      // 1. Unregister Alt and FORCE a report to the computer
      unregister_mods(MOD_BIT(KC_LALT));
      send_keyboard_report();

      if (timer_elapsed(alt_sent_timer) < TAPPING_TERM) {
        // 2. Add a tiny 10ms delay to let the OS process the Alt release
        wait_ms(10);

        // 3. Capture Shift state then clear all mods
        uint8_t temp_mods = get_mods();
        clear_mods();
        clear_weak_mods(); // Crucial: clears QMK's internal shift state
        send_keyboard_report();

        if (temp_mods & MOD_MASK_SHIFT) {
          tap_code16(KC_EXLM);
        } else {
          tap_code16(KC_QUES);
        }

        // 4. Restore Shift if you were still holding it
        set_mods(temp_mods);
        send_keyboard_report();
      }
    }
    return false;
  }
  return true;
}
