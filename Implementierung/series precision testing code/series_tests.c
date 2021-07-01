#include <stdio.h>
#include <math.h>
extern float squareroot_series(unsigned long long n);
float calculate_k(unsigned long long num){
     return sqrt(num);
}

void output(long long unsigned test) {
    printf("Test with %llu\n", test);
    printf("Precision of series implementation: %.7f\n", squareroot_series(test));
    printf("Precision of function in C: %.7f\n", calculate_k(test));
    printf("Deviation of Series to C: %.7f%%\n\n", 100 - (squareroot_series(test) / calculate_k(test) * 100)); 
}
void main () {
  output(131073); //2^17 + 1
  output(262144); //2^18
  output(524287); //2^19 - 1
  output(163840); //quarter between 2^17 and 2^18
  output(196608); //half between 2^17 and 2^18
  output(229376); //three quarters between 2^17 and 2^18
  output(327680); //quarter between 2^18 and 2^19
  output(393216); //half between 2^18 and 2^19
  output(458752); //three quarters between 2^18 and 2^19
}