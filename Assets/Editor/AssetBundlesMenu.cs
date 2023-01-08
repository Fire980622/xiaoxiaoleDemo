using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class AssetBundlesMenu : MonoBehaviour
{
      [MenuItem("Export/Build AssetBundles")]
    // Start is called before the first frame update
    static void CreatAssetBundlesMain(){
    if(!Directory.Exists(Application.dataPath+"/StreamingAssets")){
        Directory.CreateDirectory(Application.dataPath+"/StreamingAssets");
    }
    BuildPipeline.BuildAssetBundles("Assets/StreamingAssets",BuildAssetBundleOptions.DeterministicAssetBundle,BuildTarget.StandaloneLinux64);

   }
}
