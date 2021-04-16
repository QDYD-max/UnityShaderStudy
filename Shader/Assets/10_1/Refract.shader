// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Refract"
{
	Properties
	{
		_Color ("Color Tint", Color) = (1,1,1,1)
		_RefractColor ("Refract Color", Color) = (1,1,1,1)
		_RefractAmount ("Refract Amount", Range(0, 1)) = 1
		_RefractRatio ("Refract Ratio", Range(0.1, 1)) = 0.5
		_CubeMap ("Cube Map", Cube) = "_Skybox" {}
	}
	SubShader
	{

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _Color;
			fixed4 _RefractColor;
			fixed _RefractAmount;
			fixed _RefractRatio;
			samplerCUBE _CubeMap;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 worldViewDir : TEXCOORD2;
				float3 worldRefr : TEXCOORD3;
				SHADOW_COORDS(4)
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);

				o.worldRefr = refract(-normalize(o.worldViewDir),normalize(o.worldNormal),_RefractRatio);

				TRANSFER_SHADOW(o);

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = normalize(i.worldViewDir);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT;

				fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldViewDir,worldLightDir));

				fixed3 refraction = texCUBE(_CubeMap, i.worldRefr).rgb * _RefractColor.rgb;

				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

				return fixed4( ambient + lerp(diffuse, refraction, _RefractAmount) * atten,1.0);
			}
			ENDCG
		}
	}
	Fallback "Off"
}
