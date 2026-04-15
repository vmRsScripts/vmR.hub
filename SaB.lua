local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "vmR Hub | Steal a Brainrot",
   LoadingTitle = "Loading vmR Hub...",
   LoadingSubtitle = "by vmR",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "vmR-saves",
      FileName = "MainConfig"
   }
})

local Player = game.Players.LocalPlayer
local speedEnabled = false
local speedValue = 16
local spinEnabled = false
local spinSpeed = 10
local isRecording = false
local recordedPath = {}
local isPlayingPath = false
local speedOnStealActive = false

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Movement Settings")

MainTab:CreateToggle({
   Name = "Speed Boost",
   CurrentValue = false,
   Callback = function(Value)
      speedEnabled = Value
   end
})

MainTab:CreateSlider({
   Name = "WalkSpeed Customization",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      speedValue = Value
   end
})

MainTab:CreateSection("Steal Mechanics")

MainTab:CreateToggle({
   Name = "Speed Boost On Steal",
   CurrentValue = false,
   Callback = function(Value)
      speedOnStealActive = Value
   end
})

MainTab:CreateButton({
   Name = "Reset Steal Speed",
   Callback = function()
      speedEnabled = true
      local char = Player.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = speedValue
      end
      Rayfield:Notify({
         Title = "Speed Reset",
         Content = "WalkSpeed has been reset to your slider value.",
         Duration = 2,
         Image = 4483362458
      })
   end
})

game:GetService("ProximityPromptService").PromptTriggered:Connect(function(prompt)
    if speedOnStealActive and (prompt.ActionText == "Steal" or prompt.ObjectText == "Brain") then
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            speedEnabled = false
            char.Humanoid.WalkSpeed = 60
            task.wait(1.5)
            speedEnabled = true
        end
    end
end)

local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateSection("Communication")

MiscTab:CreateButton({
   Name = "Taunt (/ez by vmR Hub)",
   Callback = function()
      local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
      if chatEvents then
          chatEvents.SayMessageRequest:FireServer("/ez by vmR Hub", "All")
      else
          local tcs = game:GetService("TextChatService")
          if tcs:FindFirstChild("TextChannels") and tcs.TextChannels:FindFirstChild("RBXGeneral") then
              tcs.TextChannels.RBXGeneral:SendAsync("/ez by vmR Hub")
          end
      end
   end
})

MiscTab:CreateSection("Character Effects")

MiscTab:CreateToggle({
   Name = "Local Spin Bot",
   CurrentValue = false,
   Callback = function(Value)
      spinEnabled = Value
   end
})

MiscTab:CreateSlider({
   Name = "Spin Speed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Velocity",
   CurrentValue = 10,
   Callback = function(Value)
      spinSpeed = Value
   end
})

local PathTab = Window:CreateTab("Path", 4483362458)

PathTab:CreateSection("Recording Tools")

PathTab:CreateToggle({
   Name = "Record Path",
   CurrentValue = false,
   Callback = function(Value)
      isRecording = Value
      if Value then
          recordedPath = {}
          task.spawn(function()
              while isRecording do
                  local char = Player.Character
                  if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.MoveDirection.Magnitude > 0 then
                      table.insert(recordedPath, char.HumanoidRootPart.Position)
                  end
                  task.wait(0.2)
              end
          end)
      end
   end
})

PathTab:CreateSection("Playback Tools")

PathTab:CreateButton({
   Name = "Play Path (Anti-Kick)",
   Callback = function()
      if #recordedPath == 0 or isPlayingPath then return end
      isPlayingPath = true
      
      task.spawn(function()
          for i = 1, #recordedPath do
              if not isPlayingPath then break end
              local char = Player.Character
              if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                  char.Humanoid:MoveTo(recordedPath[i])
                  local timeout = 0
                  repeat
                      task.wait(0.05)
                      timeout = timeout + 0.05
                      local dist = (char.HumanoidRootPart.Position - recordedPath[i]).Magnitude
                  until dist < 2 or timeout > 1 or not isPlayingPath
              end
          end
          isPlayingPath = false
      end)
   end
})

PathTab:CreateButton({
   Name = "Clear Path History",
   Callback = function()
      isPlayingPath = false
      recordedPath = {}
   end
})

game:GetService("RunService").Heartbeat:Connect(function()
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        if speedEnabled and not isPlayingPath then
            char.Humanoid.WalkSpeed = speedValue
        end
        if spinEnabled then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end)

Rayfield:LoadConfiguration()
