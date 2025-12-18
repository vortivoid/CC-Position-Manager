-- This program uses cardinal direction names,
-- However, it does not use the ACTUAL in-world cardinal directions.
-- It purely represents the directions in the simulated map in the program.
local Directions = {"north", "east", "south", "west"}
local Position = {
        x = 0,
        y = 0,
        z = 0,
        direction = 1,
}
local function GetPosition() return Position end
local function GetDirection() return Directions[Position.direction] end

local function SavePosition()
    local file = fs.open("position_data.json", "w")
    file.write(textutils.serializeJSON(Position))
    file.close()
end

local function LoadPosition()
    if fs.exists("position_data.json") then
        local file = fs.open("position_data.json", "r")
        Position = textutils.unserialiseJSON(file.readAll())
        file.close()
        return true
    else
        return false
    end
end

local function ClearPosition()
    if fs.exists("position_data.json") then
        fs.delete("position_data.json")
        Position = {
            x = 0,
            y = 0,
            z = 0,
            direction = 1,
        }
        return true
    else
        return false
    end
end

local function RotateRight()
    assert(turtle.turnRight())
    Position.direction = Position.direction + 1
    if Position.direction > 4 then Position.direction = 1 end
    SavePosition()
end

local function RotateLeft()
    assert(turtle.turnLeft())
    Position.direction = Position.direction - 1
    if Position.direction < 1 then Position.direction = 4 end
    SavePosition()
end

local function MoveForward()
    if turtle.detect() then
        print("Forward movement obstructed!")
        return
    end

    if turtle.getFuelLevel() == 0 then
        print("Out of fuel!")
        return
    end

    assert(turtle.forward())

    if Directions[Position.direction] == "north" then
        Position.x = Position.x + 1
    elseif Directions[Position.direction] == "east" then
        Position.z = Position.z + 1
    elseif Directions[Position.direction] == "south" then
        Position.x = Position.x - 1
    elseif Directions[Position.direction] == "west" then
        Position.z = Position.z - 1
    end
    SavePosition()
end

local function MoveUp()
    if turtle.detectUp() then
        print("Upward movement obstructed!")
        return
    end

    if turtle.getFuelLevel() == 0 then
        print("Out of fuel!")
        return
    end

    assert(turtle.up())
    Position.y = Position.y + 1
    SavePosition()
end

local function MoveDown()
    if turtle.detectDown() then
        print("Downward movement obstructed!")
        return
    end

    if turtle.getFuelLevel() == 0 then
        print("Out of fuel!")
        return
    end

    assert(turtle.down())
    Position.y = Position.y - 1
    SavePosition()
end

local function FaceDirection(direction)

    local function validInput()
        for k,v in ipairs(Directions) do
            if v == direction then return true end
        end
        return false
    end

    if validInput(string.lower(direction)) then
        while Directions[Position.direction] ~= direction do
            RotateRight()
        end
    end
end

local function GoToPosition(x, y, z, diggingEnabled)
    if diggingEnabled ~= true then diggingEnabled = false end
    while Position.y ~= y do
        if Position.y < y then
            if diggingEnabled then turtle.digUp() end
            MoveUp()
        elseif Position.y > y then
            if diggingEnabled then turtle.digDown() end
            MoveDown()
        end
    end

    while Position.x ~= x do
        if Position.x < x then
            FaceDirection("north")
        elseif Position.x > x then
            FaceDirection("south")
        end
        if diggingEnabled then turtle.dig() end
        MoveForward()
    end

    while Position.z ~= z do
        if Position.z < z then
            FaceDirection("east")
        elseif Position.z > z then
            FaceDirection("west")
        end
        if diggingEnabled then turtle.dig() end
        MoveForward()
    end
end

return {
    RotateRight = RotateRight,
    RotateLeft = RotateLeft,
    MoveForward = MoveForward,
    MoveUp = MoveUp,
    MoveDown = MoveDown,
    LoadPosition = LoadPosition,
    ClearPosition = ClearPosition,
    GetPosition = GetPosition,
    GetDirection = GetDirection,
    FaceDirection = FaceDirection,
    GoToPosition = GoToPosition
}
