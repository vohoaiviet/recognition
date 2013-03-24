/**
  This file is used to read and write bmp file
*/

#ifndef _IO_HANDLE_H
#define _IO_HANDLE_H

#include <fstream>
#include "BMPBasic.h"
using namespace std;

class IOHandle {
public:
	void ReadBMP(BMPBasic&);
	void GenBMP(BMPBasic&, const string&) const;
private:

};

#endif