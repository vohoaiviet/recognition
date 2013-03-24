%% Get acquainted with operating on row and column vectors.
evenVect = 22 : 2 : 46;
x = [4 5 9 6];
x1 = x - 3;
x(1:2:4) = x(1:2:4) + 11;
sqrt(x);
x3 = x.^2;

vec1 = 2 : 2 : 8;
vec2 = 9 : -2 : -5;

vec3 = zeros(5);
vec4 = zeros(5);
for i = 1 : 5
    vec3(i) = 1 / i;
    vec4(i) = (i - 1) / (i);
end

vec5 = zeros(100);
for i = 1 : 100
    vec5 = (-1) ^ n / (2 * n - 1);
end
sumVec = sum(vec5);

t = 1 : 0.2 : 2;
t1 = log(2 + t + t.^2);
t2 = (cos(t)).^2 - (sin(t)).^2;
t3 = exp(t) * (1 + cos(3 * t));
t4 = atan(t);

xx = [2 1 3 7 9 4 6];
yy_1 = xx (3);
yy_2 = xx (1:7);
yy_3 = xx (1:end);
yy_4 = xx(1:end-1);
yy_5 = xx(2:2:6);
yy_6 = xx(6:-2:1);
yy_7 = xx(end-2:-3:2);
yy_8= sum(x);
yy_9 = mean(xx);
yy_10= min(xx);