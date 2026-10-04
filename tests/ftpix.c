/* FreeType + pixman check: render text, composite it in ARGB32, print a checksum. */
#include <ft2build.h>
#include FT_FREETYPE_H
#include <pixman.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#define W 320
#define H 64
int main(int argc, char **argv)
{
    FT_Library lib; FT_Face face; const char *text = "Hello, Amiga! AVWa 123";
    uint32_t *dst = calloc(W * H, 4); uint8_t *mask = calloc(W * H, 1);
    int pen = 4; uint32_t sum = 0, i; const char *p;
    if (argc < 2) { printf("usage: ftpix font.ttf\n"); return 10; }
    if (FT_Init_FreeType(&lib) || FT_New_Face(lib, argv[1], 0, &face)) { printf("FT_FAIL\n"); return 20; }
    FT_Set_Pixel_Sizes(face, 0, 32);
    for (p = text; *p; p++) {
        FT_GlyphSlot g; int x, y;
        if (FT_Load_Char(face, (unsigned char)*p, FT_LOAD_RENDER)) continue;
        g = face->glyph;
        for (y = 0; y < (int)g->bitmap.rows; y++)
            for (x = 0; x < (int)g->bitmap.width; x++) {
                int dx = pen + g->bitmap_left + x, dy = 44 - g->bitmap_top + y;
                if (dx >= 0 && dx < W && dy >= 0 && dy < H) mask[dy * W + dx] = g->bitmap.buffer[y * g->bitmap.pitch + x];
            }
        pen += g->advance.x >> 6;
    }
    {
        pixman_image_t *d = pixman_image_create_bits(PIXMAN_a8r8g8b8, W, H, dst, W * 4);
        pixman_image_t *m = pixman_image_create_bits(PIXMAN_a8, W, H, (uint32_t *)mask, W);
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff }, red = { 0xffff, 0x2000, 0x1000, 0xffff };
        pixman_image_t *bg = pixman_image_create_solid_fill(&white), *fg = pixman_image_create_solid_fill(&red);
        pixman_image_composite32(PIXMAN_OP_SRC, bg, NULL, d, 0, 0, 0, 0, 0, 0, W, H);
        pixman_image_composite32(PIXMAN_OP_OVER, fg, m, d, 0, 0, 0, 0, 0, 0, W, H);
    }
    for (i = 0; i < W * H; i++) sum = sum * 31 + dst[i];
    printf("FTPIX glyphs_end=%d pixel0=%08x pixel_mid=%08lx sum=%08lx\n", pen, (unsigned)dst[0], (unsigned long)dst[30 * W + 20], (unsigned long)sum);
    return 0;
}
