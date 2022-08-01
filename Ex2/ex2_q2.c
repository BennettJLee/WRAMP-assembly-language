#include "lib_ex2.h"
/**
 * Counts from "start" to "end" (inclusive), 
 * showing progress on the seven segment displays
 **/
void count(int start, int end){
	int cStart = start;
	int cEnd = end;
	//start/end havs to be between 0 and 255 
	if(cStart >= 0 && cStart <= 0x2710){
		if(cEnd >= 0 && cEnd <= 0x2710){
			//if start is less than end, print, loop while its true
			while(cStart < cEnd){
				writessd(cStart);
				delay();
				cStart++;
			}
			//if start is greater than end, print, loop while its true
			while(cStart > cEnd){
				writessd(cStart);
				delay();
				cStart--;
			}//if start is equal to end, print
			if(cStart == cEnd){
				writessd(cStart);
				delay();
				return;
			}
		}
	}
	return;
}
