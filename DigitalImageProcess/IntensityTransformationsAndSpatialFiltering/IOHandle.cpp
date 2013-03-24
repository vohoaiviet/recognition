#include <iostream>
#include <cmath>
#include "IOHandle.h"
using namespace std;

void IOHandle::ReadBMP(BMPBasic& bmpFile) { // read file
	ifstream readHandle(bmpFile.fileName.c_str(), ios::in | ios::binary);

	if (!readHandle) {
		cerr << "error: can't open file " << bmpFile.fileName << endl;
		exit(EXIT_FAILURE);
	}

	readHandle >> bmpFile.fileHeader;
	readHandle >> bmpFile.infoHeader;

	if (bmpFile.infoHeader.biBitCount != 24) { // read color palette
		bmpFile.colorTableNum = static_cast<unsigned long>(pow(2.0, static_cast<double>(bmpFile.infoHeader.biBitCount)));
		bmpFile.colorPalette.resize(bmpFile.colorTableNum);
		for (unsigned long i = 0; i != bmpFile.colorTableNum; ++i) {
			readHandle >> bmpFile.colorPalette[i];
		}
	}

	bmpFile.pixelArray = new unsigned char[bmpFile.infoHeader.biSizeImage];
	readHandle.read(reinterpret_cast<char*> (bmpFile.pixelArray), (bmpFile.infoHeader.biSizeImage) * sizeof (unsigned char));

	bmpFile.pixelNum = bmpFile.infoHeader.biWidth * bmpFile.infoHeader.biHeight;
	bmpFile.SetBytePerLine((bmpFile.infoHeader.biWidth * bmpFile.infoHeader.biBitCount / 8 + 3) / 4 * 4);
}

void IOHandle::GenBMP(BMPBasic& bmpFile, const string& genFileName) const { // write bmp file
	ofstream writeHandle(genFileName.c_str(), ios::out | ios::binary);

	if (!writeHandle) {
		cerr << "error: can't open file " << genFileName << endl;
		exit(EXIT_FAILURE);
	}

	writeHandle << bmpFile.fileHeader;
	writeHandle << bmpFile.infoHeader;

	for (unsigned short i = 0; i != bmpFile.colorTableNum; ++i) {
		writeHandle << bmpFile.colorPalette[i];
	}

	writeHandle.write(reinterpret_cast<char*> (bmpFile.pixelArray), bmpFile.fileHeader.bfSize * sizeof (unsigned char));
}