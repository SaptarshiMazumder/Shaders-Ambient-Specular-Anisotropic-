Shader "DiffusePracticeP1"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_NormalMap("Normal Map", 2D) = "bump" {}
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_Shininess("Shininess", Range(1,10)) = 1
		_AmbientFactor("Ambient factor", Range(0,10)) = 1
		
	}

		SubShader
	{
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform float4 _LightColor0;
			uniform float4 _Color;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			uniform float4 _SpecularColor;
			uniform float Shininess;
			uniform float _AmbientFactor;

			struct vertexInput {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				float4 tangemt : TANGENT;
				float4 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
				float4 posWorld : TEXCOORD0;
				float4 tex : TEXCOORD1;
				float4 tangentWorld : TEXCOORD3;
				float4 normalWorld : TEXCOORD4;
				float3 binormalWorld : TEXCOORD5;
			};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.tangentWorld = normalize(mul(unity_ObjectToWorld, float4x4(v.tangemt.xyz, 1.0)).xyz);
				//o.tangentWorld = (normalize(mul(float3x3(unity_ObjectToWorld), v.tangemt.xyz)), v.tangemt.w);
				o.tangentWorld = normalize(mul(float4x4(unity_ObjectToWorld), v.tangemt));
				//o.normalWorld = normalize(mul(float4x4(v.normal), unity_WorldToObject).xyz);
				o.normalWorld = normalize(mul(normalize(v.normal), float4x4(unity_WorldToObject)));
				//o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld)*v.tangemt.w);
				o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * v.tangemt);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.tex = v.texcoord;
				float4 normalDir = normalize(mul(v.normal, float4x4(unity_WorldToObject)));
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseLighting = _Color.rgb * _LightColor0.rgb * max(0, dot(normalDir, lightDir));
				o.col = float4(diffuseLighting, 1.0);
				return o;
			}

			half4 frag(vertexOutput i) : COLOR
			{
				float4 normalColor = tex2D(_NormalMap, _NormalMap_ST * i.tex.xy + i.tex.zw);
				float3 localNormal = float3(2.0 * normalColor.a - 1, 2.0 * normalColor.g - 1, 0.0);
				localNormal.z = sqrt(1 - dot(localNormal, localNormal));
				float3x3 TBN = float3x3(i.tangentWorld.xyz, i.binormalWorld.xyz, i.normalWorld.xyz);
				float3 worldNormalDir = normalize(mul(localNormal, TBN));
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.posWorld.xyz);
				float3 lightDir;
				float attenuation;
				if (0.0 == _WorldSpaceLightPos0.w)
				{
					attenuation == 0;
					lightDir = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSOurce = _WorldSpaceLightPos0 - i.posWorld.xyz;
					float distance = length(vertexToLightSOurce);
					attenuation = 1.0 / distance;
					lightDir = normalize(vertexToLightSOurce);
				}
				//lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb * _AmbientFactor ;
				float3 diffuseRefl = attenuation * _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormalDir, lightDir));
				float3 specularRefl = attenuation * _LightColor0.rgb * _Color.rgb * pow(max(0, dot(reflect(-lightDir, worldNormalDir), viewDir)), Shininess);
				return float4(ambientLighting + diffuseRefl + specularRefl, 1.0);
					
				//return i.col;

			}

				ENDCG







	}

		Pass
		{
			Tags{"LightMode" = "ForwardAdd"}
			Blend One One

			CGPROGRAM

			#pragma vertex vert  
			#pragma fragment frag 

			#include "UnityCG.cginc"

			uniform float4 _LightColor0;
			uniform float4 _Color;

			struct vertexInput 
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				float4 normalDir = normalize(mul(v.normal, float4x4(unity_WorldToObject)));
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseLighting2 = _LightColor0.rgb * _Color.rgb * max(0, dot(normalDir, lightDir));
				o.col = float4(diffuseLighting2, 1.0);
				return o;

			}
			half4 frag(vertexOutput i):COLOR
			{
				return i.col;
			}

			ENDCG
			
			
			
			
		}




	}


















}