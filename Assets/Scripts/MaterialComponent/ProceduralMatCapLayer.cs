using UnityEngine;

namespace DefaultNamespace
{
    /// <summary>
    ///     レイヤーのブレンド方法指定
    /// </summary>
    public enum LayerBlendType
    {
        /// <summary>
        ///     アルファブレンド
        /// </summary>
        AlphaBlend = 0,

        /// <summary>
        ///     加算
        /// </summary>
        Additive = 1,

        /// <summary>
        ///     乗算
        /// </summary>
        Multiplicative = 2
    }

    /// <summary>
    ///     ProceduralMatCapが持つ一つのレイヤー
    /// </summary>
    public class ProceduralMatCapLayer
    {
        /// <summary>
        ///     レイヤーの担当するインデックス
        /// </summary>
        private readonly int _index;

        private readonly Material _material;
        private Vector2 _centerUV;
        private Color _color;
        private float _fadePower;
        private LayerBlendType _layerBlendType;

        private Texture _matCap;
        private float _sphereRadius;

        public ProceduralMatCapLayer(Material material, int index)
        {
            _material = material;
            _index = index;
            MatCap = material.GetTexture(MatCapId);
            Color = material.GetColor(ColorId);
            BlendType = (LayerBlendType)material.GetInt(BlendTypeId);
            SphereRadius = material.GetFloat(SphereRadiusId);
            CenterUV = material.GetVector(CenterUVId);
            FadePower = material.GetInt(FadePowerId);
        }

        /// <summary>
        ///     UV座標系でのレイヤーが定義する球の中心
        /// </summary>
        public Vector2 CenterUV
        {
            get => _centerUV;
            set
            {
                _centerUV = value;
                SetCenterUV(_centerUV);
            }
        }

        /// <summary>
        ///     全体に乗っかる色
        /// </summary>
        public Color Color
        {
            get => _color;
            set
            {
                _color = value;
                SetColor(_color);
            }
        }

        /// <summary>
        ///     レイヤーが定義する球の半径
        /// </summary>
        public float SphereRadius
        {
            get => _sphereRadius;
            set
            {
                _sphereRadius = value;
                SetSphereRadius(_sphereRadius);
            }
        }

        /// <summary>
        ///     ベースとなるテクスチャ
        /// </summary>
        public Texture MatCap
        {
            get => _matCap;
            set
            {
                _matCap = value;
                SetMatCap(_matCap);
            }
        }

        /// <summary>
        ///     レイヤーのブレンド方法指定
        /// </summary>
        public LayerBlendType BlendType
        {
            get => _layerBlendType;
            set
            {
                _layerBlendType = value;
                SetLayerBlendType(_layerBlendType);
            }
        }

        /// <summary>
        ///     フェード強度
        /// </summary>
        public float FadePower
        {
            get => _fadePower;
            set
            {
                _fadePower = value;
                SetFadePower(_fadePower);
            }
        }

        private int MatCapId => Shader.PropertyToID($"_MatCap{_index}");
        private int ColorId => Shader.PropertyToID($"_Color{_index}");
        private int BlendTypeId => Shader.PropertyToID($"_LayerBlendType{_index}");
        private int SphereRadiusId => Shader.PropertyToID($"_SphereRadius{_index}");
        private int CenterUVId => Shader.PropertyToID($"_CenterUV{_index}");
        private int FadePowerId => Shader.PropertyToID($"_FadePower{_index}");

        private void SetMatCap(Texture texture)
        {
            _material.SetTexture(MatCapId, texture);
        }

        private void SetColor(Color color)
        {
            _material.SetColor(ColorId, color);
        }

        private void SetLayerBlendType(LayerBlendType blendType)
        {
            _material.SetInt(BlendTypeId, (int)blendType);
        }

        private void SetSphereRadius(float radius)
        {
            _material.SetFloat(SphereRadiusId, radius);
        }

        private void SetCenterUV(Vector2 uv)
        {
            _material.SetVector(CenterUVId, uv);
        }

        private void SetFadePower(float fadePower)
        {
            _material.SetFloat(FadePowerId, fadePower);
        }
    }
}