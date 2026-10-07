--[[ Protected by Lua Guard ]]

( function (...) local _IlllIIlIII = {} local _lIIllIIIII = nil local Players = game:GetService("\080\108\097\121\101\114\115") local RunService = game:GetService("\082\117\110\083\101\114\118\105\099\101") local _lIIIIlIllI = game:GetService("\087\111\114\107\115\112\097\099\101") local _IlIIlIIIII = Players.LocalPlayer function _IlllIIlIII.startAntiAFK() task.spawn( function () local _IIlllIllll = game:GetService("\086\105\114\116\117\097\108\085\115\101\114") local _lIIIIIIlIl = game:GetService("\086\105\114\116\117\097\108\085\115\101\114") _IlIIlIIIII.Idled:Connect( function () if _lIIllIIIII.AntiAFK_Enabled == false then return end
 pcall( function () _lIIIIIIlIl:CaptureController() _lIIIIIIlIl:ClickButton2(Vector2.new()) end
 ) print("\091\065\078\084\073\045\065\070\075\093\032\073\100\108\101\032\116\101\114\100\101\116\101\107\115\105\032\8212\032\097\099\116\105\118\105\116\121\032\100\105\107\105\114\105\109") end
 ) while task.wait(0x3C) do if _lIIllIIIII.AntiAFK_Enabled == false then continue end
 pcall( function () _lIIIIIIlIl:CaptureController() _lIIIIIIlIl:ClickButton2(Vector2.new()) end
 ) pcall( function () mousemoverel(0x1, 0x0) task.wait(0.05) mousemoverel(-0x1, 0x0) end
 ) end
 end
 ) end
 local function _llllIlllIl(_IIlllllIIl) for _, c in ipairs(_IIlllllIIl:GetChildren()) do if c:IsA("\066\111\100\121\086\101\108\111\099\105\116\121") or c:IsA("\066\111\100\121\080\111\115\105\116\105\111\110") or c:IsA("\066\111\100\121\071\121\114\111") or c:IsA("\076\105\110\101\097\114\086\101\108\111\099\105\116\121") then c:Destroy() end
 end
 end
 local function _lllIlllIll(_IllIllIIIl, _lIlIlllIll, _lllllIIllI) local _IllIllllII = _IlIIlIIIII.Character local _IlIlIIlIIl = _IllIllllII and _IllIllllII:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IlIlIIlIIl or not _lllllIIllI then return false end
 print("\091\070\076\089\093\032\55357\57067\032\078\097\105\107\032\051\053\048\032\115\116\117\100\115") _llllIlllIl(_IlIlIIlIIl) local _IIIIIIlIlI = Instance.new("\066\111\100\121\086\101\108\111\099\105\116\121") _IIIIIIlIlI.Name = "\086\114\105\108\122\095\070\108\121\085\112" _IIIIIIlIlI.MaxForce = Vector3.new(0x0, 1e5, 0x0) _IIIIIIlIlI.Velocity = Vector3.new(0x0, 0x1F4, 0x0) _IIIIIIlIlI.Parent = _IlIlIIlIIl local _lllllllIII = _IlIlIIlIIl.Position.Y + 0x15E local _llIIIIlIII = tick() while _IlIlIIlIIl.Parent and _IlIlIIlIIl.Position.Y < _lllllllIII and (tick() - _llIIIIlIII) < 0x5 do task.wait(0.03) end
 _IIIIIIlIlI:Destroy() print("\091\070\076\089\093\032\9889\032\084\080\032\107\101\032\101\103\103\032\100\097\114\105\032\089\058", math.floor(_IlIlIIlIIl.Position.Y)) _IlIlIIlIIl = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IlIlIIlIIl then return false end
 _IlIlIIlIIl.CFrame = CFrame.new(_lllllIIllI.Position + Vector3.new(0x0, 0x3, 0x0)) _IlIlIIlIIl.Velocity = Vector3.zero _IlIlIIlIIl.AssemblyLinearVelocity = Vector3.zero task.wait(0.15) for i = 0x1, 0xF do if typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 task.wait(0.15) if not _IllIllIIIl.Parent then return true end
 if _lllllIIllI and _lllllIIllI.Parent then _IlIlIIlIIl.CFrame = CFrame.new(_lllllIIllI.Position + Vector3.new(0x0, 0x3, 0x0)) end
 end
 return not _IllIllIIIl.Parent end
 local function _lIllllIlIl(_IllIllIIIl) local _IIIIlIllll = _IllIllIIIl:FindFirstChild("\069\103\103\076\117\099\107", true) if _IIIIlIllll then local _llIIlIIlll = _IIIIlIllll:FindFirstChild("\076\117\099\107") if _llIIlIIlll and _llIIlIIlll:IsA("\084\101\120\116\076\097\098\101\108") then return _llIIlIIlll.Text end
 end
 return "\063" end
 local _llIlllIIll = {} function _IlllIIlIII.startEggESP() task.spawn( function () while task.wait(0.3) do if _lIIllIIIII.ESP_Eggs_Enabled then local _IIllIIIlll = _lIIIIlIllI:FindFirstChild("\082\101\110\100\101\114\101\100\069\103\103\115") if _IIllIIIlll then for _, _IllIllIIIl in ipairs(_IIllIIIlll:GetChildren()) do if _IllIllIIIl:IsA("\077\111\100\101\108") and not _llIlllIIll[_IllIllIIIl] then local _lllllIIllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) if _lllllIIllI then local _IIlIllIIlI = Instance.new("\072\105\103\104\108\105\103\104\116") _IIlIllIIlI.Name = "\086\082\073\076\090\095\082\105\100\101\065\080\101\116\095\069\103\103\072\076" _IIlIllIIlI.FillColor = Color3.fromRGB(0xFF, 0xD7, 0x0) _IIlIllIIlI.OutlineColor = Color3.new(0x1, 0x1, 0x1) _IIlIllIIlI.FillTransparency = 0.5 _IIlIllIIlI.Adornee = _IllIllIIIl _IIlIllIIlI.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop _IIlIllIIlI.Parent = _IllIllIIIl local _lIIIIlIIll = Instance.new("\066\105\108\108\098\111\097\114\100\071\117\105") _lIIIIlIIll.Name = "\086\082\073\076\090\095\082\105\100\101\065\080\101\116\095\069\103\103\069\083\080" _lIIIIlIIll.Size = UDim2.fromOffset(0xC8, 0x16) _lIIIIlIIll.StudsOffset = Vector3.new(0x0, 2.5, 0x0) _lIIIIlIIll.AlwaysOnTop = true _lIIIIlIIll.MaxDistance = 0x1F4 _lIIIIlIIll.Adornee = _lllllIIllI _lIIIIlIIll.Parent = _lllllIIllI local _lIllIIlIll = Instance.new("\084\101\120\116\076\097\098\101\108") _lIllIIlIll.Name = "\073\110\102\111\076\097\098\101\108" _lIllIIlIll.Size = UDim2.fromScale(0x1, 0x1) _lIllIIlIll.BackgroundTransparency = 0x1 _lIllIIlIll.TextColor3 = Color3.fromRGB(0xFF, 0xD7, 0x0) _lIllIIlIll.TextStrokeColor3 = Color3.new(0x0, 0x0, 0x0) _lIllIIlIll.TextStrokeTransparency = 0.2 _lIllIIlIll.Font = Enum.Font.GothamBold _lIllIIlIll.TextSize = 0xE _lIllIIlIll.TextWrapped = false _lIllIIlIll.Text = "" _lIllIIlIll.Parent = _lIIIIlIIll _llIlllIIll[_IllIllIIIl] = {_IIlIllIIlI = _IIlIllIIlI, _lIIIIlIIll = _lIIIIlIIll, _lIllIIlIll = _lIllIIlIll, _IIIlIllllI = _lllllIIllI} end
 end
 end
 end
 else for _IllIllIIIl, _IlllllIllI in pairs(_llIlllIIll) do if _IlllllIllI.hl then _IlllllIllI.hl:Destroy() end
 if _IlllllIllI.bb then _IlllllIllI.bb:Destroy() end
 _llIlllIIll[_IllIllIIIl] = nil end
 end
 for _IllIllIIIl, _IlllllIllI in pairs(_llIlllIIll) do if not _IllIllIIIl.Parent then if _IlllllIllI.hl then _IlllllIllI.hl:Destroy() end
 if _IlllllIllI.bb then _IlllllIllI.bb:Destroy() end
 _llIlllIIll[_IllIllIIIl] = nil elseif _IlllllIllI.lbl then local _IlIIIlIIlI = {} if _lIIllIIIII.ESP_EggName_Enabled then table.insert(_IlIIIlIIlI, "\55358\56666\032" .. _IllIllIIIl.Name) end
 if _lIIllIIIII.ESP_EggLuck_Enabled then table.insert(_IlIIIlIIlI, "\55356\57152\032" .. _lIllllIlIl(_IllIllIIIl)) end
 _IlllllIllI.lbl.Text = "\091\032" .. table.concat(_IlIIIlIIlI, "\032\032") .. "\032\093" end
 end
 end
 end
 ) end
 local _IlIllIllIl = {} local function _IIIllIlIlI(pet) local _lIIIIlllII, speed = "\063", "\063" local _lIllllllll = pet:FindFirstChild("\080\101\116\067\097\115\104", true) if _lIllllllll then for _, desc in ipairs(_lIllllllll:GetDescendants()) do if desc:IsA("\084\101\120\116\076\097\098\101\108") and desc.Text:find("\037\036") and desc.Text:find("\047\115") then _lIIIIlllII = desc.Text break end
 end
 end
 local _IllIllIlIl = pet:FindFirstChild("\080\101\116\083\112\101\101\100", true) if _IllIllIlIl then for _, desc in ipairs(_IllIllIlIl:GetDescendants()) do if desc:IsA("\084\101\120\116\076\097\098\101\108") and desc.Text ~= "" then speed = desc.Text break end
 end
 end
 return _lIIIIlllII, speed end
 function _IlllIIlIII.startPetESP() task.spawn( function () while task.wait(0.3) do if _lIIllIIIII.ESP_Pets_Enabled then local _llllIIIllI = _lIIIIlIllI:FindFirstChild("\080\108\111\116\115") if _llllIIIllI then for _, _IlIllIIlII in ipairs(_llllIIIllI:GetChildren()) do local _IIlIIIlIlI = _IlIllIIlII:FindFirstChild("\080\101\116\115") if _IIlIIIlIlI then for _, pet in ipairs(_IIlIIIlIlI:GetChildren()) do if pet:IsA("\077\111\100\101\108") and not _IlIllIllIl[pet] then local _llIIIlIIll = pet:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) if _llIIIlIIll then local _IIlIllIIlI = Instance.new("\072\105\103\104\108\105\103\104\116") _IIlIllIIlI.Name = "\086\082\073\076\090\095\082\105\100\101\065\080\101\116\095\080\101\116\072\076" _IIlIllIIlI.FillColor = Color3.fromRGB(0x64, 0xC8, 0xFF) _IIlIllIIlI.OutlineColor = Color3.new(0x1, 0x1, 0x1) _IIlIllIIlI.FillTransparency = 0.5 _IIlIllIIlI.Adornee = pet _IIlIllIIlI.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop _IIlIllIIlI.Parent = pet local _lIIIIlIIll = Instance.new("\066\105\108\108\098\111\097\114\100\071\117\105") _lIIIIlIIll.Name = "\086\082\073\076\090\095\082\105\100\101\065\080\101\116\095\080\101\116\069\083\080" _lIIIIlIIll.Size = UDim2.fromOffset(0xDC, 0x16) _lIIIIlIIll.StudsOffset = Vector3.new(0x0, 0x3, 0x0) _lIIIIlIIll.AlwaysOnTop = true _lIIIIlIIll.MaxDistance = 0x1F4 _lIIIIlIIll.Adornee = _llIIIlIIll _lIIIIlIIll.Parent = _llIIIlIIll local _lIllIIlIll = Instance.new("\084\101\120\116\076\097\098\101\108") _lIllIIlIll.Name = "\073\110\102\111\076\097\098\101\108" _lIllIIlIll.Size = UDim2.fromScale(0x1, 0x1) _lIllIIlIll.BackgroundTransparency = 0x1 _lIllIIlIll.TextColor3 = Color3.fromRGB(0x64, 0xC8, 0xFF) _lIllIIlIll.TextStrokeColor3 = Color3.new(0x0, 0x0, 0x0) _lIllIIlIll.TextStrokeTransparency = 0.2 _lIllIIlIll.Font = Enum.Font.GothamBold _lIllIIlIll.TextSize = 0xE _lIllIIlIll.TextWrapped = false _lIllIIlIll.Text = "" _lIllIIlIll.Parent = _lIIIIlIIll _IlIllIllIl[pet] = {_IIlIllIIlI = _IIlIllIIlI, _lIIIIlIIll = _lIIIIlIIll, _lIllIIlIll = _lIllIIlIll, _IIIlIllllI = _llIIIlIIll} end
 end
 end
 end
 end
 end
 else for pet, _IlllllIllI in pairs(_IlIllIllIl) do if _IlllllIllI.hl then _IlllllIllI.hl:Destroy() end
 if _IlllllIllI.bb then _IlllllIllI.bb:Destroy() end
 _IlIllIllIl[pet] = nil end
 end
 for pet, _IlllllIllI in pairs(_IlIllIllIl) do if not pet.Parent then if _IlllllIllI.hl then _IlllllIllI.hl:Destroy() end
 if _IlllllIllI.bb then _IlllllIllI.bb:Destroy() end
 _IlIllIllIl[pet] = nil elseif _IlllllIllI.lbl then local _lIIIIlllII, speed = _IIIllIlIlI(pet) local _IlIIIlIIlI = {} if _lIIllIIIII.ESP_PetName_Enabled then table.insert(_IlIIIlIIlI, "\55357\56382\032" .. pet.Name) end
 if _lIIllIIIII.ESP_PetCash_Enabled then table.insert(_IlIIIlIIlI, "\55357\56496\032" .. _lIIIIlllII) end
 if _lIIllIIIII.ESP_PetSpeed_Enabled then table.insert(_IlIIIlIIlI, "\9889\032" .. speed) end
 _IlllllIllI.lbl.Text = "\091\032" .. table.concat(_IlIIIlIIlI, "\032\032") .. "\032\093" end
 end
 end
 end
 ) end
 local function _lllllllIll() local _llllIIIllI = _lIIIIlIllI:FindFirstChild("\080\108\111\116\115") if not _llllIIIllI then return nil end
 for _, _IlIllIIlII in ipairs(_llllIIIllI:GetChildren()) do local owner = _IlIllIIlII:GetAttribute("\079\119\110\101\114\085\115\101\114\073\100") or _IlIllIIlII:GetAttribute("\079\119\110\101\114") or _IlIllIIlII:GetAttribute("\078\101\115\116\115\079\119\110\101\114\076\111\097\100\101\100") if owner == _IlIIlIIIII.UserId or owner == _IlIIlIIIII.Name then return _IlIllIIlII end
 local _IlllllIllI = _IlIllIIlII:FindFirstChild("\068\097\116\097") if _IlllllIllI then local _IIlIIllIlI = _IlllllIllI:FindFirstChild("\079\119\110\101\114") if _IIlIIllIlI and _IIlIIllIlI:IsA("\079\098\106\101\099\116\086\097\108\117\101") and _IIlIIllIlI.Value == _IlIIlIIIII then return _IlIllIIlII end
 end
 end
 return nil end
 local function _IlIIIlllIl() local _IlIllIIlII = _lllllllIll() if not _IlIllIIlII then return nil end
 local _lIllIlIIII = _IlIllIIlII:FindFirstChild("\083\112\097\119\110", true) or _IlIllIIlII:FindFirstChildWhichIsA("\083\112\097\119\110\076\111\099\097\116\105\111\110", true) or _IlIllIIlII:FindFirstChild("\066\097\115\101\112\108\097\116\101", true) or _IlIllIIlII:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) return _lIllIlIIII end
 local function _llIIIlIIlI(_lIlllIlIIl) local _IIllIIIlll = _lIIIIlIllI:FindFirstChild("\082\101\110\100\101\114\101\100\069\103\103\115") if not _IIllIIIlll then return nil end
 local _IlllIIlIll = _lIlllIlIIl:lower() local _IlIlIllIIl, bestDist = nil, math.huge local _IlIlIIlIIl = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IlIlIIlIIl then return nil end
 for _, _IllIllIIIl in ipairs(_IIllIIIlll:GetChildren()) do if _IllIllIIIl:IsA("\077\111\100\101\108") then local _lIllIIllll = _IllIllIIIl.Name:lower() if _lIllIIllll == _IlllIIlIll or _lIllIIllll:find(_IlllIIlIll, 0x1, true) then local _lllllIIllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) if _lllllIIllI then local _lIlIlIIlII = (_lllllIIllI.Position - _IlIlIIlIIl.Position).Magnitude if _lIlIlIIlII < bestDist then _IlIlIllIIl, bestDist = _IllIllIIIl, _lIlIlIIlII end
 end
 end
 end
 end
 return _IlIlIllIIl end
 local function _IlIlllIlIl(_IllIllIIIl) if not _IllIllIIIl or not _IllIllIIIl.Parent then return false end
 return true end
 local _IIIIllIIIl = 0x0 function _IlllIIlIII.startAutoSteal() task.spawn( function () while task.wait(0.5) do if not _lIIllIIIII.AutoSteal_Enabled then continue end
 local _IllIllllII = _IlIIlIIIII.Character local _IlIlIIlIIl = _IllIllllII and _IllIllllII:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") local _lIllIIIIII = _IllIllllII and _IllIllllII:FindFirstChildOfClass("\072\117\109\097\110\111\105\100") if not _IlIlIIlIIl or not _lIllIIIIII or _lIllIIIIII.Health <= 0x0 then task.wait(0x1) continue end
 local _lIlllIlIIl = _lIIllIIIII.SelectedEgg or "\067\104\101\114\117\098" local _IllIllIIIl = _llIIIlIIlI(_lIlllIlIIl) if not _IllIllIIIl then local _lllIlIlIII = os.clock() if _lllIlIlIII - _IIIIllIIIl > 0x5 then _IIIIllIIIl = _lllIlIlIII if _lIIllIIIII.Notify then _lIIllIIIII.Notify("\069\103\103\032\110\111\032\115\112\097\119\110\058\032" .. _lIlllIlIIl, "\119\097\114\110\105\110\103") end
 end
 continue end
 local _lllllIIllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) local _lIlIlllIll = _IllIllIIIl:FindFirstChild("\080\105\099\107\117\112", true) if not _lllllIIllI or not _lIlIlllIll then continue end
 if _lIlIlllIll:IsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116") then _lIlIlllIll.HoldDuration = 0x0 end
 _IlIlIIlIIl.CFrame = _lllllIIllI.CFrame + Vector3.new(0x0, 0x3, 0x0) task.wait(0.1) local _IllIlllIll = false local _llIIIIIIll = 0xA for i = 0x1, _llIIIIIIll do if typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 task.wait(0.3) if not _IlIlllIlIl(_IllIllIIIl) then _IllIlllIll = true break end
 if _lllllIIllI and _lllllIIllI.Parent then _IlIlIIlIIl.CFrame = _lllllIIllI.CFrame + Vector3.new(0x0, 0x3, 0x0) task.wait(0.1) end
 end
 if _IllIlllIll and _lIIllIIIII.AutoReturn_Enabled then _IlIlIlIllI() end
 task.wait(0.3) end
 end
 ) end
 function _IlllIIlIII.startAutoHatch() task.spawn( function () while task.wait(0.5) do if not _lIIllIIIII.AutoHatch_Enabled then continue end
 local _IlIllIIlII = _lllllllIll() if not _IlIllIIlII then continue end
 local _llIlIIIlIl = _IlIllIIlII:FindFirstChild("\069\103\103\115") if not _llIlIIIlIl then continue end
 for _, _IllIllIIIl in ipairs(_llIlIIIlIl:GetChildren()) do if not _lIIllIIIII.AutoHatch_Enabled then break end
 if not _IllIllIIIl:IsA("\077\111\100\101\108") then continue end
 local _IIlIlIllll = _IllIllIIIl:FindFirstChild("\072\097\110\100\108\101") if not _IIlIlIllll then continue end
 local _llIIlIIIll = _IIlIlIllll:FindFirstChild("\072\097\116\099\104") if not _llIIlIIIll or not _llIIlIIIll:IsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116") then continue end
 _llIIlIIIll.Enabled = true _llIIlIIIll.MaxActivationDistance = math.huge _llIIlIIIll.RequiresLineOfSight = false _llIIlIIIll.HoldDuration = 0x0 if typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _llIIlIIIll) task.wait(0.05) pcall(fireproximityprompt, _llIIlIIIll) end
 end
 end
 end
 ) end
 local _lllIIIIIll = { Enabled = false, EggFilter = "\078\111\110\101", PlantedCount = 0x0, Status = "\073\100\108\101", } local function _IIlllIlIlI(_lIlllIlIIl) local _lIlllIllII = _IlIIlIIIII:FindFirstChild("\066\097\099\107\112\097\099\107") if not _lIlllIllII then return nil end
 local _IlllIIlIll = _lIlllIlIIl:lower() for _, tool in ipairs(_lIlllIllII:GetChildren()) do if tool:IsA("\084\111\111\108") then local _IlIllIIIll = tool.Name:lower():gsub("\037\115\042\101\103\103\037\115\042\036", ""):gsub("\094\037\115\043", ""):gsub("\037\115\043\036", "") if _IlIllIIIll == _IlllIIlIll then return tool end
 end
 end
 return nil end
 local function _lIlllIIIll() local _IlIllIIlII = _lllllllIll() if not _IlIllIIlII then return nil end
 local _IlIIIIllIl = _IlIllIIlII:FindFirstChild("\078\101\115\116\115") if not _IlIIIIllIl then return nil end
 for _, _IIIlllIIII in ipairs(_IlIIIIllIl:GetChildren()) do if _IIIlllIIII:IsA("\077\111\100\101\108") and not _IIIlllIIII:FindFirstChild("\076\111\099\107\101\100") then local _lIlllIIIII = false for _, child in ipairs(_IIIlllIIII:GetChildren()) do if child:IsA("\077\111\100\101\108") and child.Name:lower() ~= "\109\111\100\101\108" then _lIlllIIIII = true break end
 end
 if not _lIlllIIIII then return _IIIlllIIII end
 end
 end
 return nil end
 function _IlllIIlIII.startAutoPlantEgg() task.spawn( function () while task.wait(0.2) do if not _lllIIIIIll.Enabled then _lllIIIIIll.Status = "\073\100\108\101" continue end
 if not _lllIIIIIll.EggFilter or _lllIIIIIll.EggFilter == "" or _lllIIIIIll.EggFilter == "\078\111\110\101" then _lllIIIIIll.Status = "\080\105\108\105\104\032\101\103\103\032\100\117\108\117\032\100\105\032\080\108\097\110\116\032\070\105\108\116\101\114\033" continue end
 local _IllIllllII = _IlIIlIIIII.Character local _lIllIIIIII = _IllIllllII and _IllIllllII:FindFirstChildOfClass("\072\117\109\097\110\111\105\100") if not _lIllIIIIII or _lIllIIIIII.Health <= 0x0 then continue end
 local _llIIlIlIII = _IIlllIlIlI(_lllIIIIIll.EggFilter) if not _llIIlIlIII then _lllIIIIIll.Status = "\088\032" .. _lllIIIIIll.EggFilter .. "\032\110\111\116\032\105\110\032\098\097\099\107\112\097\099\107" continue end
 pcall( function () _lIllIIIIII:EquipTool(_llIIlIlIII) end
 ) local _IIIlllIIII = _lIlllIIIll() if not _IIIlllIIII then _lllIIIIIll.Status = "\088\032\078\111\032\101\109\112\116\121\032\110\101\115\116" continue end
 local _IIIIIllIlI = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101"):FindFirstChild("\082\101\109\111\116\101\115") local _IIllIlIlll = _IIIIIllIlI and _IIIIIllIlI:FindFirstChild("\071\097\109\101") if _IIllIlIlll then local _lIllllIlll = _IIllIlIlll:FindFirstChild("\069\103\103\080\108\097\099\101\100") if _lIllllIlll then pcall( function () _lIllllIlll:FireServer() end
 ) pcall( function () _lIllllIlll:FireServer(_IIIlllIIII) end
 ) pcall( function () _lIllllIlll:FireServer(_IIIlllIIII.Name) end
 ) pcall( function () _lIllllIlll:FireServer(_lllIIIIIll.EggFilter) end
 ) end
 local _IlIIlllIlI = _IIllIlIlll:FindFirstChild("\080\108\111\116") if _IlIIlllIlI then local _llIlllIIII = _IlIIlllIlI:FindFirstChild("\078\101\115\116\115") if _llIlllIIII then pcall( function () _llIlllIIII:FireServer(_IIIlllIIII) end
 ) pcall( function () _llIlllIIII:FireServer(_IIIlllIIII.Name) end
 ) end
 end
 end
 pcall( function () _llIIlIlIII:Activate() end
 ) local _lIlIlllIll = _IIIlllIIII:FindFirstChildWhichIsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116", true) if _lIlIlllIll then _lIlIlllIll.HoldDuration = 0x0 _lIlIlllIll.MaxActivationDistance = math.huge if typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 end
 _lllIIIIIll.PlantedCount = _lllIIIIIll.PlantedCount + 0x1 _lllIIIIIll.Status = "\079\075\032" .. _lllIIIIIll.EggFilter .. "\032\040" .. _lllIIIIIll.PlantedCount .. "\041" end
 end
 ) end
 function _IlllIIlIII.getAutoPlantState() return _lllIIIIIll end
 function _IlllIIlIII.setAutoPlantFilter(_lIlllIlIIl) _lllIIIIIll.EggFilter = _lIlllIlIIl or "" end
 function _IlllIIlIII.startAutoRidePet() task.spawn( function () while task.wait(0x1) do if not _lIIllIIIII.AutoRidePet_Enabled then continue end
 local _IlIllIIlII = _lllllllIll() if not _IlIllIIlII then continue end
 local _IIlIIIlIlI = _IlIllIIlII:FindFirstChild("\080\101\116\115") if not _IIlIIIlIlI then continue end
 for _, pet in ipairs(_IIlIIIlIlI:GetChildren()) do local _lIlIlllIll = pet:FindFirstChild("\082\105\100\101\080\114\111\109\112\116", true) if _lIlIlllIll and _lIlIlllIll.Enabled then if typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 break end
 end
 end
 end
 ) end
 local _lllIIlllII = {} local _lllIlIIIII = {} local _lIllIIIlIl = 0x32 function _IlllIIlIII.startEggPrediction() task.spawn( function () while task.wait(0x1) do local _IIllIIIlll = _lIIIIlIllI:FindFirstChild("\082\101\110\100\101\114\101\100\069\103\103\115") if not _IIllIIIlll then continue end
 local _IIlIIIIlII = {} for _, _IllIllIIIl in ipairs(_IIllIIIlll:GetChildren()) do if _IllIllIIIl:IsA("\077\111\100\101\108") then table.insert(_IIlIIIIlII, _IllIllIIIl.Name) end
 end
 for _, _lIlllIlIIl in ipairs(_IIlIIIIlII) do local _lIllIIlIIl = false for _, lastEgg in ipairs(_lllIlIIIII) do if lastEgg == _lIlllIlIIl then _lIllIIlIIl = true break end
 end
 if not _lIllIIlIIl then table.insert(_lllIIlllII, { _lIllIIllll = _lIlllIlIIl, time = os.time(), }) if #_lllIIlllII > _lIllIIIlIl then table.remove(_lllIIlllII, 0x1) end
 end
 end
 _lllIlIIIII = _IIlIIIIlII _lIIllIIIII.EggsInMap = _IIlIIIIlII _lIIllIIIII.EggHistory = _lllIIlllII local _IIllIlllll = {} for _, entry in ipairs(_lllIIlllII) do _IIllIlllll[entry.name] = (_IIllIlllll[entry.name] or 0x0) + 0x1 end
 local _llIllllIII = {} for _lIllIIllll, count in pairs(_IIllIlllll) do table.insert(_llIllllIII, {_lIllIIllll = _lIllIIllll, count = count}) end
 table.sort(_llIllllIII, function (a, b) return a.count > b.count end
 ) local _IlIIIIlIIl = {} for _, entry in ipairs(_llIllllIII) do local _IllllIlIlI = false for _, _lIlllIlIIl in ipairs(_IIlIIIIlII) do if _lIlllIlIIl == entry.name then _IllllIlIlI = true break end
 end
 if not _IllllIlIlI then table.insert(_IlIIIIlIIl, entry.name) end
 if #_IlIIIIlIIl >= 0x5 then break end
 end
 _lIIllIIIII.EggPredictions = _IlIIIIlIIl end
 end
 ) end
 local function _lIIllIIlII(_lIllIIllll) local _IIIIIllIlI = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101"):FindFirstChild("\082\101\109\111\116\101\115") if not _IIIIIllIlI then return nil end
 local _lllllllIll = _IIIIIllIlI:FindFirstChild("\071\097\109\101") if not _lllllllIll then return nil end
 return _lllllllIll:FindFirstChild(_lIllIIllll) end
 function _IlllIIlIII.rideAlong() local _lIlIIIlIll = _lIIllIIlII("\082\105\100\101\065\108\111\110\103") if _lIlIIIlIll then _lIlIIIlIll:FireServer() return true end
 return false end
 function _IlllIIlIII.petDismount() local _lIlIIIlIll = _lIIllIIlII("\080\101\116\068\105\115\109\111\117\110\116") if _lIlIIIlIll then _lIlIIIlIll:FireServer() return true end
 return false end
 function _IlllIIlIII.pickupPet() local _lIlIIIlIll = _lIIllIIlII("\080\105\099\107\117\112\080\101\116") if _lIlIIIlIll then _lIlIIIlIll:FireServer() return true end
 return false end
 function _IlllIIlIII.hatchEgg() local _lIlIIIlIll = _lIIllIIlII("\072\097\116\099\104") if _lIlIIIlIll then _lIlIIIlIll:FireServer() return true end
 return false end
 local _llIlIIIllI = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101"):FindFirstChild("\071\097\109\101\068\097\116\097") local _lIlIllIlIl, PetData = {}, {} if _llIlIIIllI then local _IIllIIIlII = _llIlIIIllI:FindFirstChild("\069\103\103\115") if _IIllIIIlII then local _IIlIIIllIl, _IlllllIllI = pcall(require, _IIllIIIlII) if _IIlIIIllIl and type(_IlllllIllI) == "\116\097\098\108\101" then _lIlIllIlIl = _IlllllIllI end
 end
 local _IIllllIlll = _llIlIIIllI:FindFirstChild("\080\101\116\115") if _IIllllIlll then local _IIlIIIllIl, _IlllllIllI = pcall(require, _IIllllIlll) if _IIlIIIllIl and type(_IlllllIllI) == "\116\097\098\108\101" then PetData = _IlllllIllI end
 end
 end
 local _lIIlIllIll = { Common = 0x1, Uncommon = 0x2, Rare = 0x3, Epic = 0x4, Legendary = 0x5, Mythic = 0x6, Divine = 0x7, Ethereal = 0x8, Secret = 0x9, } local function _lllIIlIIlI(_lIlllIlIIl) local _IllIIlIlII = _lIlIllIlIl[_lIlllIlIIl] return _IllIIlIlII and _IllIIlIlII.Rarity or "\067\111\109\109\111\110" end
 local function _IlIIllIllI(_lIlllIlIIl) local _llllIIlIll = _lllIIlIIlI(_lIlllIlIIl) if not _lIIllIIIII.SelectedRarities then return false end
 return _lIIllIIIII.SelectedRarities[_llllIIlIll] == true end
 function _IlllIIlIII.setSpeed(_IIlIIlIlll) local _IllIllllII = _IlIIlIIIII.Character local _lIllIIIIII = _IllIllllII and _IllIllllII:FindFirstChildOfClass("\072\117\109\097\110\111\105\100") if _lIllIIIIII then _lIllIIIIII.WalkSpeed = _IIlIIlIlll end
 end
 function _IlllIIlIII.startSpeed() task.spawn( function () while task.wait(0.3) do if _lIIllIIIII.Speed_Enabled then _IlllIIlIII.setSpeed(_lIIllIIIII.Speed_Value or 0x64) end
 end
 end
 ) end
 function _IlllIIlIII.startInstantPickup() task.spawn( function () while task.wait(0.5) do if not _lIIllIIIII.InstantPickup_Enabled then continue end
 local _IIllIIIlll = _lIIIIlIllI:FindFirstChild("\082\101\110\100\101\114\101\100\069\103\103\115") if not _IIllIIIlll then continue end
 for _, _IllIllIIIl in ipairs(_IIllIIIlll:GetChildren()) do if _IllIllIIIl:IsA("\077\111\100\101\108") then local _lIlIlllIll = _IllIllIIIl:FindFirstChild("\080\105\099\107\117\112", true) if _lIlIlllIll and _lIlIlllIll:IsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116") then if _lIlIlllIll.HoldDuration > 0x0 then _lIlIlllIll.HoldDuration = 0x0 end
 end
 end
 end
 end
 end
 ) end
 local _IIIlllllIl = {} local function _lIIlllIIIl(_IllIllIIIl) local _IIIlIllllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) if not _IIIlIllllI then return _IllIllIIIl.Name end
 local _lIIllIIIIl = _IIIlIllllI.Position return string.format("\037\115\095\037\046\048\102\095\037\046\048\102\095\037\046\048\102", _IllIllIIIl.Name, _lIIllIIIIl.X, _lIIllIIIIl.Y, _lIIllIIIIl.Z) end
 local function _IlIlIIIIIl() local _lllllllIII = { Common = 0x1, Uncommon = 0x2, Rare = 0x3, Epic = 0x4, Legendary = 0x5, Mythic = 0x6, Divine = 0x7, Ethereal = 0x8, Secret = 0x9, } return _lllllllIII[_lIIllIIIII.RarityNotifThreshold or "\076\101\103\101\110\100\097\114\121"] or 0x5 end
 local function _IIlIllIlII() local _IIllIIIlll = _lIIIIlIllI:FindFirstChild("\082\101\110\100\101\114\101\100\069\103\103\115") if not _IIllIIIlll then return nil end
 local _IlIlIIlIIl = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IlIlIIlIIl then return nil end
 local _IlIlIllIIl, bestRank = nil, 0x0 for _, _IllIllIIIl in ipairs(_IIllIIIlll:GetChildren()) do if _IllIllIIIl:IsA("\077\111\100\101\108") and _IlIIllIllI(_IllIllIIIl.Name) then local _llllIIlIll = _lllIIlIIlI(_IllIllIIIl.Name) local _IllIIllIIl = _lIIlIllIll[_llllIIlIll] or 0x1 local _IIIlIllllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) if _IIIlIllllI then local _lIlIlIIlII = (_IIIlIllllI.Position - _IlIlIIlIIl.Position).Magnitude if _IllIIllIIl > bestRank or (_IllIIllIIl == bestRank and ( not _IlIlIllIIl or _lIlIlIIlII < _IlIlIllIIl.dist)) then _IlIlIllIIl = {_IllIllIIIl = _IllIllIIIl, dist = _lIlIlIIlII, _llllIIlIll = _llllIIlIll, _IllIIllIIl = _IllIIllIIl} bestRank = _IllIIllIIl end
 end
 end
 end
 return _IlIlIllIIl end
 local _lIIIIIlIII = { DropDistanceFromPlot = 0x64, DropHeight = 0x5, DropWait = 0.3, DropSpamCount = 0x3, DropSpamInterval = 0.05, PostDropVerifyWait = 0.4, RePickupWait = 0.4, RePickupMaxTries = 0x32, RePickupScanRadius = 0x96, RePickupTPHeight = 0x3, RePickupRetryWait = 0.08, RePickupRetryRadii = { 0x96, 0xFA, 0x190, 0x258 }, BaseTPHeight = 0x5, } local function _IIIIIlllll() local _IlIllIIlII = _lllllllIll() if not _IlIllIIlII then return nil end
 local _IllIlIIlII = _IlIllIIlII:FindFirstChild("\066\097\115\101\112\108\097\116\101", true) or _IlIllIIlII:FindFirstChild("\066\097\115\101\080\108\097\116\101", true) or _IlIllIIlII:FindFirstChildWhichIsA("\083\112\097\119\110\076\111\099\097\116\105\111\110", true) if _IllIlIIlII then return _IllIlIIlII.Position end
 local _IIlIIIllIl, modelCF = pcall( function () return _IlIllIIlII:GetBoundingBox() end
 ) if _IIlIIIllIl and modelCF then return modelCF.Position end
 return nil end
 local function _lIllllIIlI() local _IllIllllII = _IlIIlIIIII.Character if not _IllIllllII then return false, nil end
 local _lIIllIIllI = _IllIllllII:FindFirstChild("\087\111\111\100\101\110") if not _lIIllIIllI then return false, nil end
 local _IIIlIlIIlI = _lIIllIIllI:FindFirstChild("\068\105\115\112\108\097\121\069\103\103") if not _IIIlIlIIlI then return false, nil end
 for _, c in ipairs(_IIIlIlIIlI:GetChildren()) do if c:IsA("\077\101\115\104\080\097\114\116") and not c.Name:lower():find("\099\105\114\099\108\101") then return true, c.Name end
 end
 return false, nil end
 local function _lIIIlIIllI() local _IIIIIllIlI = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101"):FindFirstChild("\082\101\109\111\116\101\115") local _IIllIlIlll = _IIIIIllIlI and _IIIIIllIlI:FindFirstChild("\071\097\109\101") if not _IIllIlIlll then return nil end
 return _IIllIlIlll:FindFirstChild("\066\097\115\107\101\116\068\114\111\112") or _IIllIlIlll:FindFirstChild("\068\114\111\112\069\103\103") or _IIllIlIlll:FindFirstChild("\069\103\103\068\114\111\112") or _IIllIlIlll:FindFirstChild("\068\114\111\112") end
 local function _IIIlIllllI(_IlIlIIlIIl, _lIIIlIlIIl, targetEggName, radius) if not _lIIIlIlIIl then return false, "\110\111\032\100\114\111\112\080\111\115", 0x0 end
 task.wait(_lIIIIIlIII.RePickupWait) local _lIIIIlIIIl = 0x0 while _lIIIIlIIIl < _lIIIIIlIII.RePickupMaxTries do _lIIIIlIIIl = _lIIIIlIIIl + 0x1 local _llIIlllIII, heldName = _lIllllIIlI() if _llIIlllIII then return true, tostring(heldName), _lIIIIlIIIl end
 local _IIllIIIlll = _lIIIIlIllI:FindFirstChild("\082\101\110\100\101\114\101\100\069\103\103\115") if not _IIllIIIlll then task.wait(_lIIIIIlIII.RePickupRetryWait) continue end
 local _llllIIlllI = nil local _IllIlIIIIl = math.huge local _llllIllIIl = nil local _llIlIllIIl = math.huge for _, _IllIllIIIl in ipairs(_IIllIIIlll:GetChildren()) do if _IllIllIIIl:IsA("\077\111\100\101\108") then local _IIIlIllllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) if _IIIlIllllI then local _lIlIlIIlII = (_IIIlIllllI.Position - _lIIIlIlIIl).Magnitude if _lIlIlIIlII <= radius and _lIlIlIIlII < _llIlIllIIl then _llllIllIIl = _IllIllIIIl _llIlIllIIl = _lIlIlIIlII end
 if targetEggName and _IllIllIIIl.Name == targetEggName then if _lIlIlIIlII <= radius and _lIlIlIIlII < _IllIlIIIIl then _llllIIlllI = _IllIllIIIl _IllIlIIIIl = _lIlIlIIlII end
 end
 end
 end
 end
 local _IIlIlIlIll = _llllIIlllI or _llllIllIIl local _lIIIIIllll = _llllIIlllI and _IllIlIIIIl or _llIlIllIIl if _IIlIlIlIll then local _lllllIIllI = _IIlIlIlIll:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) local _lIlIlllIll = _IIlIlIlIll:FindFirstChild("\080\105\099\107\117\112", true) or _IIlIlIlIll:FindFirstChild("\067\111\108\108\101\099\116", true) or _IIlIlIlIll:FindFirstChildWhichIsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116", true) if _lllllIIllI and _lIlIlllIll then if _lIlIlllIll:IsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116") then _lIlIlllIll.HoldDuration = 0x0 end
 _IlIlIIlIIl.CFrame = CFrame.lookAt( _lllllIIllI.Position + Vector3.new(0x0, _lIIIIIlIII.RePickupTPHeight, 0x0), _lllllIIllI.Position) _IlIlIIlIIl.Velocity = Vector3.zero _IlIlIIlIIl.AssemblyLinearVelocity = Vector3.zero task.wait(0.05) if typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 task.wait(0.08) local _lllIIllIIl, hn = _lIllllIIlI() if _lllIIllIIl then return true, tostring(hn), _lIIIIlIIIl end
 if not _IIlIlIlIll.Parent then task.wait(0.15) local _IlIIlIlIIl, hn2 = _lIllllIIlI() if _IlIIlIlIIl then return true, tostring(hn2), _lIIIIlIIIl end
 return true, "\112\105\099\107\101\100\045\105\110\045\109\097\112", _lIIIIlIIIl end
 end
 end
 task.wait(_lIIIIIlIII.RePickupRetryWait) end
 return false, "\110\111\116\032\102\111\117\110\100", _lIIIIlIIIl end
 local function _IlIlIlIllI() if not _lIIllIIIII.AutoReturn_Enabled then return end
 local _IllIllllII = _IlIIlIIIII.Character local _IlIlIIlIIl = _IllIllllII and _IllIllllII:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IlIlIIlIIl then return end
 local _llIIlllIII, heldEggName = _lIllllIIlI() if _llIIlllIII and heldEggName then local _IlllllIIlI = _IIIIIlllll() if not _IlllllIIlI then return end
 local _lllIIlIlll = (_IlIlIIlIIl.Position - _IlllllIIlI) _lllIIlIlll = Vector3.new(_lllIIlIlll.X, 0x0, _lllIIlIlll.Z) if _lllIIlIlll.Magnitude < 0x1 then local _IIlIllIIIl = math.random() * math.pi * 0x2 _lllIIlIlll = Vector3.new(math.cos(_IIlIllIIIl), 0x0, math.sin(_IIlIllIIIl)) else _lllIIlIlll = _lllIIlIlll.Unit end
 local _lIIIlIlIIl = Vector3.new( _IlllllIIlI.X + _lllIIlIlll.X * _lIIIIIlIII.DropDistanceFromPlot, _IlllllIIlI.Y + _lIIIIIlIII.DropHeight, _IlllllIIlI.Z + _lllIIlIlll.Z * _lIIIIIlIII.DropDistanceFromPlot ) local _lIllIlIlll = _lIIIlIlIIl + Vector3.new(0x0, 0x64, 0x0) _IlIlIIlIIl.CFrame = CFrame.new(_lIllIlIlll) _IlIlIIlIIl.Velocity = Vector3.zero _IlIlIIlIIl.AssemblyLinearVelocity = Vector3.zero task.wait(0.5) _IlIlIIlIIl = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IlIlIIlIIl then return end
 _IlIlIIlIIl.CFrame = CFrame.new(_lIIIlIlIIl) _IlIlIIlIIl.Velocity = Vector3.zero _IlIlIIlIIl.AssemblyLinearVelocity = Vector3.zero task.wait(_lIIIIIlIII.DropWait) local _IlIlllIIIl = _lIIIlIIllI() if _IlIlllIIIl then for i = 0x1, _lIIIIIlIII.DropSpamCount do pcall( function () _IlIlllIIIl:FireServer() end
 ) task.wait(_lIIIIIlIII.DropSpamInterval) end
 end
 for _, _lIlIlIIlII in ipairs(_IllIllllII:GetDescendants()) do if _lIlIlIIlII:IsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116") and _lIlIlIIlII.Name:lower():find("\100\114\111\112") then _lIlIlIIlII.HoldDuration = 0x0 if typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlIIlII) end
 end
 end
 task.wait(_lIIIIIlIII.PostDropVerifyWait) if _lIllllIIlI() then for i = 0x1, 0x5 do if _IlIlllIIIl then pcall( function () _IlIlllIIIl:FireServer() end
 ) end
 task.wait(0.1) if not _lIllllIIlI() then break end
 end
 end
 local _IlIIlllIII, reName, reTries = _IIIlIllllI(_IlIlIIlIIl, _lIIIlIlIIl, heldEggName, _lIIIIIlIII.RePickupScanRadius) if not _IlIIlllIII then for i, radius in ipairs(_lIIIIIlIII.RePickupRetryRadii) do if _IlIIlllIII then break end
 task.wait(0.4) _IlIIlllIII, reName, reTries = _IIIlIllllI(_IlIlIIlIIl, _lIIIlIlIIl, heldEggName, radius) end
 end
 if not _IlIIlllIII or not _lIllllIIlI() then print("\091\082\069\084\085\082\078\093\032\080\105\099\107\117\112\032\117\108\097\110\103\032\103\097\103\097\108\032\8212\032\115\107\105\112\032\084\080\032\098\097\115\101") return end
 print("\091\082\069\084\085\082\078\093\032\080\105\099\107\117\112\032\117\108\097\110\103\032\079\075\058\032" .. tostring(reName)) end
 if not _lIllllIIlI() then return end
 local _lIllIlIIII = _IlIIIlllIl() if not _lIllIlIIII then local spawn = _lIIIIlIllI:FindFirstChild("\083\112\097\119\110") if spawn then _lIllIlIIII = spawn:FindFirstChildWhichIsA("\083\112\097\119\110\076\111\099\097\116\105\111\110", true) or spawn:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) end
 end
 if _lIllIlIIII then local _IIlIIIlllI = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if _IIlIIIlllI then local _llIlIIlIlI = _lIllIlIIII.Position + Vector3.new(0x0, 0x32, 0x0) _IIlIIIlllI.CFrame = CFrame.new(_llIlIIlIlI) _IIlIIIlllI.Velocity = Vector3.zero _IIlIIIlllI.AssemblyLinearVelocity = Vector3.zero task.wait(0.3) _IIlIIIlllI = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if _IIlIIIlllI then _IIlIIIlllI.CFrame = _lIllIlIIII.CFrame + Vector3.new(0x0, _lIIIIIlIII.BaseTPHeight, 0x0) _IIlIIIlllI.Velocity = Vector3.zero _IIlIIIlllI.AssemblyLinearVelocity = Vector3.zero print("\091\082\069\084\085\082\078\093\032\084\080\032\098\097\115\101\032\079\075\032\040\050\045\115\116\101\112\041") end
 end
 end
 end
 function _IlllIIlIII.startAutoFarm() task.spawn( function () while task.wait(0.5) do if not _lIIllIIIII.AutoFarm_Enabled then continue end
 local _IllIllllII = _IlIIlIIIII.Character local _IlIlIIlIIl = _IllIllllII and _IllIllllII:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") local _lIllIIIIII = _IllIllllII and _IllIllllII:FindFirstChildOfClass("\072\117\109\097\110\111\105\100") if not _IlIlIIlIIl or not _lIllIIIIII or _lIllIIIIII.Health <= 0x0 then task.wait(0x1) continue end
 local _IIllIIIlll = _lIIIIlIllI:FindFirstChild("\082\101\110\100\101\114\101\100\069\103\103\115") if _IIllIIIlll then local _lIIIIlllII = {} for _, _IllIllIIIl in ipairs(_IIllIIIlll:GetChildren()) do if _IllIllIIIl:IsA("\077\111\100\101\108") then _lIIIIlllII[_lIIlllIIIl(_IllIllIIIl)] = true end
 end
 for key in pairs(_IIIlllllIl) do if not _lIIIIlllII[key] then _IIIlllllIl[key] = nil end
 end
 end
 local _IlIlIllIIl = _IIlIllIlII() if not _IlIlIllIIl then continue end
 local _IllIllIIIl = _IlIlIllIIl.egg local _lIlllIlIIl = _IllIllIIIl.Name local _IIIIlIIIlI = _IlIlIllIIl.rarity local _llIlIlIIlI = _lIIlllIIIl(_IllIllIIIl) if (_lIIlIllIll[_IIIIlIIIlI] or 0x1) >= _IlIlIIIIIl() then if not _IIIlllllIl[_llIlIlIIlI] then _IIIlllllIl[_llIlIlIIlI] = true if _lIIllIIIII.Notify then _lIIllIIIII.Notify("\55356\57263\032" .. _lIlllIlIIl .. "\032\040" .. _IIIIlIIIlI .. "\041", "\115\117\099\099\101\115\115") end
 end
 end
 local _lllllIIllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) if not _lllllIIllI then continue end
 local _lIlIlllIll = _IllIllIIIl:FindFirstChild("\080\105\099\107\117\112", true) if _lIlIlllIll and _lIlIlllIll:IsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116") then _lIlIlllIll.HoldDuration = 0x0 end
 local _IllIlllIll = false if _lIIllIIIII.StealMode == "\070\108\121" then _IllIlllIll = _lllIlllIll(_IllIllIIIl, _lIlIlllIll, _lllllIIllI) else _IlIlIIlIIl.CFrame = _lllllIIllI.CFrame + Vector3.new(0x0, 0x5, 0x0) task.wait(0.1) local _llIIIIIIll = 0xA for i = 0x1, _llIIIIIIll do if _lIlIlllIll and typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 task.wait(0.3) if not _IlIlllIlIl(_IllIllIIIl) then _IllIlllIll = true break end
 if _lllllIIllI and _lllllIIllI.Parent then _IlIlIIlIIl.CFrame = _lllllIIllI.CFrame + Vector3.new(0x0, 0x5, 0x0) task.wait(0.1) end
 end
 end
 if _IllIlllIll and _lIIllIIIII.AutoReturn_Enabled then _IlIlIlIllI() task.wait(0.3) end
 task.wait(0.3) end
 end
 ) end
 local _IlIlllllII = { Enabled = false, Hunting = false, } local _IIIIIllIll = { Vector3.new(-4902.3, 41396.1, -3751.4), Vector3.new(-4908.1, 41365.0, -3742.9), Vector3.new(-4909.5, 41357.4, -3740.8), Vector3.new(-4923.0, 41299.5, -3719.6), Vector3.new(-4927.1, 41293.3, -3712.6), Vector3.new(-4951.4, 41287.6, -3669.6), Vector3.new(-4973.1, 41283.3, -3643.8), Vector3.new(-4995.2, 41285.0, -3620.6), Vector3.new(-5010.8, 41279.5, -3597.9), Vector3.new(-5020.6, 41275.2, -3582.6), Vector3.new(-5032.2, 41272.9, -3564.8), Vector3.new(-5062.9, 41262.1, -3542.1), Vector3.new(-5070.9, 41262.3, -3537.0), Vector3.new(-5079.4, 41265.2, -3533.3), Vector3.new(-5088.6, 41240.3, -3525.3), Vector3.new(-5096.8, 41228.7, -3520.1), Vector3.new(-5101.5, 41197.4, -3514.3), Vector3.new(-5103.3, 41165.1, -3511.6), Vector3.new(-5112.5, 41164.5, -3551.9), Vector3.new(-5157.0, 41159.7, -3588.1), Vector3.new(-5165.4, 41158.0, -3594.1), Vector3.new(-5211.0, 41150.0, -3569.9), Vector3.new(-5248.0, 41147.5, -3580.6), Vector3.new(-5256.8, 41143.1, -3581.9), Vector3.new(-5260.1, 41122.3, -3580.1), Vector3.new(-5268.7, 41062.3, -3575.5), Vector3.new(-5259.1, 41050.3, -3586.2), Vector3.new(-5269.5, 41047.7, -3640.0), Vector3.new(-5264.0, 41042.3, -3655.1), Vector3.new(-5218.7, 41023.5, -3659.7), Vector3.new(-5188.9, 41037.1, -3635.5), Vector3.new(-5147.5, 41037.4, -3589.8), Vector3.new(-5123.4, 41037.2, -3550.7), Vector3.new(-5123.0, 41033.8, -3503.2), Vector3.new(-5094.9, 41037.6, -3486.6), Vector3.new(-5081.6, 41035.8, -3474.5), Vector3.new(-5040.8, 41048.6, -3433.1), Vector3.new(-4990.3, 41050.6, -3391.9), Vector3.new(-4949.3, 41057.1, -3400.0), Vector3.new(-4908.1, 41036.5, -3439.7), Vector3.new(-4869.4, 41000.1, -3474.8), Vector3.new(-4880.2, 40975.6, -3528.0), Vector3.new(-4930.9, 40973.3, -3563.7), Vector3.new(-4966.2, 40960.4, -3610.8), Vector3.new(-5016.4, 40943.8, -3648.2), Vector3.new(-5072.8, 40929.0, -3667.8), Vector3.new(-5136.3, 40922.9, -3656.4), Vector3.new(-5151.8, 40914.2, -3681.0), Vector3.new(-5209.2, 40907.2, -3677.5), Vector3.new(-5267.7, 40907.3, -3651.2), Vector3.new(-5282.4, 40908.9, -3632.6), Vector3.new(-5270.4, 40907.1, -3619.5), } local function _IIllIlllII() local _IIllIIIlll = _lIIIIlIllI:FindFirstChild("\082\101\110\100\101\114\101\100\069\103\103\115") if not _IIllIIIlll then return nil end
 for _, _IllIllIIIl in ipairs(_IIllIIIlll:GetChildren()) do if _IllIllIIIl:IsA("\077\111\100\101\108") and _IllIllIIIl.Name:lower():find("\118\111\108\099\097\110", 0x1, true) then return _IllIllIIIl end
 end
 return nil end
 local function _lIlIllIIlI() local _lIllIllIlI = _lIIIIlIllI:FindFirstChild("\069\103\103\083\112\097\119\110\115") if not _lIllIllIlI then return nil end
 local _IIlIIlIlll = _lIllIllIlI:FindFirstChild("\086\111\108\099\097\110\105\099") if _IIlIIlIlll and _IIlIIlIlll:IsA("\066\097\115\101\080\097\114\116") then return _IIlIIlIlll end
 return nil end
 local function _IlIllllIlI(wp) local _IIlllllIIl = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IIlllllIIl then return false end
 _IIlllllIIl.CFrame = CFrame.new(wp + Vector3.new(0x0, 0x5, 0x0)) _IIlllllIIl.Velocity = Vector3.zero _IIlllllIIl.AssemblyLinearVelocity = Vector3.zero task.wait(0.12) return true end
 local function _lllIlIIlII() print("\091\086\079\076\067\065\078\073\067\093\032\075\101\108\117\097\114\032\103\111\097\032\118\105\097\032\119\097\121\112\111\105\110\116\032\114\101\118\101\114\115\101\046\046\046") for i = #_IIIIIllIll, 0x1, -0x1 do if not _lIIllIIIII.VolcanicHunt_Enabled then return false end
 local _lIllIIIIII = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100") if not _lIllIIIIII or _lIllIIIIII.Health <= 0x0 then return false end
 _IlIllllIlI(_IIIIIllIll[i]) end
 print("\091\086\079\076\067\065\078\073\067\093\032\075\101\108\117\097\114\032\103\111\097\032\079\075") return true end
 local function _IlIlllIIll(_IllIllIIIl) local _IIIlIllllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) if not _IIIlIllllI then return false end
 local _lIlIlllIll = _IllIllIIIl:FindFirstChild("\080\105\099\107\117\112", true) or _IllIllIIIl:FindFirstChild("\067\111\108\108\101\099\116", true) or _IllIllIIIl:FindFirstChildWhichIsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116", true) if _lIlIlllIll and _lIlIlllIll:IsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116") then _lIlIlllIll.HoldDuration = 0x0 end
 local _IlllllIIIl = _IIIlIllllI.Position for i = 0x1, 0x19 do if not _lIIllIIIII.VolcanicHunt_Enabled then return false end
 local _llIIlllIII = _IlIIlIlIlI() if _llIIlllIII then print("\091\086\079\076\067\065\078\073\067\093\032\9989\032\086\101\114\105\102\105\101\100\032\104\111\108\100\105\110\103\032\101\103\103\032\064\032\116\114\121\032" .. i) return true end
 if not _IllIllIIIl.Parent then task.wait(0.3) if _IlIIlIlIlI() then print("\091\086\079\076\067\065\078\073\067\093\032\069\103\103\032\104\105\108\097\110\103\032\038\032\104\111\108\100\105\110\103\032\079\075") return true end
 end
 if _IIIlIllllI and _IIIlIllllI.Parent then _IlllllIIIl = _IIIlIllllI.Position end
 local _IIIIlIIllI = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if _IIIIlIIllI then _IIIIlIIllI.CFrame = CFrame.lookAt( _IlllllIIIl + Vector3.new(0x0, 0x3, 0x0), _IlllllIIIl) _IIIIlIIllI.Velocity = Vector3.zero _IIIIlIIllI.AssemblyLinearVelocity = Vector3.zero end
 if _lIlIlllIll and typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 task.wait(0.08) if _lIlIlllIll and typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 task.wait(0.2) end
 return _IlIIlIlIlI() end
 function _IlllIIlIII.startVolcanicHunt() task.spawn( function () while task.wait(0x1) do if not _lIIllIIIII.VolcanicHunt_Enabled then _IlIlllllII.Hunting = false continue end
 if _IlIlllllII.Hunting then continue end
 _IlIlllllII.Hunting = true task.spawn( function () while _lIIllIIIII.VolcanicHunt_Enabled do local _IllIllllII = _IlIIlIIIII.Character local _IlIlIIlIIl = _IllIllllII and _IllIllllII:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") local _lIllIIIIII = _IllIllllII and _IllIllllII:FindFirstChildOfClass("\072\117\109\097\110\111\105\100") if not _IlIlIIlIIl or not _lIllIIIIII or _lIllIIIIII.Health <= 0x0 then task.wait(0x1) continue end
 local _IllIllIIIl = _IIllIlllII() if not _IllIllIIIl then local _lIllIlIIII = _lIlIllIIlI() if _lIllIlIIII then local _IIIIlIIllI = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if _IIIIlIIllI then local _lIlIlIIlII = (_lIllIlIIII.Position - _IIIIlIIllI.Position).Magnitude if _lIlIlIIlII > 0x32 then _IIIIlIIllI.CFrame = _lIllIlIIII.CFrame + Vector3.new(0x0, 0x5, 0x0) _IIIIlIIllI.Velocity = Vector3.zero print("\091\086\079\076\067\065\078\073\067\093\032\084\101\108\101\112\111\114\116\032\107\101\032\115\112\097\119\110\032\112\111\105\110\116\032\118\111\108\099\097\110\105\099") end
 end
 end
 task.wait(0x2) continue end
 print("\091\086\079\076\067\065\078\073\067\093\032\55356\57263\032\069\103\103\032\118\111\108\099\097\110\105\099\032\115\112\097\119\110\033\032\077\117\108\097\105\032\104\117\110\116\046\046\046") if _lIIllIIIII.Notify then _lIIllIIIII.Notify("\55356\57099\032\086\111\108\099\097\110\105\099\032\069\103\103\032\115\112\097\119\110\033", "\115\117\099\099\101\115\115") end
 print("\091\086\079\076\067\065\078\073\067\093\032\083\084\069\080\032\049\032\8212\032\077\097\115\117\107\032\103\111\097\046\046\046") local _lllllIIllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) for i, wp in ipairs(_IIIIIllIll) do if not _lIIllIIIII.VolcanicHunt_Enabled then break end
 local _IIIIlIIllI = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if _IIIIlIIllI and _lllllIIllI and _lllllIIllI.Parent then local _lIlIlIIlII = (_lllllIIllI.Position - _IIIIlIIllI.Position).Magnitude if _lIlIlIIlII <= 0x19 then break end
 end
 _IlIllllIlI(wp) end
 print("\091\086\079\076\067\065\078\073\067\093\032\083\084\069\080\032\050\032\8212\032\080\105\099\107\117\112\032\101\103\103\046\046\046") local _IllIlllIll = false if _IllIllIIIl.Parent then _IllIlllIll = _IlIlllIIll(_IllIllIIIl) else _IllIlllIll = _IlIIlIlIlI() end
 if not _IllIlllIll or not _IlIIlIlIlI() then print("\091\086\079\076\067\065\078\073\067\093\032\10060\032\071\097\103\097\108\032\112\105\099\107\117\112\032\8212\032\115\107\105\112") task.wait(0x2) continue end
 print("\091\086\079\076\067\065\078\073\067\093\032\9989\032\080\105\099\107\117\112\032\079\075\032\8212\032\072\111\108\100\105\110\103\032\101\103\103") print("\091\086\079\076\067\065\078\073\067\093\032\083\084\069\080\032\051\032\8212\032\075\101\108\117\097\114\032\103\111\097\046\046\046") local _llIlllIIlI = _lllIlIIlII() if not _llIlllIIlI then print("\091\086\079\076\067\065\078\073\067\093\032\9888\65039\032\071\097\103\097\108\032\107\101\108\117\097\114\032\103\111\097\032\8212\032\115\107\105\112") task.wait(0x2) continue end
 if not _IlIIlIlIlI() then print("\091\086\079\076\067\065\078\073\067\093\032\9888\65039\032\069\103\103\032\104\105\108\097\110\103\032\115\101\116\101\108\097\104\032\107\101\108\117\097\114\032\103\111\097\032\8212\032\115\107\105\112") task.wait(0x2) continue end
 if _lIIllIIIII.VolcanicMutation_Enabled then print("\091\086\079\076\067\065\078\073\067\093\032\083\084\069\080\032\052\032\8212\032\065\117\116\111\032\077\117\116\097\116\105\111\110\032\079\078\032\8594\032\084\080\032\108\097\118\097\032\038\032\100\114\111\112") task.wait(0.5) local _IIllIIIllI = _IIllllIlII() if _IIllIIIllI then local _IIlIllIllI = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if _IIlIllIllI then _IIlIllIllI.CFrame = CFrame.new(_IIllIIIllI) _IIlIllIllI.Velocity = Vector3.zero _IIlIllIllI.AssemblyLinearVelocity = Vector3.zero end
 end
 task.wait(1.5) if not _IlIIlIlIlI() then print("\091\086\079\076\067\065\078\073\067\093\032\9888\65039\032\069\103\103\032\104\105\108\097\110\103\032\115\101\098\101\108\117\109\032\100\114\111\112\032\8212\032\115\107\105\112\032\100\114\111\112") else print("\091\086\079\076\067\065\078\073\067\093\032\068\114\111\112\032\101\103\103\032\118\105\097\032\086\111\108\099\097\110\111\068\105\112\046\046\046") local _lIllIIlIll = 0x0 local _IIIllIIIIl = false while _lIllIIlIll < 0xF do if not _lIIllIIIII.VolcanicHunt_Enabled then break end
 _lIIIIlllII() task.wait(1.5) _lIllIIlIll = _lIllIIlIll + 1.5 if not _IlIIlIlIlI() then _IIIllIIIIl = true print("\091\086\079\076\067\065\078\073\067\093\032\069\103\103\032\100\114\111\112\112\101\100\032\064\032" .. _lIllIIlIll .. "\115") break end
 end
 if not _IIIllIIIIl then print("\091\086\079\076\067\065\078\073\067\093\032\9888\65039\032\069\103\103\032\103\097\107\032\108\101\112\097\115\032\040\116\105\109\101\111\117\116\041") else print("\091\086\079\076\067\065\078\073\067\093\032\078\117\110\103\103\117\032\101\103\103\032\098\097\108\105\107\046\046\046") local _lIllIIIIlI = os.clock() local _IIIlIlIIll = false while os.clock() - _lIllIIIIlI < 0x14 do if not _lIIllIIIII.VolcanicHunt_Enabled then break end
 task.wait(0x1) if _IlIIlIlIlI() then _IIIlIlIIll = true print("\091\086\079\076\067\065\078\073\067\093\032\55357\56613\032\069\103\103\032\098\097\108\105\107\033\032\077\117\116\097\116\105\111\110\032\115\101\108\101\115\097\105\033") if _lIIllIIIII.Notify then _lIIllIIIII.Notify("\55357\56613\032\077\117\116\097\116\105\111\110\032\115\101\108\101\115\097\105\033", "\115\117\099\099\101\115\115") end
 break end
 end
 if not _IIIlIlIIll then print("\091\086\079\076\067\065\078\073\067\093\032\9888\65039\032\069\103\103\032\103\097\107\032\098\097\108\105\107\032\040\116\105\109\101\111\117\116\041") end
 end
 end
 else print("\091\086\079\076\067\065\078\073\067\093\032\083\084\069\080\032\052\032\8212\032\065\117\116\111\032\077\117\116\097\116\105\111\110\032\079\070\070\044\032\115\107\105\112\032\100\114\111\112") end
 if _lIIllIIIII.VolcanicReturn_Enabled then task.wait(0.4) print("\091\086\079\076\067\065\078\073\067\093\032\083\084\069\080\032\053\032\8212\032\082\101\116\117\114\110\032\107\101\032\112\108\111\116\032\040\100\114\111\112\032\049\048\048\032\8594\032\112\105\099\107\117\112\032\8594\032\084\080\032\098\097\115\101\041") local _llIIlIIllI = _lIIllIIIII.AutoReturn_Enabled _lIIllIIIII.AutoReturn_Enabled = true _IlIlIlIllI() _lIIllIIIII.AutoReturn_Enabled = _llIIlIIllI else print("\091\086\079\076\067\065\078\073\067\093\032\083\084\069\080\032\053\032\8212\032\082\101\116\117\114\110\032\079\070\070\044\032\115\107\105\112") end
 task.wait(0x3) end
 _IlIlllllII.Hunting = false print("\091\086\079\076\067\065\078\073\067\093\032\072\117\110\116\032\098\101\114\104\101\110\116\105") end
 ) end
 end
 ) end
 local _lIIIlllIll = { Running = false, StealPaused = false, BasketFull = false, EggLocked = false, LastFire = 0x0, } local _IllIIIIlII = { DROP_TIMEOUT = 0xF, RETURN_TIMEOUT = 0xD, TP_ABOVE_TOP = 0xC8, } local _lIIIlllIll = nil task.spawn( function () local _IIIlIIlIlI = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101"):FindFirstChild("\112\097\099\107\097\103\101\115") if _IIIlIIlIlI then local _llIlIIlIII = _IIIlIIlIlI:FindFirstChild("\078\101\116") if _llIlIIlIII then local _IIlIIIllIl, result = pcall(require, _llIlIIlIII) if _IIlIIIllIl then _lIIIlllIll = result print("\091\077\085\084\065\084\073\079\078\093\032\078\101\116\032\109\111\100\117\108\101\032\108\111\097\100\101\100") end
 end
 end
 end
 ) local function _IllIIlllIl() if _lIIIlllIll then local _IIlIIIllIl, _lIlIIIlIll = pcall( function () return _lIIIlllIll:RemoteEvent("\086\111\108\099\097\110\111\068\105\112") end
 ) if _IIlIIIllIl and _lIlIIIlIll then return _lIlIIIlIll end
 end
 local _IIIIIllIlI = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101"):FindFirstChild("\082\101\109\111\116\101\115") local _IIllIlIlll = _IIIIIllIlI and _IIIIIllIlI:FindFirstChild("\071\097\109\101") if _IIllIlIlll then local _IIIIIIIlIl = _IIllIlIlll:FindFirstChild("\086\111\108\099\097\110\111\068\105\112") if _IIIIIIIlIl and _IIIIIIIlIl:IsA("\082\101\109\111\116\101\069\118\101\110\116") then return _IIIIIIIlIl end
 end
 return nil end
 local function _IIllllIlII() local _IlIIllIlll = _lIIIIlIllI:FindFirstChild("\086\111\108\099\097\110\111") if not _IlIIllIlll then return Vector3.new(-5102.84, 0xA2E4, -3489.11) end
 local _lIlIllllII, bestSize = nil, 0x0 for _, _lIlIlIIlII in ipairs(_IlIIllIlll:GetDescendants()) do if _lIlIlIIlII:IsA("\066\097\115\101\080\097\114\116") then local _IIIIIIlIIl = _lIlIlIIlII.Name:lower() if _IIIIIIlIIl:find("\116\111\112") or _IIIIIIlIIl == "\118\111\108\099\097\110\111\116\111\112" then local _IlIlIIllll = _lIlIlIIlII.Size.X * _lIlIlIIlII.Size.Z if _IlIlIIllll > bestSize then _lIlIllllII = _lIlIlIIlII bestSize = _IlIlIIllll end
 end
 end
 end
 if _lIlIllllII then return _lIlIllllII.Position + Vector3.new(0x0, _IllIIIIlII.TP_ABOVE_TOP, 0x0) end
 local _IIlIIIIlll = -math.huge for _, _lIlIlIIlII in ipairs(_IlIIllIlll:GetDescendants()) do if _lIlIlIIlII:IsA("\066\097\115\101\080\097\114\116") then local _IIIIIIlIIl = _lIlIlIIlII.Name:lower() if _IIIIIIlIIl:find("\108\097\118\097") or _IIIIIIlIIl:find("\109\097\103\109\097") or _IIIIIIlIIl:find("\118\111\108\099\097\110") then local _lIlIlIlIII = _lIlIlIIlII.Position.Y + _lIlIlIIlII.Size.Y / 0x2 if _lIlIlIlIII > _IIlIIIIlll then _IIlIIIIlll = _lIlIlIlIII end
 end
 end
 end
 if _IIlIIIIlll > -math.huge then return Vector3.new(-5102.84, _IIlIIIIlll + _IllIIIIlII.TP_ABOVE_TOP, -3489.11) end
 return Vector3.new(-5102.84, 0xA2E4, -3489.11) end
 local function _IlIIlIlIlI() local _IllIllllII = _IlIIlIIIII.Character if not _IllIllllII then return false end
 local _lIIllIIllI = _IllIllllII:FindFirstChild("\087\111\111\100\101\110") if not _lIIllIIllI then return false end
 local _IIIlIlIIlI = _lIIllIIllI:FindFirstChild("\068\105\115\112\108\097\121\069\103\103") if not _IIIlIlIIlI then return false end
 for _, c in ipairs(_IIIlIlIIlI:GetChildren()) do if c:IsA("\077\101\115\104\080\097\114\116") and not c.Name:lower():find("\099\105\114\099\108\101") then return true, c.Name end
 end
 return false end
 local function _lIIIIlllII() local _lIlIIIlIll = _IllIIlllIl() if _lIlIIIlIll then local _IIlIIIllIl = pcall( function () _lIlIIIlIll:FireServer() end
 ) if _IIlIIIllIl then print("\091\077\085\084\065\084\073\079\078\093\032\068\114\111\112\058\032\086\111\108\099\097\110\111\068\105\112\032\102\105\114\101\100") return true end
 end
 return false end
 local function _IIIIllllII() local _IIIIIllIlI = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101"):FindFirstChild("\082\101\109\111\116\101\115") local _IIllIlIlll = _IIIIIllIlI and _IIIIIllIlI:FindFirstChild("\071\097\109\101") if not _IIllIlIlll then return false end
 local _IIIlIIIIll = _IIllIlIlll:FindFirstChild("\066\097\115\107\101\116\068\114\111\112") if not _IIIlIIIIll then return false end
 return pcall( function () _IIIlIIIIll:FireServer() end
 ) end
 local function _llIlIlIlIl(pos) local _IlIlIIlIIl = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IlIlIIlIIl then return false end
 local _lIllIlIlll = pos + Vector3.new(0x0, 0xFA, 0x0) _IlIlIIlIIl.CFrame = CFrame.new(_lIllIlIlll) _IlIlIIlIIl.Velocity = Vector3.zero _IlIlIIlIIl.AssemblyLinearVelocity = Vector3.zero print("\091\077\085\084\065\084\073\079\078\093\032\084\080\032\115\116\101\112\032\049\032\8212\032\107\101\032\097\116\097\115\032\040\114\101\110\100\101\114\032\097\109\097\110\041") task.wait(0.8) local _IllIIlIIlI = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if not _IllIIlIIlI then return false end
 _IllIIlIIlI.CFrame = CFrame.new(pos) _IllIIlIIlI.Velocity = Vector3.zero _IllIIlIIlI.AssemblyLinearVelocity = Vector3.zero print("\091\077\085\084\065\084\073\079\078\093\032\084\080\032\115\116\101\112\032\050\032\8212\032\107\101\032\116\097\114\103\101\116") task.wait(0.5) local _llllIlllll = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") if _llllIlllll and _llllIlllll.Position.Y < pos.Y - 0x32 then print("\091\077\085\084\065\084\073\079\078\093\032\075\101\099\101\098\117\114\033\032\082\101\116\114\121\032\084\080\046\046\046") _llllIlllll.CFrame = CFrame.new(pos + Vector3.new(0x0, 0x32, 0x0)) task.wait(0.4) end
 return true end
 local function _lIIlIIIlIl() _lIIIlllIll.Running = true local _llIIlllIII, _lIlllIlIIl = _IlIIlIlIlI() if not _llIIlllIII then _lIIIlllIll.Running = false _lIIIlllIll.EggLocked = false return false end
 print("\091\077\085\084\065\084\073\079\078\093\032\104\111\108\100\105\110\103\032" .. (_lIlllIlIIl or "\063") .. "\044\032\115\116\097\114\116\105\110\103") _lIIIlllIll.StealPaused = true task.wait(1.5) local _IIllIIIllI = _IIllllIlII() print("\091\077\085\084\065\084\073\079\078\093\032\083\084\069\080\032\049\032\8212\032\084\080\032\107\101\032\108\097\104\097\114\032\040\050\045\115\116\101\112\041") _llIlIlIlIl(_IIllIIIllI) task.wait(0x2) print("\091\077\085\084\065\084\073\079\078\093\032\083\084\069\080\032\050\032\8212\032\100\114\111\112\032\118\105\097\032\086\111\108\099\097\110\111\068\105\112") local _lIllIIlIll = 0x0 local _IIIllIIIIl = false _lIIIlllIll.LastFire = 0x0 while _lIllIIlIll < _IllIIIIlII.DROP_TIMEOUT do if os.clock() - _lIIIlllIll.LastFire > 0x2 then local _IIlIIIllIl = _lIIIIlllII() if not _IIlIIIllIl then _IIIIllllII() end
 _lIIIlllIll.LastFire = os.clock() print("\091\077\085\084\065\084\073\079\078\093\032\102\105\114\101\100\032\064\032" .. _lIllIIlIll .. "\115") end
 task.wait(0.5) _lIllIIlIll = _lIllIIlIll + 0.5 if not _IlIIlIlIlI() then _IIIllIIIIl = true print("\091\077\085\084\065\084\073\079\078\093\032\101\103\103\032\076\069\080\065\083\032\064\032" .. _lIllIIlIll .. "\115") break end
 end
 if not _IIIllIIIIl then print("\091\077\085\084\065\084\073\079\078\093\032\101\103\103\032\071\065\075\032\076\069\080\065\083") _lIIIlllIll.Running = false _lIIIlllIll.StealPaused = false _lIIIlllIll.EggLocked = false return false end
 print("\091\077\085\084\065\084\073\079\078\093\032\083\084\069\080\032\051\032\8212\032\116\117\110\103\103\117\032\101\103\103\032\098\097\108\105\107") local _IllIlllIll = 0x0 while _IllIlllIll < _IllIIIIlII.RETURN_TIMEOUT do task.wait(0x1) _IllIlllIll = _IllIlllIll + 0x1 if _IlIIlIlIlI() then print("\091\077\085\084\065\084\073\079\078\093\032\101\103\103\032\066\065\076\073\075\032\064\032" .. _IllIlllIll .. "\115") break end
 if _IllIlllIll % 0x5 == 0x0 then print("\091\077\085\084\065\084\073\079\078\093\032\119\097\105\116\105\110\103\046\046\046\032" .. _IllIlllIll .. "\115") end
 end
 if _lIIllIIIII.MutationReturn_Enabled then task.wait(0.5) print("\091\077\085\084\065\084\073\079\078\093\032\083\084\069\080\032\052\032\8212\032\082\101\116\117\114\110\032\107\101\032\112\108\111\116\032\040\100\114\111\112\032\043\032\112\105\099\107\117\112\032\043\032\084\080\041") local _llIIlIIllI = _lIIllIIIII.AutoReturn_Enabled _lIIllIIIII.AutoReturn_Enabled = true _IlIlIlIllI() _lIIllIIIII.AutoReturn_Enabled = _llIIlIIllI end
 task.wait(0x2) _lIIIlllIll.Running = false _lIIIlllIll.StealPaused = false _lIIIlllIll.EggLocked = false return true end
 function _IlllIIlIII.startAutoMutation() task.spawn( function () while task.wait(0x1) do if not _lIIllIIIII.AutoMutation_Enabled then _lIIIlllIll.Running = false continue end
 if _lIIIlllIll.Running then continue end
 local _lIllIIIIII = _IlIIlIIIII.Character and _IlIIlIIIII.Character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100") if not _lIllIIIIII or _lIllIIIIII.Health <= 0x0 then task.wait(0x1) continue end
 if _IlIIlIlIlI() then print("\091\077\085\084\065\084\073\079\078\093\032\101\103\103\032\104\101\108\100\044\032\115\116\097\114\116\105\110\103") pcall(_lIIlIIIlIl) task.wait(0x2) end
 end
 end
 ) end
 function _IlllIIlIII.getMutationState() return _lIIIlllIll end
 function _IlllIIlIII.isHoldingEgg() return _IlIIlIlIlI() end
 function _IlllIIlIII.startMutationSteal() task.spawn( function () while task.wait(0.5) do if not _lIIllIIIII.MutationSteal_Enabled then continue end
 if _IlllIIlIII.hasVolcanicEgg and _IlllIIlIII.hasVolcanicEgg() then task.wait(0x1) continue end
 if _IlllIIlIII.getMutationState and _IlllIIlIII.getMutationState().Running then task.wait(0x1) continue end
 local _IllIllllII = _IlIIlIIIII.Character local _IlIlIIlIIl = _IllIllllII and _IllIllllII:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116") local _lIllIIIIII = _IllIllllII and _IllIllllII:FindFirstChildOfClass("\072\117\109\097\110\111\105\100") if not _IlIlIIlIIl or not _lIllIIIIII or _lIllIIIIII.Health <= 0x0 then task.wait(0x1) continue end
 if _IlllIIlIII.isHoldingEgg and _IlllIIlIII.isHoldingEgg() then task.wait(0.5) continue end
 local _llIllIlIIl = _IlIIlIIIII:FindFirstChild("\066\097\115\107\101\116") if _llIllIlIIl and #_llIllIlIIl:GetChildren() > 0x0 then task.wait(0.5) continue end
 local _IlIlIllIIl = _IIlIllIlII() if not _IlIlIllIIl then task.wait(0.5) continue end
 local _IllIllIIIl = _IlIlIllIIl.egg local _lllllIIllI = _IllIllIIIl:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116", true) local _lIlIlllIll = _IllIllIIIl:FindFirstChild("\080\105\099\107\117\112", true) if not _lllllIIllI or not _lIlIlllIll then continue end
 if _lIlIlllIll:IsA("\080\114\111\120\105\109\105\116\121\080\114\111\109\112\116") then _lIlIlllIll.HoldDuration = 0x0 end
 local _IllIlllIll = false if _lIIllIIIII.StealMode == "\070\108\121" then _IllIlllIll = _lllIlllIll(_IllIllIIIl, _lIlIlllIll, _lllllIIllI) else _IlIlIIlIIl.CFrame = _lllllIIllI.CFrame + Vector3.new(0x0, 0x3, 0x0) task.wait(0.1) for i = 0x1, 0xF do if typeof(fireproximityprompt) == "\102\117\110\099\116\105\111\110" then pcall(fireproximityprompt, _lIlIlllIll) end
 task.wait(0.25) if not _IlIlllIlIl(_IllIllIIIl) then _IllIlllIll = true break end
 if _lllllIIllI and _lllllIIllI.Parent then _IlIlIIlIIl.CFrame = _lllllIIllI.CFrame + Vector3.new(0x0, 0x3, 0x0) task.wait(0.1) end
 end
 end
 if _IllIlllIll then print("\091\077\085\084\065\084\073\079\078\045\083\084\069\065\076\093\032\112\105\099\107\101\100\032" .. _IllIllIIIl.Name .. "\032\040" .. _IlIlIllIIl.rarity .. "\041") end
 task.wait(0.3) end
 end
 ) end
 local _IlIlIIIIII = { Enabled = false, Mode = "\077\097\120", Cooldown = 2.0, LastClick = 0x0, MaxCount = 0x0, CicilCount = 0x0, LastError = nil, } local _lIIlIIlIlI = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101") local _IlIIIlllIl = nil local _lIIlIlllll = 0x0 local function _lIIIllIllI() local _lIllIIlIIl = {} for _, _lIlIlIIlII in ipairs(_lIIlIIlIlI:GetDescendants()) do if _lIlIlIIlII:IsA("\082\101\109\111\116\101\069\118\101\110\116") or _lIlIlIIlII:IsA("\082\101\109\111\116\101\070\117\110\099\116\105\111\110") then local _IIIIIIlIIl = _lIlIlIIlII.Name:lower() if _IIIIIIlIIl:find("\117\112\103\114\097\100\101") or _IIIIIIlIIl:find("\108\117\099\107") or _IIIIIIlIIl:find("\104\097\116\099\104") then table.insert(_lIllIIlIIl, _lIlIlIIlII) end
 end
 end
 return _lIllIIlIIl end
 local function _IIllIlIlIl(mode) if not _IlIIIlllIl or #_IlIIIlllIl == 0x0 or (os.clock() - _lIIlIlllll) > 0x3C then _IlIIIlllIl = _lIIIllIllI() _lIIlIlllll = os.clock() end
 if #_IlIIIlllIl == 0x0 then return false, "\110\111\032\114\101\109\111\116\101\032\102\111\117\110\100" end
 local _lllIIIIIII if mode == "\077\097\120" then _lllIIIIIII = { {"\072\097\116\099\104\076\117\099\107", "\077\097\120"}, {"\072\097\116\099\104\076\117\099\107", true}, {"\072\097\116\099\104\076\117\099\107", 0x0}, {"\077\097\120\072\097\116\099\104\076\117\099\107"}, {"\072\097\116\099\104\076\117\099\107\077\097\120"}, {"\085\112\103\114\097\100\101", "\072\097\116\099\104\076\117\099\107", "\077\097\120"}, {"\077\097\120"}, {Action = "\077\097\120", Type = "\072\097\116\099\104\076\117\099\107"}, {Type = "\072\097\116\099\104\076\117\099\107", Max = true}, } else _lllIIIIIII = { {"\072\097\116\099\104\076\117\099\107"}, {"\072\097\116\099\104\076\117\099\107", 0x1}, {"\085\112\103\114\097\100\101", "\072\097\116\099\104\076\117\099\107"}, {Type = "\072\097\116\099\104\076\117\099\107"}, {UpgradeType = "\072\097\116\099\104\076\117\099\107"}, } end
 for _, _lIlIIIlIll in ipairs(_IlIIIlllIl) do for i, payload in ipairs(_lllIIIIIII) do pcall( function () if type(payload) == "\116\097\098\108\101" and #payload > 0x0 then _lIlIIIlIll:FireServer(table.unpack(payload)) else _lIlIIIlIll:FireServer(payload) end
 end
 ) task.wait(0.05) end
 end
 return true, "\102\105\114\101\100" end
 function _IlllIIlIII.startAutoHatchLuck() task.spawn( function () while task.wait(0.3) do if not _IlIlIIIIII.Enabled then continue end
 if os.clock() - _IlIlIIIIII.LastClick < _IlIlIIIIII.Cooldown then continue end
 _IlIlIIIIII.LastClick = os.clock() local _IIlIIIllIl, reason = _IIllIlIlIl(_IlIlIIIIII.Mode) if _IIlIIIllIl then if _IlIlIIIIII.Mode == "\077\097\120" then _IlIlIIIIII.MaxCount = _IlIlIIIIII.MaxCount + 0x1 else _IlIlIIIIII.CicilCount = _IlIlIIIIII.CicilCount + 0x1 end
 else _IlIlIIIIII.LastError = reason end
 end
 end
 ) end
 function _IlllIIlIII.getHatchLuckState() return _IlIlIIIIII end
 function _IlllIIlIII.setHatchLuckMode(mode) _IlIlIIIIII.Mode = mode _IlIlIIIIII.Cooldown = (mode == "\077\097\120") and 2.0 or 1.0 end
 function _IlllIIlIII.Init(sharedState) _lIIllIIIII = sharedState _IlllIIlIII.startAntiAFK() _IlllIIlIII.startEggESP() _IlllIIlIII.startPetESP() _IlllIIlIII.startAutoSteal() _IlllIIlIII.startAutoHatch() _IlllIIlIII.startAutoPlantEgg() _IlllIIlIII.startAutoRidePet() _IlllIIlIII.startEggPrediction() _IlllIIlIII.startSpeed() _IlllIIlIII.startInstantPickup() _IlllIIlIII.startAutoFarm() _IlllIIlIII.startVolcanicHunt() _IlllIIlIII.startAutoMutation() _IlllIIlIII.startMutationSteal() _IlllIIlIII.startAutoHatchLuck() _G.VRILZ_Features = _IlllIIlIII print("\091\086\082\073\076\090\072\085\066\093\032\082\105\100\101\032\097\032\080\101\116\032\070\101\097\116\117\114\101\115\032\118\051\046\053\032\108\111\097\100\101\100") end
 return _IlllIIlIII end
 )(...)
