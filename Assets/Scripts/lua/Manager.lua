require("BgUI")
require("Grid")
require("InitClass")
Manager={}
local MoveSinglePositionTime=0.1
local bgUI=nil
local bgUIPrefab=nil
local gridPrefab=nil
local Spritearrey=nil
local PosXStart=80
local PosYStart=30
local mIsMarkedGrids =nil
local gridnumArrey={}

local mMoveMarkGrids  = {}

local mMoveNoMarkGrids  = {}

local mMoveSwitchGrids  = {}
local mMarkGridsList = {}
local GridArrey={}
local markGridCount=0
local GridSize=52
local RowCount=9
local mStartMoveTime =0
local SwitchTime=0.5
local mGoFirstClickGrid = nil;

local mGoSecondClickGrid = nil;
local speed=300

function Manager:CreatGrid() 
        for  i=1,12,1 do
            for j=1,9,1 do
                local go=Grid:new()
                local spritenum=math.random(1,6)
                local sprite=Spritearrey:GetSprite(spritenum)
                go:Init(gridPrefab,sprite,bgUI.content,spritenum)

                go.gridObject.transform.position=Vector3(PosXStart+i*GridSize,PosYStart+j*GridSize,0)
                go.gridObject.name=i*10+j
                if(GridArrey[i]==nil)then
                    GridArrey[i]={}
                end
                GridArrey[i][j]=go
                gridnumArrey[i*10+j]=go
            end
        end
end
function Manager:CreatBgUI()
    bgUI=BgUI:new()
    bgUI:Show(bgUIPrefab)
end
function Manager:Init()
    bgUIPrefab=ABMgr:loadres("ui","BgUI",typeof(GameObject))
    gridPrefab=ABMgr:loadres("ui","Grid",typeof(GameObject));
    Spritearrey= ABMgr:loadres("ui","Sprite",typeof(SpriteAtlas))
    self:CreatBgUI()
    self:CreatGrid()
    self:CheckAndRefresh()
end
function Manager:CheckAndRefresh()
   self:CheckAll()
   self:Refresh() 
end
function Manager:CheckAll()
    self:InitMarkGrids()
    self:RefreshGridName()
    --横向扫描
    for i=1,10,1 do
      for j=1,9,1 do
       if((GridArrey[i][j].num==GridArrey[i+1][j].num) and (GridArrey[i][j].num==GridArrey[i+2][j].num)) then
        self:MarkGrid(i, j);
        self:MarkGrid(i + 1, j);
        self:MarkGrid(i + 2, j);
       end
      end
    end
    --纵向扫描
    for i=1,12,1 do
        for j=1,7,1 do
         if((GridArrey[i][j].num==GridArrey[i][j+1].num) and (GridArrey[i][j].num==GridArrey[i][j+2].num)) then
          self:MarkGrid(i, j);
          self:MarkGrid(i , j+1);
          self:MarkGrid(i , j+2);
         end
        end
      end
end
function  Manager:MarkGrid(x,y)
    markGridCount=#mMarkGridsList[x] + 1;
    for index=0,markGridCount do
        if(mMarkGridsList[x][index]==GridArrey[x][y])then
            return
        end
    end
    if(mMarkGridsList[x][markGridCount]==nil)then
        mMarkGridsList[x][markGridCount]=GridArrey[x][y]
        mIsMarkedGrids=true
    end
end
function Manager:InitMarkGrids()
    mIsMarkedGrids = false;
    for i = 1, 12 do
        mMarkGridsList[i]={}
    end
     mMoveMarkGrids  = {};
     mMoveNoMarkGrids  = {};
