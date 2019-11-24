Shader "Hidden/DreamTransition"
{
    Properties
    {
    _MainTex("Texture", 2D) = "white" {}
    _Speed("Speed", float) = 500
    _Pivot("", Vector) = (0.5, 0.5, 1.0, 1.0)

    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            name "Dream"
            Cull Off ZWrite Off
            ZTest Always Lighting Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _MotionTex;
            float _Speed;
            fixed4 _Pivot;

            float2 rotate( float magnitude , float2 p )
            {
                float sinTheta = sin(magnitude);
                float cosTheta = cos(magnitude);
                float2x2 rotationMatrix = float2x2(cosTheta, -sinTheta, sinTheta, cosTheta);
                return mul(p, rotationMatrix);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv=float2(0,0);
                
                //spiral effect
                // center
                float2 p = i.uv - _Pivot.xy;
                // distance to center
                float r = 1-sqrt(dot(p,p));
                // rotate
                uv += rotate(r*_Time*_Speed, p);
                // move back and make sure its inside the screen
                uv = clamp(uv + _Pivot.xy, float2(0,0), float2(1,1));
                
                //noise
                //uv += (3 * sin(_Time) * cos(uv.y), 3 * cos(_Time) * sin(uv.x) );

                fixed4 fragColor = tex2D(_MainTex, uv);
                //_BlendAmount
                //fixed4 fragColor = fixed4(lerp(tex2D(_MainTex, uv).rgb, tex2D(_TransitionTex, uv).rgb, 0.5), 1.0);
  
                //face to white
                float rel = sin(_Time);//clamp(_Time/100000,0,1);
                fragColor = fragColor;// + (rel,rel,rel,1.0);//clamp(fragColor + (rel,rel,rel,1.0),float4(0,0,0,0),float4(1,1,1,1));

                return fragColor;

            }
            ENDCG
        }
    }
}
