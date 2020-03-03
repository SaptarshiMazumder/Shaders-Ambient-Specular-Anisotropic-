// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderDev/12Outline"
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_Outline("Outline", Float) = 0.1
		_OutlineColor("Outline Color",Color) = (1,1,1,1)
		
	}
	
	Subshader
	{
		//http://docs.unity3d.com/462/Documentation/Manual/SL-SubshaderTags.html
	    // Background : 1000     -        0 - 1499 = Background
        // Geometry   : 2000     -     1500 - 2399 = Geometry
        // AlphaTest  : 2450     -     2400 - 2699 = AlphaTest
        // Transparent: 3000     -     2700 - 3599 = Transparent
        // Overlay    : 4000     -     3600 - 5000 = Overlay
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Front
			Zwrite off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform half _Outline;
			uniform half4 _OutlineColor;
			
			//https://msdn.microsoft.com/en-us/library/windows/desktop/bb509647%28v=vs.85%29.aspx#VS
			struct vertexInput
			{
				float4 vertex : POSITION;
			};
			
			struct vertexOutput
			{
				float4 pos : SV_POSITION; 
			};
			
			float4 Outline(float4 vertPos, float outline)
			{
				float4x4 scaleMat;
				scaleMat[0][0] = 1.0 + outline;
				scaleMat[0][1] = 0.0;
				scaleMat[0][2] = 0.0;
				scaleMat[0][3] = 0.0;
				scaleMat[1][0] = 0.0;
				scaleMat[1][1] = 1.0 + outline;
				scaleMat[1][2] = 0.0;
				scaleMat[1][3] = 0.0;
				scaleMat[2][0] = 0.0;
				scaleMat[2][1] = 0.0;
				scaleMat[2][2] = 1.0 + outline;
				scaleMat[2][3] = 0.0;
				scaleMat[3][0] = 0.0;
				scaleMat[3][1] = 0.0;
				scaleMat[3][2] = 0.0;
				scaleMat[3][3] = 1.0;	
				return mul(scaleMat, vertPos);
			}
			
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(Outline(v.vertex,_Outline));
				return o;
			}
			
			half4 frag(vertexOutput i) : COLOR
			{
				return _OutlineColor;
			}
			
			ENDCG
		}
		
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			//http://docs.unity3d.com/Manual/SL-ShaderPrograms.html
			#pragma vertex vert
			#pragma fragment frag
			
			//http://docs.unity3d.com/ru/current/Manual/SL-ShaderPerformance.html
			//http://docs.unity3d.com/Manual/SL-ShaderPerformance.html
			uniform half4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			
			//https://msdn.microsoft.com/en-us/library/windows/desktop/bb509647%28v=vs.85%29.aspx#VS
			struct vertexInput
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0; 
			};
			
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o; UNITY_INITIALIZE_OUTPUT(vertexOutput, o); // d3d11 requires initialization
				o.pos = UnityObjectToClipPos( v.vertex);
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}
			
			half4 frag(vertexOutput i) : COLOR
			{
				return tex2D(_MainTex, i.texcoord) * _Color;
			}
			ENDCG
		}
	}
}