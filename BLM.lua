local profile = {};
local player = gData.GetPlayer();
local action = nil;
local fastCastValue = 0.0;
local minimumBuffer = 0.2;
local packetDelay = 0.4;

local ElementalStaffTable = {
    ["Fire"] = "Fire Staff",
    ["Earth"] = "Earth Staff",
    ["Water"] = "Water Staff",
    ["Wind"] = "Wind Staff",
    ["Ice"] = "Aquilo's Staff",
    ["Thunder"] = "Thunder Staff",
    ["Light"] = "Light Staff",
    ["Dark"] = "Dark Staff"
};

local sets = {
    idle = {
        Main = "Earth Staff",
        Ammo = "Phtm. Tathlum",
        Neck = "Elemental Torque",
        Ear1 = "Morion Earring",
        Ear2 = "Morion Eraring",
        Body = "Black Cloak",
        Hands = "Igqira Manillas",
        Ring1 = "Eremite's Ring",
        Ring2 = "Eremite's Ring",
        Back = "Cheviot Cape",
        Waist = 'Heko Obi +1',
        Legs = "Wizard's Tonban",
        Feet = "Wizard's Sabots",
    },
    nuke = {
        --Main = "Yew Wand +1",
        --Sub = "Yew Wand +1",
        Ammo = "Phtm. Tathlum",
        Head = "Wizard's Petasos",
        Body = "Igqira Weskit",
        Hands = "Igqira Manillas",
        Waist = "Mrc.Cpt. Belt",
        Legs = "Errant Slops",
        Feet = "Wizard's Sabots",
        Back = "Rainbow Cape",
        Neck = "Philomath Stole",
        Ear1 = "Morion Earring",
        Ear2 = "Moldavite Earring",
        Ring1 = "Diamond Ring",
        Ring2 = "Diamond Ring"
    },
    INT = {
        Ammo = "Phtm. Tathlum",
        Head = "Wizard's Petasos",
        Body = "Errant Hpl.",
        Hands = "Errant Cuffs",
        Waist = "Mrc.Cpt. Belt",
        Legs = "Errant Slops",
        Feet = "Wizard's Sabots",
        Back = "Rainbow Cape",
        Neck = "Philomath Stole",
        Ear1 = "Morion Earring",
        Ear2 = "Morion Earring",
        Ring1 = "Diamond Ring",
        Ring2 = "Diamond Ring"
    },
    enfeebleINT = {
        Ammo = "Phtm. Tathlum",
        Head = "Igqira Tiara",
        Body = "Wizard's Coat",
        Hands = "Errant Cuffs",
        Waist = "Mrc.Cpt. Belt",
        Legs = "Errant Slops",
        Feet = "Wizard's Sabots",
        Back = "Rainbow Cape",
        Neck = "Enfeebling Torque",
        Ear1 = "Morion Earring",
        Ear2 = "Morion Earring",
        Ring1 = "Diamond Ring",
        Ring2 = "Diamond Ring"
    },
    enfeebleMND = {
        --Ammo = "",
        Head = "Igqira Tiara",
        Body = "Wizard's Coat",
        Hands = "Seer's Mitts",
        Waist = "Mrc.Cpt. Belt",
        Legs = "Errant Slops",
        Feet = "Seer's Pumps",
        Back = "Rainbow Cape",
        Neck = "Enfeebling Torque",
        --Ear1 = "",
        --Ear2 = "",
        Ring1 = "Saintly Ring",
        Ring2 = "Saintly Ring"
    },
    drain = {
        legs="Wizard's Tonban",
    },
    fastCast = {

    },
    spellInterruptionDown = {
        Main = "Hermit's Wand",
        Sub = "Varlet's Targe",
        Waist = "Heko Obi +1",
        Feet = "Wizard's Sabots",
        Back = "Cheviot Cape"
    }
};


profile.Sets = sets;

profile.Packer = {
};


