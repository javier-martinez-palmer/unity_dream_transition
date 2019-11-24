Shader "Hidden/DreamEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Progress ("Progress", Float) = 0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			float _Progress;
			float4 _MainTex_TexelSize;

            float2 rotate( float magnitude , float2 p )
            {
                float sinTheta = sin(magnitude);
                float cosTheta = cos(magnitude);
                float2x2 rotationMatrix = float2x2(cosTheta, -sinTheta, sinTheta, cosTheta);
                return mul(p, rotationMatrix);
            }

			fixed4 frag (v2f_img i) : SV_Target
			{
				float2 pivot=float2(0.5,0.5);
                float2 uv=float2(0,0);
				fixed4 fragColor;
				float force = (1-_Progress)/2;
				fragColor = tex2D(_MainTex, i.uv);
				
				if(force>0)
				{
					//iterate over blur samples
					for(float index=0;index<10;index++){
						//get uv coordinate of sample
						float2 uv = i.uv + float2(0, (index/9 - 0.5) * 0.1);
						//add color at position to color
						fragColor += tex2D(_MainTex, uv)*force;
					}
				}
				return fragColor;
			}
			ENDCG
		}
	}
}
