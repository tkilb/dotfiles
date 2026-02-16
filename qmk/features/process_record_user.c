
#include "process_record_user.h"

static uint16_t alt_sent_timer;

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case CUST_ALT_QUE:
    if (record->event.pressed) {
      alt_sent_timer = timer_read();
      register_mods(MOD_BIT(KC_LALT));
    } else {
      unregister_mods(MOD_BIT(KC_LALT));

      if (timer_elapsed(alt_sent_timer) < TAPPING_TERM) {
        // 1. Force the OS to see that Alt is gone
        send_keyboard_report();

        // 2. Capture current shift state
        uint8_t temp_mods = get_mods();

        // 3. Clear everything for a "clean" tap
        clear_mods();

        if (temp_mods & MOD_MASK_SHIFT) {
          tap_code16(KC_EXLM);
        } else {
          tap_code16(KC_QUES);
        }

        // 4. Restore the Shift state if you were still holding it
        set_mods(temp_mods);
        send_keyboard_report();
      }
    }
    return false;
  }
  return true;
}
