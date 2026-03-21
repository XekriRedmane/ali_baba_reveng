#!/usr/bin/env python3
"""Reorder chunk references in assembly files by ORG address.

Usage:
    python .claude/skills/assemble/reorder_chunks.py [TARGET] [-v]

TARGET is one of: main (default), boot1, ealdr, all

Reads main.nw, finds the <<TARGET.asm>>= chunk, resolves each chunk
reference's first ORG address, and reorders them in ascending order.

Use -v for verbose output showing all chunks with their addresses.
"""

from __future__ import annotations

import re
import sys

FILE = 'main.nw'

CHUNK_NAMES = {
    'main':  'main.asm',
    'boot1': 'boot1.asm',
    'ealdr': 'ealdr.asm',
}


def find_chunk_org(chunk_name: str, lines: list[str]) -> int | None:
    """Find the first ORG address in a chunk definition."""
    target = f'<<{chunk_name}>>='
    in_chunk = False
    for line in lines:
        stripped = line.strip()
        if stripped == target:
            in_chunk = True
            continue
        if in_chunk:
            m = re.match(r'\s+ORG\s+\$([0-9A-Fa-f]+)', line)
            if m:
                return int(m.group(1), 16)
            if stripped.startswith('<<') and stripped.endswith('>>='):
                if stripped == target:
                    continue
                in_chunk = False
            if stripped == '@' or stripped.startswith('@ %def'):
                in_chunk = False
    return None


def reorder_target(target: str, lines: list[str]) -> list[str]:
    """Reorder chunk refs in one <<target.asm>>= chunk. Returns modified lines."""
    asm_chunk = f'<<{CHUNK_NAMES[target]}>>='
    chunk_ref_pattern = re.compile(r'^<<(.+)>>$')

    # Find the chunk boundaries
    start = -1
    end = -1
    for i, line in enumerate(lines):
        if line.strip() == asm_chunk:
            start = i
        elif start >= 0 and end < 0:
            if line.strip() == '@' or (
                line.strip().startswith('<<') and line.strip().endswith('>>=')
                and line.strip() != asm_chunk
            ):
                end = i
                break
    if start < 0:
        print(f'  {target}: <<{CHUNK_NAMES[target]}>>= not found')
        return lines
    if end < 0:
        end = len(lines)

    # Extract refs and non-ref lines before first ref
    refs: list[str] = []
    pre_lines: list[str] = []
    found_first = False
    for i in range(start + 1, end):
        m = chunk_ref_pattern.match(lines[i].strip())
        if m:
            found_first = True
            refs.append(m.group(1))
        elif not found_first:
            pre_lines.append(lines[i])

    # Resolve ORGs
    chunk_orgs: dict[str, int] = {}
    unresolved: list[str] = []
    for name in refs:
        org = find_chunk_org(name, lines)
        if org is not None:
            chunk_orgs[name] = org
        else:
            unresolved.append(name)

    # Sort
    resolved = [n for n in refs if n in chunk_orgs]
    resolved.sort(key=lambda n: chunk_orgs[n])
    new_refs = unresolved + resolved  # non-ORG chunks first (macros, defines)

    # Count changes
    changes = sum(1 for a, b in zip(refs, new_refs) if a != b)

    # Rebuild
    new_chunk = [lines[start]]
    new_chunk.extend(pre_lines)
    for name in new_refs:
        new_chunk.append(f'<<{name}>>\n')

    result = lines[:start] + new_chunk + lines[end:]

    print(f'  {target}: {len(refs)} chunks, {changes} reordered'
          + (f', {len(unresolved)} without ORG' if unresolved else ''))

    if '-v' in sys.argv or '--verbose' in sys.argv:
        for name in new_refs:
            org = chunk_orgs.get(name)
            addr = f'${org:04X}' if org is not None else '????'
            print(f'    {addr}  <<{name}>>')

    return result


def main() -> None:
    args = [a for a in sys.argv[1:] if not a.startswith('-')]
    target = args[0] if args else 'main'

    with open(FILE, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    if target == 'all':
        targets = ['main', 'boot1', 'ealdr']
    else:
        targets = [target]

    for t in targets:
        lines = reorder_target(t, lines)

    with open(FILE, 'w', encoding='utf-8') as f:
        f.writelines(lines)


if __name__ == '__main__':
    main()
