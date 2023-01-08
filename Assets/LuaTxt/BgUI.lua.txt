require("Grid")
BgUI={}
BgUI.PanelObject=nil
BgUI.content=nil
function BgUI:Init(name)
    if self.PanelObject==nil then
        self.PanelObject=Instantiate(name)
        self.content=self.PanelObject.transform:Find("Content"):GetComponent(typeof(Transform))
    end
    
end
function BgUI:Show(BgUIPrefab)
   
    self:Init(BgUIPrefab)
    self.PanelObject:SetActive(true)
    
end

function BgUI:new()
    local obj={}
    self.__index=self
    setmetatable(obj,self)   
    return obj
end