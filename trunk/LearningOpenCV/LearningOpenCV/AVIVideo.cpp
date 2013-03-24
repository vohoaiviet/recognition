#include "cv.h"
#include "highgui.h"
#include <cstdio>

int g_slider_position = 0;
CvCapture* g_capture = NULL;

void onTrackbarSlide(int pos) {
	cvSetCaptureProperty(
		g_capture,
		CV_CAP_PROP_POS_FRAMES,
		pos
		);
}

int main() {
	cvNamedWindow("xiyou", CV_WINDOW_AUTOSIZE);
	CvCapture* capture = cvCreateFileCapture("pic\\xiyou.avi");
	
	int frames = (int) cvGetCaptureProperty(
		g_capture,
		CV_CAP_PROP_FRAME_COUNT
		);

	if (frames != 0) {
		cvCreateTrackbar(
			"Position",
			"xiyou",
			&g_slider_position,
			frames,
			onTrackbarSlide
			);
	} else {
		printf("Frames not know");
	}

	IplImage* frame;
	while (true) {
		frame = cvQueryFrame(capture);
		if (!frame)
			break;
		cvShowImage("xiyou", frame);
		char c = cvWaitKey(33);
		if (c == 27)
			break;
	}

	cvReleaseCapture(&capture);
	cvDestroyWindow("Xiyou");

	return 0;
}