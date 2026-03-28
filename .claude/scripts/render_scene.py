#!/usr/bin/env python3
"""Render a scene from the Ali Baba disk image using the custom font.

Usage:
    python .claude/scripts/render_scene.py SCENE_NUM [OUTPUT_FILE]

SCENE_NUM: decimal or $hex scene number
OUTPUT_FILE: defaults to output/scene_XX.png
"""
from __future__ import annotations

import sys
from PIL import Image

DISK_FILE = 'Ali Baba and the Forty Thieves (4am and san inc crack).dsk'
MAIN_BIN = 'main.bin'
MAIN_BIN_BASE = 0x0500
FONT_START = 0x83A5
SKEW_TABLE = [0, 7, 14, 6, 13, 5, 12, 4, 11, 3, 10, 2, 9, 1, 8, 15]

# Scene text uses FONT_CHARSET=2 -> HRCG charset 3 -> font char offset 48
SCENE_CHAR_OFFSET = 48

# Apple II hi-res artifact colors
COLORS: dict[str, tuple[int, int, int]] = {
    '.': (0, 0, 0),
    'G': (0, 255, 0),
    'V': (128, 0, 255),
    'O': (255, 128, 0),
    'B': (0, 128, 255),
    'W': (255, 255, 255),
}

SCALE = 3
CHAR_W = 14
CHAR_H = 16
COLS = 20
ROWS = 12


def read_sector(disk: bytes, track: int, sector: int) -> bytes | None:
    for phys_s in range(16):
        if SKEW_TABLE[phys_s] == sector:
            offset = (track * 16 + phys_s) * 256
            return disk[offset:offset + 256]
    return None


def get_char_pixels(ref: bytes, font_char_idx: int) -> list[list[str]]:
    """Get 14x16 colored pixel array using Apple II hi-res color algorithm."""
    font_offset = FONT_START - MAIN_BIN_BASE
    data = ref[font_offset + font_char_idx * 32:
               font_offset + (font_char_idx + 1) * 32]
    if len(data) < 32:
        return [['.' for _ in range(14)] for _ in range(16)]

    sprite_data: list[str] = [""] * 16
    for j in range(8):
        sprite_data[j] = f"{data[j]:08b}{data[j+8]:08b}"
    for j in range(8):
        sprite_data[j + 8] = f"{data[j+16]:08b}{data[j+24]:08b}"

    pixel_data: list[list[str]] = []
    for line in sprite_data:
        raw = f"{line[9:16]}{line[1:8]}"
        raw = raw[::-1]
        color_set = line[0]
        color01 = "O" if color_set == "1" else "G"
        color10 = "B" if color_set == "1" else "V"
        pixels = list("..............")
        for i in range(0, 14, 2):
            if raw[i:i + 2] == "01":
                pixels[i + 1] = color01
            elif raw[i:i + 2] == "10":
                pixels[i] = color10
        for i in range(13):
            if raw[i:i + 2] == "11":
                pixels[i:i + 2] = list("WW")
        for i in range(12):
            if raw[i:i + 3] == "010":
                color = color10 if ((i + 1) % 2) == 0 else color01
                pixels[i + 1] = color
            elif raw[i:i + 3] == "101":
                color = color10 if ((i + 1) % 2) == 1 else color01
                pixels[i + 1] = color
        pixel_data.append(pixels)
    return pixel_data


def render_scene(scene_num: int, output_file: str) -> None:
    ref = open(MAIN_BIN, 'rb').read()
    disk = open(DISK_FILE, 'rb').read()

    total_sector = scene_num
    track = 0x11 + total_sector // 13
    sector = total_sector % 13
    scene_data = read_sector(disk, track, sector)
    if scene_data is None:
        print(f"Error: could not read scene {scene_num}")
        return

    img_w = COLS * CHAR_W * SCALE
    img_h = ROWS * CHAR_H * SCALE
    img = Image.new('RGB', (img_w, img_h), (0, 0, 0))

    def draw_char(scene_char_idx: int, col: int, row: int) -> None:
        if scene_char_idx == 0:
            return
        font_idx = SCENE_CHAR_OFFSET + scene_char_idx
        pixels = get_char_pixels(ref, font_idx)
        px_x = col * CHAR_W * SCALE
        px_y = row * CHAR_H * SCALE
        for y in range(CHAR_H):
            for x in range(CHAR_W):
                color = COLORS.get(pixels[y][x], (0, 0, 0))
                if color != (0, 0, 0):
                    for sy in range(SCALE):
                        for sx in range(SCALE):
                            ix = px_x + x * SCALE + sx
                            iy = py + y * SCALE + sy
                            if 0 <= ix < img_w and 0 <= iy < img_h:
                                img.putpixel((ix, iy), color)

    col = 2
    row = 0
    left_margin = 2
    right_margin = 18

    i = 0
    while i < len(scene_data):
        b = scene_data[i]
        if b == 0x7F:
            break
        elif b == 0x7E:
            pass  # page break — skip for static render
        elif b == 0x7D:
            left_margin = 0
            right_margin = 20
        elif b >= 0x80:
            row = b & 0x7F
            i += 1
            col = scene_data[i]
        else:
            draw_char(b, col, row)
            col += 1
            if col >= right_margin:
                col = left_margin
                row += 1
        i += 1

    img.save(output_file)
    print(f"Saved {output_file} ({img_w}x{img_h})")


def main() -> None:
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} SCENE_NUM [OUTPUT_FILE]")
        sys.exit(1)

    arg = sys.argv[1]
    if arg.startswith('$') or arg.startswith('0x'):
        scene_num = int(arg.lstrip('$').lstrip('0x'), 16)
    else:
        scene_num = int(arg)

    output_file = sys.argv[2] if len(sys.argv) > 2 else f"output/scene_{scene_num:02x}.png"
    render_scene(scene_num, output_file)


if __name__ == '__main__':
    main()
