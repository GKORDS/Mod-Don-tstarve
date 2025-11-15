local GLOBAL = GLOBAL
local TUNING = GLOBAL.TUNING

local MAP_WIDE_RANGE = 2048

local catapult_tuning_keys = {
    "WINONA_CATAPULT_ATTACK_RANGE",
    "WINONA_CATAPULT_ATTACK_RANGE_BUFFER",
    "WINONA_CATAPULT_MIN_RANGE",
    "WINONA_CATAPULT_MAX_RANGE",
    "WINONA_CATAPULT_TARGET_DIST",
 codex/modify-winona-catapult-and-remote-for-global-control-ct091g
}

for _, key in ipairs(catapult_tuning_keys) do
    if type(TUNING[key]) == "number" then
=======
    "WINONA_CATAPULT_RANGE",
}

for _, key in ipairs(catapult_tuning_keys) do
    if TUNING[key] ~= nil then
 main
        TUNING[key] = MAP_WIDE_RANGE
    end
end

 codex/modify-winona-catapult-and-remote-for-global-control-ct091g
if type(TUNING.WINONA_REMOTE_RANGE) == "number" then
    TUNING.WINONA_REMOTE_RANGE = MAP_WIDE_RANGE
end
if type(TUNING.WINONA_BATTERY_RANGE) == "number" then
    TUNING.WINONA_BATTERY_RANGE = MAP_WIDE_RANGE
end
if type(TUNING.WINONA_REMOTE_FAR_TARGET) == "number" then
=======
if TUNING.WINONA_REMOTE_RANGE ~= nil then
    TUNING.WINONA_REMOTE_RANGE = MAP_WIDE_RANGE
end
if TUNING.WINONA_BATTERY_RANGE ~= nil then
    TUNING.WINONA_BATTERY_RANGE = MAP_WIDE_RANGE
end
if TUNING.WINONA_REMOTE_FAR_TARGET ~= nil then
 main
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

 codex/modify-winona-catapult-and-remote-for-global-control-ct091g
local function IsRangeFailureReason(reason)
    if reason == nil then
        return true
    end

    local reason_type = type(reason)
    if reason_type == "string" then
        local lowered = reason:lower()
        return lowered:find("range", 1, true) ~= nil
            or lowered:find("distance", 1, true) ~= nil
            or lowered:find("far", 1, true) ~= nil
    elseif reason_type == "table" then
        -- Spell failure reasons sometimes arrive as tables with a message field.
        if type(reason.message) == "string" then
            local lowered = reason.message:lower()
            return lowered:find("range", 1, true) ~= nil
                or lowered:find("distance", 1, true) ~= nil
                or lowered:find("far", 1, true) ~= nil
        end
    end

    return false
end

local function RemoteInfiniteRange(inst)
    if GLOBAL.TheWorld.ismastersim then
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

            local old_can_cast_fn = spellcaster.spelltestfn
            spellcaster:SetCanCastFn(function(doer, target, pos, item)
                if old_can_cast_fn ~= nil then
                    local result, reason = old_can_cast_fn(doer, target, pos, item)
                    if result or not IsRangeFailureReason(reason) then
                        return result, reason
                    end
                end
                return true
            end)
        end
    end

    if inst.replica ~= nil and inst.replica.spellcaster ~= nil and inst.replica.spellcaster.SetCanCastFn ~= nil then
        inst.replica.spellcaster:SetCanCastFn(function()
            return true
        end)
=======
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
 codex/modify-winona-catapult-and-remote-for-global-control-pmoybu

        local old_can_cast_fn = spellcaster.spelltestfn
        spellcaster:SetCanCastFn(function(doer, target, pos, item)
            if old_can_cast_fn ~= nil then
                local result, reason = old_can_cast_fn(doer, target, pos, item)
                if result then
                    return result, reason
                end
            end
            return true
        end)

        if inst.replica ~= nil and inst.replica.spellcaster ~= nil and inst.replica.spellcaster.SetCanCastFn ~= nil then
            inst.replica.spellcaster:SetCanCastFn(function()
                return true
            end)
        end
=======
 main
 main
    end
end

AddPrefabPostInit("winona_remote", RemoteInfiniteRange)
