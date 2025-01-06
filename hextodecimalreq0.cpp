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
    string user_input;
    cout << "Enter a hexadecimal value." << endl;
    cin >> user_input;
    //cout << user_input << endl;

    if(user_input.length() <= 8){
        int32_t decimalValue = 0;
        bool hexValid = true;
        for(char c : user_input){
            int characterValue = charToDecimal(c);

            if(characterValue >=0 ) {
                //cout << "Valid Hex digit: " << c << " = " << characterValue << endl;
                decimalValue = decimalValue * 16 + characterValue;
            } else {
                hexValid = false;
                cout << "Invalid hex digit: " << c << endl;
                break;
            }
        }

        if(hexValid) {
            cout << "The hexadecimal number entered is the decimal value: " << decimalValue << endl;
        }
    } else {
        cout << "More than 8 hex digits entered." << endl;
    }

    return 0;
}
