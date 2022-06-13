using System.Collections.Generic;
using DefaultNamespace;
using Editor;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;

/// <summary>
///     MaterialEditorだとnamespaceが使えないロックな説があるので一旦コメントアウト
/// </summary>
// namespace ProceduralMatCap.Editor
// {
public class ProceduralMatCapInspector : MaterialEditor
{
    [SerializeField] private VisualTreeAsset treeAsset;

    private readonly List<ProceduralMatCapLayer> _layers = new();
    private VisualElement _layerView;

    /// <summary>
    ///     マテリアルへのアクセス
    /// </summary>
    private Material Material => target as Material;

    private int LayerNumId => Shader.PropertyToID("_LayerNum");

    public override VisualElement CreateInspectorGUI()
    {
        var rootElement = new VisualElement();
        _layerView = new VisualElement();
        rootElement.Bind(serializedObject);
        treeAsset.CloneTree(rootElement);

        var layerNum = Material.GetInt(LayerNumId);
        var layerNumField = rootElement.Q<SliderInt>("LayerNum");
        layerNumField.value = layerNum;
        // 自力で初期化
        UpdateLayerComponent(layerNum);
        UpdateLayerView();

        // レイヤー数が変わった際にビューに更新が入るようにいい感じに調整
        layerNumField.RegisterValueChangedCallback(e => UpdateLayerComponent(e.newValue));

        rootElement.Add(_layerView);

        return rootElement;
    }

    /// <summary>
    ///     レイヤー用のビューを動的に構築する
    /// </summary>
    private void UpdateLayerView()
    {
        _layerView.Clear();
        foreach (var layer in _layers) _layerView.Add(new ProceduralMatCapLayerDrawer(layer));
    }

    /// <summary>
    ///     レイヤー用変数の中身を更新する
    /// </summary>
    private void UpdateLayerComponent(int layerNum)
    {
        _layers.Clear();
        Material.SetInt(LayerNumId, layerNum);
        for (var i = 0; i < layerNum; i++) _layers.Add(new ProceduralMatCapLayer(Material, i));
        UpdateLayerView();
    }
}
// }