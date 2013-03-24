#ifndef _SPATIAL_FILTER_H
#define _SPATIAL_FILTER_H

#include <vector>
#include <algorithm>

int LaplacianMask[2][3][3] = {
	{
		{0, 1, 0}, 
		{1, -4, 1}, 
		{0, 1, 0}
	},
	{
		{1, 1, 1},
		{1, -8, 1},
		{1, 1, 1}
	}
};

int dir[9][2] = {{-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {0, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}};

void Truncate(std::vector<unsigned char>& rgb, std::vector<int>& intensity) {
	int vecSize = rgb.size();
	for (size_t i = 0; i != vecSize; ++i) {
		if (intensity[i] < 0)
			rgb[i] = 0;
		else if (intensity[i] > 255)
			rgb[i] = 255;
		else 
			rgb[i] = (unsigned char) intensity[i];
	}
}

void Calibration(std::vector<unsigned char>& rgb, std::vector<int>& intensity) {
	size_t vecSize = rgb.size();
	int maxGrayLevel = 0, minGrayLevel = 255;

	for (size_t i = 0; i < vecSize; ++i)
		minGrayLevel = std::min(minGrayLevel, intensity[i]);

	for (size_t i = 0; i < vecSize; ++i) {
		intensity[i] -= minGrayLevel;
		maxGrayLevel = std::max(maxGrayLevel, intensity[i]);
	}

	for (size_t i = 0; i < vecSize; ++i)
		rgb[i] = (unsigned char) (255 * (double)(intensity[i]) / maxGrayLevel);
}

void LaplacianFilter(std::vector<int>& intensity, long width, long height, int mode) {
	std::vector<int> resultIntensity;
	resultIntensity.resize(intensity.size());

	for (long j = 1; j < height - 1; ++j) {
		for (long i = 1; i < width - 1; ++i) {
			int sum = 0;
			for (int k = 0; k < 9; ++k) {
				sum += intensity[(j + dir[k][1]) * width + (i + dir[k][0])] * 
					LaplacianMask[mode][k / 3][k % 3];
			}
			resultIntensity[j * width + i] = sum;
		}
	}

	intensity = resultIntensity;
}

void LaplacianEnhancement(std::vector<unsigned char>& rgb, 
						  std::vector<unsigned char>& initRGB, 
						  std::vector<int>& intensity) 
{
	std::vector<int> temp;
	temp.resize(rgb.size());

	size_t vecSize = rgb.size();
	for (size_t i = 0; i != vecSize; ++i)
		temp[i] =  (initRGB[i] - intensity[i]);

	Truncate(rgb, temp);
}

void MedianFilter(std::vector<unsigned char>& intensity, long width, long height, int mode) {
	std::vector<unsigned char> resultIntensity;
	resultIntensity.resize(intensity.size());

	std::vector<unsigned char> adj;
	adj.resize(9);

	for (long j = 1; j < height - 1; ++j) {
		for (long i = 1; i < width - 1; ++i) {
			for (int k = 0; k < 9; ++k)
				adj[k] = intensity[(j + dir[k][1]) * width + (i + dir[k][0])];

			std::sort(adj.begin(), adj.end());
			resultIntensity[j * width + i] = adj[4];
		}
	}

	if (mode == 0) {
		int ww, hh;
		for (int i = 0; i < width; ++i) {
			for (int k = 0; k < 9; ++k) {
				ww = i + dir[k][0];
				hh = 0 + dir[k][1];
				if (hh < 0 || ww < 0 || ww == width)
					adj[k] = 0;
				else
					adj[k] = intensity[hh * width + ww];
			}
			std::sort(adj.begin(), adj.end());
			resultIntensity[i] = adj[4];

			for (int k = 0; k < 9; ++k) {
				ww = i + dir[k][0];
				hh = height - 1 + dir[k][1];
				if (hh == height || ww < 0 || ww == width)
					adj[k] = 0;
				else
					adj[k] = intensity[hh * width + ww];
			}
			std::sort(adj.begin(), adj.end());
			resultIntensity[(height - 1) * width + i] = adj[4];
		}

		for (int j = 0; j < height; ++j) {
			for (int k = 0; k < 9; ++k) {
				ww = 0 + dir[k][0];
				hh = j + dir[k][1];
				if (ww < 0 || hh < 0 || hh == height)
					adj[k] = 0;
				else
					adj[k] = intensity[hh * width + ww];
			}
			std::sort(adj.begin(), adj.end());
			resultIntensity[j * width] = adj[4];

			for (int k = 0; k < 9; ++k) {
				ww = width - 1 + dir[k][0];
				hh = j + dir[k][1];
				if (ww == width || hh < 0 || hh == height)
					adj[k] = 0;
				else
					adj[k] = intensity[hh * width + ww];
			}
			std::sort(adj.begin(), adj.end());
			resultIntensity[j * width + width - 1] = adj[4];
		}
	} else {
		int ww, hh;
		for (int i = 0; i < width; ++i) {
			for (int k = 0; k < 9; ++k) {
				ww = i + dir[k][0];
				hh = 0 + dir[k][1];
				if (hh < 0 && ww < 0) 
					hh = ww = 1;
				else if (hh < 0 && ww == width) {
					hh = 1;
					ww = width - 2;
				} else if (hh < 0)
					hh = 1;
				else if (ww < 0) 
					ww = 1;
				else if (ww == width)
					ww = width - 2;
				adj[k] = intensity[hh * width + ww];
			}
			std::sort(adj.begin(), adj.end());
			resultIntensity[i] = adj[4];

			for (int k = 0; k < 9; ++k) {
				ww = i + dir[k][0];
				hh = height - 1 + dir[k][1];
				if (hh == height && ww < 0) {
					hh = height - 2;
					ww = 1;
				} else if (hh == height && ww == width) {
					hh = height - 2;
					ww = width - 2;
				} else if (hh == height)
					hh = height - 2;
				else if (ww < 0)
					ww = 1;
				else if (ww == width)
					ww = width - 2;
				adj[k] = intensity[hh * width + ww];
			}
			std::sort(adj.begin(), adj.end());
			resultIntensity[(height - 1) * width + i] = adj[4];
		}
		
		for (int j = 1; j < height - 1; ++j) {
			for (int k = 0; k < 9; ++k) {
				ww = 0 + dir[k][0];
				hh = j + dir[k][1];
				if (ww < 0)
					ww = 1;
				adj[k] = intensity[hh * width + ww];
			}
			std::sort(adj.begin(), adj.end());
			resultIntensity[j * width] = adj[4];

			for (int k = 0; k < 9; ++k) {
				ww = width - 1 + dir[k][0];
				hh = j + dir[k][1];
				if (ww == width)
					ww = width - 2;
				adj[k] = intensity[hh * width + ww];
			}
			std::sort(adj.begin(), adj.end());
			resultIntensity[j * width + width - 1] = adj[4];
		}
	}

	intensity = resultIntensity;
}                                                                      

#endif