-- Begin Helpers
function exists(...)
    local ret = {}
    for _,k in ipairs({...}) do ret[k] = true end
    return ret
end

function resetCommonVars()
    player = gData.GetPlayer();
    action = gData.GetAction();
    fastCastValue = 0.0;
end
-- End Helpers

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.tp);
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.resting);
    else
        gFunc.EquipSet(sets.idle);
    end
end

profile.HandleWeaponskill = function()
    local action = gData.GetAction();
    
    if (action.Name == 'Savage Blade') then
        --gFunc.EquipSet(sets.SavageBlade);
    elseif (action.Name == 'Sanguine Blade') then
        --gFunc.EquipSet(sets.SanguineBlade);
    elseif (action.Name == 'Spirits Within') then
        --gFunc.EquipSet(sets.SpiritsWithin);
    else
        --gFunc.EquipSet(sets.DefaultWeaponskill);
    end
end

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.fastCast);
end

profile.HandleMidcast = function()
    resetCommonVars();
    
    if (player.SubJob == "RDM") then
        if player.SubJobLevel >= 35 then
            fastCastValue = fastCastValue + 0.15
        elseif player.SubJobLevel >= 15 then
            fastCastValue = fastCastValue + 0.10
        end
    end

    print("Fast Cast Set to "..(fastCastValue * 100).."%");

    local castDelay = ((action.CastTime * (1 - fastCastValue)) / 1000) - minimumBuffer;

    if (castDelay >= packetDelay) then
        gFunc.SetMidDelay(castDelay);
    end

    gFunc.InterimEquipSet(sets.spellInterruptionDown);

    if exists("Cure", "Cure II", "Cure III", "Cure IV", "Cure V")[action.Name] then
    
    elseif exists("Stone", "Stone II", "Stone III", "Stone IV", "Stonega", "Stonega II", "Stonega III", "Quake", "Quake II",
                  "Water", "Water II", "Water III", "Water IV", "Waterga", "Waterga II", "Waterga III", "Flood", "Flood II",
                  "Aero", "Aero II", "Aero III", "Aero IV", "Aeroga", "Aeroga II", "Aeroga III", "Tornado", "Tornado II",
                  "Fire", "Fire II", "Fire III", "Fire IV", "Firaga", "Firaga II", "Firaga III", "Flare", "Flare II",
                  "Blizzard", "Blizzard II", "Blizzard III", "Blizzard IV", "Blizzaga", "Blizzaga II", "Blizzaga III", "Freeze", "Freeze II",
                  "Thunder", "Thunder II", "Thunder III", "Thunder IV", "Thundaga", "Thundaga II", "Thundaga III", "Burst", "Burst II"
                )[action.Name] then
        gFunc.EquipSet(sets.nuke);
    elseif exists("Bind", "Gravity", "Sleep", "Sleep II", "Sleepga", "Sleepga II", "Blind", "Break", "Breakga")[action.Name] then
        gFunc.EquipSet(sets.enfeebleINT);
    elseif exists("Slow", "Paralyze", "Silence", "Repose")[action.Name] then
        gFunc.EquipSet(sets.enfeebleMND);
    elseif exists("Stun", "Drain", "Drain II", "Aspir", "Bio", "Bio II")[action.Name] then
        gFunc.EquipSet(sets.enfeebleINT);
        gFunc.EquipSet(sets.drain);
    elseif exists("Burn", "Choke", "Rasp", "Shock", "Frost", "Drown") then
        gFunc.EquipSet(sets.INT);
    end

    if (exists("Enfeebling Magic", "Elemental Magic", "Divine Magic", "Dark Magic", "Healing Magic")[action.Skill] ) then
        gFunc.Equip('main', ElementalStaffTable[action.Element]);
    end

end

profile.HandleAbility = function()
end

profile.HandleDefault = function()
end

profile.HandleItem = function()
end

return profile;