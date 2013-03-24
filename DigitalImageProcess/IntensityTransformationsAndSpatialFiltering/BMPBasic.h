#ifndef _BMP_STRUCT_H
#define _BMP_STRUCT_H

#include <string>
#include <vector>
#include <fstream>
using namespace std;

namespace BMPSTRUCT {
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

	// stream operator overload, convinient for read and write
	ifstream& operator >> (ifstream&, BITMAPFILEHEADER&);
	ofstream& operator << (ofstream&, BITMAPFILEHEADER&);

	ifstream& operator >> (ifstream&, BITMAPINFOHEADER&);
	ofstream& operator << (ofstream&, BITMAPINFOHEADER&);

	ifstream& operator >> (ifstream&, RGBQUAD&);
	ofstream& operator << (ofstream&, RGBQUAD&);
}

using namespace BMPSTRUCT;

class BMPBasic {
	friend class IOHandle;
public:
	BMPBasic(const string&); // parameter:file name

	void ShowInformation(); // print some infomation
	unsigned long GetBytePerLine() const; // windows
	virtual bool GetColor(vector<unsigned char>&, vector<unsigned char>&, vector<unsigned char>&) = 0; // get rgb info via image data, implement in derived class
	virtual bool SetColor(vector<unsigned char>&, vector<unsigned char>&, vector<unsigned char>&) = 0; // set image data via rgb info

	string fileName;
	unsigned long colorTableNum;
	unsigned long colorUsedNum;
	unsigned long pixelNum;

	BITMAPFILEHEADER fileHeader;
	BITMAPINFOHEADER infoHeader;
	vector<RGBQUAD> colorPalette;
	PixelArray pixelArray;
protected:
	unsigned long bytePerLine;
private:
	void SetBytePerLine(unsigned long);
	BMPBasic(const BMPBasic&); // forbid copy constructor
	BMPBasic& operator=(const BMPBasic&); // forbid copy operator
};

#endif