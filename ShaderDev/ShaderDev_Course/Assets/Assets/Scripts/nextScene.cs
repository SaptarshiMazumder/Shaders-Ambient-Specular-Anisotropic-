using UnityEngine;
using System.Collections;

public class nextScene : MonoBehaviour 
{
	int levelNum;
	int totalScenes;
	void Start () 
	{
		levelNum = Application.loadedLevel;
		totalScenes = Application.levelCount;
	}
	void Update () 
	{
		var tapCount = Input.touchCount;
		if(tapCount > 1 || Input.GetMouseButtonDown(0)) {
			levelNum += 1;
			if (levelNum >= totalScenes)
			{
				levelNum = 0;
			}
			Debug.Log(levelNum);
			Application.LoadLevelAsync(levelNum);
		}
	}
}
