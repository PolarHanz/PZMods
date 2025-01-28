--***********************************************************
--**                        POLAR HANZ                     **
--**                    Bonus exp handler                  **
--***********************************************************

require "ISBaseObject";
bonusExpUpdate = ISBaseObject:derive("bonusExpUpdate");

local AMOUNT = 250;
local PERCENT_AMOUNT = SandboxVars.BonusExp.AmountPercent or 0.2;

bonusExpUpdate.amount = AMOUNT;
bonusExpUpdate.added = false;

bonusExpUpdate.addXp = function(owner, type, amount)
    -- print("bonusExpUpdate amount - ", type," ", amount," ", bonusExpUpdate.amount," ",bonusExpUpdate.added);
	if type == Perks.TalentPoints or amount < 0 or owner:isDead() then
        return;
	end

    if bonusExpUpdate.added == true then
        bonusExpUpdate.added = false;
        return;
    end

    owner:getXp():AddXP(Perks.TalentPoints, amount * PERCENT_AMOUNT, true, false, true);
end

Events.AddXP.Add(bonusExpUpdate.addXp);

-- 42 - shift
-- 29 - ctrl
-- 56 - alt
keyMap = {
    [42] = 10,
    [29] = 100,
    [56] = 1000,
};

local pressedKey = nil;

bonusExpUpdate.OnKeyStartPressed = function(key)
    if keyMap[key] == nil then 
        return;
    end
    pressedKey = key;
    bonusExpUpdate.amount = keyMap[key];
end

bonusExpUpdate.onKeyPressed = function(key)
    if keyMap[key] == nil or key ~= pressedKey then 
        return;
    end
    pressedKey = nil;
    bonusExpUpdate.amount = AMOUNT;
end


Events.OnKeyStartPressed.Add(bonusExpUpdate.OnKeyStartPressed);
Events.OnKeyPressed.Add(bonusExpUpdate.onKeyPressed);