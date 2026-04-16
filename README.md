![PATTYS-PICTURE-PACKER_Logo](patty.png)


timmy.sh
#  "Timmy's Time Table"
#
#  PURPOSE:
#  --------
#  Fast, ten-key-friendly time calculator for hh:mm:ss math.
#
#  CORE FEATURES:
#  --------------
#  • Accepts:
#      hh:mm:ss
#      mm:ss
#      ss
#
#  • Ten-key input:
#      "." is treated as ":"
#      Example:
#          1.02.30  ->  1:02:30
#          45.15    ->  45:15
#
#  • Operations:
#      ADD / SUBTRACT
#
#  • Internals:
#      Converts all time → total seconds → math → back to hh:mm:ss
#
#  • Design Philosophy:
#      Permissive parsing (sexagesimal-style, base-60 behavior)
#      Example:
#          1:75:90 → valid → normalized via math
#
#  • House Style:
#      - Colored prompts
#      - ">" prefix
#      - q / 0. exit tokens
#      - Looping calculator mode
