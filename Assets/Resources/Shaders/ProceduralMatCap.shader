Shader "Unlit/ProceduralMatCap"
{
    Properties
    {
        _LayerNum ("Total Layer Num", int) = 1
        _MatCap0 ("MatCap 0", 2D) = "white" {}
        _Color0 ("Color 0", Color) = (1,1,0,1)
        _CenterUV0 ("CenterUV 0", Vector) = (0.5, 0.5, 0, 0)
        _SphereRadius0 ("Radius 0", float) = 0.2
        _LayerBlendType0 ("Layer Bledn Type 0", int) = 0
        _FadePower0 ("Fade Power 0", float) = 0.5
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

            int _LayerNum;
            
            // 各レイヤーでのパラメータ
            sampler2D _MatCap0;
            float4 _Color0;
            int _LayerBlendType0;
            float _SphereRadius0;
            float2 _CenterUV0;
            float _FadePower0;

            float4 ApplyLayer(const int layerIndex, const float2 uv, const float4 color)
            {
                // 一旦UVが範囲内にいるか確認して_Colorを乗算してみる
                const float distance = length(uv - _CenterUV0);
                const float ratio = distance/_SphereRadius0;
                const float attenuation = clamp((1-ratio)/(_FadePower0 + 0.001), 0, 1);
                const float4 matCapColor = tex2D(_MatCap0, uv);
                const half4 finalLayerColor = matCapColor * attenuation * _Color0;
                float4 res = color;
                switch (_LayerBlendType0)
                {
                case 0:
                    // アルファブレンド
                    res.rgb = lerp(color.rgb, finalLayerColor.rgb, finalLayerColor.a);
                    break;
                case 1:
                    // 加算
                    res.rgb += finalLayerColor.rgb * finalLayerColor.a;
                    break;
                case 2:
                    // 乗算
                    res.rgb *= lerp(1, finalLayerColor.rgb, finalLayerColor.a);
                    break;
                default:
                    // NOTE:一旦想定外の値が来たら真っ白にする
                    res.rgb = 1;
                    break;
                }
                return res;
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

            fixed4 frag (const v2f input) : SV_Target
            {
                // sample the texture
                float4 col = 0;
                for (int i = 0; i < _LayerNum; i++)
                {
                    col = ApplyLayer(0, input.uv, col);
                }
                return col;
            }
            ENDCG
        }
    }
//    CustomEditor "ProceduralMatCap.Editor.ProceduralMatCapInspector"
//    CustomEditor "ShaderGUICustomInspector"
     CustomEditor "ProceduralMatCapInspector"
}
