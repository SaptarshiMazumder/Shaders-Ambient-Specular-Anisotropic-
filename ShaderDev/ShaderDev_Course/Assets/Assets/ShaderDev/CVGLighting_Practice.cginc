#ifndef CVGLIGHTING_PRACTICE
#define CVGLIGHTING_PRACTICE


float3 normalFromColor (float4 colorVal)
			{
				#if defined(UNITY_NO_DXT5nm)
					return colorVal.xyz * 2 - 1;
				#else
					// R => x => A
					// G => y
					// B => z => ignored
					
					float3 normalVal;
					normalVal = float3 (colorVal.a * 2.0 - 1.0,
										colorVal.g * 2.0 - 1.0,
										0.0);
					normalVal.z = sqrt(1.0 - dot(normalVal, normalVal));
					return normalVal;
				#endif
			}


float3 WorldNormalFromNormalMap(sampler2D normalMap, float2 normalTexCoord, float3 tangentWorld, float3 binormalWorld, float3 normalWorld)
			{
				float4 colorAtPixel = tex2D(normalMap, normalTexCoord);

				// Normal value converted from Color value
				float3 normalAtPixel = normalFromColor(colorAtPixel);

				// Compose TBN matrix

				float3x3 TBNWorld = float3x3(tangentWorld, binormalWorld, normalWorld);

				//Correction : float3x3 TBNWorld = float3x3(i.tangentWorld.xyz, i.binormalWorld.xyz, i.normalWorld.xyz);
				return normalize(mul(normalAtPixel, TBNWorld));
				
			}

#endif