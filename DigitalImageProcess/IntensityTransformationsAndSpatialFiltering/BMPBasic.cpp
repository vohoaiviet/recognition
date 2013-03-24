#include <iostream>
#include "BMPBasic.h"
using namespace std;

namespace BMPSTRUCT {
	ifstream& operator >> (ifstream& in, BITMAPFILEHEADER& fileHeader) { // cpp file stream, read file header
		in.read(reinterpret_cast<char*>(&fileHeader.bfType), sizeof (fileHeader.bfType));
		in.read(reinterpret_cast<char*>(&fileHeader.bfSize), sizeof (fileHeader.bfSize));
		in.read(reinterpret_cast<char*>(&fileHeader.bfReserved1), sizeof (fileHeader.bfReserved1));
		in.read(reinterpret_cast<char*>(&fileHeader.bfReserved2), sizeof (fileHeader.bfReserved2));
		in.read(reinterpret_cast<char*>(&fileHeader.bfOffBits), sizeof (fileHeader.bfOffBits));
		return in;
	}
	ofstream& operator << (ofstream& out, BITMAPFILEHEADER& fileHeader) { // write file header
		out.write(reinterpret_cast<char*>(&fileHeader.bfType), sizeof (fileHeader.bfType));
		out.write(reinterpret_cast<char*>(&fileHeader.bfSize), sizeof (fileHeader.bfSize));
		out.write(reinterpret_cast<char*>(&fileHeader.bfReserved1), sizeof (fileHeader.bfReserved1));
		out.write(reinterpret_cast<char*>(&fileHeader.bfReserved2), sizeof (fileHeader.bfReserved2));
		out.write(reinterpret_cast<char*>(&fileHeader.bfOffBits), sizeof (fileHeader.bfOffBits));
		return out;
	}

	ifstream& operator >> (ifstream& in, BITMAPINFOHEADER& infoHeader) { // read info header
		in.read(reinterpret_cast<char*>(&infoHeader.biSize), sizeof (infoHeader.biSize));
		in.read(reinterpret_cast<char*>(&infoHeader.biWidth), sizeof (infoHeader.biWidth));
		in.read(reinterpret_cast<char*>(&infoHeader.biHeight), sizeof (infoHeader.biHeight));
		in.read(reinterpret_cast<char*>(&infoHeader.biPlanes), sizeof (infoHeader.biPlanes));
		in.read(reinterpret_cast<char*>(&infoHeader.biBitCount), sizeof (infoHeader.biBitCount));
		in.read(reinterpret_cast<char*>(&infoHeader.biCompression), sizeof (infoHeader.biCompression));
		in.read(reinterpret_cast<char*>(&infoHeader.biSizeImage), sizeof (infoHeader.biSizeImage));
		in.read(reinterpret_cast<char*>(&infoHeader.biXPelsPerMeter), sizeof (infoHeader.biXPelsPerMeter));
		in.read(reinterpret_cast<char*>(&infoHeader.biYPelsPerMeter), sizeof (infoHeader.biYPelsPerMeter));
		in.read(reinterpret_cast<char*>(&infoHeader.biClrUsed), sizeof (infoHeader.biClrUsed));
		in.read(reinterpret_cast<char*>(&infoHeader.biClrImportant), sizeof (infoHeader.biClrImportant));

		return in;
	}
	ofstream& operator << (ofstream& out, BITMAPINFOHEADER& infoHeader) { // write info header
		out.write(reinterpret_cast<char*>(&infoHeader.biSize), sizeof (infoHeader.biSize));
		out.write(reinterpret_cast<char*>(&infoHeader.biWidth), sizeof (infoHeader.biWidth));
		out.write(reinterpret_cast<char*>(&infoHeader.biHeight), sizeof (infoHeader.biHeight));
		out.write(reinterpret_cast<char*>(&infoHeader.biPlanes), sizeof (infoHeader.biPlanes));
		out.write(reinterpret_cast<char*>(&infoHeader.biBitCount), sizeof (infoHeader.biBitCount));
		out.write(reinterpret_cast<char*>(&infoHeader.biCompression), sizeof (infoHeader.biCompression));
		out.write(reinterpret_cast<char*>(&infoHeader.biSizeImage), sizeof (infoHeader.biSizeImage));
		out.write(reinterpret_cast<char*>(&infoHeader.biXPelsPerMeter), sizeof (infoHeader.biXPelsPerMeter));
		out.write(reinterpret_cast<char*>(&infoHeader.biYPelsPerMeter), sizeof (infoHeader.biYPelsPerMeter));
		out.write(reinterpret_cast<char*>(&infoHeader.biClrUsed), sizeof (infoHeader.biClrUsed));
		out.write(reinterpret_cast<char*>(&infoHeader.biClrImportant), sizeof (infoHeader.biClrImportant));
		return out;
	}

	ifstream& operator >> (ifstream& in, RGBQUAD& rgbQuad) { // read color palette
		in.read(reinterpret_cast<char*>(&rgbQuad.rgbBlue), sizeof (rgbQuad.rgbBlue));
		in.read(reinterpret_cast<char*>(&rgbQuad.rgbGreen), sizeof (rgbQuad.rgbGreen));
		in.read(reinterpret_cast<char*>(&rgbQuad.rgbRed), sizeof (rgbQuad.rgbRed));
		in.read(reinterpret_cast<char*>(&rgbQuad.rgbReserved), sizeof (rgbQuad.rgbReserved));
		return in;
	}
	ofstream& operator << (ofstream& out, RGBQUAD& rgbQuad) { // write color palette
		out.write(reinterpret_cast<char*>(&rgbQuad.rgbBlue), sizeof (rgbQuad.rgbBlue));
		out.write(reinterpret_cast<char*>(&rgbQuad.rgbGreen), sizeof (rgbQuad.rgbGreen));
		out.write(reinterpret_cast<char*>(&rgbQuad.rgbRed), sizeof (rgbQuad.rgbRed));
		out.write(reinterpret_cast<char*>(&rgbQuad.rgbReserved), sizeof (rgbQuad.rgbReserved));
		return out;
	}

}

BMPBasic::BMPBasic(const string& fName):  fileName(fName), colorTableNum(0) { 
}

void BMPBasic::ShowInformation() { // output some infomation
	cout << "type(bfType): " << hex << fileHeader.bfType << dec << "\nfile size(bfSize): " << fileHeader.bfSize << endl;
	cout << "bitcount(biBitCount): " << infoHeader.biBitCount << " " << "\nwidth: " << infoHeader.biWidth << 
		"\nheight: " << infoHeader.biHeight << "\nimage data size(biSizeImage): " << infoHeader.biSizeImage << endl;
	cout << "size per line: " << bytePerLine << endl;

	cout << "bfOffBits: " << fileHeader.bfOffBits << endl;
}

void BMPBasic::SetBytePerLine(unsigned long lineSize) {
	bytePerLine = lineSize;
}

unsigned long BMPBasic::GetBytePerLine() const {
	return bytePerLine;
}