#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <limits.h>
#include <getopt.h>
#include <math.h>
#include <errno.h>
#include <time.h>
#include "lookup_table.h"

extern float birthday_num_series(unsigned long long n);
extern float birthday_num_tab(unsigned long long n, float arr[]);
extern float assembler_vergleich(unsigned long long n);

/* 
  Das Ziel von diesem Program ist dem Nutzer die Moeglichkeit zu 
  geben, unsere Assembly manuell zu probieren und tests und Benchmarking
  auszufuehren.
*/

//Function used to calculate the value using standard C functions
float calculate_k(unsigned long long num){
    float numF;
    if(num < 0){
        numF = (float) num + pow(2.0, 63.0);
    } else {
        numF = num;
    }
     float res = (1 + sqrt(1+8*numF*log(2)))/2.0;
     return res;
}

void output_benchmarking(double time, int iterations, double res, int implementation) {
    char impl[25];
    if(implementation == 0){
        strcpy(impl, "Tabellenimplementierung");
    } else if(implementation == 1){
        strcpy(impl, "Serienimplementierung");
    } else if(implementation == 2){
        strcpy(impl, "Assemblerimplementierung");
    } else {
        strcpy(impl, "C Implementierung");
    }
    printf("Resultat: %lf\n", res);
    printf("Performanz von %s:\n", impl);
    printf("Laufzeit: %.15lf Sekunden\n",time);
    printf("Durchschnittliche Laufzeit: %.15lf Sekunden\n\n",time/iterations);
}

//Benchmarks with smaller input-interval
int modbenchmark(int iterations) {
    
    double res=0; 
    struct timespec start; 
    struct timespec end;

    //Benchmarking of table implementation
    clock_gettime(CLOCK_MONOTONIC, &start);
    for(int i=0;i<iterations;i++){
        res+=birthday_num_tab(i % 65535,table);//res is calculated this way to prevent 
                           //the compiler from optimizing the loop away
    } 
    clock_gettime(CLOCK_MONOTONIC,&end);
    double time=end.tv_sec-start.tv_sec +1e-9*(end.tv_nsec-start.tv_nsec);
    printf("\n-------------------Benchmarks mit kleinerem Eingabebereich--------------------------\n");
    output_benchmarking(time, iterations, res, 0);
    
    //Benchmarking of series implementation
    clock_gettime(CLOCK_MONOTONIC, &start);
    for(int i=0;i<iterations;i++){
        res+=birthday_num_series(i % 65535);
    }
    clock_gettime(CLOCK_MONOTONIC,&end);
    time=end.tv_sec-start.tv_sec +1e-9*(end.tv_nsec-start.tv_nsec);
    output_benchmarking(time, iterations, res, 1);

    //Benchmarking of assembly function using standard functions
    clock_gettime(CLOCK_MONOTONIC, &start);
    for(int i=0;i<iterations;i++){
        res+=assembler_vergleich(i % 65535);
    }
    clock_gettime(CLOCK_MONOTONIC,&end);
    time=end.tv_sec-start.tv_sec +1e-9*(end.tv_nsec-start.tv_nsec);
    output_benchmarking(time, iterations, res, 2);

    //Benchmarking of C implementation
    clock_gettime(CLOCK_MONOTONIC, &start);
    for(int i=0;i<iterations;i++){
        res+=calculate_k(i % 65535);
    }
    clock_gettime(CLOCK_MONOTONIC,&end);
    time=end.tv_sec-start.tv_sec +1e-9*(end.tv_nsec-start.tv_nsec);
    output_benchmarking(time, iterations, res, 3);


    return 0;
}

