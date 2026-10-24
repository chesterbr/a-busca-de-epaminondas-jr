import struct, sys
# uso: estado.py arquivo.bmp -> PROMPT (cinza), PAUSA (ciano) ou OUTRO, na caixa "Avisos e Extras"
d = open(sys.argv[1], 'rb').read()
off = struct.unpack_from('<I', d, 10)[0]
w, h = struct.unpack_from('<ii', d, 18)
bpp = struct.unpack_from('<H', d, 28)[0] // 8
row = (w * bpp + 3) // 4 * 4
sx = w / 1440.0
cy = gr = 0
for y in range(int(700*sx), int(735*sx)):
    ry = (h - 1 - y) if h > 0 else y
    for x in range(int(270*sx), int(1000*sx)):
        o = off + ry * row + x * bpp
        b, g, r = d[o], d[o+1], d[o+2]
        if r < 120 and g > 200 and b > 200: cy += 1
        elif 140 < r < 200 and abs(r-g) < 12 and abs(r-b) < 12: gr += 1
print('PAUSA' if cy > 30 and cy > gr else 'PROMPT' if gr > 30 else 'OUTRO', cy, gr)
