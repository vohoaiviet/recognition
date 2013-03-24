clear all;
close all;

filename = 'PCAtest\\data.txt';

data = load(filename);

[result_data, eigenvec] = PCA(data, 2);