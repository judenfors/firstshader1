Shader "Unlit/Fire"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float x = 1-uv.y;
                uv.y -= _Time.x *8.0;
                float y = tex2D(_MainTex, uv).r;
                float s1 = step(y,x);
                float s2 = step(y,x-0.2);
                float step1 = s1-s2;
                float3 col = lerp(float3(1.0,1.0,0.0), float3(1.0,0.0,0.0), step1);
                float s3 = step(y, x-0.4);
                float step2 = s2-s3;
                col = lerp(col, float3(1.0,0.5,0.0),step2);


                //float4 col = float4(s1,s1,s1,1.0);
                return float4(col,s1);
            }
            ENDCG
        }
    }
}