end
function  Manager:Refresh()
    for col=1,12 do
       local curColMarkGridCount=#mMarkGridsList[col]
       if(curColMarkGridCount>0)then
        
           for row=1,9 do
              local notMarkDescend=0
              for k = 1, curColMarkGridCount do
                   if(GridArrey[col][row]==mMarkGridsList[col][k])then
                    notMarkDescend=0
                    break
                   end
                   --print(col,row,k,GridArrey[col][row].gridObject.transform.position,mMarkGridsList[col][k].gridObject.transform.position)
                   if(GridArrey[col][row].gridObject.transform.position.y>mMarkGridsList[col][k].gridObject.transform.position.y)then
                    notMarkDescend=notMarkDescend+1
                   end
              end
              if(notMarkDescend>0)then
                GridArrey[col][row - notMarkDescend] =GridArrey[col][row]

                local startPos = GridArrey[col][row - notMarkDescend].gridObject.transform.position;
                local endPos =  Vector3(PosXStart+col*GridSize, PosYStart+(row - notMarkDescend)*GridSize, 0)
                local time = notMarkDescend * MoveSinglePositionTime + 0.1
                 mMoveNoMarkGrids[#mMoveNoMarkGrids+1]={GridArrey[col][row - notMarkDescend],startPos,endPos,time}
              end
           end
           for i = 1, curColMarkGridCount do
                local markIndex = 0;
                  for j = 1, curColMarkGridCount do
                --按照移动前的高低放置
                     if(mMarkGridsList[col][i].gridObject.transform.position.y < mMarkGridsList[col][j].gridObject.transform.position.y) then
                         markIndex = markIndex + 1;
                    end
               end
                 GridArrey[col][9 - markIndex] =mMarkGridsList[col][i];
            end
            for row = (10 - curColMarkGridCount), 9 do

                local moveDistance = row + RowCount;
                if( row + moveDistance > 12) then
                    moveDistance = 12 - row;
                end
                --重置棋子，更换棋子游戏物体名称、位置、材质
                GridArrey[col][row].gridObject.transform.position = Vector3(PosXStart+col*GridSize, PosYStart+(row+moveDistance)*GridSize,0)
                local random = math.random(1, 6);
                local sprite=Spritearrey:GetSprite(random)
                GridArrey[col][row]:SetSprite(sprite,random)
                local startPos = GridArrey[col][row].gridObject.transform.position;
                local endPos = Vector3(PosXStart+col*GridSize, PosYStart+row*GridSize,0);
                mMoveMarkGrids[#mMoveMarkGrids + 1] ={GridArrey[col][row], startPos, endPos, SwitchTime};
            end
       end
    end
    if ((#mMoveMarkGrids > 0) or (#mMoveNoMarkGrids > 0)) then
        mStartMoveTime =CS.UnityEngine.Time.time
    end
end
function Manager:Update()

    if(#mMoveNoMarkGrids>0)then
        if(self:Move(mMoveNoMarkGrids))then
            mMoveNoMarkGrids={}
            mStartMoveTime=CS.UnityEngine.Time.time
         
        end
    
    elseif(#mMoveMarkGrids>0)then
       
        if(self:Move(mMoveMarkGrids))then
            mMoveNoMarkGrids={}
            self:CheckAndRefresh()
            mStartMoveTime=CS.UnityEngine.Time.time
            
        end
    
    elseif(#mMoveSwitchGrids > 0) then
      
        if(self:Move(mMoveSwitchGrids)) then
        mMoveSwitchGrids = {};
       
       
        self:CheckAll();
        if(mIsMarkedGrids) then
         
            self:Refresh();
           
        else
           
            self:SwtichChess();
            
        end
        self:CancelSeleted();
        

    end
    else
        self:DeadEndCheck()
        if(CS.UnityEngine.Input.GetMouseButtonDown(0)) then
            self:RaycastChess();
        end
    end
end

function Manager:Move(Grids)
    local Gridcount=#Grids
    if(Gridcount<=0)then
        return false
    end
    local finishcount=0
    for i=1,Gridcount do
       local goTarget = Grids[i][1]
        local startPos = Grids[i][2]
        local endPos = Grids[i][3]
        local time = Grids[i][4]  
      local distCovered = (Time.time - mStartMoveTime) * speed
      local journeyLength=Vector3.Distance(startPos,endPos)
       local  fractionOfJourney = distCovered / journeyLength 
       local position = Vector3.Lerp(startPos,endPos,(CS.UnityEngine.Time.time- mStartMoveTime)/time )

       goTarget.gridObject.transform.position=position
      
        if(Vector3.Distance(endPos, position) == 0) then
            finishcount = finishcount + 1;
        end
    end
    return finishcount==Gridcount
end

function Manager:RaycastChess()
    local ray = CS.UnityEngine.Camera.main:ScreenPointToRay(CS.UnityEngine.Input.mousePosition)
    
    if(CS.UnityEngine.Physics.Raycast(ray) == false) then 
        return;
    end

    local hit = CS.UnityEngine.Physics.RaycastAll(ray)[0];
    
    if(hit.transform.parent == bgUI.content) then
     

       local tt=tonumber(hit.transform.gameObject.name)   

        if(self:IsSwitchable(gridnumArrey[tt])) then
            

           self:SwtichChess()
        end
    else
    
       self:CancelSeleted();
    end
end
function  Manager:IsSwitchable(gohit)
    if(mGoFirstClickGrid==nil)then
        mGoFirstClickGrid=gohit
        mGoFirstClickGrid.gridObject:GetComponent(typeof(Image)).color = CS.UnityEngine.Color.black;
        return false
    end
   --[[ local firstsprite=mGoFirstClickGrid:GetComponent(typeof(Image)).sprite
    local gohitsprite=gohit:GetComponent(typeof(Image)).sprite ]]
    if(gohit.num==mGoFirstClickGrid.num)then
        self:CancelSeleted()
       
        return false
    end
    local Distance=Vector3.Distance(mGoFirstClickGrid.gridObject.transform.position,gohit.gridObject.transform.position)
    
    if((Distance>GridSize*1.1)or(Distance<GridSize*0.9))then
        self:CancelSeleted()
        return false
    end  
  
    mGoSecondClickGrid=gohit
    return true
end
function Manager:CancelSeleted()
    if(mGoFirstClickGrid==nil)then
        return false
    end
    mGoFirstClickGrid.gridObject:GetComponent(typeof(Image)).color = CS.UnityEngine.Color.white;
    mGoFirstClickGrid = nil;
    mGoSecondClickGrid = nil;

end
function Manager:SwtichChess ()
    if((mGoFirstClickGrid==nil)and(mGoSecondClickGrid==nil))then
        return
    end
    local posFirst = mGoFirstClickGrid.gridObject.transform.position;
    local posSecond = mGoSecondClickGrid.gridObject.transform.position;
    local firstnum=tonumber( mGoFirstClickGrid.gridObject.name)
    local firsti= math.ceil(firstnum/10)-1
    local firstj=firstnum-firsti*10
    local secondnum=tonumber( mGoSecondClickGrid.gridObject.name)
    local secondi= math.ceil(secondnum/10)-1
    local secondj=secondnum-secondi*10
    GridArrey[firsti][firstj] = mGoSecondClickGrid;
    GridArrey[secondi][secondj] = mGoFirstClickGrid;
    mStartMoveTime = CS.UnityEngine.Time.time;
    mMoveSwitchGrids[1] = {mGoFirstClickGrid, posFirst, posSecond, SwitchTime}
    mMoveSwitchGrids[2] = {mGoSecondClickGrid, posSecond, posFirst, SwitchTime}
end
function Manager:RefreshGridName()
    for i=1,#GridArrey do
        for j=1,#GridArrey[i]do
            GridArrey[i][j].gridObject.name=i*10+j
            gridnumArrey[i*10+j]=GridArrey[i][j]
        end
    end
    
end
function Manager:DeadEndCheck()
    if((self:DeadEndCheck_1())and (self:DeadEndCheck_2())) then
        self:Restart()
    end
end
function Manager:DeadEndCheck_1 ()
    local colorTable={}
    for i=1,9,1 do
        for j=1,9,1 do    
            for t=1,6,1 do
                colorTable[t]=0
            end   
            for k=0,3,1 do
                colorTable[GridArrey[i+k][j].num]=colorTable[GridArrey[i+k][j].num]+1
            end    
            for t=1,6,1 do
                if(colorTable[t]>=3)then
                    return false
                end
            end 
        end
        
    end
    for i=1,12,1 do
        for j=1,6,1 do    
            for t=1,6,1 do
                colorTable[t]=0
            end   
            for k=0,3,1 do
                colorTable[GridArrey[i][j+k].num]=colorTable[GridArrey[i][j+k].num]+1
            end    
            for t=1,6,1 do
                if(colorTable[t]>=3)then
                    return false
                end
            end 
        end
        
    end
    return true
end
function Manager: DeadEndCheck_2 ()
    for i=2,10,1 do
        for j=2,8,1 do    
            if(GridArrey[i][j].num==GridArrey[i+1][j].num)then
                if(self:RoundCheck(i,j,GridArrey[i][j].num,1))then
                    return false
                end
            end
           
        end
        
    end
    for i=2,11,1 do
        for j=2,7,1 do    
            if(GridArrey[i][j].num==GridArrey[i][j+1].num)then
                if(self:RoundCheck(i,j,GridArrey[i][j].num,2))then
                    return false
                end
            end
           
        end
        
    end
    return true
end
--marknum:横向连格为1，纵向为2
function Manager:RoundCheck(col,row,gridnum,marknum)
    if(marknum==1)then
        if((gridnumArrey[col-1][row-1].num==gridnum)or(gridnumArrey[col-1][row+1].num==gridnum)
        or(gridnumArrey[col+2][row-1].num==gridnum)or(gridnumArrey[col+2][row+1].num==gridnum))then
            return true
        end
    end
    if(marknum==2)then
        if((gridnumArrey[col-1][row-1].num==gridnum)or(gridnumArrey[col-1][row+2].num==gridnum)
        or(gridnumArrey[col+1][row-1].num==gridnum)or(gridnumArrey[col+1][row+2].num==gridnum))then
            return true
        end
    end
    return false
end
function Manager:Restart()
    for  i=1,12,1 do
        for j=1,9,1 do
           GridArrey[i][j]:Destory()
        end
    end
    self:CreatGrid()
end


