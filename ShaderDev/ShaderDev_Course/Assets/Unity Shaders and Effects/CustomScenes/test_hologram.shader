Shader "Custom/test_hologram"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DotProduct("Rim Effect", Range(-1,1))=0
		_Intensity("Rim Intensity", Range(-1,1))=1
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        LOD 200
		Cull Back
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard alpha:fade nolighting

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		float _DotProduct;
		float _Intensity;

        struct Input
        {
            float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
        };

        
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			float border =(abs(dot(IN.viewDir,
				IN.worldNormal)));
			float alpha = (border*(1 - _DotProduct) + _DotProduct);
			
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            
            o.Alpha = c.a*alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
