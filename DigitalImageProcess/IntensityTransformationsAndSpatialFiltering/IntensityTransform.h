#ifndef _LOG_TRANSFORM_H
#define _LOG_TRANSFORM_H

#include <vector>
#include <cmath>
#include <algorithm>
#include <numeric>

struct Stretch {
	Stretch(double exp, double avg): E(exp), mean(avg) { }
	void operator() (unsigned char& intensity) const {
		double s = 1.0 / (1.0 + mean / pow((double) intensity , E));
		intensity = (unsigned char) (s * 255);
	}
private:
	double E;
	double mean;
};

void LogTransform(std::vector<unsigned long>& intensity) {
	double dmax(0.0), dmin(1.0); 
	size_t vecSize = intensity.size();

	std::vector<double> dintensity(intensity.begin(), intensity.end());

	for (size_t i = 0; i != vecSize; ++i) {
		dintensity[i] = log(dintensity[i] + 1);
		dmax = std::max(dmax, dintensity[i]);
		dmin = std::min(dmin, dintensity[i]);
	}

	double dis = dmax - dmin;
	for (size_t i = 0; i != vecSize; ++i)
		intensity[i] = (unsigned char) ((dintensity[i] - dmin) / dis * 255);
}

void LogTransformShow(std::vector<unsigned char>& intensity) {
	double dmax(0.0), dmin(1.0); 
	size_t vecSize = intensity.size();

	std::vector<double> dintensity(intensity.begin(), intensity.end());

	for (size_t i = 0; i != vecSize; ++i) {
		dintensity[i] = log(dintensity[i] + 1);
		dmax = std::max(dmax, dintensity[i]);
		dmin = std::min(dmin, dintensity[i]);
	}

	double dis = dmax - dmin;
	for (size_t i = 0; i != vecSize; ++i)
		intensity[i] = (unsigned char) ((dintensity[i] - dmin) / dis * 255);
}

void ContrastStretch(std::vector<unsigned char>& intensity, double exp) {
	std::vector<double> dintensity(intensity.begin(), intensity.end());
	double avg = std::accumulate(dintensity.begin(), dintensity.end(), 0.0) / dintensity.size();

	std::for_each(intensity.begin(), intensity.end(), Stretch(exp, avg));
}

#endif