# Compiler
A Java compiler written using Perl code. Call it from the command line with a file to read from

    perl .\CLevel_compiler.pl [file to read from]
The compiler uses regular expressions to detect
  - proper naming conventions
  - proper package imports
  - integer, string, and boolean operations
  - print statements
  - conditionals and loops
  - classes and functions

Recognized data types are
  - int
  - String
  - Boolean
  - Scanner

The compiler has many print statements as it runs, showing the substitutions it makes to verify the correctness.
