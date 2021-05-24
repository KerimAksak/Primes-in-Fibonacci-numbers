# 80-86 - Primes in Fibonacci numbers

**NOTE:** 
<br>
**1- Only 2 and 3 of the multiplication rules were completed. The rest will be added.**
<br>
**2- The transactions will be brought to the 32bit level.**

## **PROJECT PURPOSE:** An 8086 assembly will be implemented that lists all Fibonacci numbers that are prime numbers up to a positive integer entered in the 8086 architecture using EMU8086.


### 1- First of all, the number entry query will be displayed on the screen as shown below.

<br>

![img1](https://raw.githubusercontent.com/KerimAksak/80-86/main/img/img1.jpg?token=AMFVIYLUHID3RTHCUUFCJ63AVNU2Q)

<br>

### 2- User will enter an integer value up to the maximum number value as given below and press "Enter". It should be foreseen that the user may make wrong entries and in this case, an error message should be given and the user should be informed.

<br>

![img2](https://raw.githubusercontent.com/KerimAksak/80-86/main/img/img2.jpg?token=AMFVIYJ3UVXHG3SX3GC6LQDAVNU3Q)

### 3- The program will use the divisibility rules summarized in Table 1 to check whether the Fibonacci numbers from F (0) = 1 to the entered number are prime.

<br>

| Number | Rule |
| --- | --- |
| 1 | Each number is divided. |
| 2 | Divide if the last digit is an even number. If an integer is not divided by 2, the remainder will always be 1.  |
| 3 | The sum of the values of the numbers is divided by 3 and the multiples of three. |
| 4 | If the ones and tens digit of a number is 00 or a multiple of 4, the number is divided by 4.  |
| 5 | If the last digit is 0 or 5, it is divided by 5. |
| 7 | Starting from the units digit (from right to left) under the digits of the number, a b c d e f 2 3 1 2 3 1 - + should be written in the order (1 3 2 1 3 2 ...) and the following calculation should be made: (1.f + 3.e + 2.d ) - (1.c + 3.b + 2.a) = 7.k + m (k, n: integer) if the result is 7 or a multiple of 7 (m = 0), this number is divided by 7 exactly . Also, when this number is written as 10a + b, if the number a-2b is divided by 7, the prime number can be divided by 7. |
| 11 | In order to divide a number exactly by 11, the signs of +, -, +, -, ... are written under the units of the number, starting with the units digit, the positive groups are added between themselves and the negative groups are added together, the difference is taken. If the remainder of the grand total by 11 division is 0, the number is divided by 11 exactly. If the result is negative, +11 is added to the result. |
| 17 | When we write the number as X = 10a + b, it is formed by dividing the number a-5b by 17 without a remainder. |
| 19 | When we write the number as X = 10a + b, it can be divided if the number a + 2b is divided by 19 without a remainder. |
| 23 | When we write the number as X = 10a + b, it can be divided if the number a + 7b is divided by 23 without a remainder.  |

<br>

**If a result cannot be obtained as a result of the rules, the classical prime number calculation method should be used.**

<br>

![img3](https://raw.githubusercontent.com/KerimAksak/80-86/main/img/img3.jpg?token=AMFVIYJXG756PMZYS7TZLR3AVNU4G)