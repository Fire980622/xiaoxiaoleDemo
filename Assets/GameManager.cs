using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class GameManager : MonoBehaviour
{
    public GameObject grid;
    public Sprite[] sprites;

    // Start is called before the first frame update
    void Start()
    {
        for(int x=0;x<10;x++){
            for(int y=0;y<9;y++){

                GameObject g=Instantiate(grid,new Vector3(x-5,y-4,0),Quaternion.identity);
                int i=Random.Range(0,5);
                g.GetComponentInChildren<SpriteRenderer>().sprite=sprites[i];
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
