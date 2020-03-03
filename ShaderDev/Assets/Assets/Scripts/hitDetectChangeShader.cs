using UnityEngine;
using System.Collections;
 
public class hitDetectChangeShader : MonoBehaviour {

	// Use this for initialization
	private Shader outlineShader;
	void Start () {
		outlineShader = Shader.Find ("Temp/11Outline");
	}
	
	// Update is called once per frame
	void Update () {
		if ( Input.GetMouseButtonDown(0))
		{
			RaycastHit hit;
			Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
			
			if (Physics.Raycast (ray, out hit, 100.0f))
			{  
				hit.collider.gameObject.GetComponent<rotateObj>().rotation.x = 0.2f;
				Transform parent = hit.collider.gameObject.transform.parent;
				for (int i=0;i < parent.childCount;i++)
				{
					GameObject childObj = parent.GetChild(i).gameObject;
					childObj.GetComponent<rotateObj>().rotation.x = 0;
					childObj.GetComponent<Renderer>().sharedMaterial.shader = Shader.Find ("Standard");
				}
				GameObject gameObj = hit.collider.gameObject;
				Material mat = gameObj.GetComponent<Renderer>().material;
				gameObj.GetComponent<rotateObj>().rotation.x = 2.2f;
				mat.shader = outlineShader;
				mat.SetFloat("_Outline", 0.1f);
				//mat.SetColor("_OutlineColor", mat.GetColor("_Color"));

			}
		}
	}
}
