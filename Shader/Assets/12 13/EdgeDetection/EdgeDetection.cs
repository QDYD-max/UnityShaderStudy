using UnityEngine;
using System.Collections;

public class EdgeDetection : PostEffectsBase
{
    public Shader edgfeDetecShader;
    private Material edgeDSetecMaterial;
    public Material material
    {
        get
        {
            edgeDSetecMaterial = CheckShaderAndCreateMaterial(edgfeDetecShader, edgeDSetecMaterial);
            return edgeDSetecMaterial;
        }
    }

    [Range(0.0f, 1.0f)]
    public float edgesOnly = 0.0f;

    public Color edgeColor = Color.black;

    public Color bgColor = Color.white;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_EdegesOnly", edgesOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BGColor", bgColor);

            Graphics.Blit(src, dest, material);
        }
        else
            Graphics.Blit(src, dest);
    }


}
