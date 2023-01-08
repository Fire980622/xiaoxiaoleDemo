using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class LuaCopyEditor : Editor
{
    [MenuItem("Lua打包/删除.txt后缀lua脚本")]
    public static void DeleteLuaTxt()
    {
        string curPath = Application.dataPath + "/LuaTxt/";
        if (Directory.Exists(curPath))
        {
            string[] txtFilePaths = Directory.GetFiles(curPath, "*.txt");
            string[] metaFilePaths = Directory.GetFiles(curPath, "*.meta");
            for (int i = 0; i < txtFilePaths.Length; i++)
            {
                File.Delete(txtFilePaths[i]);
                File.Delete(metaFilePaths[i]);
            }
            Debug.Log("删除成功");
        }
        // 刷新asset文件夹
        AssetDatabase.Refresh();
    }

    [MenuItem("Lua打包/生成.txt后缀lua脚本")]
    public static void CopyLuaToTxt()
    {
        string files = Application.dataPath + "/Scripts/C#/";
        if (Directory.Exists(files))
        {
            // 得到所有lua文件路径
            string[] filePaths = Directory.GetFiles(files, "*.lua");
            // 复制到一个新文件夹
            string newPath = Application.dataPath + "/Scripts/C#/";
            if (!Directory.Exists(newPath))
                Directory.CreateDirectory(newPath);
            string fileName = "";
            for (int i = 0; i < filePaths.Length; i++)
            {
                fileName = newPath + filePaths[i].Substring(filePaths[i].LastIndexOf("/") + 1) + ".txt";
                File.Copy(filePaths[i], fileName);
            }
            Debug.Log("生成成功");
        }
        // 刷新asset文件夹
        AssetDatabase.Refresh();
    }

    
}