//function for benchmarking
int benchmark(int iterations){
   
    double res=0; 
    struct timespec start; 
    struct timespec end;

    printf("\n\nalle Benchmarks haben %i Iterationen", iterations);
    printf("\nResultat hat hier keine Bedeutung, muss aber da sein, damit die Schleife nicht wegoptimiert wird\n");
    printf("\n-------------------Benchmarks mit größerem Eingabebereich--------------------------\n");

    //Benchmarking of table implementation
    clock_gettime(CLOCK_MONOTONIC, &start);
    for(int i=0;i<iterations;i++){
        res+=birthday_num_tab(i,table);//res is calculated this way to prevent 
                           //the compiler from optimizing the loop away
    }
    clock_gettime(CLOCK_MONOTONIC,&end);
    double time=end.tv_sec-start.tv_sec +1e-9*(end.tv_nsec-start.tv_nsec);
    output_benchmarking(time, iterations, res, 0);
    
    //Benchmarking of series implementation
    clock_gettime(CLOCK_MONOTONIC, &start);
    for(int i=0;i<iterations;i++){
        res+=birthday_num_series(i);
    }
    clock_gettime(CLOCK_MONOTONIC,&end);
    time=end.tv_sec-start.tv_sec +1e-9*(end.tv_nsec-start.tv_nsec);
    output_benchmarking(time, iterations, res, 1);

    //Benchmarking of assembly function using standard functions
    clock_gettime(CLOCK_MONOTONIC, &start);
    for(int i=0;i<iterations;i++){
        res+=assembler_vergleich(i);
    }
    clock_gettime(CLOCK_MONOTONIC,&end);
    time=end.tv_sec-start.tv_sec +1e-9*(end.tv_nsec-start.tv_nsec);
    output_benchmarking(time, iterations, res, 2);

    //Benchmarking of C implementation
    clock_gettime(CLOCK_MONOTONIC, &start);
    for(int i=0;i<iterations;i++){
        res+=calculate_k(i);
    }
    clock_gettime(CLOCK_MONOTONIC,&end);
    time=end.tv_sec-start.tv_sec +1e-9*(end.tv_nsec-start.tv_nsec);
    output_benchmarking(time, iterations, res, 3);


    modbenchmark(iterations);

    return 0;
    }

//Test output function
void output(long long unsigned test) {
    printf("\nTest mit %llu\n", test);
    printf("Genauigkeit von Tabellenimplementierung: %.7f\n", birthday_num_tab(test, table));
    printf("Genauigkeit von Serienimplementierung: %.7f\n", birthday_num_series(test));
    printf("Genauigkeit von Assemblerimplementierung: %.7f\n", assembler_vergleich(test));
    printf("Genauigkeit von C Implementierung: %.7f\n", calculate_k(test));
    printf("Abweichung der Tabellenimplementierung zu C: %.7f%%\n", 100 - (birthday_num_tab(test, table) / calculate_k(test) * 100)); 
    printf("Abweichung der Serienimplementierung zu C: %.7f%%\n", 100 - (birthday_num_series(test) / calculate_k(test) * 100));
    printf("Abweichung der Assemblerreferenz zu C: %.7f%%\n\n", 100 - (assembler_vergleich(test) / calculate_k(test) * 100)); 
}

//Test function
 int test(void){

     //Test 1 2 
    long long unsigned test1 = 2; 
    output(test1);

    //Test 2 33 
    long long unsigned test2 = 33; 
    output(test2);

    //Test 3 73 
    long long unsigned test3 = 73; 
    output(test3);

    //Test 4 365 
    long long unsigned test4 = 365; 
    output(test4);

    //Test 5 737474
    long long unsigned test5 = 737474;
    output(test5);
    
    //Test 6 9898989
    long long unsigned test6 = 9898989;
    output(test6);
    
    //Test 7 9898242989
    long long unsigned test7 = 9898242989;
    output(test7);

    //Test 8 532578665767 
    long long unsigned test8 = 532578665767;
    output(test8);

    //Test 9 unsigned long max
    long long unsigned test9 = 0xffffffffffffffff;
    output(test9);

    return 0;

}

