#ifndef _DIPCH3_H
#define _DIPCH3_H

#include <iostream>
#include <sstream>
#include "GrayscaleImage.h"
#include "IMReadWrite.h"
#include "ImageAdjust.h"
#include "IntensityTransform.h"
#include "HistProcess.h"
#include "SpatialFilter.h"

void ImReadWrite() {
	GrayscaleBMP image("pic\\rose.bmp");
	IMRead(image);
	IMWrite(image, "pic\\rose_w.bmp");
}
 
void ImAdjust() {
	// read image
	GrayscaleBMP image("pic\\breast.bmp");
	IMRead(image);

	// imadjust(f, [low_in high_in], [low_out high_out], gamma)
	int num = 0;
	double low_in, high_in, low_out, high_out, gamma;
	std::string end;

	std::vector<BMPFILE::BYTE> rgb, intensityVec;
	GetIntensity(image, rgb);
	while (std::cin >> low_in >> high_in >> low_out >> high_out >> gamma) {
		intensityVec = rgb;
		imadjust(intensityVec, 
			std::pair<double, double>(low_in * 255, high_in * 255), 
			std::pair<double, double>(low_out * 255, high_out * 255), 
			gamma);

		// file name
		std::ostringstream ost;
		ost << num;
		std::string fileName = "pic\\breast_" + ost.str() + ".bmp";

		// write image
		SetIntensity(image, intensityVec);
		IMWrite(image, fileName);

		std::cout << "press 'n' to for next test, or other key to quit." << std::endl;
		std::cin >> end;
		if (end != "n")
			break;
		num++;
	}
}

void LogTranformation() {
	GrayscaleBMP image("pic\\spectrum.bmp");
	IMRead(image);

	std::vector<BMPFILE::BYTE> rgb;
	GetIntensity(image, rgb);

	LogTransformShow(rgb);

	std::string fileName("pic\\spectrum_cr.bmp");
	SetIntensity(image, rgb);
	IMWrite(image, fileName);
}

void IntensityStretch() {
	double exp;
	std::cin >> exp;

	GrayscaleBMP image("pic\\bone-scan.bmp");
	IMRead(image);

	std::vector<BMPFILE::BYTE> rgb;
	GetIntensity(image, rgb);

	ContrastStretch(rgb, exp);

	std::string fileName("pic\\bone-scan_cs.bmp");
	SetIntensity(image, rgb);
	IMWrite(image, fileName);
}

void HistEqual() {
	GrayscaleBMP image("pic\\pollen.bmp");
	IMRead(image);

	std::vector<BMPFILE::BYTE> rgb;
	GetIntensity(image, rgb);

	HistogramEqualization(rgb);

	std::string fileName("pic\\pollen_eq.bmp");
	SetIntensity(image, rgb);
	IMWrite(image, fileName);
}

void HistMatch() {
	GrayscaleBMP image("pic\\moon-phobos.bmp");
	IMRead(image);

	std::vector<BMPFILE::BYTE> rgb;
	GetIntensity(image, rgb);

	HistogramMatch(rgb);

	std::string fileName("pic\\moon-phobos_hm.bmp");
	SetIntensity(image, rgb);
	IMWrite(image, fileName);
}

void LaplacianOperator() {
	GrayscaleBMP image("pic\\moon.bmp");
	IMRead(image);

	std::vector<BMPFILE::BYTE> rgb;
	GetIntensity(image, rgb);

	std::vector<unsigned char> initRGB(rgb.begin(), rgb.end());
	std::vector<int> intensity(rgb.begin(), rgb.end());
	LaplacianFilter(intensity, image.infoHeader.biWidth, image.infoHeader.biHeight, 0);
	
	std::vector<int> tempValue(intensity.begin(), intensity.end());
	Truncate(rgb, tempValue);
	std::string fileName("pic\\moon_tru.bmp");
	SetIntensity(image, rgb);
	IMWrite(image, fileName);

	tempValue = intensity;
	Calibration(rgb, tempValue);
	fileName = "pic\\moon_cal.bmp";
	SetIntensity(image, rgb);
	IMWrite(image, fileName);

	LaplacianEnhancement(rgb, initRGB, intensity);
	fileName = "pic\\moon_enh.bmp";
	SetIntensity(image, rgb);
	IMWrite(image, fileName);
}

void LaplacianCompare() {
	GrayscaleBMP image("pic\\moon.bmp");
	IMRead(image);

	std::vector<BMPFILE::BYTE> rgb;
	GetIntensity(image, rgb);

	std::vector<unsigned char> initRGB(rgb.begin(), rgb.end());
	std::vector<unsigned char> tempInitRGB(rgb.begin(), rgb.end());
	std::vector<int> intensity(rgb.begin(), rgb.end());
	std::vector<int> tempIntensity(rgb.begin(), rgb.end());

	LaplacianFilter(intensity, image.infoHeader.biWidth, image.infoHeader.biHeight, 0);
	LaplacianEnhancement(rgb, initRGB, intensity);

	std::string fileName = "pic\\moon_enh_4.bmp";
	SetIntensity(image, rgb);
	IMWrite(image, fileName);

	LaplacianFilter(tempIntensity, image.infoHeader.biWidth, image.infoHeader.biHeight, 1);
	LaplacianEnhancement(rgb, tempInitRGB, tempIntensity);

	fileName = "pic\\moon_enh_8.bmp";
	SetIntensity(image, rgb);
	IMWrite(image, fileName);
}

void MedianFiltering() {
	GrayscaleBMP image("pic\\ckt-board-slt-pep.bmp");
	IMRead(image);

	std::vector<BMPFILE::BYTE> rgb;
	GetIntensity(image, rgb);
	std::vector<BMPFILE::BYTE> tempRGB(rgb.begin(), rgb.end());

	MedianFilter(rgb, image.infoHeader.biWidth, image.infoHeader.biHeight, 1);
	std::string fileName("pic\\ckt-board-slt-pep-sym.bmp");
	SetIntensity(image, rgb);
	IMWrite(image, fileName);
}

#endif 