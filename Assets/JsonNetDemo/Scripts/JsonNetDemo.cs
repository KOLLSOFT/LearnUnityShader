using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Newtonsoft.Json;

public class JsonNetDemo : MonoBehaviour {

	// Use this for initialization
	void Start () {
        Test1();


	}

    void Test1()
    {
        AchievementSystem ac = new AchievementSystem();
        for (int i = 1; i < 10; i++)
        {
            AchievementInfo info = new AchievementInfo();
            info.id = i;
            info.name = "成就" + info.id;
            info.condition = "条件" + info.id;
            //ac.achievement_info_list.Add(info);
            ac.achievement_dic[info.id] = info;
        }
        ac.is_unlock_all = true;
        string json_str = JsonConvert.SerializeObject(ac, Formatting.Indented);
        Debug.Log(json_str);

    }

    // Update is called once per frame
    //void Update () {

    //}
}

public class AchievementInfo
{
    public int id;
    public string name;
    public string condition;
    private bool is_unlock;
}

public class AchievementSystem
{
    public bool is_unlock_all;
    //public List<AchievementInfo> achievement_info_list = new List<AchievementInfo>();
    public Dictionary<int, AchievementInfo> achievement_dic = new Dictionary<int, AchievementInfo>();
}
