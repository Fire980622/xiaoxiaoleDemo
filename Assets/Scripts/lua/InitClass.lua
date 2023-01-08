
require("Object")
--Unity相关
GameObject = CS.UnityEngine.GameObject
Resources = CS.UnityEngine.Resources
Transform = CS.UnityEngine.Transform
RectTransform = CS.UnityEngine.RectTransform
Vector2 = CS.UnityEngine.Vector2
Vector3 = CS.UnityEngine.Vector3
TextAsset = CS.UnityEngine.TextAsset
Time=CS.UnityEngine.Time
--图集对象类
SpriteAtlas = CS.UnityEngine.U2D.SpriteAtlas
SpriteRenderer= CS.UnityEngine.SpriteRenderer
--UI相关
UI = CS.UnityEngine.UI
Image = UI.Image
Button = UI.Button
Text = UI.Text
Toggle = UI.Toggle
ScrollRect = UI.ScrollRect
UIBehaviour = CS.UnityEngine.EventSystems.UIBehaviour
Instantiate=CS.UnityEngine.GameObject.Instantiate
--1
ABMgr = CS.AssetBundleManager.Instance()--直接得到ABMge的单例对象
WaitForSeconds=CS.UnityEngine.WaitForSeconds