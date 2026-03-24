"""Generate per-character font renditions for mob data chapter."""
from __future__ import annotations
import sys
from font_data import show_char

MAIN_BIN = "main.bin"
MAIN_BIN_BASE = 0x0500
FONT_START = 0x83A5

PIXEL_MAP = {
    ".": "\\Cbk",
    "B": "\\Cbl",
    "O": "\\Cbo",
    "W": "\\Cbw",
    "G": "\\Cbg",
    "V": "\\Cbv",
}


def render_one_char(data: bytes, char_num: int) -> str:
    """Return LaTeX for a single character rendition, scaled small."""
    pixel_data = show_char(data, char_num)
    lines: list[str] = []
    lines.append("\\scalebox{0.5}{")
    lines.append("\\begin{tabular}{@{}cccccccccccccc@{}}")
    for row in range(16):
        cells: list[str] = []
        for col in range(14):
            pixel = pixel_data[row][col]
            cells.append(PIXEL_MAP.get(pixel, "\\Cbk"))
        lines.append(" & ".join(cells) + " \\\\")
    lines.append("\\end{tabular}")
    lines.append("}")
    return "\n".join(lines)


def main() -> None:
    file_offset = FONT_START - MAIN_BIN_BASE
    with open(MAIN_BIN, "rb") as f:
        f.seek(file_offset)
        data = f.read(120 * 32)  # 120 characters

    # Find unique font chars used by mobs
    with open(MAIN_BIN, "rb") as f:
        all_data = f.read()

    mob_base = 0x4C80 - MAIN_BIN_BASE

    def appearance_to_fontchar(app: int) -> tuple[int, int]:
        group = app // 21
        remainder = (app % 21) + 1
        fontchar = remainder
        if remainder < 5 and group > 0:
            fontchar = remainder + 32
        return fontchar, group

    used_chars: set[int] = set()
    for i in range(128):
        app = all_data[mob_base + i * 16 + 4]
        fc, _ = appearance_to_fontchar(app)
        used_chars.add(fc)

    # Generate one LaTeX command per unique character
    with open("output/mob_font_data.tex", "w") as out:
        out.write("% Auto-generated mob font character renditions\n")
        out.write("% Usage: \\mobchar{N} renders font character N\n")
        for ch in sorted(used_chars):
            out.write(f"\\expandafter\\def\\csname mobchar@{ch}\\endcsname{{\n")
            out.write(render_one_char(data, ch))
            out.write("\n}\n")
        out.write("\\newcommand{\\mobchar}[1]{\\csname mobchar@#1\\endcsname}\n")

    print(f"Generated {len(used_chars)} unique character renditions")


if __name__ == "__main__":
    main()
