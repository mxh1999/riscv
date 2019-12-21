#include <iostream> 
#include <cstring> 
using namespace std;

int main() {
  char inst[128]; 
  char tp; // instruction type  
  char bin[32]; 
  scanf(" %c %s", &tp, inst); 

  char btmp[4]; // temp for 4-bit binary per hex
  int nb; // number 
  for (int i = 0; i < 8; ++i) {
    nb = inst[i] - '0'; 
    for (int j = 3; j >= 0; --j) {
      btmp[j] = char(nb % 2 + '0'); 
      nb /= 2; 
    }
    for (int j = 0; j < 4; ++j) {
      bin[4*i + j] = btmp[j];  
    }
  }

  int midx; // manual index is different from current array index 
  switch(tp){
    case 'R':
      for(int i = 0; i < 32; ++i) {
        midx = 31 - i; 
        if (midx == 24 || midx == 19 || midx == 14 || midx == 11 || midx == 6) 
          putchar(' '); 
        putchar(bin[i]); 
      }
      break;
    case 'I':
      for(int i = 0; i < 32; ++i) {
        midx = 31 - i; 
        if (midx == 19 || midx == 14 || midx == 11 || midx == 6) 
          putchar(' '); 
        putchar(bin[i]); 
      }
      break;
    case 'S':
      for(int i = 0; i < 32; ++i) {
        midx = 31 - i; 
        if (midx == 24 || midx == 19 || midx == 14 || midx == 11 || midx == 6) 
          putchar(' '); 
        putchar(bin[i]); 
      }
      break; 
    case 'B':
      for(int i = 0; i < 32; ++i) {
        midx = 31 - i; 
        if (midx == 24 || midx == 19 || midx == 14 || midx == 11 || midx == 6) 
          putchar(' '); 
        putchar(bin[i]); 
      }
      break;
    case 'U':
      for(int i = 0; i < 32; ++i) {
        midx = 31 - i; 
        if (midx == 11 || midx == 6) 
          putchar(' '); 
        putchar(bin[i]); 
      }
      break;
    case 'J':
      for(int i = 0; i < 32; ++i) {
        midx = 31 - i; 
        if (midx == 11 || midx == 6) 
          putchar(' '); 
        putchar(bin[i]); 
      }
      break; 
    default :
      printf("ERROR: unknown instruction type!\n");
  }
  putchar('\n'); 
  return 0; 
}