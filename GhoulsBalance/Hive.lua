local networkVars = {
	isMotherHive = "boolean"
}

if Server then
	local oldOnCreate = Hive.OnCreate
	function Hive:OnCreate()
		oldOnCreate(self)

		self.isMotherHive = false
	end

	local oldSetFirstLogin = Hive.SetFirstLogin
	function Hive:SetFirstLogin()
		self.isMotherHive = true
	end
end

function Hive:GetIsMotherHive()
	return self.isMotherHive
end

local oldGetTechAllowed = Hive.GetTechAllowed
function Hive:GetTechAllowed(techId, techNode, player)
	local allowed, canAfford = oldGetTechAllowed(self, techId, techNode, player)

	if techId == kTechId.ResearchBioMassThree then
		allowed = allowed and self:GetIsMotherHive() and self.bioMassLevel == 3
	end

	return allowed, canAfford
end

local oldGetTechButtons = Hive.GetTechButtons
function Hive:GetTechButtons()
	local techButtons = oldGetTechButtons(self)

	if self.bioMassLevel == 3 and self:GetIsMotherHive() then
		techButtons[2] = kTechId.ResearchBioMassThree
	end

	local techId = self:GetTechId()
	if techId == kTechId.CragHive then
		techButtons[5] = kTechId.DrifterRegeneration
	elseif techId == kTechId.ShiftHive then
		techButtons[5] = kTechId.DrifterCelerity
	elseif techId == kTechId.ShadeHive then
		techButtons[5] = kTechId.DrifterCamouflage
    end

	return techButtons
end

local oldUpdateResearch = Hive.UpdateResearch
function Hive:UpdateResearch()
	oldUpdateResearch(self)

	local researchId = self:GetResearchingId()
	if researchId == kTechId.ResearchBioMassThree then
		self.biomassResearchFraction = self:GetResearchProgress()
	end
end

Class_Reload("Hive", networkVars)
