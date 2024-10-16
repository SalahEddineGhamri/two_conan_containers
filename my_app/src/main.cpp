#include "my_app.h"
#include <iostream>
#include "addition.h"

int main() {
  int y = add(12, 12);
  std::cout << y << std::endl;
  return 0;
}
