function oimg = preprocessing(iimg, iminfo)
%PREPROCESS preprocessing and partitioning the input facial image.
%OIMG is the output image of size.we first manually determine the
%positions of eyes and mouth in each image, and use these positions to
%obtain facial of each image, thereby scale to 164 X 127 (184 * 152).

width = iminfo.Width;
height = iminfo.Height;
cx = width / 2;
cy = height / 2;
oimg = iimg(cx - 71:cx + 92, cy - 60:cy + 66);