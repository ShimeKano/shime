-- Tạo GUI và các nút như trước
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local ToggleFarm = Instance.new("TextButton")
ToggleFarm.Parent = ScreenGui
ToggleFarm.Size = UDim2.new(0, 200, 0, 50)
ToggleFarm.Position = UDim2.new(0, 10, 0, 10)
ToggleFarm.Text = "Bật Auto Farm"
ToggleFarm.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Tạo ComboBox chọn vũ khí
local WeaponDropdown = Instance.new("TextButton")
WeaponDropdown.Parent = ScreenGui
WeaponDropdown.Size = UDim2.new(0, 200, 0, 50)
WeaponDropdown.Position = UDim2.new(0, 10, 0, 70)
WeaponDropdown.Text = "Chọn vũ khí"
WeaponDropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 255)

-- Các vũ khí có sẵn
local weapons = {"Melee", "Kiếm", "Súng"}
local selectedWeapon = "Melee" -- Mặc định là Melee

-- Tạo danh sách vũ khí khi nhấn vào ComboBox
WeaponDropdown.MouseButton1Click:Connect(function()
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0, 200, 0, 150)
    dropdown.Position = UDim2.new(0, 10, 0, 130)
    dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.Parent = ScreenGui

    -- Tạo các nút lựa chọn cho từng vũ khí
    for i, weapon in ipairs(weapons) do
        local weaponButton = Instance.new("TextButton")
        weaponButton.Size = UDim2.new(0, 200, 0, 40)
        weaponButton.Position = UDim2.new(0, 0, 0, (i-1) * 45)
        weaponButton.Text = weapon
        weaponButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        weaponButton.Parent = dropdown

        -- Lựa chọn vũ khí khi click
        weaponButton.MouseButton1Click:Connect(function()
            selectedWeapon = weapon
            WeaponDropdown.Text = "Vũ khí: " .. selectedWeapon
            dropdown:Destroy() -- Đóng dropdown sau khi chọn
        end)
    end
end)

-- Biến kiểm soát farm
getgenv().AutoFarm = false

-- Hàm di chuyển
function toPosition(pos)
    local ply = game.Players.LocalPlayer
    if ply.Character then
        ply.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- Tìm mob gần nhất
function getClosestMob()
    local closestMob = nil
    local shortestDistance = math.huge
    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local dist = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestMob = v
            end
        end
    end
    return closestMob
end

-- Auto click function (dựa trên vũ khí đã chọn)
function attack()
    local vim = game:GetService("VirtualUser")
    if selectedWeapon == "Melee" then
        vim:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(0.1)
        vim:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    elseif selectedWeapon == "Kiếm" then
        -- Bạn có thể thêm code cho việc sử dụng kiếm nếu cần
        vim:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(0.1)
        vim:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    elseif selectedWeapon == "Súng" then
        -- Bạn có thể thêm code cho việc sử dụng súng nếu cần
        vim:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(0.1)
        vim:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end

-- Vòng lặp farm
spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().AutoFarm then
            local mob = getClosestMob()
            if mob and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    -- Đưa nhân vật tới gần mob
                    toPosition(mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                    attack()
                end)
            end
        end
    end)
end)

-- Sự kiện bật/tắt farm
ToggleFarm.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    ToggleFarm.Text = getgenv().AutoFarm and "Tắt Auto Farm" or "Bật Auto Farm"
end)
