![Timmys-Time-Table_Logo](timmy.png)


timmy.sh
#  "Timmy's Time Table"
#
#  PURPOSE:
#  --------
#  Fast, ten-key-friendly time calculator for hh:mm:ss math.
#
#
#  • Design Philosophy:
#      Permissive parsing (sexagesimal-style, base-60 behavior)
#      Example:
#          1:75:90 → valid → normalized via math
#  • Accepts Ten-key input:
#                  . is treated as :
#      Example:   1.02.30  =   1:02:30
#                   45.15  =     45:15
#      hh.mm.ss
#      mm.ss
#      hh:mm:ss
#      mm:ss
#      ss
#    All wording and prompts are left close to the left margin intentionally
#    so you can resize Timmy's window down to a small calculator sized "winlet"
#  • Operations:
#      ADD / SUBTRACT
#  • Internals:
#      Converts all time → total seconds → math → back to hh:mm:ss
#  • House Style:
#      - Colored prompts
#      - ">" prefix
#      - q / 0. exit tokens
#      - Looping calculator mode
