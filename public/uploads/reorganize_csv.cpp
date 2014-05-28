#include <iostream>
#include <fstream>
#include <cstdio>
#include <string>
#include <cstdlib>

using namespace std;

char * itoa (int, char[], int);

int main (int argc, char *argv[]) {

	if (argc != 14) {
		printf("Wrong number of arguments\n");
	 	return 0;
	}

	/* 1. original file name;
	** 2. where to extract
	** 3. last_id
	** 4. has some headers
	** 5. manufacturer
	** 6. didtributor
	** 7. route
	** code, price, weight, amount, description 
	** 13. pg
	*/
	FILE* f = fopen(argv[1], "r");
	ofstream out(argv[2]);

	fseek(f, 0, SEEK_END); 

	long long size = ftell(f);
	char* where = new char[size];
	rewind(f);
	fread(where, sizeof(char), size, f);
	string text (where);
	string result = "";

	long long index = atoi(argv[3]); // last index of the product in database 
	char eol = 10;//, comma = ',';
	unsigned int ccounter = 0;
	string words [6];
	words[1] = "";
	words[2] = "";
	words[3] = "";
	words[4] = "";
	words[5] = "";
	words[0] = "";
	
	bool open = false;
	bool np = false;
	long long i = 0;
	//skip first line
	int cc = 0; // coma counters
	int sc = 0; // selicolon counters
	if (*argv[4] == '1') for (; where[i++] != eol;) {
		if (where[i] == ',') cc++;
		if (where[i] == ';') sc++;
	}

	char comma;
	if (cc > sc) {
		comma = ',';
	}
	else {
		comma = ';';
	}

	for (; i < size; i++) {	

		if (where[i] == comma & !open) {
			ccounter ++;
		}
		else if (where[i] == eol) {
			char buf [12];			
			cerr << index <<',';
			result += string(itoa(index++, buf, 12)) + '|' + words[atoi(argv[8])] + '|' + words[atoi(argv[9])] + '|' + words[atoi(argv[10])] + '|' + words[atoi(argv[11])] + '|' + words[atoi(argv[12])] + '|' + argv[5] + '|' + argv[6] + '|' + argv[7] + '|' + argv[13] + '\n';
			ccounter = 0;
			words[1] = "";
			words[2] = "";
			words[3] = "";
			words[4] = "";
			words[5] = "";
			words[0] = "";
		}
		else if (where[i] == '"' && ccounter < 6) { 
			open = !open; words[ccounter] += '"'; 
		}
		else if (where[i] == '\\' && ccounter < 6) {
			open = !open; words[ccounter] += '"'; 
		}
		else if (ccounter < 6){
			words[ccounter] += where[i];	
		}
	}
	out << result;
	return 0;
	
}

char* itoa (int i, char* buffer, int size) {
	  snprintf(buffer, size, "%d", i);
	  return buffer;
}
