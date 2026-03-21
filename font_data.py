import sys


MAIN_BIN = "main.bin"
MAIN_BIN_BASE = 0x0500


def show_char(data: bytes, ch: int) -> list[str]:
    pixel_data: list[str] = [""] * 16
    sprite_data: list[str] = [""] * 16
    data = data[ch * 32 : (ch + 1) * 32]
    for j in range(8):
        sprite_data[j] = f"{data[j]:08b}{data[j+8]:08b}"
    for j in range(8):
        sprite_data[j + 8] = f"{data[j+16]:08b}{data[j+24]:08b}"

    for n, line in enumerate(sprite_data):
        raw = f"{line[9:16]}{line[1:8]}"
        raw = raw[::-1]
        color_set = line[0]
        color01 = "O" if color_set == "1" else "G"
        color10 = "B" if color_set == "1" else "V"
        pixels = list("..............")
        for i in range(0, 14, 2):
            if raw[i : i + 2] == "01":
                pixels[i + 1] = color01
            elif raw[i : i + 2] == "10":
                pixels[i] = color10
        for i in range(13):
            if raw[i : i + 2] == "11":
                pixels[i : i + 2] = "WW"
        for i in range(12):
            if raw[i : i + 3] == "010":
                color = color10 if ((i + 1) % 2) == 0 else color01
                pixels[i + 1] = color
            elif raw[i : i + 3] == "101":
                color = color10 if ((i + 1) % 2) == 1 else color01
                pixels[i + 1] = color

        pixel_data[n] = "".join(pixels)
    return pixel_data


def main():
    if len(sys.argv) != 4:
        print(f"Usage: {sys.argv[0]} START_ADDR END_ADDR OUTPUT_FILE")
        print(f"  Addresses are hex (e.g. 83A5 92A4)")
        print(f"  Data is read from {MAIN_BIN} (base ${MAIN_BIN_BASE:04X})")
        sys.exit(1)

    start_addr = int(sys.argv[1], 16)
    end_addr = int(sys.argv[2], 16)
    output_file = sys.argv[3]

    data_len = end_addr - start_addr + 1
    if data_len <= 0 or data_len % 32 != 0:
        print(f"Error: address range ${start_addr:04X}-${end_addr:04X} "
              f"({data_len} bytes) must be a positive multiple of 32")
        sys.exit(1)

    num_chars = data_len // 32
    file_offset = start_addr - MAIN_BIN_BASE

    with open(MAIN_BIN, "rb") as f:
        f.seek(file_offset)
        data = f.read(data_len)

    if len(data) != data_len:
        print(f"Error: expected {data_len} bytes but read {len(data)}")
        sys.exit(1)

    pixel_data = []
    for i in range(num_chars):
        pixel_data.append(show_char(data, i))

    with open(output_file, "w") as out:
        for i in range(0, num_chars, 2):
            out.write("\\begin{center}\n")
            out.write("\\scalebox{0.8}{\n")
            out.write("\\begin{tabular}{@{}rcccccccccccccccccccccccccccccc@{}}\n")
            if i + 1 < num_chars:
                out.write(f" & \\multicolumn{{14}}{{c}}{{Character {i}}} & & \\multicolumn{{14}}{{c}}{{Character {i + 1}}} \\\\\n")
                sprites = range(i, i + 2)
            else:
                out.write(f" & \\multicolumn{{14}}{{c}}{{Character {i}}} \\\\\n")
                sprites = range(i, i + 1)
            for row in range(16):
                out.write(f"{row} ")
                for sprite in sprites:
                    for col in range(14):
                        pixel = pixel_data[sprite][row][col]
                        if pixel == ".":
                            out.write("& \\Cbk ")
                        elif pixel == "B":
                            out.write("& \\Cbl ")
                        elif pixel == "O":
                            out.write("& \\Cbo ")
                        elif pixel == "W":
                            out.write("& \\Cbw ")
                        elif pixel == "G":
                            out.write("& \\Cbg ")
                        elif pixel == "V":
                            out.write("& \\Cbv ")
                    out.write("& ")
                out.write("\\\\\n")
            out.write("\\end{tabular}\n")
            out.write("}\n")
            out.write("\\end{center}\n")

    print(f"Wrote {num_chars} characters from ${start_addr:04X}-${end_addr:04X} to {output_file}")


if __name__ == "__main__":
    main()
