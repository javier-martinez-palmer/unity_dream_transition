using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class CameraSwitch : MonoBehaviour {

    public int switch_camera_delay = 60;
    public GameObject cameraOne;
    AudioListener cameraOneAudioLis;
    
    public GameObject cameraTwo;
    AudioListener cameraTwoAudioLis;

    private int _camera_index;
    private int _in_transition;
    private int _out_transition;

    void Start()
    {
        //Get Camera Listeners
        cameraOneAudioLis = cameraOne.GetComponent<AudioListener>();
        cameraTwoAudioLis = cameraTwo.GetComponent<AudioListener>();

        //switch_camera_delay = 60;
        _camera_index = PlayerPrefs.GetInt("CameraPosition");
        cameraSet();
    }

    void Update()
    {
        if (_out_transition>0)
            _out_transition+=1;
        if (_out_transition >=switch_camera_delay)
        {
            _out_transition=0;
        }
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (_in_transition==0 && _out_transition==0)
            {
                _in_transition+=1; 
                if(_camera_index == 0)
                    cameraOne.GetComponent<Camera>().FadeOut(1f);
                if(_camera_index == 1)
                    cameraTwo.GetComponent<Camera>().FadeOut(1f);
            }
        }
        if (_in_transition > 0)
            _in_transition+=1;
        if (_in_transition >=switch_camera_delay)
        {
            _camera_index+=1; 
            PlayerPrefs.SetInt("CameraPosition", _camera_index);
            cameraSet();
        }
    }

    void cameraSet()
    {
        _in_transition=0;
        if (_camera_index > 1)
        {
            _camera_index = 0;
        } 
        if (_camera_index == 0)
        {
            cameraOne.SetActive(true);
            cameraOneAudioLis.enabled = true;
            cameraOne.GetComponent<Camera>().FadeIn(1f);
            
            cameraTwoAudioLis.enabled = false;
            cameraTwo.SetActive(false);
        }
        if (_camera_index == 1)
        {
            cameraTwo.SetActive(true);
            cameraTwoAudioLis.enabled = true;
            cameraTwo.GetComponent<Camera>().FadeIn(1f);

            cameraOneAudioLis.enabled = false;
            cameraOne.SetActive(false);
        } 
        _out_transition+=1;
    }
}
