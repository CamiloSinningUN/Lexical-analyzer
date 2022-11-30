# Lexical-analyzer

LEXICAL AND SYNTACTIC ANALYZER OF A SUBSET OF C.

## Grammar 

The following are the tokens that are part of the set to take into account:
start({),if-else-fif,for-ffor,mq-fmq,hh-fhh,dd-fdd (depending on),read,write,end
Arithmetic operators: op-mult(*), op-sum(+), op-sust(-), op-div(/), op-mod(%)

Assignment: op-assign(=)

Take into account the syntax of an internal instruction regarding its termination, that is, if
ends with a semicolon, semicolon, or nothing.

The following symbols: parent-a ( ( ), parent-c ( ) ), comma (,), where necessary.

The following tokens: Integer constants, reals, strings (strings are enclosed in quotes
double quotes) and characters (characters are enclosed in single quotes).

The lexical components of the variables: Identifiers.

The lexical components of comparison: Equal (==), Different (!=) Less-equal (<=),
Greater-equal (>=), Greater (>) and Less (<).

Boolean operators: And ( && ), Or ( || ), Not ( ! ).

Comments within each of the programs should be considered.

The following variable declarations are considered: int, float, char. these are words
C programming language keys.

**You should not consider:**

Handling arrays of any dimension.
string handling
Handling functions or subroutines
Management of predefined functions.
