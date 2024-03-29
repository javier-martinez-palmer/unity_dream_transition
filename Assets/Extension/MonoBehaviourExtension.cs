﻿using UnityEngine;
using System.Collections;
using System;

public static class MonoBehaviourExtension  {

	public static Coroutine Tween (this MonoBehaviour self, float start, float end, float duration,Action<float> action) {
		return self.StartCoroutine (_Tween (start, end, duration, action));
	}
		
	static IEnumerator _Tween ( float s, float e,float d, Action<float> a){
		if (a == null) yield break;
		float time = 0f;
		float t = 0f;

		do {
			t = time / d;
			//Debug.Log(Mathf.Lerp (s, e, t));
			a (Mathf.Lerp (s, e, t));
			time += Time.deltaTime;
			yield return null;
		} while (time < d);

		a (e);
	}


}
