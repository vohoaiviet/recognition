function [size, wlen] = calparam
%%
cnt = 1;
size = zeros(3);
wlen = zeros(3);
for S = 11 : 9 : 29
    size(cnt) = 0.0036 * S * S + 0.35 * S + 0.18;
    wlen(cnt) = size(cnt) / 0.8;
    cnt = cnt + 1;
end