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

				float force = (1.0f-_Progress)*2; //prepare passed tween value
				fixed4 fragColor = tex2D(_MainTex, i.uv);
				
				if(force>0)
				{
					//spiral 
					// center
					float2 p = i.uv - pivot.xy;
					// distance to center
					float r = 1-sqrt(dot(p,p)); //1-
					// rotate
					uv += rotate(r*pow(1.1,force*100), p);
					// move back and make sure its inside the screen
					uv = clamp(uv + pivot.xy, float2(0,0), float2(1,1));
					//
					fragColor = tex2D(_MainTex, uv);
					//blur
					for(float index=0;index<10;index++){
						//get uv coordinate of sample
						float2 buv = uv + float2(0, (index/9 - 0.5) * 0.1);
						//add color at position to color
						fragColor += tex2D(_MainTex, buv)*force;
					}
				}
				return fragColor;
			}
			ENDCG
		}
	}
}
