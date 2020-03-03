Shader "Custom/ToonCell"
{
    Properties
    {
        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		
		_CelShadingLevels("Levels", Range(0,10)) = 4

        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf ToonCel

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		

        struct Input
        {
            float2 uv_MainTex;
        };
		fixed _CelShadingLevels;
        

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		fixed4 LightingToonCel(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half NdotL = max(0, dot(s.Normal, lightDir));
			half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);
			
			half4 color;
			color.rgb = s.Albedo * _LightColor0 * cel * atten;
			color.a = s.Alpha;
			return color;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
           
        }
        ENDCG
    }
    FallBack "Diffuse"
}
