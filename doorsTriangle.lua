local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

local gameData = ReplicatedStorage:WaitForChild("GameData")
local latestRoom = gameData:WaitForChild("LatestRoom")

local multiplier = 0

function distanceFromCharacter(position)
    if typeof(position) == "Instance" then
        position = position:GetPivot().Position
    end

    local character = localPlayer.Character

    if character and character.PrimaryPart then
        return (localPlayer.Character.PrimaryPart.Position - position).Magnitude
    end

    return 9e9
end

function roomConnection(room)
    local currentDoor = room:WaitForChild("Door")

    repeat
        task.wait()
    until latestRoom.Value > tonumber(room.Name)

    currentDoor.ActivateEventPrompt:Destroy()
    currentDoor.Door.CanCollide = false
    currentDoor.Door.CanQuery = false
    currentDoor.Door.Transparency = 1
    for _, v in pairs(currentDoor.Model:GetChildren()) do
        if v.Name == "Hinge" then
            v.Transparency = 1
        else
            v:Destroy()
        end
    end

    if multiplier > 2 then
        multiplier = 0
    end

    local rotateOffset = CFrame.Angles(0, math.rad(120 * multiplier), 0)
    multiplier += 1
    repeat
        currentDoor.Door.CFrame = (localPlayer.Character.HumanoidRootPart.CFrame * rotateOffset) * CFrame.new(0, 0, 1.4)
        task.wait()
    until not currentDoor:IsDescendantOf(workspace) or not currentDoor.Door or not room:IsDescendantOf(workspace)
end

ReplicatedStorage.Entities.ScreechRetro:Destroy()

for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
    task.spawn(roomConnection, room)
end

workspace.CurrentRooms.ChildAdded:Connect(function(room)
    task.wait(0.1)
    roomConnection(room)
end)