/* display.c */
/* Copyright (c) 2020 J. M. Spivey */

/* A simple driver for the micro:bit LEDs with the same interface on
V1 and V2. */

#include "microbian.h"
#include "hardware.h"
#include <string.h>

/* Note that blank is not the same as an image that is all zeroes,
because it has the row bits set.  Copying blank and then setting
(actually, clearing) column bits for each row results in an image 
that displays properly. */

/* blank -- empty image */
const image blank =
    IMAGE(0,0,0,0,0,
          0,0,0,0,0,
          0,0,0,0,0,
          0,0,0,0,0,
          0,0,0,0,0);

/* image_clear -- set image to blank */
void image_clear(image img)
{
    memcpy(img, blank, sizeof(image));
}

/* PAIR, etc. -- encode a pair of integers in one integer */
#define PAIR(x, y) (((x) << 5) | (y))
#define XPART(p) ((p) >> 5)
#define YPART(p) ((p) & 0x1f)

#ifdef UBIT_V1
#define PIX(i, j)  PAIR(i-1, j+3)

/* img_map -- map of logical row and column bits for each physical pixel */
static unsigned img_map[5][5] = {
    { PIX(3,3), PIX(2,7), PIX(3,1), PIX(2,6), PIX(3,2) },
    { PIX(1,8), PIX(1,7), PIX(1,6), PIX(1,5), PIX(1,4) },
    { PIX(2,2), PIX(1,9), PIX(2,3), PIX(3,9), PIX(2,1) },
    { PIX(3,4), PIX(3,5), PIX(3,6), PIX(3,7), PIX(3,8) },
    { PIX(1,1), PIX(2,4), PIX(1,2), PIX(2,5), PIX(1,3) }
};

/* map_pixel -- find logical row and column for a pixel */
static unsigned map_pixel(int x, int y)
{
    return img_map[y][x];
}
#endif

#ifdef UBIT_V2
/* img_col -- map of column bits for each physical column */
static const unsigned img_col[] = {
    COL1, COL2, COL3, COL4, COL5
};

/* map_pixel -- find logical row and column for a pixel */
static unsigned map_pixel(int x, int y)
{
    /* Each row is represented by two words for the two GPIO registers. */
    unsigned col = img_col[x];
    int index = 2*y + XPART(col);
    int bit = YPART(col);
    return PAIR(index, bit);
    /* Could optimise to ((4-y) << 6) | img_col[x]. */
}
#endif

/* image_set -- switch on a single pixel in an image */
void image_set(int x, int y, int l, image img)
{
    if (x < 0 || x >= 5 || y < 0 || y >= 5) return;
    unsigned p = map_pixel(x, y);
    if (l == 0) SET_BIT(img[XPART(p)], YPART(p));
    else CLR_BIT(img[XPART(p)], YPART(p));
}

/* display_image is a shared variable between the client and the
display driver task, but it is read-only in the task.  Partial updates
don't really matter, because they will cause only a momentary glitch in
the display when it is changing anyway. */

/* display_image -- shared variable for currently displayed image */
static image display_image;

/* display_task -- device driver for LED display */
void display_task(int dummy)
{
    int n = 0;

#ifdef UBIT_V1
    GPIO.DIRSET = LED_MASK;
    timer_pulse(5);             /* 5ms x 3 = 15ms updates */
#endif
    
#ifdef UBIT_V2
    GPIO0.DIRSET = LED_MASK0;
    GPIO1.DIRSET  = LED_MASK1;
    
    /* Set row pins to high-drive mode to increase brightness */
    gpio_drive(ROW1, GPIO_DRIVE_S0H1);
    gpio_drive(ROW2, GPIO_DRIVE_S0H1);
    gpio_drive(ROW3, GPIO_DRIVE_S0H1);
    gpio_drive(ROW4, GPIO_DRIVE_S0H1);
    gpio_drive(ROW5, GPIO_DRIVE_S0H1);

    timer_pulse(3);             /* 3ms * 5 = 15ms updates */
#endif

    image_clear(display_image);
    priority(P_HIGH);

    while (1) {
        /* Carefully change LED bits and leave other bits alone */
#ifdef UBIT_V1
        GPIO.OUTCLR = 0xfff0;
        GPIO.OUTSET = display_image[n++];
        if (n == 3) n = 0;
#endif

#ifdef UBIT_V2
        /* To avoid ghosting, clear GPIO0 (which contains the row bits)
           first and set it last. */
        GPIO0.OUTCLR = LED_MASK0;
        GPIO1.OUTCLR = LED_MASK1;
        GPIO1.OUTSET = display_image[n+1];
        GPIO0.OUTSET = display_image[n];
        n += 2;
        if (n == 10) n = 0;
#endif

        receive(PING, NULL);
    }
}

