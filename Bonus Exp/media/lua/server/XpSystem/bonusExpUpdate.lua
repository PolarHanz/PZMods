--***********************************************************
--**                        POLAR HANZ                     **
--**                    Bonus exp handler                  **
--***********************************************************

require "ISBaseObject";
bonusExpUpdate = ISBaseObject:derive("bonusExpUpdate");

local AMOUNT = 250;

bonusExpUpdate.amount = AMOUNT;
bonusExpUpdate.added = false;

bonusExpUpdate.addXp = function(owner, type, amount)
    --print("bonusExpUpdate amount - ", type," ", amount," ", bonusExpUpdate.amount," ",bonusExpUpdate.added);
	if type == Perks.TalentPoints or amount < 0 then
        return;
	end

    if bonusExpUpdate.added == true then
        bonusExpUpdate.added = false;
        return;
    end

    -- amount приходит полным с множителями, но почему-то addXp добавляет 25% от amount. Вероятно из-за отсутстсвия влияния глобального мультиплаера для перков.
    addXp(owner, Perks.TalentPoints, amount);
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