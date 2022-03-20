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


The deployment engine is divided into multiple parts
-
You can intervene in the deployment process by adding more deployment tags, activate the first deployment:
.\Engine.ps1 -Force


* Shared deployment tags

| Path             | Deployment tag        | Description |
|------------------|-----------------------|---|
| \Deploy\Allow    | IsMarkSync            | Allows full disk search and synchronization of deployment tags |

When enabling full disk search and synchronization of deployment tags, you can store deployment tags on any other disk, allowing or disallowing deployment, for example:
   1. The priority judgment deployment is marked as:
      D:\Yi\Deploy\Not Allowed\AutoUpdate

   2. Continue to judge: D:\Yi\Deploy\Allow\AutoUpdate

   3. Continue to judge the Deploy directory under the directory where the deployment engine script is stored.

When full disk search and synchronization of deployment tags are not allowed, only the Deploy directory under the directory where the deployment engine scripts are stored is recognized.

Download template: Engine.Deploy.Rule.ISO


* Part 1: Prerequisite deployment

| Assignable path               | Deployment tag        | Description |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | AutoUpdate            | Allow automatic updates |
| \Deploy\{allow, Not Allowed}  | UseUTF8               | Beta: Use Unicode UTF-8 to provide global language support |
| \Deploy\{allow, Not Allowed}  | PrerequisitesReboot   | Restart the computer<br>Restarting the computer after completing the prerequisite deployment can solve the problem that needs to be restarted to take effect. |
| \Deploy\Regional              | Zone marker           | Change system locale |


* Part 2: Complete the first deployment

| Assignable path               | Deployment tag        | Description |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | PopupEngine           | Allow the main interface of the deployment engine to pop up for the first time |
| \Deploy\{allow, Not Allowed}  | FirstPreExperience    | Allow the first pre-experience, as planned |
| \Deploy\{allow, Not Allowed}  | ResetExecutionPolicy  | Recovery PowerShell execution strategy: restricted |
| \Deploy\{allow, Not Allowed}  | ClearSolutions        | Delete the entire solution |
| \Deploy\{allow, Not Allowed}  | ClearEngine           | Delete the deployment engine, keep the others |
| \Deploy\{allow, Not Allowed}  | FirstExperienceReboot | Restart the computer<br>After the deployment is complete, there are no important events. It is recommended that you cancel. |


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
