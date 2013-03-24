#ifndef _GRAYSCALE_IMAGE_H
#define _GRAYSCALE_IMAGE_H

#include <string>
#include <vector>

namespace BMPFILE {
	typedef unsigned char BYTE;
	typedef unsigned short WORD;
	typedef unsigned long DWORD;
	typedef long LONG;
	 
	// file header
	typedef struct tagBITMAPFILEHEADER {
		WORD bfType; // BM
		DWORD bfSize; // size of the BMP file in bytes
		WORD bfReserved1; // reserved 
		WORD bfReserved2; // reserved
		DWORD bfOffBits; // The offset, in bytes, from the beginning of the BITMAPFILEHEADER structure to the bitmap bits.
	} BITMAPFILEHEADER;

	// infomation header
	typedef struct tagBITMAPINFOHEADER {
		DWORD biSize; // the size of this header(40 bytes)
		LONG biWidth; // the bitmap width in pixels
		LONG biHeight; // the bitmap height in pixels
		WORD biPlanes; // the number of color planes.Must be 1
		WORD biBitCount; // the number of bits per pixel
		DWORD biCompression; // the compression method being used
		DWORD biSizeImage; // the size of the raw bitmap data
		LONG biXPelsPerMeter; // the horizontal resolution. (pixel per meter, signed integer)
		LONG biYPelsPerMeter; // the vertical resolution. (pixel per meter, signed integer)
		DWORD biClrUsed; // the number of colors in the color palette
		DWORD biClrImportant; // the number of important colors used, generally ignored.
	}BITMAPINFOHEADER;

	// color palette
	typedef struct tagRGBQUAD {
		BYTE rgbBlue;
		BYTE rgbGreen;
		BYTE rgbRed;
		BYTE rgbReserved;
	}RGBQUAD;

	// image data
	typedef unsigned char* PixelArray;
}

class GrayscaleBMP {
public:
	GrayscaleBMP(const std::string& _fileName): fileName(_fileName) { };

	std::string fileName;
	BMPFILE::DWORD pixelNum;
	BMPFILE::DWORD bytePerLine;

	BMPFILE::BITMAPFILEHEADER fileHeader;
	BMPFILE::BITMAPINFOHEADER infoHeader;
	std::vector<BMPFILE::RGBQUAD> colorPalette;
	BMPFILE::PixelArray pixelArray;

private:
	GrayscaleBMP(const GrayscaleBMP&); // forbid copy constructor
	GrayscaleBMP& operator=(const GrayscaleBMP&); // forbid copy operator
};

#endif