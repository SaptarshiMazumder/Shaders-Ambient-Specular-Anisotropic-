using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections;

public class vectors : MonoBehaviour{

	// Use this for initialization
	public Transform vectorA;
	public Transform vectorB;
	public Transform CrossProduct;
	public Transform resultantPoint;

	public float DotProduct;
	public InputField DotText;

	public Vector3 VectorAngleA;
	public Vector3 VectorAngleB;


	
	// Update is called once per frame
	void Update()
	{
		Calculate ();


	}
	void Calculate () {

		VectorAngleA = vectorA.GetChild(0).position;
		VectorAngleB = vectorB.GetChild(0).position;

		resultantPoint.position = Vector3.Cross (VectorAngleA, VectorAngleB);//(angleC.x,angleC.y,angleC.z);
		CrossProduct.LookAt(resultantPoint); 

		DotProduct = Round(Vector3.Dot (VectorAngleA, VectorAngleB),2);//(angleC.x,angleC.y,angleC.z);
		DotText.text = DotProduct.ToString();
		VectorAngleA = Round(VectorAngleA, 2);
		VectorAngleB = Round(VectorAngleB, 2);

	}
	public Vector3 Round(Vector3 value, int decimalPlaces) {
		value.x = Round(value.x, decimalPlaces);
		value.y = Round(value.y, decimalPlaces);
		value.z = Round(value.z, decimalPlaces);
		return value;
	}

	public float Round(float value, int decimalPlaces) {
		value = Mathf.Round(value * Mathf.Pow(10, decimalPlaces));
		return value / Mathf.Pow (10, decimalPlaces);
	}


	public Vector3 VectorAngles(Vector3 angles)
	{
		angles.x = VectorAngles (angles.x);
		angles.y = VectorAngles (angles.y);
		angles.z = VectorAngles (angles.z);
		return NormalizeVector(angles);
	}

	public float VectorAngles(float angle)
	{
		angle = PositiveAngle(angle);
		Debug.Log (angle);
		if (angle > 0 && angle <= 90) 
		{
			angle = NormalizeRange(angle, new Vector3(0,90), new Vector3(1,0));
		}
		else if (angle > 90 && angle <= 180) 
		{
			angle = NormalizeRange(angle, new Vector3(90,180), new Vector3(0,-1));
		} 
		else if (angle > 180 && angle <= 270) 
		{
			angle = NormalizeRange(angle, new Vector3(180,270), new Vector3(-1,0));
		} 		
		else if (angle > 270 && angle <= 360) 
		{
			angle = NormalizeRange(angle, new Vector3(270,360), new Vector3(0,1));
		}
		return angle;
	}

	public Vector3 PositiveAngle(Vector3 angles)
	{
		angles.x = PositiveAngle (angles.x);
		angles.y = PositiveAngle (angles.y);
		angles.z = PositiveAngle (angles.z);
		return angles;
	}

	public float PositiveAngle(float angle)
	{
		if (angle < 0) 
		{
			angle += 360;
		}
		return angle;
	}

	public Vector3 NormalizeRange(Vector3 value, Vector2 sourceRange, Vector2 targetRange)
	{
		Vector3 finalValue = new Vector3 ();
		finalValue.x = 1 + (value.x - sourceRange.x) * (targetRange.y - targetRange.x) / (sourceRange.y - sourceRange.x);
		finalValue.y = 1 + (value.y - sourceRange.x) * (targetRange.y - targetRange.x) / (sourceRange.y - sourceRange.x);
		finalValue.z = 1 + (value.z - sourceRange.x) * (targetRange.y - targetRange.x) / (sourceRange.y - sourceRange.x);
		return finalValue;
	}

	public float NormalizeRange(float value, Vector2 sourceRange, Vector2 targetRange)
	{
		return 1 + (value - sourceRange.x) * (targetRange.y - targetRange.x) / (sourceRange.y - sourceRange.x);
	}

	public Vector3 NormalizeVector(Vector3 v)
	{
		return Mathf.Sqrt(Vector3.Dot(v,v))*v;
	}
}
