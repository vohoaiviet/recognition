/*
  this file contain three kind BMP file,monochrome, 256 color and true color BMP file.
  There all derive from BMPBasic class.
  Special their GetColor and SetColor method.
**/
#ifndef _BMP_CONCRETE_H
#define _BMP_CONCRETE_H

#include "BMPBasic.h"

class  MonochromeBMP : public BMPBasic { 
	friend class IOHandle;
public:
	MonochromeBMP(const string&);

	bool GetColor(vector<unsigned char>&, vector<unsigned char>&, vector<unsigned char>&);
	bool SetColor(vector<unsigned char>&, vector<unsigned char>&, vector<unsigned char>&);
private:
};

class EightBitBMP : public BMPBasic { // 256 color
	friend class IOHandle;
public:
	EightBitBMP(const string&);

	bool GetColor(vector<unsigned char>&, vector<unsigned char>&, vector<unsigned char>&);
	bool SetColor(vector<unsigned char>&, vector<unsigned char>&, vector<unsigned char>&);
private:
};

class TrueColorBMP : public BMPBasic {
	friend class IOHandle;
public:
	TrueColorBMP(const string&);

	bool GetColor(vector<unsigned char>&, vector<unsigned char>&, vector<unsigned char>&);
	bool SetColor(vector<unsigned char>&, vector<unsigned char>&, vector<unsigned char>&);
private:
};

#endif