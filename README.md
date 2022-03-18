# Multilingual
Automatically add known languages

Automatically add languages installed on Windows system
-

The main function:
```
1. Support online upgrade;
2. Modify the script and press R to hot refresh;
3. Implement deployment rules according to the description file;
4. Get the installed language pack and add it automatically;
5. During the adding process, the S and SN versions are automatically judged and added according to the rules;
6. All conditions of "Language Overview" have been followed and met
   https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/languages-overview
```

Available languages
-
 * United States - English
 * 日本 - 日本語
 * 대한민국 - 한국어
 * Россия - Русский
 * 简体中文 - 中国
 * 繁體中文 - 中國


The deployment engine is divided into two parts
-
The deployment process can be intervened through the description file.

* Part 1: Prerequisite deployment

| Path             | Configuration file    | Description |
|------------------|-----------------------|---|
| \Deploy          | DoNotUpdate           | Prevent automatic updates of the deployment engine |
| \Deploy          | ExcludeDefender       | Add home directory to Defend exclude directory |
| \Deploy          | SyncVolumeName        | The volume label of the system disk is the same as the home directory |
| \Deploy          | UseUTF8               | Beta: Use Unicode UTF-8 to provide global language support |
| \Deploy\Regional | Area marker           | Change system locale |
| \Deploy          | PrerequisitesReboot   | Restart the computer<br>Restarting the computer after completing the prerequisite deployment can solve the problem that needs to be restarted to take effect. |


* Part 2: Complete the first deployment

| Path             | Configuration file    | Description |
|------------------|-----------------------|---|
| \Deploy          | PopupEngine           | Allow the main interface of the deployment engine to pop up for the first time |
| \Deploy          | FirstPreExperience    | Allow the first pre-experience, as planned |
| \Deploy          | ResetExecutionPolicy  | Recovery PowerShell execution strategy: restricted |
| \Deploy          | ClearSolutions        | Delete the entire solution |
| \Deploy          | ClearEngine           | Delete the deployment engine, keep the others |
| \Deploy          | FirstExperienceReboot | Restart the computer<br>After the deployment is complete, there are no important events. It is recommended that you cancel. |


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
