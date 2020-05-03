#include <math.h>

double signal (double freq, double time, double phase) // Hz, sec, rad
{
	return sin(2*3.14159265*freq*time + phase);
}