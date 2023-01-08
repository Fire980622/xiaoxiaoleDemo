using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.UI;

public class TestAB : MonoBehaviour
{
  object [] Material;
 object []  Helmet;
   GameObject BagItem,Cube;
    GameObject go;
    GameObject content;
    GameObject b;
    Button t;

    // Start is called before the first frame update
    void Start()
    {    b=GameObject.FindGameObjectWithTag("Button");
     content=GameObject.FindGameObjectWithTag("BagPanel"); 
       t=b.GetComponent<Button>();
       t.onClick.AddListener(AddItem);      
    }
     void Awake() {
        loadFrom();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
   public void AddItem(){
        GameObject go1= Instantiate(BagItem);
        Image image=go1.GetComponentInChildren<Image>();
        image.sprite=(Sprite)Material[1];                                         
        go1.transform.SetParent(content.transform); 
        go1.SetActive(true);  
        go.SetActive(false);   
    }
    void loadFrom(){
        string path="Assets/StreamingAssets/uiprefab";
      
        AssetBundle myBundle=AssetBundle.LoadFromFile(path);
       AssetBundleManifest mainManifest = myBundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
       // string [] myBundleDepArrey=mainManifest.GetAllDependencies("uiprefab");
       /* for(int i=0;i<myBundleDepArrey.Length;i++){
            AssetBundle.LoadFromFile(Application.streamingAssetsPath+"/"+myBundleDepArrey[i]);
        } */
         go=myBundle.LoadAsset<GameObject>("BagUI") ;
         BagItem=myBundle.LoadAsset<GameObject>("BagItem");
        Material=myBundle.LoadAssetWithSubAssets("Material");
        Helmet=myBundle.LoadAssetWithSubAssets("Helmet");
        
        
        
        Instantiate(go);
       

        
    }
}
