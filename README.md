# CalculatorTheGame-Solver
An AI solver for 'Calculator The Game'

a solver for game 'Calculator The Game'

https://itunes.apple.com/us/app/calculator-the-game/id1243055750?mt=8
<br>https://play.google.com/store/apps/details?id=com.sm.calculateme

Matlab code.

Usage:
```
>> solver [move] [target] [initial value] [operations]+
```

Output:
<br>a list of operations
<br>('Store2MEM' means storing current result to 'Store')
<br>('Store' means use stored value as append)

operations (key shortcut, N/A/B can be any number):
<br>1:+/-: c
<br>2:<<: l
<br>3:A=>B: AbB (8=>9 as 8b9)
<br>4:+N: aN (+8 as a8) 
<br>5:-N: mN (-8 as m8) 
<br>6:(append)N: N (no shortcut)
<br>7:xN: xN or tN (x8 as t8)
<br>8:/N: dN (/8 as d8) 
<br>9:Reverse: r
<br>10:Inv10: i
<br>11:Sum: s
<br>12:x^N: pN (x^3 as p3)
<br>13:<Shift: z
<br>14:Shift>: x
<br>15:Mirror: m
<br>16:[+]N: cN ([+]2 as c2)
<br>17:Store: g
<br>18:Portal: ApB (from location A to location B, e.g. _ _ ^ _ _ \/ as 4p1, count from 1 and from right to left)

negative number can be typed as -N or mN, e.g. number '-3' can be 'm3', operation 'x-3' can be 'xm3'
