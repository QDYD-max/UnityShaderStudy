// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "KeRui/MotionBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlurAmount ("Blur Anount", Float) = 1.0
	}
	SubShader
	{
		CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float _BlurAmount;

		struct v2f
		{
			float2 uv : TEXCOORD0;
			float4 pos : SV_POSITION;
		};

		v2f vert(appdata_img v){
			v2f o;
			
			o.pos = UnityObjectToClipPos(v.vertex);

			o.uv = v.texcoord;

			return o;
		}

		fixed4 fragRGB(v2f i) : SV_Target{
			return fixed4(tex2D(_MainTex, i.uv).rgb, _BlurAmount);
		}


		fixed4 fragA(v2f i) : SV_Target{
			return tex2D(_MainTex, i.uv);
		}

		ENDCG

		ZTest Always Cull Off ZWrite Off
		
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			
			CGPROGRAM
			
			#pragma vertex vert  
			#pragma fragment fragRGB  
			
			ENDCG
		}
		
		Pass {   
			Blend One Zero
			ColorMask A
			   	
			CGPROGRAM  
			
			#pragma vertex vert  
			#pragma fragment fragA
			  
			ENDCG
		}
	}
	FallBack Off
}
