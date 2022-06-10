Shader "Unlit/ProceduralMatCap"
{
    Properties
    {
        _LayerNum ("Layer Num", int) = 1
        _MatCap ("MatCap", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,0,1)
        _CenterUV ("CenterUV", Vector) = (0.5, 0.5, 0, 0)
        _Radius0 ("Radius 0", float) = 0.2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MatCap;
            float4 _Color;
            float2 _CenterUV;
            float _Radius0;

            float4 ApplyLayer(const int layerIndex, const float2 uv, const float4 color)
            {
                // 一旦UVが範囲内にいるか確認して_Colorを乗算してみる
                const float distance = length(uv - _CenterUV);
                return color * (distance < _Radius0 ? _Color : 1);
            }

            v2f vert (const appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // カメラ座標系での法線を取得
                float3 normal = UnityObjectToWorldNormal(v.normal);
                normal = mul((float3x3) UNITY_MATRIX_V, normal);

                // 法線のxyを[-1,1]から[0,1]に変換する
                o.uv = normal.xy * 0.5 + 0.5;

                return o;
            }

            fixed4 frag (const v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MatCap, i.uv);
                col = ApplyLayer(0, i.uv, col);
                return col;
            }
            ENDCG
        }
    }
//    CustomEditor "ProceduralMatCap.Editor.ProceduralMatCapInspector"
//    CustomEditor "ShaderGUICustomInspector"
     CustomEditor "ProceduralMatCapInspector"
}
