#!/usr/bin/env python3
"""
image_to_hex.py — Convert Aadhaar JPEG (first 64 bytes) to SRAM-loadable hex.

The JPEG is 505 KB which exceeds SRAM capacity (64 KB), so we take the
first 64 bytes (16 × 32-bit words) as a deterministic test slice.
This proves the full AES-256-CTR encrypt/decrypt round-trip through the
PDF engine without running out of SRAM space.

Byte packing: little-endian (RISC-V native).
  word[i] = byte[4i] | (byte[4i+1]<<8) | (byte[4i+2]<<16) | (byte[4i+3]<<24)

Usage:
    python3 image_to_hex.py
    → dv/tb/test_vectors/aadhar/aadhar_slice.hex   (16 words for $readmemh)
"""

import os
import struct

SLICE_BYTES  = 64           # 16 × 32-bit words
JPEG_PATH    = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                            "test_vectors", "aadhar", "aadhar.jpeg")
OUT_PATH     = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                            "test_vectors", "aadhar", "aadhar_slice.hex")

# ---------------------------------------------------------------------------
# Read JPEG
# ---------------------------------------------------------------------------
with open(JPEG_PATH, "rb") as f:
    raw = f.read()

if len(raw) < SLICE_BYTES:
    raise RuntimeError(f"JPEG too small: {len(raw)} bytes (need {SLICE_BYTES})")

slice_bytes = raw[:SLICE_BYTES]
print(f"[image_to_hex] JPEG total size : {len(raw)} bytes")
print(f"[image_to_hex] Using first      : {SLICE_BYTES} bytes ({SLICE_BYTES//4} words)")
print(f"[image_to_hex] First 16 bytes   : {slice_bytes[:16].hex(' ')}")

# ---------------------------------------------------------------------------
# Pack as little-endian 32-bit words
# ---------------------------------------------------------------------------
words = []
for i in range(0, SLICE_BYTES, 4):
    word = int.from_bytes(slice_bytes[i:i+4], 'little')
    words.append(word)

# ---------------------------------------------------------------------------
# Write hex file (one 8-digit hex word per line, $readmemh compatible)
# ---------------------------------------------------------------------------
os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
with open(OUT_PATH, "w") as f:
    for w in words:
        f.write(f"{w:08x}\n")

print(f"[image_to_hex] Wrote {len(words)} words → {OUT_PATH}")
print("[image_to_hex] Words:")
SRAM_BASE = 0x20000000
SRC_OFFSET = 0x100   # SRAM word index where image data lives
for i, w in enumerate(words):
    addr = SRAM_BASE + (SRC_OFFSET + i) * 4
    print(f"  [{i:2d}] 0x{addr:08X}: 0x{w:08X}  ({int.to_bytes(w,4,'little').hex(' ')})")
