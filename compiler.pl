# This is my code for syntax checking simple Java code
# It can be run from the command line as shown below
#       perl .\CLevel_compiler.pl [file to read from]


#-----Declarations---------------
$code = "";
$VALID_LINE = "int N = N;|String S = S;|boolean B = B;|N = N;|S = S;|B = B;|PR;|Scanner SC = new Scanner\(System\.in\);";

#-----Open the file--------------
$filename = $ARGV[0];
open(FH,"<",$filename) or die $!;

#-----Read input into $code------
while (<FH>){
    $code = $code.$_;
}
print "\n#################################################\n";
print "############# The code read in is: ##############\n";
print "#################################################\n\n";
print $code."\n";

#-----Strip comments---------------
$code =~ s/\/\/(\w|\W)*?\n//g;   # First, inline comments
$code =~ s/\/\*(\w|\W)*?\*\///g; # Next, block comments

print "\n#################################################\n";
print "############### Removing Comments ###############\n";
print "#################################################\n\n";
print $code."\n";

#-----Strip whitespace------------
$code =~ s/^\n+//g;      # First, strip first excess line breaks at the head of $code
$code =~ s/\n\s*\n/\n/g; # Second, get rid of empty lines
$code =~ s/\n\s+/\n/g;   # Third, eliminate tabs/other extra whitespace at the beginning of a line

print "\n#################################################\n";
print "############## Removing white space #############\n";
print "#################################################\n\n";
print $code."\n";

#---- replacing package imports-------

$code =~ s/(import(\w|.)*\*{0,1};\n)*/IMP;\n/; # Replace package import with IMP;
print "\n#################################################\n";
print "########### Replacing package imports ###########\n";
print "#################################################\n\n";
print $code."\n";

