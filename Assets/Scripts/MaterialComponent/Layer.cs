﻿using UnityEngine;

namespace DefaultNamespace
{
    /// <summary>
    ///     ProceduralMatCapが持つ一つのレイヤー
    /// </summary>
    public class Layer
    {
        /// <summary>
        ///     UV座標系でのレイヤーが定義する球の中心
        /// </summary>
        public Vector2 centerUV = new(0.5f, 0.5f);

        /// <summary>
        ///     全体に乗っかる色
        /// </summary>
        public Color color = Color.blue;

        /// <summary>
        ///     レイヤーが定義する球の半径
        /// </summary>
        public float sphereRadius = 0.5f;

        /// <summary>
        ///     ベースとなるテクスチャ
        /// </summary>
        public Texture2D texture = Texture2D.whiteTexture;
    }
}