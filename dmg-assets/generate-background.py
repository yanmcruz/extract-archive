#!/usr/bin/env python3
"""Generate DMG background with arrow and 'Drag to Applications' instruction."""

import struct
import zlib

W, H = 600, 400

def chunk(name, data):
    c = name + data
    return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)

def create_base():
    rows = []
    for y in range(H):
        row = bytearray(b'\x00')
        for x in range(W):
            t = (x/W + y/H) / 2
            r = int(13 + t * 8)
            g = int(13 + t * 8)
            b = int(15 + t * 12)
            cx, cy = W/2, H/2
            d = ((x-cx)**2 + (y-cy)**2)**0.5
            glow = max(0, 1 - d/250) * 0.08
            r = min(255, int(r + 91*glow))
            g = min(255, int(g + 124*glow))
            b = min(255, int(b + 246*glow))
            row.extend([r, g, b, 255])
        rows.append(row)
    return rows

def set_pixel(rows, x, y, r, g, b, a=255):
    if 0 <= x < W and 0 <= y < H:
        i = 1 + (x * 4)
        rows[y][i:i+4] = bytes([r, g, b, a])

def draw_arrow(rows):
    # Arrow from app (center 140) to Applications (center 400)
    # Body: horizontal line from x=200 to x=340, y=200
    # Arrowhead: triangle pointing right at x=360
    x1, x2, yc = 200, 340, 200
    # Thick white/gray line
    for thick in range(-4, 5):
        for x in range(x1, x2 + 1):
            fade = 1 - abs(thick)/5
            set_pixel(rows, x, yc + thick, 240, 242, 248, int(220 * fade))
    # Arrowhead triangle
    for dy in range(-10, 11):
        for dx in range(-14, 2):
            if abs(dy) <= 5 + (14 + dx) * 0.45:
                set_pixel(rows, x2 + dx, yc + dy, 250, 252, 255, 230)

# Simple 3x5 bitmap font - only chars we need
FONT = {
    'D': [[1,1,0],[1,0,1],[1,0,1],[1,0,1],[1,1,0]],
    'R': [[1,1,0],[1,0,1],[1,1,0],[1,0,1],[1,0,1]],
    'A': [[0,1,0],[1,0,1],[1,1,1],[1,0,1],[1,0,1]],
    'G': [[1,1,1],[1,0,0],[1,0,1],[1,0,1],[1,1,1]],
    'T': [[1,1,1],[0,1,0],[0,1,0],[0,1,0],[0,1,0]],
    'O': [[1,1,1],[1,0,1],[1,0,1],[1,0,1],[1,1,1]],
    'I': [[1,1,1],[0,1,0],[0,1,0],[0,1,0],[1,1,1]],
    'C': [[1,1,1],[1,0,0],[1,0,0],[1,0,0],[1,1,1]],
    'L': [[1,0,0],[1,0,0],[1,0,0],[1,0,0],[1,1,1]],
    'N': [[1,0,1],[1,1,1],[1,0,1],[1,0,1],[1,0,1]],
    'S': [[1,1,1],[1,0,0],[1,1,1],[0,0,1],[1,1,1]],
    'P': [[1,1,0],[1,0,1],[1,1,0],[1,0,0],[1,0,0]],
    ' ': [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]],
}

def draw_text(rows, text, x0, y0, scale=4):
    cw = 4  # char width in pixels
    for i, c in enumerate(text.upper()):
        glyph = FONT.get(c, FONT[' '])
        for gy, row in enumerate(glyph):
            for gx, v in enumerate(row):
                if v:
                    for sy in range(scale):
                        for sx in range(scale):
                            px = x0 + (i * cw + gx) * scale + sx
                            py = y0 + gy * scale + sy
                            set_pixel(rows, px, py, 255, 255, 255, 240)

def main():
    rows = create_base()
    draw_arrow(rows)
    # "DRAG TO APPLICATIONS" below the arrow
    draw_text(rows, "DRAG TO APPLICATIONS", 140, 250)
    raw = b''.join(bytes(r) for r in rows)
    comp = zlib.compress(raw, 9)
    ihdr = struct.pack('>IIBBBBB', W, H, 8, 6, 0, 0, 0)
    png = b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', ihdr) + chunk(b'IDAT', comp) + chunk(b'IEND', b'')
    out = __file__.replace('generate-background.py', 'dmg-background.png')
    import os
    out = os.path.join(os.path.dirname(__file__), 'dmg-background.png')
    with open(out, 'wb') as f:
        f.write(png)
    print(f"Created {out}")

if __name__ == '__main__':
    main()
