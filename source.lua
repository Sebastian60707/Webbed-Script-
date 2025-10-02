-- TestInjector (LocalScript) - SOLO para DEV / testing
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local DEV_USERID = 12345678 -- reemplaza por tu UserId
if player.UserId ~= DEV_USERID then return end

local function safeGetHRP()
    if not player.Character then return nil end
    return player.Character:FindFirstChild("HumanoidRootPart")
end

-- 1) Inyectar BodyVelocity (simula boost / vuelo)
local function injectBodyVelocity(duration, velocity)
    local hrp = safeGetHRP()
    if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "TEST_BodyVelocity"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = velocity or Vector3.new(0, 100, 0)
    bv.P = 1250
    bv.Parent = hrp
    delay(duration or 1, function()
        if bv and bv.Parent then pcall(function() bv:Destroy() end) end
    end)
end

-- 2) Teleport instantáneo (simula hop grande)
local function instantTeleport(offset)
    local hrp = safeGetHRP()
    if not hrp then return end
    hrp.CFrame = hrp.CFrame + (offset or Vector3.new(0, 500, 0))
end

-- 3) Aplicar VectorForce en character (simula exploits modernos)
local function injectVectorForce(duration, force)
    local hrp = safeGetHRP()
    if not hrp then return end
    local vf = Instance.new("VectorForce")
    vf.Name = "TEST_VectorForce"
    vf.Attachment0 = Instance.new("Attachment", hrp)
    vf.Force = force or Vector3.new(0, 20000, 0)
    vf.RelativeTo = Enum.ActuatorRelativeTo.World
    vf.Parent = hrp
    delay(duration or 1, function()
        if vf and vf.Parent then pcall(function() vf:Destroy() end) end
    end)
end

-- Mapa de teclas para pruebas
-- B = BodyVelocity short burst
-- N = BodyVelocity long burst
-- T = Teleport grande
-- V = VectorForce burst
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.B then
        injectBodyVelocity(0.6, Vector3.new(0,200,0))
        print("[TestInjector] injected short BodyVelocity")
    elseif input.KeyCode == Enum.KeyCode.N then
        injectBodyVelocity(2, Vector3.new(0,300,0))
        print("[TestInjector] injected long BodyVelocity")
    elseif input.KeyCode == Enum.KeyCode.T then
        instantTeleport(Vector3.new(0, 1000, 0))
        print("[TestInjector] instant teleport applied")
    elseif input.KeyCode == Enum.KeyCode.V then
        injectVectorForce(1.2, Vector3.new(0,40000,0))
        print("[TestInjector] injected VectorForce")
    end
end)
