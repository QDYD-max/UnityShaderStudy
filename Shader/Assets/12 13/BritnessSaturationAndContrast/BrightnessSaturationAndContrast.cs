using UnityEngine;
using System.Collections;

public class BrightnessSaturationAndContrast : PostEffectsBase {

	[Range(0.0f, 3.0f)]
	public float brightness = 0.0f;

	[Range(0.0f, 3.0f)]
	public float saturation = 0.0f;

	[Range(0.0f, 3.0f)]
	public float constract = 0.0f;

	public Shader briSatConShader;
	private Material briSatConMatrial;

	public Material material{
		get
		{
			briSatConMatrial = CheckShaderAndCreateMaterial(briSatConShader, briSatConMatrial);
			return briSatConMatrial;
		}
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest){
		if(material != null){
			material.SetFloat("_Brightness", brightness);
			material.SetFloat("_Saturation", saturation);
			material.SetFloat("_Contrast", constract);

			Graphics.Blit(src, dest, material);
		}
        else{
			Graphics.Blit(src, dest);
		}

	}

}