/* display_show -- set display from image */
void display_show(const image img)
{
    memcpy(display_image, img, sizeof(image));
}

/* display_init -- start display driver task */
void display_init(void)
{
    start("Display", display_task, 0, STACK);
}

void microbit_write_pixel(int x, int y, int l) {
  image_set(x, y, l, display_image);
}

void microbit_clear_screen() {
  image_clear(display_image);
}
// Taken from microbit-dal
static const unsigned char pendolino3[475] = {
0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x8, 0x8, 0x0, 0x8, 0xa, 0x4a, 0x40, 0x0, 0x0, 0xa, 0x5f, 0xea, 0x5f, 0xea, 0xe, 0xd9, 0x2e, 0xd3, 0x6e, 0x19, 0x32, 0x44, 0x89, 0x33, 0xc, 0x92, 0x4c, 0x92, 0x4d, 0x8, 0x8, 0x0, 0x0, 0x0, 0x4, 0x88, 0x8, 0x8, 0x4, 0x8, 0x4, 0x84, 0x84, 0x88, 0x0, 0xa, 0x44, 0x8a, 0x40, 0x0, 0x4, 0x8e, 0xc4, 0x80, 0x0, 0x0, 0x0, 0x4, 0x88, 0x0, 0x0, 0xe, 0xc0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x0, 0x1, 0x22, 0x44, 0x88, 0x10, 0xc, 0x92, 0x52, 0x52, 0x4c, 0x4, 0x8c, 0x84, 0x84, 0x8e, 0x1c, 0x82, 0x4c, 0x90, 0x1e, 0x1e, 0xc2, 0x44, 0x92, 0x4c, 0x6, 0xca, 0x52, 0x5f, 0xe2, 0x1f, 0xf0, 0x1e, 0xc1, 0x3e, 0x2, 0x44, 0x8e, 0xd1, 0x2e, 0x1f, 0xe2, 0x44, 0x88, 0x10, 0xe, 0xd1, 0x2e, 0xd1, 0x2e, 0xe, 0xd1, 0x2e, 0xc4, 0x88, 0x0, 0x8, 0x0, 0x8, 0x0, 0x0, 0x4, 0x80, 0x4, 0x88, 0x2, 0x44, 0x88, 0x4, 0x82, 0x0, 0xe, 0xc0, 0xe, 0xc0, 0x8, 0x4, 0x82, 0x44, 0x88, 0xe, 0xd1, 0x26, 0xc0, 0x4, 0xe, 0xd1, 0x35, 0xb3, 0x6c, 0xc, 0x92, 0x5e, 0xd2, 0x52, 0x1c, 0x92, 0x5c, 0x92, 0x5c, 0xe, 0xd0, 0x10, 0x10, 0xe, 0x1c, 0x92, 0x52, 0x52, 0x5c, 0x1e, 0xd0, 0x1c, 0x90, 0x1e, 0x1e, 0xd0, 0x1c, 0x90, 0x10, 0xe, 0xd0, 0x13, 0x71, 0x2e, 0x12, 0x52, 0x5e, 0xd2, 0x52, 0x1c, 0x88, 0x8, 0x8, 0x1c, 0x1f, 0xe2, 0x42, 0x52, 0x4c, 0x12, 0x54, 0x98, 0x14, 0x92, 0x10, 0x10, 0x10, 0x10, 0x1e, 0x11, 0x3b, 0x75, 0xb1, 0x31, 0x11, 0x39, 0x35, 0xb3, 0x71, 0xc, 0x92, 0x52, 0x52, 0x4c, 0x1c, 0x92, 0x5c, 0x90, 0x10, 0xc, 0x92, 0x52, 0x4c, 0x86, 0x1c, 0x92, 0x5c, 0x92, 0x51, 0xe, 0xd0, 0xc, 0x82, 0x5c, 0x1f, 0xe4, 0x84, 0x84, 0x84, 0x12, 0x52, 0x52, 0x52, 0x4c, 0x11, 0x31, 0x31, 0x2a, 0x44, 0x11, 0x31, 0x35, 0xbb, 0x71, 0x12, 0x52, 0x4c, 0x92, 0x52, 0x11, 0x2a, 0x44, 0x84, 0x84, 0x1e, 0xc4, 0x88, 0x10, 0x1e, 0xe, 0xc8, 0x8, 0x8, 0xe, 0x10, 0x8, 0x4, 0x82, 0x41, 0xe, 0xc2, 0x42, 0x42, 0x4e, 0x4, 0x8a, 0x40, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1f, 0x8, 0x4, 0x80, 0x0, 0x0, 0x0, 0xe, 0xd2, 0x52, 0x4f, 0x10, 0x10, 0x1c, 0x92, 0x5c, 0x0, 0xe, 0xd0, 0x10, 0xe, 0x2, 0x42, 0x4e, 0xd2, 0x4e, 0xc, 0x92, 0x5c, 0x90, 0xe, 0x6, 0xc8, 0x1c, 0x88, 0x8, 0xe, 0xd2, 0x4e, 0xc2, 0x4c, 0x10, 0x10, 0x1c, 0x92, 0x52, 0x8, 0x0, 0x8, 0x8, 0x8, 0x2, 0x40, 0x2, 0x42, 0x4c, 0x10, 0x14, 0x98, 0x14, 0x92, 0x8, 0x8, 0x8, 0x8, 0x6, 0x0, 0x1b, 0x75, 0xb1, 0x31, 0x0, 0x1c, 0x92, 0x52, 0x52, 0x0, 0xc, 0x92, 0x52, 0x4c, 0x0, 0x1c, 0x92, 0x5c, 0x90, 0x0, 0xe, 0xd2, 0x4e, 0xc2, 0x0, 0xe, 0xd0, 0x10, 0x10, 0x0, 0x6, 0xc8, 0x4, 0x98, 0x8, 0x8, 0xe, 0xc8, 0x7, 0x0, 0x12, 0x52, 0x52, 0x4f, 0x0, 0x11, 0x31, 0x2a, 0x44, 0x0, 0x11, 0x31, 0x35, 0xbb, 0x0, 0x12, 0x4c, 0x8c, 0x92, 0x0, 0x11, 0x2a, 0x44, 0x98, 0x0, 0x1e, 0xc4, 0x88, 0x1e, 0x6, 0xc4, 0x8c, 0x84, 0x86, 0x8, 0x8, 0x8, 0x8, 0x8, 0x18, 0x8, 0xc, 0x88, 0x18, 0x0, 0x0, 0xc, 0x83, 0x60};

void microbit_print_string(char *str) {
  for(; *str != '\0'; str++) {
    int start = (*str-32)*5;
    for(int i = start; i < start+5; i++) {
      unsigned char c = pendolino3[i];
      microbit_write_pixel(0, i-start, (c&0x10));
      microbit_write_pixel(1, i-start, (c&0x08));
      microbit_write_pixel(2, i-start, (c&0x04));
      microbit_write_pixel(3, i-start, (c&0x02));
      microbit_write_pixel(4, i-start, (c&0x01));
    }
    timer_delay(300);
  }
  microbit_clear_screen();
}
