# CC-Position-Manager
A Lua module that provides a movement and position-tracking API for CC:Tweaked turtles

# Setup
Getting this running is as simple as adding positionManager.lua to a computer and then adding `foo = require("positionManager")` to the top of any script you want to use the module. ("foo" can be replaced with whatever you want the variable to be called. This variable will be used to access the movement methods through the script.)

# Useage
To call the methods in this module, you simply call the variable you created in the setup followed by a . and the method. For example `foo.MoveForward()`.
You should avoid manually calling the built-in turtle movement methods such as `turtle.forward()` as these will NOT update the stored position in positionManager, which will almost certainly cause issues.

# Methods
- `RotateRight()`
- `RotateLeft()`  
Rotate the turtle similarly to calling `turtle.turnLeft()` and `turtle.turnRight()`, however it also updates the saved positional data so it remembers which way it's facing.
---
- `MoveForward()`
- `MoveUp()`
- `MoveDown()`  
Move the turtle similarly to calling `turtle.forward()`, `turtle.up()`, and `turtle.down()`. However these will update the saved positional data and detect failed movements.
---
- `LoadPosition()`  
This will update the position in memory with data stored in `position_data.json`, (which is automatically created when the module is run, and automatically updated with every movement/rotation using the module's methods) In most cases this is best to run once at the beginning of your program.
---
- `ClearPosition()`  
This will delete `position_data.json` and reset the position in memory to {x=0,y=0,z=0,direction=1} (direction=1 is reffered to as "north" when calling `GetDirection()`)
---
- `GetPosition()`  
Returns a table with the stored positional data with entries for for x, y, z, and direction.  
[NOTE: These values are not alligned with the Minecraft world's actual XYZ coordinates! They represent the turtle's position from the program's origin point (or the last time `ClearPosition()` was called).]
---
- `GetDirection()`  
Returns the stored direction as a String containing a cardinal direction rather than a number. This is purely for easier readability in functions.  
(1 = north, 2 = east, 3 = south, 4 = west)  
[NOTE: These values are not alligned with the Minecraft world's actual cardinal directions! They represent the turtle's rotation from the program's starting rotation (or the last time `ClearPosition()` was called).]
---
- `FaceDirection(direction)`  
Rotates the turtle to face the direction provided. This uses the cardinal direction names rather than the internal integer.  
**Example: `FaceDirection("south")`**
---
- `GoToPosition(x, y, z, diggingEnabled)` 
Moves the turtle to the provided coordinates based on it's internal positional data. `diggingEnabled` can be passed as either `true` or `false` depending on whether or not the turtle should break blocks in it's way to reach it's destination.  
**Example: `GoToPosition(10, 5, 8, true)`**
