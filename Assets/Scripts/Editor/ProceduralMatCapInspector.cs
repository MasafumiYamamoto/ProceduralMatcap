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

    /// <summary>
    ///     マテリアルへのアクセス
    /// </summary>
    private Material material => target as Material;

    public override VisualElement CreateInspectorGUI()
    {
        var rootElement = new VisualElement();
        rootElement.Bind(serializedObject);
        treeAsset.CloneTree(rootElement);
        return rootElement;
    }
}
// }