Grid={}
Grid.gridObject=nil
Grid.sprite=nil
Grid.num=nil
Grid.gridnum=nil

function Grid:Init(gridPrefab,sprite,parent,num)
    if self.gridObject==nil then
        self.gridObject=Instantiate(gridPrefab) 
        self.gridObject:GetComponent(typeof(Image)).sprite=sprite
        --self.gridnum=self.gridObject:GetComponent("GridNum").Gridnum  

        self.gridObject.transform:SetParent(parent,false)
        self.num=num
    end
end
function Grid:SetSprite(sprite,num)
    self.gridObject:GetComponent(typeof(Image)).sprite=sprite
    self.num=num
end
function Grid:new()
    local obj={}
    self.__index=self
    setmetatable(obj,self)   
    return obj
end
function Grid:Destory()
    GameObject.Destroy(self.gridObject)
    self.gridObject = nil
end
