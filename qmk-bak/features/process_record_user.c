
#include "process_record_user.h"

static uint16_t alt_sent_timer;

static uint16_t alt_sent_timer;

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case CUST_ALT_QUE:
    if (record->event.pressed) {
      alt_sent_timer = timer_read();
      register_mods(MOD_BIT(KC_LALT));
    } else {
      // 1. Kill Alt and force the computer to see the release
      unregister_mods(MOD_BIT(KC_LALT));
      send_keyboard_report();

      if (timer_elapsed(alt_sent_timer) < TAPPING_TERM) {
        // 2. Send a "Dummy" key to stop the OS from highlighting the Alt menu
        tap_code(KC_F24);

        // 3. Clean up all mod states for a pure symbol tap
        uint8_t temp_mods = get_mods();
        clear_mods();
        clear_weak_mods();
        send_keyboard_report();

        // 4. Send the symbol based on Shift state
        if (temp_mods & MOD_MASK_SHIFT) {
          tap_code16(KC_EXLM);
        } else {
          tap_code16(KC_QUES);
        }

        // 5. Restore your physical mods (like Shift)
        set_mods(temp_mods);
        send_keyboard_report();
      }
    }
    return false;
  }
  return true;
}
