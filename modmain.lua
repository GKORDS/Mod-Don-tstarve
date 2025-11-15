local GLOBAL = GLOBAL
local TUNING = GLOBAL.TUNING

local MAP_WIDE_RANGE = 2048

local catapult_tuning_keys = {
    "WINONA_CATAPULT_ATTACK_RANGE",
    "WINONA_CATAPULT_ATTACK_RANGE_BUFFER",
    "WINONA_CATAPULT_MIN_RANGE",
    "WINONA_CATAPULT_MAX_RANGE",
    "WINONA_CATAPULT_TARGET_DIST",
    "WINONA_CATAPULT_RANGE",
}

for _, key in ipairs(catapult_tuning_keys) do
    if TUNING[key] ~= nil then
        TUNING[key] = MAP_WIDE_RANGE
    end
end

if TUNING.WINONA_REMOTE_RANGE ~= nil then
    TUNING.WINONA_REMOTE_RANGE = MAP_WIDE_RANGE
end
if TUNING.WINONA_BATTERY_RANGE ~= nil then
    TUNING.WINONA_BATTERY_RANGE = MAP_WIDE_RANGE
end
if TUNING.WINONA_REMOTE_FAR_TARGET ~= nil then
    TUNING.WINONA_REMOTE_FAR_TARGET = MAP_WIDE_RANGE
end

local function ExtendCatapult(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    if inst.components.combat ~= nil then
        inst.components.combat:SetRange(MAP_WIDE_RANGE)
        if inst.components.combat.SetKeepTargetFunction ~= nil then
            inst.components.combat:SetKeepTargetFunction(function() return true end)
        end
        if inst.components.combat.SetHitRange ~= nil then
            inst.components.combat:SetHitRange(MAP_WIDE_RANGE)
        end
    end

    if inst.components.weapon ~= nil then
        inst.components.weapon:SetRange(MAP_WIDE_RANGE)
    end

    if inst.components.playerprox ~= nil then
        inst.components.playerprox:SetDist(MAP_WIDE_RANGE, MAP_WIDE_RANGE)
    end

    if inst.components.turret ~= nil then
        if inst.components.turret.SetRange ~= nil then
            inst.components.turret:SetRange(MAP_WIDE_RANGE)
        end
        if inst.components.turret.SetTargetDist ~= nil then
            inst.components.turret:SetTargetDist(MAP_WIDE_RANGE)
        end
    end
end

AddPrefabPostInit("winona_catapult", ExtendCatapult)

local function RemoteInfiniteRange(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    local spellcaster = inst.components.spellcaster
    if spellcaster ~= nil then
        local old_spell_fn = spellcaster.spell
        if old_spell_fn ~= nil then
            spellcaster:SetSpellFn(function(item, doer, target, pos)
                if old_spell_fn ~= nil then
                    return old_spell_fn(item, doer, target, pos)
                end
            end)
        end
    end
end

AddPrefabPostInit("winona_remote", RemoteInfiniteRange)
