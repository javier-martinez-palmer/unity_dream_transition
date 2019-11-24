using UnityEngine;
using System.Collections;

public static class CameraExtension {

	static CameraFade camFade (Camera cam) {
		CameraFade cf = cam.GetComponent<CameraFade>();
		if (cf) return cf; else {
			return cam.gameObject.AddComponent<CameraFade>();
		}
	}

	public static void FadeIn(this Camera cam, float duration) {
		CameraFade cf = camFade(cam);
		cf.Tween(0f,1.0f,duration,x => cf.progress = x);
	}

	public static void FadeOut(this Camera cam, float duration) {
		CameraFade cf = camFade(cam);
		cf.Tween(1.0f,0f,duration,x => cf.progress = x);
	}

}

