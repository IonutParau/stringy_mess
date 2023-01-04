# Stringy Mess

A fan-made Game of Strings remake.

## Differences from Game of Strings

### Cell States

Cells have a "states" variable that is the amount of phases to go through.
0 means always dead, 1 means alive and dead, and 2 means alive, dying, dead.
You can have as many as you want!

### Fading Interpolation

Cells fade from alive to dead to play nicely with states.