#----Sub class declaration------
$code =~ s/class (\w)*\{/CLS\{/g; # First sub the class declaration for CLS{

print "\n#################################################\n";
print "########### Replacing class declaration #########\n";
print "#################################################\n\n";
print $code."\n";

#----Replace immediate primitives with type------
$code =~ s/"(\s|\S)*?"/S/g;  # Replace quoted strings with S
$code =~ s/\d+/N/g;  # Replace numbers with N
$code =~ s/(false|true);/B;/g; # Replace boolean with B

print "\n#################################################\n";
print "###### Replacing immediate vals with type #######\n";
print "#################################################\n\n";
print $code."\n";

#----Replace variables with type------
@code = split("\n", $code);

# Replacing scanner with SC
for ($i = 0; $i <= scalar @code; $i++){
    $line = @code[$i];
    if ($line =~ m/Scanner (\w*) = new Scanner\(System.in\);/g){
        $variable_name = $1;
        $code =~ s/ $variable_name;/ SC;/g; # Replace in all places a scanner could be
        $code =~ s/\n$variable_name;/\nSC;/g; # And keep formatting
        $code =~ s/ $variable_name / SC /g;
        $code =~ s/\n$variable_name /\nSC /g;
        $code =~ s/ $variable_name\.next\(\);/ S;/g;
        $code =~ s/ $variable_name\.nextInt\(\);/ N;/g;
        @code = split("\n", $code);
    }
}

# Ints replaced with N
for ($i = 0; $i <= scalar @code; $i++){
    $line = @code[$i];

    if ($line =~ m/int (\w*)/g){
        $variable_name = $1; 

        $code =~ s/ $variable_name;/ N;/g; # Replace in all places an int could be
        $code =~ s/ $variable_name,/ N,/g; # And keep formatting
        $code =~ s/\n$variable_name;/\nN;/g;
        $code =~ s/ $variable_name / N /g;
        $code =~ s/\n$variable_name /\nN /g;
        $code =~ s/\($variable_name\)/\(N\)/g;
        $code =~ s/\($variable_name, /\(N, /g;
        $code =~ s/\($variable_name; /\(N; /g;
        $code =~ s/\($variable_name /\(N /g;
        $code =~ s/ $variable_name\)/ N\)/g;
        $code =~ s/ $variable_name\+\+\)/ N\+\+\)/g;
        $code =~ s/ $variable_name\-\-\)/ N\-\-\)/g;
        @code = split("\n", $code);
    }
}

# Strings replaced with S
for ($i = 0; $i <= scalar @code; $i++){
    $line = @code[$i];
    if ($line =~ m/String (\w*)/g){
        $variable_name = $1;

        $code =~ s/ $variable_name;/ S;/g; # Replace in all places a string could be
        $code =~ s/\n$variable_name;/\nS;/g; # And keep formatting
        $code =~ s/ $variable_name / S /g;
        $code =~ s/\n$variable_name /\nS /g;
        $code =~ s/\($variable_name\)/\(S\)/g;
        $code =~ s/\($variable_name, /\(S, /g;
        $code =~ s/\($variable_name /\(S /g;
        $code =~ s/ $variable_name\)/ S\)/g;

        @code = split("\n", $code);
    }
}

# Booleans replaced with B
for ($i = 0; $i <= scalar @code; $i++){
    $line = @code[$i];
    if ($line =~ m/boolean (\w*) *= B;/g){
        $variable_name = $1;
        
        $code =~ s/ $variable_name;/ B;/g; # Replace in all places a boolean could be
        $code =~ s/\n$variable_name;/\nB;/g; # And keep formatting
        $code =~ s/ $variable_name / B /g;
        $code =~ s/\n$variable_name /\nB /g;
        $code =~ s/\($variable_name\)/\(B\)/g;
        $code =~ s/\($variable_name, /\(B, /g;
        $code =~ s/\($variable_name /\(B /g;
        $code =~ s/ $variable_name\)/ B\)/g;

        @code = split("\n", $code);
    }
}

# Object replaced with O/OBJ
for ($i = 0; $i <= scalar @code; $i++){
    $line = @code[$i];
    if ($line =~ m/(\w*) (\w*) = new ((\w*)\((B|S|N)(, (B|S|N))*\));/g){
        $class_name = $1;
        $variable_name = $2;

        $code =~ s/$class_name $variable_name \= new $class_name\(N, S\)/OBJ O = O/g;

        $code =~ s/ $variable_name;/ O;/g; # Replace in all possible places a variable could be
        $code =~ s/\n$variable_name;/\nO;/g;
        $code =~ s/ $variable_name / O /g;
        $code =~ s/\n$variable_name /\nO /g;
        $code =~ s/\($variable_name\)/\(O\)/g;
        $code =~ s/\($variable_name, /\(O, /g;
        $code =~ s/\($variable_name /\(O /g;
        $code =~ s/ $variable_name\)/ O\)/g;
        $code =~ s/$variable_name.(\w*)\(((int ){0,1}N|(String ){0,1}S|(boolean ){0,1}B){0,1}(, ((int ){0,1}N|(String ){0,1}S|(boolean ){0,1}B))*\);/OBJ O.METHOD;/g;

        @code = split("\n", $code);
    }
}

print "\n#################################################\n";
print "######### Replacing variables with type #########\n";
print "#################################################\n\n";
print $code."\n";

#----Replacing function declarations------

print "\n#################################################\n";
print "######### Replacing function declaration ########\n";
print "#################################################\n\n";
print $code."\n";

$code =~ s/(public ){0,1}(static ){0,1}(void ){0,1}(\w*)( *)\(((int ){0,1}N|(String ){0,1}S|(int ){0,1}B|String \[\] args){0,1}(, ((int ){0,1}N|(String ){0,1}S|(boolean ){0,1} B))*\)\{/FUNC\{/g;

#----Allowing for integer/string/boolean operations------
$code =~ s/N( (\+|-|\*|\/|\*\*|%) N)*;/N;/g; # N +/- N +/-... = N (allow integer arithmetic)
$code =~ s/N (<|>)=* N/B/g;
$code =~ s/N == N/B/g;
$code =~ s/S == S/B/g;
$code =~ s/B == B/B/g;
$code =~ s/S( \+ S)*;/S;/g; # S + S +... = S (allow string addition)

print "\n#################################################\n";
print "##### Allowing int/string/bool operations ########\n";
print "#################################################\n\n";
print $code."\n";

#----Allowing print statements------
$code =~ s/System.out.println\((S|N)( \+ (S|N))*\)/PR/g;

print "\n#################################################\n";
print "########### Allowing print statements ###########\n";
print "#################################################\n\n";
print $code."\n";

#----Label lines with valid code------
$code =~ s/IMP;|int N;|String S;|int N = N;|String S = S;|boolean B = B;|N = N;|S = S;|B = B;|PR;|Scanner SC = new Scanner\(System\.in\);|OBJ O;|OBJ O.METHOD;|OBJ O = O;/VL;/g; 

print "\n#################################################\n";
print "######### Label lines with valid code ###########\n";
print "#################################################\n\n";
print $code."\n";

#----Allowing conditionals and loops------
$code =~ s/ //g; # First make sure spacing is unified

$code =~ s/((if\(B\)\{(\nVL;)*\n\})(\nelse\{(\nVL;)*\n\})*)/VL;/g; # Check if statements

$code =~ s/(while\(B\)\{(\nVL;)*\n\})/VL;/g;  # Check while loops
$code =~ s/(for\((N|VL);B;N(\+\+|\-\-)\)\{(\nVL;)*\n\})/VL;/g; # Check for loops

print "\n#################################################\n";
print "######## Allowing conditionals and loops ########\n";
print "#################################################\n\n";
print $code."\n";

#----Allowing classes and functions------
$code =~ s/(FUNC\{(\nVL;)*\n\})/VL;/g;  # Check functions
$code =~ s/(CLS\{(\nVL;)*\n\})/VL;/g;  # Check classes

print "\n#################################################\n";
print "######## Allowing classes and functions #########\n";
print "#################################################\n\n";
print $code."\n";

#----Checking all lines------
$code =~ s/(VL;\n)*VL;/VL;/g;
print "\n#################################################\n";
print "############## Checking all lines ###############\n";
print "#################################################\n\n";
print $code."\n";

$code =~ s/\s//g; # Finally, clean white space once more

if ($code eq "VL;"){
    print "\n#################################################\n";
    print "######## Success! Your code has compiled ########\n";
    print "#################################################\n\n";
}
else {
    print "\n#################################################\n";
    print "##### There was an error. Please try again. #####\n";
    print "#################################################\n\n";
}
