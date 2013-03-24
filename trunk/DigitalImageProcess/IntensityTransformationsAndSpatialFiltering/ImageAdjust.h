#ifndef _IMAGEADJUST_H
#define _IMAGEADJUST_H

#include <vector>
#include <utility>
#include <cmath>
#include <algorithm>

class MapValue {
public:
	MapValue(double LI, double HI, double LO, double HO, double GAMMA)
		: low_in(LI), 
		high_in(HI), 
		low_out(LO), 
		high_out(HO),
		gamma(GAMMA)
	{
	}

	void operator() (unsigned char& intensity) const {
		if (intensity >= low_in && intensity <= high_in) {
			intensity = (unsigned char) (low_out + (high_out - low_out) * 
				pow((intensity - low_in) / (high_in - low_in), gamma));
		}
		else if (intensity < low_in)
			intensity = (unsigned char) low_out;
		else 
			intensity = (unsigned char) high_out;
	}

private:
	double low_in;
	double high_in;
	double low_out;
	double high_out;
	double gamma;
};

void imadjust(std::vector<unsigned char>& intensityVec, 
			  std::pair<double, double> in = std::make_pair(0, 1), 
			  std::pair<double, double> out = std::make_pair(0, 1), 
			  double gamma = 1.0) 
{
	for_each(intensityVec.begin(), intensityVec.end(),
		MapValue(in.first, in.second, out.first, out.second, gamma));

	/* The same with below
	int mid(0), low(0), high(0);
	for (size_t i = 0; i != intensityVec.size(); ++i) {
		if (intensityVec[i] >= in.first && intensityVec[i] <= in.second) {
			intensityVec[i] = (unsigned char) (out.first + (out.second - out.first) * 
				pow((intensityVec[i] - in.first) / (in.second - in.first), gamma));
			++mid;
		}
		else if (intensityVec[i] < in.first) {
			intensityVec[i] = (unsigned char) out.first;
			++low;
		}
		else {
			intensityVec[i] = (unsigned char) out.second;
			++high;
		}
	}
	cout << low << " " << mid << " " << high << endl;*/
}

#endif