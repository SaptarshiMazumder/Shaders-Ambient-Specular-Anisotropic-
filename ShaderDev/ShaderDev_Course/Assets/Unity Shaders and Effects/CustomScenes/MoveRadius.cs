using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class MoveRadius : MonoBehaviour
{
    // Start is called before the first frame update
    public Material RadiusMaterial;
    public float radius = 1;
    public Color color = Color.white;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(RadiusMaterial!=null)
        {
            RadiusMaterial.SetVector("_Center", transform.position);
            RadiusMaterial.SetFloat("_Radius", radius);
            RadiusMaterial.SetColor("_RadiusColor", color);
        }
    }
}
