

local UI_Current_Selected_Skill = 1;
local SkillOnIndex = {};

function layWorld_frMakeEx_lstSkills_OnLoad(self)
	self:InsertColumn("", 221, -1, -1, -1, -1)
	
	self:RemoveAllLines(true); 
	
	local File = io.open("skills.txt", "r");
	local Index = 1
	
	while true do
		local Text = File:read();
		
		if Text == nil then
			break 
		end
		
		local SkillIndex = File:read();
		local FullName = Text.. " " .. SkillIndex;
		self:InsertLine(-1, 0, -1);
		self:SetLineItem(Index - 1, 0, FullName, 4292730333);
		SkillOnIndex[Index - 1] = Text;
		Index = Index + 1;
    end
	
	File:close();
end

function layWorld_frMakeEx_lstSkills_OnSelect(self)
	if self:getSelectLine() ~= UI_Current_Selected_Skill then
		UI_Compose_Count = 1
	end
	
	UI_Current_Selected_Skill = self:getSelectLine();
	
	local SkillIndex = SkillOnIndex[UI_Current_Selected_Skill];
	SkillIndex = tonumber(SkillIndex);
	
	local Text = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><UiRichText>	<Line>	<Items><Item text=\"Try Learn Skill\" hlink=\"String:life_skill:skill?index=" .. SkillIndex .. "\" /></Items></Line></UiRichText>";
	local edtLink = SAPI.GetSibling(self, "edtLink");
	
	edtLink:SetRichText(Text, false);
	
	local btnTalent = SAPI.GetSibling(self, "btnTalent");
	
	local skillBaseInfo = uiSkill_GetSkillBaseInfoByIndex(SkillIndex);
	
	btnTalent:Set(EV_UI_SHORTCUT_CLASSID_KEY, SkillIndex);
	btnTalent:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_SKILL);
	btnTalent:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_SKILL);
	local _sImage = SAPI.GetImage(skillBaseInfo.StrImage, 2, 2, -2, -2)
	
	if _sImage ~= nil then
		btnTalent:SetNormalImage(_sImage)
	end
	
	btnTalent:ModifyFlag("DragOut_RightButton", true)
	btnTalent:ModifyFlag("DragOut_MouseMove", true) 
	
	if btnTalent:IsHovered() then
		layWorld_frmSkillEx_frmTrumps_lbItemTalent_btnTalent_OnLClick(btnTalent);
	end
	
	LoadCheats(SAPI.GetSibling(self, "edtLinkCheats"));
end

function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function LoadCheats(self)
	self:SetRichText(readAll("cheatmenu.txt"), false);
end

