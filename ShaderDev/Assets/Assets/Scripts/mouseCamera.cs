using UnityEngine;

//[AddComponentMenu("Camera-Control/Mouse")]
public class mouseCamera : MonoBehaviour
{
	public GameObject center;
	public float sentitivity;
	void LateUpdate ()
	{
		if (Input.GetMouseButton(0)) {
			Debug.Log ("Left");
			transform.RotateAround (center.transform.position, Vector3.up, Input.GetAxis ("Mouse X") * Time.deltaTime * sentitivity);
			//transform.RotateAround (center.transform.position, Vector3.left, Input.GetAxis ("Mouse Y") * Time.deltaTime * sentitivity);
		}
	}


}