#include "wramp.h"

void main()
{
    int switches = readswitches();
	int start = (switches >> 8) & 0xFF;
	int end = switches & 0xFF;
	count(start, end);
}
