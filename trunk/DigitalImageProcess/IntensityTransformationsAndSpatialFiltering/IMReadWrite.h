#ifndef _IM_READ_WRITE_H
#define _IM_READ_WRITE_H

#include <cmath>
#include <fstream>
#include <iostream>
#include "GrayscaleImage.h"

void IMRead(GrayscaleBMP& bmpHandle) {
	std::ifstream readStream(bmpHandle.fileName.c_str(), std::ios::in | std::ios::binary);
	if (!readStream) {
		std::cerr << "error! can't open file " << bmpHandle.fileName << std::endl;
		exit(EXIT_FAILURE);
	}

	readStream.read(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfType), sizeof (bmpHandle.fileHeader.bfType));
	readStream.read(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfSize), sizeof (bmpHandle.fileHeader.bfSize));
	readStream.read(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfReserved1), sizeof (bmpHandle.fileHeader.bfReserved1));
	readStream.read(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfReserved2), sizeof (bmpHandle.fileHeader.bfReserved2));
	readStream.read(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfOffBits), sizeof (bmpHandle.fileHeader.bfOffBits));

	readStream.read(reinterpret_cast<char*>(&bmpHandle.infoHeader), sizeof (bmpHandle.infoHeader));

	bmpHandle.colorPalette.resize(256);
	for (size_t i = 0; i != 256; ++i)
		readStream.read(reinterpret_cast<char*>(&(bmpHandle.colorPalette[i])), sizeof (BMPFILE::RGBQUAD));

	bmpHandle.pixelArray = new BMPFILE::BYTE[bmpHandle.infoHeader.biSizeImage];
	readStream.read(reinterpret_cast<char*>(bmpHandle.pixelArray), bmpHandle.infoHeader.biSizeImage * sizeof (BMPFILE::BYTE));

	bmpHandle.pixelNum = bmpHandle.infoHeader.biWidth * bmpHandle.infoHeader.biHeight;
	bmpHandle.bytePerLine = (bmpHandle.infoHeader.biWidth + 3) / 4 * 4; 
}

void IMWrite(GrayscaleBMP& bmpHandle, const std::string& fileName) {
	std::ofstream writeStream(fileName.c_str(), std::ios::out | std::ios::binary);
	if (!writeStream) { 
		std::cerr << "error: can't write file " << fileName << std::endl;
	}

	writeStream.write(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfType), sizeof (bmpHandle.fileHeader.bfType));
	writeStream.write(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfSize), sizeof (bmpHandle.fileHeader.bfSize));
	writeStream.write(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfReserved1), sizeof (bmpHandle.fileHeader.bfReserved1));
	writeStream.write(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfReserved2), sizeof (bmpHandle.fileHeader.bfReserved2));
	writeStream.write(reinterpret_cast<char*>(&bmpHandle.fileHeader.bfOffBits), sizeof (bmpHandle.fileHeader.bfOffBits));

	writeStream.write(reinterpret_cast<char*>(&bmpHandle.infoHeader), sizeof (bmpHandle.infoHeader));

	for (size_t i = 0; i != 256; ++i)
		writeStream.write(reinterpret_cast<char*>(&(bmpHandle.colorPalette[i])), sizeof (BMPFILE::RGBQUAD));

	writeStream.write(reinterpret_cast<char*>(bmpHandle.pixelArray), bmpHandle.fileHeader.bfSize * sizeof (BMPFILE::BYTE));
}

void GetIntensity(GrayscaleBMP& bmpHandle, std::vector<unsigned char>& intensity) {
	intensity.resize(bmpHandle.pixelNum);

	unsigned long idx = 0;
	for (long j = 0; j < bmpHandle.infoHeader.biHeight; ++j) {
		for (long i = 0; i < bmpHandle.infoHeader.biWidth; ++i, ++idx) 
			intensity[idx] = bmpHandle.colorPalette[bmpHandle.pixelArray[j * bmpHandle.bytePerLine + i]].rgbRed; 
	}
}

void SetIntensity(GrayscaleBMP& bmpHandle, std::vector<unsigned char>& intensity) {
	unsigned long idx = 0;
	for (long j = 0; j < bmpHandle.infoHeader.biHeight; ++j) {
		for (long i = 0; i < bmpHandle.infoHeader.biWidth; ++i, ++idx) {
			bmpHandle.pixelArray[j * bmpHandle.bytePerLine + i] = intensity[idx];
		}
	}
}

#endif