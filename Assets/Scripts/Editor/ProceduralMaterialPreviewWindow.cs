using UnityEditor;
using UnityEngine;

namespace Editor
{
    /// <summary>
    ///     編集中のProceduralMatCapをプレビューするための画面
    /// </summary>
    public class ProceduralMaterialPreviewWindow : EditorWindow
    {
        private GameObject _currentTarget;
        private Material _targetMaterial;
        private UnityEditor.Editor _targetMaterialEditor;

        private void OnGUI()
        {
            _targetMaterial = (Material)EditorGUILayout.ObjectField(_targetMaterial, typeof(Material), true);

            var bgColor = new GUIStyle
            {
                normal =
                {
                    background = EditorGUIUtility.whiteTexture
                }
            };

            if (_targetMaterial != null)
            {
                if (_targetMaterialEditor == null)
                {
                    _targetMaterialEditor = UnityEditor.Editor.CreateEditor(_targetMaterial);
                }
                else
                {
                    if (_targetMaterialEditor.target != _targetMaterial)
                        _targetMaterialEditor = UnityEditor.Editor.CreateEditor(_targetMaterial);
                }

                _targetMaterialEditor.OnInteractivePreviewGUI(GUILayoutUtility.GetRect(256, 256), bgColor);
            }
        }

        [MenuItem("Example/GameObject Editor")]
        private static void ShowWindow()
        {
            GetWindowWithRect<ProceduralMaterialPreviewWindow>(new Rect(0, 0, 256, 256));
        }
    }
}