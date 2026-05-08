local isVisible = true
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        isVisible = not isVisible
        Window:SetVisible(isVisible)
    end
end)

local autoPop = false
local popThread = nil

local function PopBubble(bubbleId)
    pcall(function()
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remote then
            local server = remote:FindFirstChild("Server")
            if server then
                local popRemote = server:FindFirstChild("PopProgrammingBubble")
                if popRemote then
                    popRemote:FireServer(tostring(bubbleId))
                    return true
                end
            end
        end
        return false
    end)
end

local function FindAndPopAllBubbles()
    local popped = 0
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name and (obj.Name:lower():find("bubble") or obj.Name:lower():find("programming")) then
            local bubbleId = nil
            
            if obj:GetAttribute("Id") then
                bubbleId = obj:GetAttribute("Id")
            elseif obj:GetAttribute("BubbleId") then
                bubbleId = obj:GetAttribute("BubbleId")
            elseif obj:GetAttribute("QuestionId") then
                bubbleId = obj:GetAttribute("QuestionId")
            elseif obj:FindFirstChild("Id") and obj.Id:IsA("IntValue") then
                bubbleId = obj.Id.Value
            elseif obj:FindFirstChild("BubbleId") and obj.BubbleId:IsA("IntValue") then
                bubbleId = obj.BubbleId.Value
            end
            
            if bubbleId then
                if PopBubble(bubbleId) then
                    popped = popped + 1
                end
            else
                for i = 1, 10 do
                    if PopBubble(i) then
                        popped = popped + 1
                        task.wait(0.1)
                    end
                end
            end
        end
    end
    
    return popped
end

local function AutoPopLoop()
    while autoPop do
        local count = FindAndPopAllBubbles()
        if count > 0 then
            print("Patlatilan bubble sayisi: " .. count)
        end
        task.wait(1)
    end
end

local MainTab = Window:Tab({ Title = "BUBBLE", Icon = "solar:chat-bubbles-bold", Border = true })


local SettingsSection = MainTab:Section({ Title = "⚙️ SETTINGS", Opened = true })
SettingsSection:Toggle({
    Title = "AUTO POP BUBBLES",
    Desc = "Automatically pops programming bubbles",
    Icon = "solar:automatic-bold",
    Value = false,
    Callback = function(state)
        autoPop = state
        if autoPop then
            popThread = task.spawn(AutoPopLoop)
            WindUI:Notify({ Title = "Auto Pop", Content = "STARTED", Duration = 2 })
        else
            if popThread then
                task.cancel(popThread)
                popThread = nil
            end
            WindUI:Notify({ Title = "Auto Pop", Content = "STOPPED", Duration = 2 })
        end
    end
})


local ActionsSection = MainTab:Section({ Title = "🎮 ACTIONS", Opened = true })
ActionsSection:Button({
    Title = "POP NOW",
    Desc = "Pop all bubbles once",
    Icon = "solar:chat-bubbles-bold",
    Color = Color3.fromRGB(52, 199, 89),
    Justify = "Center",
    Callback = function()
        local count = FindAndPopAllBubbles()
        WindUI:Notify({ Title = "Popped", Content = count .. " bubbles", Duration = 2 })
    end
})


local InfoSection = MainTab:Section({ Title = "📌 INFO", Opened = true })
InfoSection:Label({ Title = "Removes programming bubbles" })
InfoSection:Label({ Title = "Uses PopProgrammingBubble remote" })

local InfoTab = Window:Tab({ Title = "INFO", Icon = "solar:info-square-bold", Border = true })
local InfoTabSection = InfoTab:Section({ Title = "ABOUT", Opened = true })
InfoTabSection:Label({ Title = "Bubble Popper" })
InfoTabSection:Label({ Title = "Right Shift to toggle GUI" })

InfoTab:Space()
InfoTab:Button({
    Title = "DESTROY GUI",
    Color = Color3.fromRGB(239, 79, 29),
    Justify = "Center",
    Callback = function()
        autoPop = false
        if popThread then task.cancel(popThread) end
        Window:Destroy()
    end
})

WindUI:Notify({ Title = "Bubble Popper", Content = "Ready | Right Shift to toggle", Duration = 3 })
