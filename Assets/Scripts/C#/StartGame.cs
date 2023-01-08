using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.Text;
using System.IO;

public class StartGame : MonoBehaviour
{

    /*  private  void Awake() {
         LuaManager.GetInstance().Init();
        LuaManager.GetInstance().DoLuaFile("Main");
    } */
    public static StartGame Instance { get; private set; }
    private Action luaStart;
    private Action luaUpdate;
    private Action luaOnDestroy;
    public LuaEnv luaEnv;
    private LuaTable scriptEnv;

    private void Awake()
    {

        Instance = this;
        luaEnv = new LuaEnv();
        luaEnv.AddLoader(LuaScriptCustomLoader);

        scriptEnv = luaEnv.NewTable();

        LuaTable meta = luaEnv.NewTable();
        meta.Set("__index", luaEnv.Global);
        scriptEnv.SetMetaTable(meta);
        meta.Dispose();

        scriptEnv.Set("self", this);
        luaEnv.DoString("require('Main')", "StartGame", scriptEnv);


        Action luaAwake = scriptEnv.Get<Action>("awake");
        scriptEnv.Get("Start", out luaStart);
        scriptEnv.Get("Update", out luaUpdate);
        scriptEnv.Get("Ondestroy", out luaOnDestroy);

        if (luaAwake != null)  luaAwake();
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

    private void Start()
    {
        if (luaStart != null) luaStart();
    }

    private void Update()
    {
        if (luaUpdate != null) luaUpdate();
    }

    private void OnDestory()
    {
        if (luaOnDestroy != null) luaOnDestroy();
        scriptEnv.Dispose();
        luaEnv.Dispose();
    }


}
