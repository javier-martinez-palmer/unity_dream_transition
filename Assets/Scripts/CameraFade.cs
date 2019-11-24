using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CameraFade : MonoBehaviour {

	[Range(0f,1.0f)]
	public float progress;
	float _progress;
	Material _mtl;
	Material mtl {
		get{
			if (_mtl) return _mtl; 
			else {
				_mtl = new Material(Shader.Find("Hidden/DreamEffect"));
				return _mtl;
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		if (_progress != progress) {
			mtl.SetFloat("_Progress",progress);
			// Debug.Log("Setting radius to " + radius);
			_progress = progress;
		}
	}

	void OnRenderImage ( RenderTexture src, RenderTexture dst) {
		Graphics.Blit(src, dst, mtl);
	}
}



