using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AssetBundleManager :BaseManager<AssetBundleManager>
{ 
     private AssetBundle mainAB = null;//主包
    private AssetBundleManifest mainManifest = null;//获取依赖包的配置文件

    //存储加载过的AB包
    private Dictionary<string, AssetBundle> abDict = new Dictionary<string, AssetBundle>();
    string path="Assets/StreamingAssets/";
    private void LoadAB(string abName) {
       // AssetBundle ab=null;
        if (!abDict.ContainsKey(abName)) {
            mainAB = AssetBundle.LoadFromFile(path + abName);
            mainManifest = mainAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
            abDict.Add(abName, mainAB);
        } 
       
    }
    public T LoadRes<T>(string abName, string resName) where T : Object {
        //加载AB包
      
        LoadAB(abName);

        //加载资源
        T obj = abDict[abName].LoadAsset<T>(resName);
        if (obj is GameObject) {
            return GameObject.Instantiate(obj);
        } else {
            return obj;
        }
    }
    public Object loadres(string abName, string resName) {
        
        //加载AB包
        LoadAB(abName);

        //加载资源
        Object obj = abDict[abName].LoadAsset(resName);
        if (obj is GameObject) {
            return Instantiate(obj);
        } else {
            return obj;
        }
       
    }
    public Object loadres(string abName, string resName, System.Type objType) {
        //加载AB包
        LoadAB(abName);

        //加载资源
        Object obj = abDict[abName].LoadAsset(resName, objType);
        return obj;
       /*  if (obj is GameObject) {
            return Instantiate(obj);
        } else { 
            return obj;
           
        } */
    }

}
