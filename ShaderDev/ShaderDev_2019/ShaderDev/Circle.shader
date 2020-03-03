// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderDev/06Circle"
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_Center ("Center", Float) = 0.5
		_Radius ("Radius", Float) = 0.5
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
			
			CGPROGRAM
			//http://docs.unity3d.com/Manual/SL-ShaderPrograms.html
			#pragma vertex vert
			#pragma fragment frag
			
			//http://docs.unity3d.com/ru/current/Manual/SL-ShaderPerformance.html
			//http://docs.unity3d.com/Manual/SL-ShaderPerformance.html
			uniform half4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _Center;
			uniform float _Radius;
			
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
				vertexOutput o;UNITY_INITIALIZE_OUTPUT(vertexOutput, o); // d3d11 requires initialization
				o.pos = UnityObjectToClipPos( v.vertex);
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}
			
			float drawLine (float2 uv, float start, float end)
			{
				if ((uv.x > start && uv.x < end) || (uv.y > start && uv.y < end))
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}
			
			float drawCircle(float2 uv, float2 center, float radius)
			{
				float circle = pow((uv.y - center.y), 2) + pow ((uv.x - center.x), 2);
				float radiusSq = pow (radius, 2);
				
				if (circle < radiusSq)
				{
					return 1;
				}
				return 0;
			}
			
			
			half4 frag(vertexOutput i) : COLOR
			{
				float4 col = tex2D(_MainTex, i.texcoord) * _Color;
				col.a = drawCircle(i.texcoord, _Center , _Radius);
				return col;
			}

			ENDCG
		}
	}
}