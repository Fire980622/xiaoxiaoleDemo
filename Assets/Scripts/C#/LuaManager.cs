using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;

public class LuaManager : SingletonManager<LuaManager>
{
   public LuaEnv luaEnv=null;

   public void Init() {
        if (luaEnv != null) return;
        luaEnv = new LuaEnv();
        luaEnv.AddLoader(LuaScriptCustomLoader);
    }

    public void DoLuaFile(string fileName){
        string str = string.Format("require('{0}')", fileName);
        luaEnv.DoString(str);
    }
    private byte[] LuaScriptCustomLoader(ref string filePsth)
    {
        string path = Application.dataPath + "/Scripts/lua/" + filePsth + ".Lua";
        if (File.Exists(path))
        {
            return File.ReadAllBytes(path);
        }
        else
        {
            Debug.Log("/Scripts/Lua/路径重定向失败：" + filePsth);
            return null;
        }
    }


}
