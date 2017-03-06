// Headers {{{
#include <iostream>
#include <fstream>

#include <string>
#include <array>
#include <vector>
#include <map>
#include <set>

#include <algorithm>
#include <numeric>
#include <iterator>
#include <memory>
#include <utility>
#include <chrono>

#include <ctime>
#include <cmath>
#include <cstddef>
// }}}

// g++ main.cpp -o hello && ./hello foo bar
// cl.exe main.cpp /Fehello.exe && hello.exe foo bar

int main(int argc, char* argv[]) {
	std::ios::sync_with_stdio(false);

	std::cout << "hello world" << '\n';

	for (int i = 1; i < argc; i++) {
		std::cout << argv[i] << '\n';
	}

	return 0;
}
