-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Nút bật tắt farm
local ToggleFarm = Instance.new("TextButton")
ToggleFarm.Parent = ScreenGui
ToggleFarm.Size = UDim2.new(0, 200, 0, 50)
ToggleFarm.Position = UDim2.new(0, 10, 0, 10)
ToggleFarm.Text = "Bật Auto Farm"
ToggleFarm.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Nút chọn vũ khí
local WeaponDropdown = Instance.new("TextButton")
WeaponDropdown.Parent = ScreenGui
WeaponDropdown.Size = UDim2.new(0, 200, 0, 50)
WeaponDropdown.Position = UDim2.new(0, 10, 0, 70)
WeaponDropdown.Text = "Chọn vũ khí"
WeaponDropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 255)

-- Lấy tất cả vũ khí từ backpack
local function getWeaponsFromBackpack()
    local weapons = {}
    local backpack = game.Players.LocalPlayer.Backpack

    -- Lấy các vũ khí trong backpack
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(weapons, item.Name)
        end
    end
    return weapons
end

-- Hiển thị các vũ khí trong dropdown
local function updateWeaponDropdown()
    local weapons = getWeaponsFromBackpack()
    if #weapons == 0 then
        WeaponDropdown.Text = "Không có vũ khí"
    else
        local dropdown = Instance.new("Frame")
        dropdown.Size = UDim2.new(0, 200, 0, 150)
        dropdown.Position = UDim2.new(0, 10, 0, 130)
        dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.Parent = ScreenGui

        for i, weapon in ipairs(weapons) do
            local weaponButton = Instance.new("TextButton")
            weaponButton.Size = UDim2.new(0, 200, 0, 40)
            weaponButton.Position = UDim2.new(0, 0, 0, (i-1) * 45)
            weaponButton.Text = weapon
            weaponButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            weaponButton.Parent = dropdown

            weaponButton.MouseButton1Click:Connect(function()
                selectedWeapon = weapon
                WeaponDropdown.Text = "Vũ khí: " .. selectedWeapon
                dropdown:Destroy()
            end)
        end
    end
end

-- Cập nhật dropdown mỗi lần khởi tạo
updateWeaponDropdown()

-- Biến kiểm soát farm
getgenv().AutoFarm = false

-- Di chuyển đến vị trí mục tiêu
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
    local player = game.Players.LocalPlayer

    -- Tìm vũ khí trong backpack
    local weapon = player.Backpack:FindFirstChild(selectedWeapon)

    if weapon then
        -- Dùng vũ khí đã chọn (giả sử vũ khí có thể tấn công)
        weapon:Activate()
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

-- Bật/tắt Auto Farm khi nhấn nút
ToggleFarm.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    ToggleFarm.Text = getgenv().AutoFarm and "Tắt Auto Farm" or "Bật Auto Farm"
end)
