/*
 Only functions that will be reused throughout the project will live here, only ‘stock’ type functions.
*/
stock CountChars(const string[], const ch[2]) {
    new i, found;
    while(string[i] != EOS) {
        if(string[i] == ch[0]) {
            found++;
        }
        i++;
    }
    return found;
}