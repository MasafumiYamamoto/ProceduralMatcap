using DefaultNamespace;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;

namespace Editor
{
    /// <summary>
    ///     各レイヤーのインすペクター定義
    /// </summary>
    public class ProceduralMatCapLayerDrawer : VisualElement
    {
        private const string VisualTreeAssetPath = "ProceduralMatCapEditor/ProceduralMatCapLayerDrawer";

        public ProceduralMatCapLayerDrawer(ProceduralMatCapLayer layer)
        {
            var treeAsset = Resources.Load<VisualTreeAsset>(VisualTreeAssetPath);
            var container = treeAsset.Instantiate();

            // フィールドの取得
            var labelField = container.Q<Foldout>("Label");
            var colorField = container.Q<ColorField>("Color");
            var centerUVField = container.Q<Vector2Field>("CenterUV");
            var fadePowerField = container.Q<Slider>("FadePower");
            var matCapField = container.Q<ObjectField>("MatCap");
            var layerBlendTypeField = container.Q<EnumField>("LayerBlendType");
            var sphereRadiusField = container.Q<Slider>("SphereRadius");

            // 初期値の反映
            labelField.text = $"Layer {layer.Index}";
            matCapField.value = layer.MatCap;
            layerBlendTypeField.value = layer.BlendType;
            sphereRadiusField.value = layer.SphereRadius;
            colorField.value = layer.Color;
            centerUVField.value = layer.CenterUV;
            fadePowerField.value = layer.FadePower;

            // コールバック登録
            matCapField.RegisterValueChangedCallback(e => layer.MatCap = e.newValue as Texture);
            layerBlendTypeField.RegisterValueChangedCallback(e => layer.BlendType = (LayerBlendType)e.newValue);
            sphereRadiusField.RegisterValueChangedCallback(e => layer.SphereRadius = e.newValue);
            colorField.RegisterValueChangedCallback(e => layer.Color = e.newValue);
            centerUVField.RegisterValueChangedCallback(e => layer.CenterUV = e.newValue);
            fadePowerField.RegisterValueChangedCallback(e => layer.FadePower = e.newValue);


            hierarchy.Add(container);
        }
    }
}