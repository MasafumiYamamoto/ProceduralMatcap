Shader "Unlit/ProceduralMatCap"
{
    Properties
    {
        _LayerNum ("Total Layer Num", int) = 1
        
        // 0レイヤー
        _MatCap0 ("MatCap 0", 2D) = "white" {}
        _Color0 ("Color 0", Color) = (1,1,0,1)
        _CenterUV0 ("CenterUV 0", Vector) = (0.5, 0.5, 0, 0)
        _SphereRadius0 ("Radius 0", float) = 0.2
        _LayerBlendType0 ("Layer Bledn Type 0", int) = 0
        _FadePower0 ("Fade Power 0", float) = 0.5
        
        // 1レイヤー
        _MatCap1 ("MatCap 0", 2D) = "white" {}
        _Color1 ("Color 0", Color) = (1,1,0,1)
        _CenterUV1 ("CenterUV 0", Vector) = (0.5, 0.5, 0, 0)
        _SphereRadius1 ("Radius 0", float) = 0.2
        _LayerBlendType1 ("Layer Bledn Type 0", int) = 0
        _FadePower1 ("Fade Power 0", float) = 0.5
        
        _MatCap2 ("MatCap 0", 2D) = "white" {}
        _Color2 ("Color 0", Color) = (1,1,0,1)
        _CenterUV2 ("CenterUV 0", Vector) = (0.5, 0.5, 0, 0)
        _SphereRadius2 ("Radius 0", float) = 0.2
        _LayerBlendType2 ("Layer Bledn Type 0", int) = 0
        _FadePower2 ("Fade Power 0", float) = 0.5
        
        _MatCap3 ("MatCap 0", 2D) = "white" {}
        _Color3 ("Color 0", Color) = (1,1,0,1)
        _CenterUV3 ("CenterUV 0", Vector) = (0.5, 0.5, 0, 0)
        _SphereRadius3 ("Radius 0", float) = 0.2
        _LayerBlendType3 ("Layer Bledn Type 0", int) = 0
        _FadePower3 ("Fade Power 0", float) = 0.5
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

            sampler2D _MatCap1;
            float4 _Color1;
            int _LayerBlendType1;
            float _SphereRadius1;
            float2 _CenterUV1;
            float _FadePower1;

            sampler2D _MatCap2;
            float4 _Color2;
            int _LayerBlendType2;
            float _SphereRadius2;
            float2 _CenterUV2;
            float _FadePower2;

            sampler2D _MatCap3;
            float4 _Color3;
            int _LayerBlendType3;
            float _SphereRadius3;
            float2 _CenterUV3;
            float _FadePower3;
            
            struct layer_info
            {
                float4 mat_cap_color;
                float4 color;
                int layer_blend_type;
                float sphere_radius;
                float2 center_uv;
                float fade_power;
            };

            // レイヤーの情報を詰めるだけ
            layer_info SetupLayerInfo(const int layerIndex, const float2 uv)
            {
                layer_info layer;
                if(layerIndex == 0){
                    layer.mat_cap_color = tex2D(_MatCap0, uv);
                    layer.color = _Color0;
                    layer.layer_blend_type = _LayerBlendType0;
                    layer.sphere_radius = _SphereRadius0;
                    layer.center_uv = _CenterUV0;
                    layer.fade_power = _FadePower0;
                    return layer;
                }

                if(layerIndex == 1){
                    layer.mat_cap_color = tex2D(_MatCap1, uv);
                    layer.color = _Color1;
                    layer.layer_blend_type = _LayerBlendType1;
                    layer.sphere_radius = _SphereRadius1;
                    layer.center_uv = _CenterUV1;
                    layer.fade_power = _FadePower1;
                    return layer;
                }

                if(layerIndex == 2){
                    layer.mat_cap_color = tex2D(_MatCap2, uv);
                    layer.color = _Color2;
                    layer.layer_blend_type = _LayerBlendType2;
                    layer.sphere_radius = _SphereRadius2;
                    layer.center_uv = _CenterUV2;
                    layer.fade_power = _FadePower2;
                    return layer;
                }

                layer.mat_cap_color = tex2D(_MatCap3, uv);
                layer.color = _Color3;
                layer.layer_blend_type = _LayerBlendType3;
                layer.sphere_radius = _SphereRadius3;
                layer.center_uv = _CenterUV3;
                layer.fade_power = _FadePower3;

                return layer;
            }

            // レイヤーの情報を適用
            float4 ApplyLayer(const layer_info layer, const float2 uv, const float4 color)
            {
                // 一旦UVが範囲内にいるか確認して_Colorを乗算してみる
                const float distance = length(uv - layer.center_uv);
                const float ratio = distance/layer.sphere_radius;
                const float attenuation = clamp((1-ratio)/(layer.fade_power + 0.001), 0, 1);
                const half4 finalLayerColor = layer.mat_cap_color * attenuation * layer.color;
                float4 res = color;
                switch (layer.layer_blend_type)
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
                    const layer_info layer = SetupLayerInfo(i, input.uv);
                    col = ApplyLayer(layer, input.uv, col);
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
