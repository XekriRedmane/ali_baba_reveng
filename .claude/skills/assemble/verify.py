#!/usr/bin/env python3
"""Compare assembled output against the reference binary (main.bin).

Usage:
    python .claude/skills/assemble/verify.py [START END]

With no arguments, shows overall coverage statistics and lists all
undocumented gaps.

With START END (hex addresses), checks just that region for mismatches.

Examples:
    python .claude/skills/assemble/verify.py              # full report
    python .claude/skills/assemble/verify.py 0503 0569    # check one region
"""

from __future__ import annotations

import sys

BASE = 0x0500
TEST_BIN = 'output/main_test.bin'
REF_BIN = 'main.bin'


def parse_addr(s: str) -> int:
    """Parse hex address: '$7780', '0x7780', or '7780'."""
    return int(s.strip().lstrip('$').removeprefix('0x').removeprefix('0X'), 16)


def main() -> None:
    try:
        test = open(TEST_BIN, 'rb').read()
    except FileNotFoundError:
        print(f'ERROR: {TEST_BIN} not found. Run /assemble first.')
        sys.exit(1)

    try:
        ref = open(REF_BIN, 'rb').read()
    except FileNotFoundError:
        print(f'ERROR: {REF_BIN} not found.')
        sys.exit(1)

    if len(test) != len(ref):
        print(f'WARNING: size mismatch: test={len(test)}, ref={len(ref)}')

    size = min(len(test), len(ref))

    # Region check mode
    if len(sys.argv) >= 3:
        start = parse_addr(sys.argv[1])
        end = parse_addr(sys.argv[2])
        ok = True
        for i in range(start - BASE, end - BASE):
            if i >= size:
                break
            if test[i] != ref[i]:
                print(f'  DIFF at ${BASE + i:04X}: '
                      f'expected ${ref[i]:02X}, got ${test[i]:02X}')
                ok = False
                if not ok:
                    # Show up to 5 more diffs
                    count = 1
                    for j in range(i + 1, min(i + 20, end - BASE)):
                        if j < size and test[j] != ref[j]:
                            print(f'  DIFF at ${BASE + j:04X}: '
                                  f'expected ${ref[j]:02X}, got ${test[j]:02X}')
                            count += 1
                            if count >= 5:
                                print('  ...')
                                break
                    break
        if ok:
            print(f'${start:04X}-${end - 1:04X}: MATCH ({end - start} bytes)')
        return

    # Full report mode
    in_diff = False
    diff_start = 0
    gaps: list[tuple[int, int]] = []
    for i in range(size):
        if test[i] != ref[i]:
            if not in_diff:
                diff_start = i
                in_diff = True
        else:
            if in_diff:
                gaps.append((diff_start, i))
                in_diff = False
    if in_diff:
        gaps.append((diff_start, size))

    total_diff = sum(e - s for s, e in gaps)
    documented = size - total_diff

    print(f'Coverage: {documented}/{size} bytes '
          f'({documented * 100 / size:.1f}%)')
    print(f'Remaining: {total_diff} bytes '
          f'({total_diff * 100 / size:.1f}%)')
    print(f'Gaps: {len(gaps)}')
    print()

    # Group gaps by size
    large = [(s, e) for s, e in gaps if e - s >= 500]
    medium = [(s, e) for s, e in gaps if 100 <= e - s < 500]
    small = [(s, e) for s, e in gaps if e - s < 100]

    if large:
        print(f'Large gaps (>= 500 bytes): {len(large)}')
        for s, e in large:
            print(f'  ${BASE + s:04X}-${BASE + e - 1:04X}  {e - s:5d}B')

    if medium:
        print(f'Medium gaps (100-499 bytes): {len(medium)}')
        for s, e in medium:
            print(f'  ${BASE + s:04X}-${BASE + e - 1:04X}  {e - s:5d}B')

    if small:
        total_small = sum(e - s for s, e in small)
        print(f'Small gaps (< 100 bytes): {len(small)} '
              f'({total_small}B total)')


if __name__ == '__main__':
    main()
