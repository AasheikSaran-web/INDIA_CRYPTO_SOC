"""
pdf_encrypt_decrypt.py
───────────────────────────────────────────────────────────────────────────────
Demonstrates real PDF-file encryption and decryption with AES-256-CA:

  STEP 1 — Read the original PDF (binary)
  STEP 2 — Encrypt every byte with AES-256-CA (CTR mode + 4 CA stages / round)
  STEP 3 — Save encrypted blob  →  encrypted_payload.bin
  STEP 4 — Decrypt the blob
  STEP 5 — Save decrypted result → decrypted_output.pdf
  STEP 6 — Binary comparison:  decrypted_output.pdf == original PDF  ✓/✗
  STEP 7 — Generate a proof PDF showing SHA-256 hashes, byte counts, hex samples

The AES-256-CA implementation is the same Python model used in aes_ca_demo.py
(matches the RTL in rtl/crypto/aes_ca_accel.v exactly).
"""

import os
import sys
import hashlib
import hmac as hmac_lib

sys.path.insert(0, os.path.dirname(__file__))
from aes_ca_demo import aes_ca_ctr_encrypt, aes_ca_ctr_decrypt

DEMO_DIR   = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT  = os.path.dirname(DEMO_DIR)

INPUT_PDF  = os.path.join(REPO_ROOT, "INDIA_CRYPTO_SOC_Demo.pdf")
ENC_BIN    = os.path.join(DEMO_DIR, "encrypted_payload.bin")
DEC_PDF    = os.path.join(DEMO_DIR, "decrypted_output.pdf")
PROOF_PDF  = os.path.join(REPO_ROOT, "INDIA_CRYPTO_SOC_Encryption_Proof.pdf")

KEY = bytes([
    0xDE,0xAD,0xBE,0xEF, 0xCA,0xFE,0xBA,0xBE,
    0x12,0x34,0x56,0x78, 0x9A,0xBC,0xDE,0xF0,
    0x0F,0xED,0xCB,0xA9, 0x87,0x65,0x43,0x21,
    0xAA,0xBB,0xCC,0xDD, 0xEE,0xFF,0x00,0x11,
])
IV  = bytes([
    0x01,0x23,0x45,0x67, 0x89,0xAB,0xCD,0xEF,
    0xFE,0xDC,0xBA,0x98, 0x76,0x54,0x32,0x10,
])

def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

def hex_sample(data: bytes, n: int = 32) -> str:
    """First n bytes as spaced hex."""
    return " ".join(f"{b:02x}" for b in data[:n])

def human_size(n: int) -> str:
    return f"{n:,} bytes ({n/1024:.1f} KB)"

