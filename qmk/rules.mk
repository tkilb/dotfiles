CAPS_WORD_ENABLE = yes
COMBO_ENABLE = yes
MOUSEKEY_ENABLE = yes
TAP_DANCE_ENABLE = yes
KEY_OVERRIDE_ENABLE = yes
REPEAT_KEY_ENABLE = yes

#features/process_record_user.c 

SRC += \
    features/achordion.c \
		combo/combo.c \
		override/override.c \
		tap_dance/tap_dance.c \
		tap_dance/tap_dance__global.c \
		tap_dance/tap_dance_simple.c \
		tap_dance/tap_dance_k.c \
		tap_dance/tap_dance_v.c \
		tap_dance/tap_dance_coln.c \
		tap_dance/tap_dance_dquo.c \
		tap_dance/tap_dance_exlm.c \
		tap_dance/tap_dance_lcbr.c \
		tap_dance/tap_dance_perc.c \
		tap_dance/tap_dance_ques.c \
		tap_dance/tap_dance_rcbr.c \
		tap_dance/tap_dance_spc.c \
