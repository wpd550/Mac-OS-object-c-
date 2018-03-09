#pragma once

typedef unsigned char byte;
typedef unsigned int uint32_t;
#define OUT

class MD5 {
public:
	MD5();
	virtual ~MD5();
	void init();
	void update(byte* input, uint32_t length);
	void transform();
	void final(OUT byte digest[16]);
private:
	void transform(byte block[64]);
	void encode(uint32_t* input, byte* output, uint32_t length);
	void decode(byte* input, uint32_t* output, uint32_t length);
	
	//MD5 context
	uint32_t state[4]; //state (ABCD)
	uint32_t count[2]; //number of bits, modulo 2^64 (lsb first)
	byte buffer[64]; //input buffer
};