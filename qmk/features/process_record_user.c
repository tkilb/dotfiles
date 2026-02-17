
#include "process_record_user.h"

static uint16_t alt_key_timer = 0;
static bool alt_key_pressed = false;
static bool alt_key_registered = false;

void matrix_scan_user(void) {
  // If key is held and timer expired, register Alt
  if (alt_key_pressed && !alt_key_registered && timer_elapsed(alt_key_timer) >= TAPPING_TERM) {
    register_mods(MOD_BIT(KC_LALT));
    alt_key_registered = true;
  }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case CUST_ALT_QUE:
    if (record->event.pressed) {
      // Key pressed - start timer but don't register Alt yet
      alt_key_timer = timer_read();
      alt_key_pressed = true;
      alt_key_registered = false;
    } else {
      // Key released
      if (!alt_key_pressed) {
        return false; // Already processed
      }
      
      alt_key_pressed = false;
      
      // If Alt was registered (held long enough), unregister it
      if (alt_key_registered) {
        unregister_mods(MOD_BIT(KC_LALT));
        alt_key_registered = false;
      } else {
        // Was a tap - send ? or !
        // Send a "Dummy" key to prevent issues
        tap_code(KC_F24);

        // Clean up all mod states for a pure symbol tap
        uint8_t temp_mods = get_mods();
        clear_mods();
        clear_weak_mods();
        send_keyboard_report();

        // Send the symbol based on Shift state
        if (temp_mods & MOD_MASK_SHIFT) {
          tap_code16(KC_EXLM);
        } else {
          tap_code16(KC_QUES);
        }

        // Restore physical mods
        set_mods(temp_mods);
        send_keyboard_report();
      }
    }
    return false;
  }
  return true;
}
