#include <map>
#include "BMPConcrete.h"
using namespace std;

MonochromeBMP::MonochromeBMP(const string& fileName) 
	:BMPBasic(fileName)
{
}

bool MonochromeBMP::GetColor(vector<unsigned char>& rvec, vector<unsigned char>& gvec, vector<unsigned char>& bvec) {
	// add code here
	return true;
}
   
bool MonochromeBMP::SetColor(vector<unsigned char>& rvec, vector<unsigned char>& gvec, vector<unsigned char>& bvec) {
	// add code here
	return true;
}

EightBitBMP::EightBitBMP(const string& fileName) 
	:BMPBasic(fileName)
{
}

bool EightBitBMP::GetColor(vector<unsigned char>& rvec, vector<unsigned char>& gvec, vector<unsigned char>& bvec) {
	rvec.resize(infoHeader.biWidth * infoHeader.biHeight);
	gvec.resize(infoHeader.biWidth * infoHeader.biHeight);
	bvec.resize(infoHeader.biWidth * infoHeader.biHeight);

	unsigned long idx = 0;
	for (long j = 0; j < infoHeader.biHeight; ++j) {
		for (long i = 0; i < infoHeader.biWidth; ++i, ++idx) {
			rvec[idx] = colorPalette[pixelArray[j * bytePerLine + i]].rgbRed; 
			gvec[idx] = colorPalette[pixelArray[j * bytePerLine + i]].rgbGreen;
			bvec[idx] = colorPalette[pixelArray[j * bytePerLine + i]].rgbBlue;
		}
	}

	return true;
}

bool EightBitBMP::SetColor(vector<unsigned char>& rvec, vector<unsigned char>& gvec, vector<unsigned char>& bvec) {
	map<int, unsigned char> colorIndex; 
	for (size_t i = 0; i != 256; ++i) { // hash, set image data
		colorIndex[(colorPalette[i].rgbBlue << 16) + (colorPalette[i].rgbGreen << 8) + colorPalette[i].rgbRed] = i;
	}

	unsigned long idx = 0;
	for (long j = 0; j < infoHeader.biHeight; ++j) {
		for (long i = 0; i < infoHeader.biWidth; ++i, ++idx) {
			pixelArray[j * bytePerLine + i] = colorIndex[(bvec[idx] << 16) + (gvec[idx] << 8) + rvec[idx]];;
		}
	}

	return true;
}

TrueColorBMP::TrueColorBMP(const string& fileName) 
	:BMPBasic(fileName) 
{

}

bool TrueColorBMP::GetColor(vector<unsigned char>& rvec, vector<unsigned char>& gvec, vector<unsigned char>& bvec) {
	rvec.resize(infoHeader.biWidth * infoHeader.biHeight);
	gvec.resize(infoHeader.biWidth * infoHeader.biHeight);
	bvec.resize(infoHeader.biWidth * infoHeader.biHeight);

	unsigned long idx = 0;
	for (long j = 0; j < infoHeader.biHeight; ++j) { // get color according to image data
		for (long i = 0; i < infoHeader.biWidth; ++i, ++idx) {
			rvec[idx] = pixelArray[j * bytePerLine + 3 * i];
			gvec[idx] = pixelArray[j * bytePerLine + 3 * i + 1];
			bvec[idx] = pixelArray[j * bytePerLine + 3 * i + 2];
		}
	}

	return true;
}

bool TrueColorBMP::SetColor(vector<unsigned char>& rvec, vector<unsigned char>& gvec, vector<unsigned char>& bvec) {
	unsigned long idx = 0;
	for (long j = 0; j < infoHeader.biHeight; ++j) {
		for (long i = 0; i < infoHeader.biWidth; ++i, ++idx) {
			pixelArray[j * bytePerLine + 3 * i] = rvec[idx];
			pixelArray[j * bytePerLine + 3 * i + 1] = gvec[idx];
			pixelArray[j * bytePerLine + 3 * i + 2] = bvec[idx];
		}
	}

	return true;
}