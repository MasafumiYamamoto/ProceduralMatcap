using DefaultNamespace;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

namespace Editor
{
    /// <summary>
    /// 各レイヤーのインすペクター定義
    /// </summary>
    public class ProceduralMatCapLayerDrawer : VisualElement
    {
        private const string VisualTreeAssetPath = "ProceduralMatCapEditor/ProceduralMatCapLayerDrawer";

        public ProceduralMatCapLayerDrawer(ProceduralMatcapLayer layer)
        {
            var treeAsset = Resources.Load<VisualTreeAsset>(VisualTreeAssetPath);
            var container = treeAsset.Instantiate();

            hierarchy.Add(container);
        }
    }
}