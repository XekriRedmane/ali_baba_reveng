# ali_baba_reveng
Reverse engineering of Ali Baba and the Forty Thieves for the Apple II.

[main.pdf](main.pdf) is the literate programming document for this project. This means the explanatory text is interspersed with source code. The source code can be extracted from the document and compiled.

The goal is to provide all the source code necessary to reproduce a binary identical to the one found on the Internet Archive's [Ali Baba and the Forty Thieves (4am and san inc crack)](https://archive.org/details/AntiquesAliBabaAndTheFortyThieves4amCrack) disk image.

The assembly code is assembled using [`dasm`](https://dasm-assembler.github.io/).

This document doesn't explain every last detail. It's assumed that the reader can find enough details on the 6502 processor and the Apple II series of computers to fill in the gaps.

## Useful 6502 and Apple II resources:

* [Beneath Apple DOS](https://archive.org/details/beneath-apple-dos), by Don Worth and Pieter Lechner, 1982.
* [Apple II Computer Graphics](https://archive.org/details/williams-et-al-1983-apple-ii-computer-graphics), by Ken Williams, Bob Kernaghan, and Lisa Kernaghan, 1983.
* [6502 Assembly Language Programming](https://archive.org/details/6502alp), by Lance A. Leventhal, 1979.
* [Beagle Bros Apple Colors and ASCII Values](https://archive.org/details/Beagle_Bros-Poster_1), Beagle Bros Micro Software Inc, 1984.
* [Hi-Res Graphics and Animation Using Assembly Language, The Guide for Apple II Programmers](https://archive.org/details/hi-res-graphics-and-animation-using-assembly-language), by Leanard I. Malkin, 1985.

## Building

`build.py` is the single-command build pipeline that tangles the literate source, assembles all binaries, and reconstructs the disk image.

### Prerequisites

* Python 3.10+
* [`dasm`](https://dasm-assembler.github.io/), the 6502 assembler (must be on `PATH`).
* A distribution of [TeX Live](https://www.tug.org/texlive/) with the `booktabs` and `tikz` packages (only needed for PDF generation).

### Building the binaries and disk image

```sh
$ python build.py
```

This will:
1. Tangle `main.nw` into assembly files in `output/`.
2. Assemble `main.asm`, `boot1.asm`, and `ealdr.asm` with `dasm`.
3. Reconstruct the complete `.dsk` disk image at `output/ali_baba.dsk`.

To verify the outputs match the original disk image byte-for-byte:

```sh
$ python build.py --verify
```

### Generating the PDF

```sh
$ python weave.py main.nw output
$ cp noweb.sty output/
$ cp -r images output/
$ python font_data.py 83A5 92A4 output/font_data.tex
$ cd output
$ pdflatex main.tex
$ pdflatex main.tex
```

Yes, you have to run `pdflatex` twice. The first run generates auxiliary information about indexes that the second run can use to properly cross-reference things.

## Project structure

* `main.nw` — Literate programming source (noweb format). Contains all assembly code, prose documentation, and build instructions.
* `build.py` — Build pipeline: tangle, assemble, reconstruct disk image.
* `weave.py` — Custom noweb tangler/weaver that generates `.asm` and `.tex` files from `main.nw`.
* `scenes/` — Scene data tracks extracted from the disk image (HEX format, one file per track).
* `ea_splash_screen.asm` — EA splash screen bitmap data.
* `dos.asm` — DOS 3.3 RWTS binary data.
* `boot1.bin`, `ealdr.bin`, `main.bin` — Reference binaries for verification.

## License

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg
