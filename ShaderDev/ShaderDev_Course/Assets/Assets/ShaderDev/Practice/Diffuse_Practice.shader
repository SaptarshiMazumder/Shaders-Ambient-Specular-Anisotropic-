Shader "Practice/Diffuse_LIghting"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "white" {}
		[KeywordEnum(On, Off)] _UseNormal ("Use normal map", Float) = 0
		_Diffuse ("Diffuse %", Range(0,1)) = 1
		[KeywordEnum(Off, Vertex, Fragment)] _Lighting("Lighting_Mode", Float) = 0


		Subshader
		{
			Tags {"LightMode" = "ForwardBase" "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			Pass
			{
				Blend SrcAlpha OneMinusSrcAlpha

				CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag
				#pragma shader_feature _USENORMAL_OFF _USENORMAL_ON
				#pragma shader_feature _LIGHTING_OFF _LIGHTING_VERT _LIGHTING_FRAG

				uniform half4 _Color;
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;

				uniform sampler2D _NormalMap;
				uniform sampler2D _NormalMap_ST;

				uniform float _Diffuse;
				uniform float4 _LightColor0;

				struct vertexInput
				{
					float4 vertex : POSITION;
					float4 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					#if _USENORMAL_ON
						float4 tangent : TANGENT;
					#endif

				};

				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float4 texcoord : TEXCOORD0;
					float4 normalWorld : TEXCOORD1;
					
					#if _USENORMAL_ON
						float4 tangentWorld : TEXCOORD2;
						float4 binormalWorld : TEXCOORD3;
						float4 normalTexCoord : TEXCOORD4;
					#endif
					#if _LIGHTING_VERT
						float4 surfaceColor : COLOR0;
					#endif
				};

				float3 normalFromColor(float4 colorVal) {
					#if defined(UNITY_NO_DXT5nm)
						return colorVal.xyz * 2 - 1;

					#else
						float3 normalVal;
						normalVal = float3(colorVal.a*2.0 - 1.0, colorVal.g*2.0 - 1.0, 0.0);
						normalVal.z = sqrt(1.0 - dot(normalVal, normalVal));
						return normalVal;
					#endif
				}

				float3 WorldNormalFromNormalMap(sampler2D normalMap, float2 normalTexCoord, float3 tangentWorld, float3 binormalWorld, float3 normalWorld)
				{
					float4 colorAtPixel = tex2D(normalMap, normalTexCoord);
					float3 normalAtPixel = normalFromColor(colorAtPixel);
					float3x3 TBNWorld = float3x3(tangentWorld, binormalWorld, normalWorld);
					return normalize(mul(normalAtPixel, TBNWorld));

				}

				float3 DiffuseLambert(float3 normalVal, float3 lightDir, float3 lightColor, float3 diffuseFactor, float attenuation)
				{
					return lightColor * diffuseFactor * attenuation * max(dot(normalVal, lightDir));
				}

				vertexOutput vert(vertexInput v)
				{
					vertexOutput o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
					o.normalWorld = normalize(mul(normalize(v.normal), float4x4(unity_WorldToObject)));

					#if _USENORMAL_ON
						o.normalTexCoord.xy = (v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw);
						o.tangentWorld = normalize(mul(float4x4(unity_ObjectToWorld), v.tangent));
						o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent);

					#endif

					#if _LIGHTING_VERT
						float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
						float3 lightColor = _LightColor0.xyz;
						float attenuation = 1;
						o.surfaceColor = float4(DiffuseLambert(o.normalWorld, lightDir, lightColor, _Diffuse, attenuation), 1);

					#endif
					return o;

				}

				half4 frag(vertexOutput i): COLOR
				{
					#if _USENORMAL_ON
						float3 worldNormalAtPixel = WorldNormalFromNormalMap(_NormalMap, i.normalTexCoord.xy, i.tangentWorld.xyz, i.binormalWorld.xyz, i.normalWorld.xyz);

					#else
						float3 worldNormalAtPixel = i.normalWorld.xyz;
					#endif

					#if _LIGHTING_FRAG
						float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
						float3 lightColor = _LightColor0.xyz;
						float attenuation = 1;
						o.surfaceColor = float4(DiffuseLambert(worldNormalAtPixel, lightDir, lightColor, _Diffuse, attenuation), 1);
					#elif _LIGHTING_VERT
						return i.surfaceColor;
					#else
						return float4(worldNormalAtPixel, 1);
					#endif
				}
				ENDCG





			}


		}




	}











}