//user input scanner function
int get_user_input(void){

    char num[22]; //Used for User Input validation
    unsigned long long num2;
    char *ptr; //Needed for the strtoul function
    char *p; // Used for the Buffer Flush
    int i=0;
    
    printf("Geben Sie bitte Ihre Zahl in Dezimaldarstellung ein: \n");
    fgets(num,22,stdin); //fgets()-Used to prevent buffer overflow
    
    if(p=strchr(num,'\n')){ //Block to Flush the buffer in case the user
         *p=0;              //enters a string that is too large
                            //Logic based on setting of non-null pointers 
                            //evaluating to "true"
     }  
     else{
         scanf("%*[^\n]");// Scans up to the newline character and discards the input
         scanf("%*c");    //Scans the "\n" character and discards it 
     }
    
    char character='0';
    while(character!='\0'){  //Validating user input
    errno=0;              //Setting errno to zero to check whether strtoul can successfully convert the string to unsigned long,
    strtoul(num,&ptr,10);//used for inhibiting too large numbers
    if((isdigit(num[i])==0 && i<strlen(num)) || strlen(num)==0 || errno!=0){//Validating size of string                        
    printf("Sie haben kein legaler Wert eingegeben.\n");                    //if zero, then only the enter key was pressed
    printf("Geben Sie bitte erneut Ihre Zahl in Decimaldarstellung ein: \n");
    fgets(num,22,stdin);
    
    if(p=strchr(num,'\n')){ //Block to Flush the buffer in case the user
    *p=0;                   //enters an input that is too large
     }  
     else{
         scanf("%*[^\n]");
         scanf("%*c");    
     }

    //Resetting the values for subsequent checks
    i=0;
    character='0';
    }
    else {
        i++;
    character=num[i];
    }
    }
    
    //setting the string to an unsigned long
    num2=strtoul(num,&ptr,10);
    
    //if input is zero, the result is printed
    if(num2==0){
        printf("%s\n","Das Resultat von k ist: 1");
        return 0;
    }
    
    
    printf("\nDie kleinste Zahl k an Menschen, die in einem Raum notwendig sind,\n");
    printf("damit mind. 2 Personen mit mind. 50%% Wahrscheinlichkeit dasselbe\n");
    printf("Element von einer Menge M mit %llu Elementen haben, ist:\n\n",num2);
    
    float k = birthday_num_series(num2); //Outputting the result of k using the series implementation
    printf("Das Resultat von k, mit Hilfe der Serienimplementierung, ist: %f, also gerundet %.lf.\n\n", k, ceil(k));

    k = birthday_num_tab(num2, table);//Outputting the result of k using the table implementation
    printf("Das Resultat von k, mit Hilfe der Tabellenimplementierung, ist: %f, also gerundet %.lf.\n\n", k, ceil(k));

    k = calculate_k(num2);//Outputting the result of k using the standard C implementation
    printf("Das Resultat von k, mit Hilfe der Referenzimplementierung, ist: %f, also gerundet %.lf.\n\n", k, ceil(k));

    return 0;
    }

int main(int argc, char **argv){
    
    int opt;
    int iterations=0;

    while((opt=getopt(argc,argv,"sthb:"))!=-1){
        switch(opt){
            //Manual user input
            case 's':
            get_user_input();
            break;

            //Perform tests
            case 't':
            test();
            break;

            //Benchmarking with iteration number input
            case 'b':
            iterations=atoi(optarg);
            if(iterations<=0){
            benchmark(10000);
            }
            else 
            benchmark(iterations);
            break;


            //Help and info
            case 'h':
            printf("\nAllgemeine Informationen:\n");
            printf("Das Ziel des Programms ist dem Nutzer die Moeglichkeit zu geben\n");
            printf("die Assembly Implementierungen unseres Projekts manuell auszufuehren.\n\n");
            printf("Weitere Informationen:\n");
            printf("Das Programm soll so ausgefuehrt werden:\n");
            printf("./main -option Kommandozeilenargument\n");
            printf("\nOptionen:\n-s Option Kein_Argument: Eingabe von Nutzer\n");
            printf("-t Option Kein_Argument: Testen\n");
            printf("-b Option Anzahl_von_Iterationen: Benchmarking\n");
            printf("-h Option Kein_Argument: Hilfe\n\n");
            break;

            default:
            printf("Fuer Hilfe fuehren Sie das Programm so aus:\n");
            printf("./main -h\n\n");
            break;
        }
    }
    return 0;
}


    