def run():
    print("=" * 70)
    print("  INDIA_CRYPTO_SOC — PDF Encryption / Decryption Round-Trip Test")
    print("=" * 70)

    if not os.path.exists(INPUT_PDF):
        sys.exit(f"[ERROR] Input PDF not found: {INPUT_PDF}")

    with open(INPUT_PDF, "rb") as f:
        original = f.read()

    orig_sha  = sha256_hex(original)
    print(f"\n[STEP 1] Original PDF")
    print(f"         File  : {os.path.basename(INPUT_PDF)}")
    print(f"         Size  : {human_size(len(original))}")
    print(f"         SHA-256: {orig_sha}")
    print(f"         Header: {hex_sample(original, 16)}  ({original[:8]})")

    print(f"\n[STEP 2] AES-256-CA Encryption")
    print(f"         Key  : {KEY.hex()}")
    print(f"         IV   : {IV.hex()}")
    print(f"         Mode : CTR + 4 CA stages per round (14 rounds → 56 CA ops/block)")

    ciphertext = aes_ca_ctr_encrypt(original, KEY, IV)

    enc_sha = sha256_hex(ciphertext)
    print(f"\n         Encrypted size : {human_size(len(ciphertext))}")
    print(f"         Ciphertext SHA-256: {enc_sha}")
    print(f"         First 32 bytes: {hex_sample(ciphertext, 32)}")

    assert ciphertext != original, "BUG: ciphertext == plaintext!"
    diff_bytes = sum(1 for a, b in zip(original, ciphertext) if a != b)
    pct = diff_bytes * 100 // len(original)
    print(f"         Bytes changed  : {diff_bytes:,}/{len(original):,}  ({pct}% — confirms diffusion)")

    with open(ENC_BIN, "wb") as f:
        f.write(ciphertext)
    print(f"\n[STEP 3] Saved encrypted blob → {os.path.basename(ENC_BIN)}")

    print(f"\n[STEP 4] AES-256-CA Decryption (same key + IV, CTR mode)")
    decrypted = aes_ca_ctr_decrypt(ciphertext, KEY, IV)

    with open(DEC_PDF, "wb") as f:
        f.write(decrypted)
    print(f"\n[STEP 5] Saved decrypted result → {os.path.basename(DEC_PDF)}")

    dec_sha = sha256_hex(decrypted)
    print(f"\n[STEP 6] Round-Trip Verification")
    print(f"         Original  SHA-256: {orig_sha}")
    print(f"         Decrypted SHA-256: {dec_sha}")
    match = (decrypted == original)
    print(f"         SHA-256 match    : {'✅ MATCH' if orig_sha == dec_sha else '❌ MISMATCH'}")
    print(f"         Byte-for-byte    : {'✅ IDENTICAL' if match else '❌ DIFFERENT'}")
    print(f"         First 16 bytes   : {hex_sample(decrypted, 16)}")
    print(f"         Last  16 bytes   : {hex_sample(decrypted[-16:], 16)}")
    print(f"         PDF header valid : {'✅ %PDF' if decrypted[:4] == b'%PDF' else '❌ INVALID'}")

    assert match, "ROUND-TRIP FAILED — decrypted != original!"
    print(f"\n[✅ PASS] Decrypted PDF is byte-for-byte identical to the original.")

    tag = hmac_lib.new(KEY[:16], ciphertext, hashlib.sha256).hexdigest()
    print(f"\n[HMAC-SHA256 Auth Tag] {tag}")
    print(f"         Verifies ciphertext integrity (India PDF Engine model)")

    print(f"\n[STEP 7] Generating proof PDF → {os.path.basename(PROOF_PDF)}")
    _generate_proof_pdf(
        original    = original,
        ciphertext  = ciphertext,
        decrypted   = decrypted,
        orig_sha    = orig_sha,
        enc_sha     = enc_sha,
        dec_sha     = dec_sha,
        diff_bytes  = diff_bytes,
        hmac_tag    = tag,
    )

    print("\n" + "=" * 70)
    print("  ALL STEPS COMPLETE — PDF round-trip encryption verified ✅")
    print("=" * 70)
    return True

