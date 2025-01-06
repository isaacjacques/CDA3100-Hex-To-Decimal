using namespace std;
#include <iostream>
#include <string>


int charToDecimal(char c) {
    if(c >= '0' && c <= '9') {
        return c - '0';         // ASCII '0' = decimal 48
    } else if(c >= 'a' && c <= 'f') {
        return 10 + (c - 'a');  // ASCII 'a' = decimal 97
    } else {
        return -1;
    }
}

int main() {
    int decimalValue = 0;
    int i = 0;  
    string hexStr;

    cout << "Enter a hexadecimal value." << endl;
    cin >> hexStr;

    if(hexStr.length() > 8) {  
        goto invalid_length;
    }


conversion_loop:
    if(i < hexStr.length())
    {
        char c = hexStr[i];
        int characterValue = charToDecimal(c);

        if(characterValue == -1) goto invalid_digit;
        decimalValue = (decimalValue * 16) + characterValue;
        i = i + 1;
        goto conversion_loop;
    } else {
        cout << "The hexadecimal number entered is the decimal value: " << decimalValue << endl;
        goto end_program;
    }

invalid_length:
    cout << "More than 8 hex digits entered." << endl;
    goto end_program;

invalid_digit:
    cout << "Invalid hex digit: " << hexStr[i] << endl;
    goto end_program;
    
end_program:
    return 0;
}



