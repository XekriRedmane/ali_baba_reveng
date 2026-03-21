#!/usr/bin/env python3
"""Reorder chunk references in <<main.asm>> by ORG address.

Reads main.nw, finds the <<main.asm>>= chunk, collects all chunk
references (lines like <<chunk name>>), resolves each chunk's first
ORG address, and reorders the references in ascending ORG order.

Non-chunk lines (blank lines, comments) within the chunk list are
removed. The chunk definition content is not modified — only the
order of references in <<main.asm>> changes.

Usage:
    python .claude/skills/assemble/reorder_chunks.py
"""

from __future__ import annotations

import re
import sys

FILE = 'main.nw'


def find_chunk_org(chunk_name: str, lines: list[str]) -> int | None:
    """Find the first ORG address in a chunk definition."""
    # Search for <<chunk_name>>= (definition)
    target = f'<<{chunk_name}>>='
    in_chunk = False
    for line in lines:
        stripped = line.strip()
        if stripped == target:
            in_chunk = True
            continue
        if in_chunk:
            # Look for ORG directive
            m = re.match(r'\s+ORG\s+\$([0-9A-Fa-f]+)', line)
            if m:
                return int(m.group(1), 16)
            # If we hit another chunk definition or @, stop
            if stripped.startswith('<<') and stripped.endswith('>>='):
                # This is an append to the same chunk
                if stripped == target:
                    continue
                # Different chunk — check if it also has an ORG
                in_chunk = False
            if stripped == '@' or stripped.startswith('@ %def'):
                in_chunk = False
    return None


def main() -> None:
    with open(FILE, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # Find the <<main.asm>>= chunk in the file
    # It's typically near the end, containing lines like <<chunk name>>
    main_asm_start = -1
    main_asm_end = -1
    for i, line in enumerate(lines):
        if line.strip() == '<<main.asm>>=':
            main_asm_start = i
        elif main_asm_start >= 0 and main_asm_end < 0:
            # The chunk ends at @ or at the next chunk definition
            if line.strip() == '@' or (
                line.strip().startswith('<<') and line.strip().endswith('>>=')
                and line.strip() != '<<main.asm>>='
            ):
                main_asm_end = i
                break

    if main_asm_start < 0:
        print('ERROR: <<main.asm>>= chunk not found')
        sys.exit(1)
    if main_asm_end < 0:
        main_asm_end = len(lines)

    # Extract chunk references from the main.asm chunk
    chunk_ref_pattern = re.compile(r'^<<(.+)>>$')
    refs: list[str] = []
    non_chunk_lines_before: list[str] = []  # lines before first chunk ref

    found_first = False
    for i in range(main_asm_start + 1, main_asm_end):
        line = lines[i]
        m = chunk_ref_pattern.match(line.strip())
        if m:
            found_first = True
            refs.append(m.group(1))
        elif not found_first:
            non_chunk_lines_before.append(line)

    print(f'Found {len(refs)} chunk references in <<main.asm>>')

    # Resolve ORG addresses for each chunk
    chunk_orgs: dict[str, int] = {}
    unresolved: list[str] = []
    for name in refs:
        org = find_chunk_org(name, lines)
        if org is not None:
            chunk_orgs[name] = org
        else:
            unresolved.append(name)

    if unresolved:
        print(f'WARNING: {len(unresolved)} chunks have no ORG:')
        for name in unresolved:
            print(f'  <<{name}>>')

    # Sort by ORG address (unresolved chunks keep their relative order at the end)
    resolved = [name for name in refs if name in chunk_orgs]
    resolved.sort(key=lambda n: chunk_orgs[n])

    # Check for duplicate ORG addresses
    seen_orgs: dict[int, list[str]] = {}
    for name in resolved:
        org = chunk_orgs[name]
        seen_orgs.setdefault(org, []).append(name)
    for org, names in seen_orgs.items():
        if len(names) > 1:
            print(f'  NOTE: multiple chunks at ${org:04X}: {", ".join(names)}')

    # Rebuild the main.asm chunk
    new_refs = resolved + unresolved
    new_chunk_lines = [lines[main_asm_start]]  # <<main.asm>>=
    new_chunk_lines.extend(non_chunk_lines_before)
    for name in new_refs:
        new_chunk_lines.append(f'<<{name}>>\n')

    # Replace in file
    new_lines = lines[:main_asm_start] + new_chunk_lines + lines[main_asm_end:]

    with open(FILE, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)

    # Report changes
    changes = 0
    for i, (old, new) in enumerate(zip(refs, new_refs)):
        if old != new:
            changes += 1
    print(f'Reordered: {changes} chunks moved')

    # Show the new order with addresses
    if '--verbose' in sys.argv or '-v' in sys.argv:
        for name in new_refs:
            org = chunk_orgs.get(name)
            addr = f'${org:04X}' if org is not None else '????'
            print(f'  {addr}  <<{name}>>')


if __name__ == '__main__':
    main()