def _generate_proof_pdf(**kw):
    from reportlab.lib.pagesizes import letter
    from reportlab.lib.units import inch
    from reportlab.lib import colors
    from reportlab.platypus import (SimpleDocTemplate, Paragraph, Spacer,
                                    Table, TableStyle, HRFlowable)
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
    from reportlab.lib.enums import TA_CENTER, TA_LEFT

    W, H = letter

    styles = getSampleStyleSheet()

    NAVY   = colors.HexColor("#0A1628")
    TEAL   = colors.HexColor("#00B4D8")
    GREEN  = colors.HexColor("#2DC653")
    RED    = colors.HexColor("#E63946")
    LGRAY  = colors.HexColor("#F0F4F8")
    MGRAY  = colors.HexColor("#CBD5E1")

    title_s  = ParagraphStyle("title_s",  fontName="Helvetica-Bold",
                               fontSize=22, leading=28, textColor=NAVY,
                               alignment=TA_CENTER)
    sub_s    = ParagraphStyle("sub_s",    fontName="Helvetica",
                               fontSize=11, leading=16, textColor=colors.HexColor("#475569"),
                               alignment=TA_CENTER)
    head_s   = ParagraphStyle("head_s",   fontName="Helvetica-Bold",
                               fontSize=13, leading=18, textColor=NAVY,
                               spaceBefore=14, spaceAfter=4)
    body_s   = ParagraphStyle("body_s",   fontName="Helvetica",
                               fontSize=9,  leading=13, textColor=colors.HexColor("#1E293B"))
    mono_s   = ParagraphStyle("mono_s",   fontName="Courier",
                               fontSize=8,  leading=12, textColor=colors.HexColor("#1E293B"),
                               backColor=LGRAY, borderPadding=(4,6,4,6))
    pass_s   = ParagraphStyle("pass_s",   fontName="Helvetica-Bold",
                               fontSize=14, leading=20, textColor=GREEN,
                               alignment=TA_CENTER)
    step_s   = ParagraphStyle("step_s",   fontName="Helvetica-Bold",
                               fontSize=10, leading=14, textColor=TEAL)

    doc = SimpleDocTemplate(
        PROOF_PDF, pagesize=letter,
        leftMargin=0.75*inch, rightMargin=0.75*inch,
        topMargin=0.75*inch, bottomMargin=0.75*inch,
    )

    story = []

    story.append(Spacer(1, 0.2*inch))
    story.append(Paragraph("INDIA_CRYPTO_SOC", title_s))
    story.append(Spacer(1, 4))
    story.append(Paragraph("AES-256-CA · PDF Encryption &amp; Decryption Proof", sub_s))
    story.append(Spacer(1, 6))
    story.append(Paragraph(
        "Round-trip verification: original PDF → encrypt → decrypt → identical PDF",
        sub_s,
    ))
    story.append(Spacer(1, 0.15*inch))
    story.append(HRFlowable(width="100%", thickness=2, color=TEAL))
    story.append(Spacer(1, 0.15*inch))

    story.append(Paragraph("Overview", head_s))

    orig = kw["original"]
    ct   = kw["ciphertext"]
    dec  = kw["decrypted"]
    diff = kw["diff_bytes"]

    overview_data = [
        ["Parameter", "Value"],
        ["Algorithm",       "AES-256-CA (CTR mode, 14 rounds × 4 CA stages = 56 CA ops/block)"],
        ["Key size",        "256 bits (32 bytes)"],
        ["IV / Nonce",      "128 bits (16 bytes)"],
        ["Input file",      "INDIA_CRYPTO_SOC_Demo.pdf"],
        ["Input size",      f"{len(orig):,} bytes ({len(orig)/1024:.1f} KB)"],
        ["Output (enc)",    f"{len(ct):,} bytes (same size — CTR mode is length-preserving)"],
        ["Bytes changed",   f"{diff:,} / {len(orig):,} ({diff*100//len(orig)}% diffusion)"],
        ["Round-trip",      "✅  PASS — decrypted == original (byte-for-byte)"],
    ]
    tbl = Table(overview_data, colWidths=[1.7*inch, 5.3*inch])
    tbl.setStyle(TableStyle([
        ("BACKGROUND",   (0,0), (-1,0),  NAVY),
        ("TEXTCOLOR",    (0,0), (-1,0),  colors.white),
        ("FONTNAME",     (0,0), (-1,0),  "Helvetica-Bold"),
        ("FONTSIZE",     (0,0), (-1,0),  9),
        ("BACKGROUND",   (0,1), (-1,-2), LGRAY),
        ("BACKGROUND",   (0,-1),(-1,-1), colors.HexColor("#D1FAE5")),
        ("FONTNAME",     (0,1), (0,-1),  "Helvetica-Bold"),
        ("FONTSIZE",     (0,1), (-1,-1), 9),
        ("GRID",         (0,0), (-1,-1), 0.5, MGRAY),
        ("ROWBACKGROUNDS",(0,1),(-1,-1), [LGRAY, colors.white]),
        ("VALIGN",       (0,0), (-1,-1), "MIDDLE"),
        ("TOPPADDING",   (0,0), (-1,-1), 5),
        ("BOTTOMPADDING",(0,0), (-1,-1), 5),
        ("LEFTPADDING",  (0,0), (-1,-1), 8),
    ]))
    story.append(tbl)
    story.append(Spacer(1, 0.15*inch))

    story.append(Paragraph("Key Material", head_s))
    key_hex = " ".join(f"{b:02x}" for b in KEY)
    iv_hex  = " ".join(f"{b:02x}" for b in IV)
    km_data = [
        ["Field",  "Hex Value (256-bit AES-256 key / 128-bit IV)"],
        ["KEY",    key_hex],
        ["IV",     iv_hex],
    ]
    km_tbl = Table(km_data, colWidths=[0.7*inch, 6.3*inch])
    km_tbl.setStyle(TableStyle([
        ("BACKGROUND",  (0,0), (-1,0),  NAVY),
        ("TEXTCOLOR",   (0,0), (-1,0),  colors.white),
        ("FONTNAME",    (0,0), (-1,0),  "Helvetica-Bold"),
        ("FONTSIZE",    (0,0), (-1,-1), 8),
        ("FONTNAME",    (1,1), (1,-1),  "Courier"),
        ("FONTNAME",    (0,1), (0,-1),  "Helvetica-Bold"),
        ("BACKGROUND",  (0,1), (-1,-1), LGRAY),
        ("GRID",        (0,0), (-1,-1), 0.5, MGRAY),
        ("TOPPADDING",  (0,0), (-1,-1), 5),
        ("BOTTOMPADDING",(0,0),(-1,-1), 5),
        ("LEFTPADDING", (0,0), (-1,-1), 8),
    ]))
    story.append(km_tbl)
    story.append(Spacer(1, 0.15*inch))

    story.append(Paragraph("SHA-256 Hash Verification", head_s))
    story.append(Paragraph(
        "A byte-for-byte match is proven when the SHA-256 of the decrypted output "
        "exactly equals the SHA-256 of the original PDF. "
        "Any single corrupted bit would produce a completely different hash.",
        body_s,
    ))
    story.append(Spacer(1, 6))

    hash_data = [
        ["File / Stage",        "SHA-256 (hex)"],
        ["Original PDF",        kw["orig_sha"]],
        ["Ciphertext (enc)",    kw["enc_sha"]],
        ["Decrypted PDF",       kw["dec_sha"]],
        ["Match (orig ↔ dec)", "✅  IDENTICAL" if kw["orig_sha"] == kw["dec_sha"] else "❌  MISMATCH"],
    ]
    h_tbl = Table(hash_data, colWidths=[1.8*inch, 5.2*inch])
    h_tbl.setStyle(TableStyle([
        ("BACKGROUND",  (0,0), (-1,0),  NAVY),
        ("TEXTCOLOR",   (0,0), (-1,0),  colors.white),
        ("FONTNAME",    (0,0), (-1,0),  "Helvetica-Bold"),
        ("FONTSIZE",    (0,0), (-1,-1), 8),
        ("FONTNAME",    (1,1), (1,3),   "Courier"),
        ("FONTNAME",    (0,1), (0,-1),  "Helvetica-Bold"),
        ("BACKGROUND",  (0,-1),(-1,-1), colors.HexColor("#D1FAE5")),
        ("TEXTCOLOR",   (1,-1),(1,-1),  GREEN),
        ("FONTNAME",    (1,-1),(1,-1),  "Helvetica-Bold"),
        ("ROWBACKGROUNDS",(0,1),(-1,-2),[LGRAY, colors.white]),
        ("GRID",        (0,0), (-1,-1), 0.5, MGRAY),
        ("TOPPADDING",  (0,0), (-1,-1), 5),
        ("BOTTOMPADDING",(0,0),(-1,-1), 5),
        ("LEFTPADDING", (0,0), (-1,-1), 8),
    ]))
    story.append(h_tbl)
    story.append(Spacer(1, 0.15*inch))

    story.append(Paragraph("Byte-Level Evidence", head_s))
    story.append(Paragraph(
        "The table below shows the first 32 bytes of the original PDF, "
        "after encryption, and after decryption — confirming the ciphertext "
        "is completely transformed and the decrypted output is identical to the original.",
        body_s,
    ))
    story.append(Spacer(1, 6))

    def fmt32(data):
        return " ".join(f"{b:02x}" for b in data[:32])

    byte_data = [
        ["Stage",          "First 32 bytes (hex)"],
        ["Original PDF",   fmt32(orig)],
        ["Encrypted",      fmt32(ct)],
        ["Decrypted PDF",  fmt32(dec)],
    ]
    b_tbl = Table(byte_data, colWidths=[1.3*inch, 5.7*inch])
    b_tbl.setStyle(TableStyle([
        ("BACKGROUND",  (0,0), (-1,0),  NAVY),
        ("TEXTCOLOR",   (0,0), (-1,0),  colors.white),
        ("FONTNAME",    (0,0), (-1,0),  "Helvetica-Bold"),
        ("FONTSIZE",    (0,0), (-1,-1), 8),
        ("FONTNAME",    (1,1), (1,-1),  "Courier"),
        ("FONTNAME",    (0,1), (0,-1),  "Helvetica-Bold"),
        ("ROWBACKGROUNDS",(0,1),(-1,-1),[LGRAY, colors.HexColor("#FEF3C7"), colors.HexColor("#D1FAE5")]),
        ("GRID",        (0,0), (-1,-1), 0.5, MGRAY),
        ("TOPPADDING",  (0,0), (-1,-1), 6),
        ("BOTTOMPADDING",(0,0),(-1,-1), 6),
        ("LEFTPADDING", (0,0), (-1,-1), 8),
    ]))
    story.append(b_tbl)
    story.append(Spacer(1, 0.1*inch))

    story.append(Paragraph(
        f"Original PDF header (ASCII): "
        f"{orig[:8].decode('latin-1', errors='replace')} "
        f"— confirms the decrypted output is a valid PDF (starts with %PDF).",
        body_s,
    ))
    story.append(Spacer(1, 0.15*inch))

    story.append(Paragraph("HMAC-SHA256 Authentication Tag", head_s))
    story.append(Paragraph(
        "The HMAC-SHA256 tag below authenticates the ciphertext, "
        "matching the CA-HMAC engine modeled in rtl/periph/india_pdf_engine.v. "
        "A recipient recomputes this tag before decryption; "
        "any modification to the ciphertext invalidates the tag.",
        body_s,
    ))
    story.append(Spacer(1, 6))
    story.append(Paragraph(
        f"<font name='Courier'>{kw['hmac_tag']}</font>",
        ParagraphStyle("hmac_p", parent=body_s, backColor=LGRAY,
                       borderPadding=(5,8,5,8), leading=14),
    ))
    story.append(Spacer(1, 0.15*inch))

    story.append(HRFlowable(width="100%", thickness=1.5, color=TEAL))
    story.append(Spacer(1, 0.1*inch))
    story.append(Paragraph(
        "✅  ROUND-TRIP VERIFIED — The decrypted PDF is byte-for-byte identical to the original",
        pass_s,
    ))
    story.append(Spacer(1, 6))
    story.append(Paragraph(
        "AES-256-CA (CTR mode) is a symmetric cipher: the same key + IV decrypts "
        "what was encrypted. The decrypted file passes the PDF validity check "
        "(%PDF header intact) and its SHA-256 matches the original exactly.",
        ParagraphStyle("final_body", parent=body_s, alignment=TA_CENTER,
                       fontSize=9, textColor=colors.HexColor("#475569")),
    ))
    story.append(Spacer(1, 0.08*inch))

    story.append(HRFlowable(width="100%", thickness=0.5, color=MGRAY))
    story.append(Spacer(1, 4))
    story.append(Paragraph(
        "INDIA_CRYPTO_SOC · AES-256-CA Accelerator · TSMC 28nm HPC · "
        "Aadhaar e-KYC Secure Document Processing",
        ParagraphStyle("footer", parent=body_s, fontSize=7,
                       textColor=colors.HexColor("#94A3B8"), alignment=TA_CENTER),
    ))

    doc.build(story)
    print(f"         Proof PDF written: {PROOF_PDF}")
    print(f"         Size: {os.path.getsize(PROOF_PDF):,} bytes")

if __name__ == "__main__":
    ok = run()
    sys.exit(0 if ok else 1)
