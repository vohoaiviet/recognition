#ifndef _HIST_PROCESS_H
#define _HIST_PROCESS_H

#include <vector>
#include <cmath>

#define M_PI       3.14159265358979323846
#define M_E        2.71828182845904523536

// inner function
void TwoModeGauss(std::vector<double>& z) {
	z.resize(256);
	double m1 = 0.15, m2 = 0.75, sig1 = 0.05, sig2 = 0.05, A1 = 1, A2 = 0.07, k = 0.002;

	double c1 = A1 / std::pow(2 * M_PI, 0.5) * sig1;
	double k1 = 2 * (sig1 * sig1);
	double c2 = A2 / std::pow(2 * M_PI, 0.5) * sig2;
	double k2 = 2 * (sig2 * sig2);

	double sum = 0.0;
	for (size_t i = 0; i != 256; ++i) {
		z[i] = k + c1 * std::pow(M_E, -(i / 256.0 - m1) * (i / 256.0 - m1) / k1) 
			+ c2 * std::pow(M_E, -(i / 256.0 - m2) * (i / 256.0 - m2) / k2);
		sum += z[i];
	}

	for (size_t i = 0; i != 256; ++i)
		z[i] /= sum;
}

void GetRelation(std::vector<double>& nhist, std::vector<unsigned char>& rel) {
	double subSum = 0.0;
	rel.resize(256);

	for (size_t i = 0; i != 256; ++i) {
		subSum += nhist[i];
		rel[i] = (unsigned char) (subSum * 255);
	}
}

// function
void HistogramEqualization(std::vector<unsigned char>& intensity) {
	unsigned long bins[256] = {0};
	unsigned char grayscale[256];

	size_t vecSize = intensity.size();
	for (size_t i = 0; i != vecSize; ++i)
		++bins[intensity[i]];

	unsigned long subSum = 0;
	for (size_t i = 0; i != 256; ++i) {
		subSum += bins[i];
		grayscale[i] = (unsigned char) ((double) subSum / (double) vecSize * 255);
	}

	for (size_t i = 0; i != vecSize; ++i)
		intensity[i] = grayscale[intensity[i]];
}

// function
void HistogramMatch(std::vector<unsigned char>& intensity) {
	std::vector<double> z;
	TwoModeGauss(z);

	size_t vecSize = intensity.size();
	std::vector<double> sbins;
	sbins.resize(256);
	for (size_t i = 0; i != vecSize; ++i) 
		++sbins[intensity[i]];
	for (size_t i = 0; i != 256; ++i)
		sbins[i] /= vecSize; 

	std::vector<unsigned char> r2s;
	std::vector<unsigned char> z2s;
	std::vector<unsigned char> r2z;

	GetRelation(sbins, r2s);
	GetRelation(z, z2s);

	int idx, min;
	r2z.resize(256);
	for (size_t i = 0; i != 256; ++i) {
		min = 256;
		for (size_t j = 0; j != 256; ++j) {
			if (std::abs(z2s[j] - r2s[i]) < min) {
				min = std::abs(z2s[j] - r2s[i]);
				idx = j;
			}
		}
		r2z[i] = idx;
	}

	for (size_t i = 0; i != vecSize; ++i)
		intensity[i] = r2z[intensity[i]];
}

#endif