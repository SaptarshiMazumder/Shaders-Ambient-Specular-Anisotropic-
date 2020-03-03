// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderDev/11NormalMap"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "white" {}


	}

		Subshader
	{

		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		Pass{

			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform half4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			
			struct vertexInput 
			{
				float4 vertex: POSITION;
				float4 normal: NORMAL;
				float4 tangent: TANGENT;
				float4 texcoord: TEXCOORD0;

			};
			
			struct vertexOutput
			{
				float4 pos: SV_POSITION;
				float4 texcoord: TEXCOORD0;
				float4 normalTexCoord: TEXCOORD4;
				float4 normalWorld: TEXCOORD1;
				float4 tangentWorld: TEXCOORD2;
				float3 binormalWorld: TEXCOORD3;

			};

			float3 normalFromColor(float4 colorVal) 
			{
				#if defined(UNITY_NO_DXT5nm)
					return colorVal.xyz * 2 - 1;
				#else
					float3 normalVal;
					normalVal = float3(colorVal.a * 2.0 -1, colorVal.g * 2.0 - 1, 0.0);
					normalVal.z = sqrt(1.0 - dot(normalVal, normalVal));
					return normalVal;
				#endif 

			}

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o; 
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				o.normalTexCoord.xy = (v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw);

				//World space T B N
				o.normalWorld = normalize(mul(v.normal, unity_WorldToObject));
				o.tangentWorld = normalize(mul(v.tangent, unity_ObjectToWorld));
				o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent );
				return o;
			}

			half4 frag(vertexOutput i) : COLOR
			{
				float4 ColorAtPixel = tex2D(_NormalMap, i.normalTexCoord);
				float3 normalAtPixel = normalFromColor(ColorAtPixel);
				float3x3 TBNWorld = float3x3(i.tangentWorld, i.binormalWorld, i.normalWorld);
				float3 worldNormalAtPixel = normalize(mul(normalAtPixel, TBNWorld));
				return worldNormalAtPixel;
				//return tex2D(_MainTex, i.texcoord) * _Color;
				
			}


			ENDCG


		}



	}





}