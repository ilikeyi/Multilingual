Available languages
-
 * United States - English
 * [简体中文 - 中国](https://github.com/ilikeyi/Multilingual/blob/main/_Learn/Deployment.Tag/Readme.zh-CN.md)

<br>
<h4><pre>Intervene in the deployment process using deployment tags</pre></h4>
<ul>The deployment engine is divided into multiple parts. You can intervene in the deployment process by adding more deployment tags to activate the first deployment: .\Engine.ps1 -Force</ul>

<br>
* Shared deployment tags
<br>
<dl><dd>

| Path | Deployment tag | Description |
|------------------|-----------------------|---|
| \Deploy\Allow    | Is_Mark_Sync          | Allow global search and synchronization of deployment tags |


When allowing full disk search and synchronization of deployment marks, you can store deployment marks on any other disk, allowing deployment or disallowing deployment, for example:

   1. Prioritize the deployment mark as:
      D:\Yi\Deploy\Not Allowed\Auto_Update

   2. Continue to judge: D:\Yi\Deploy\Allow\Auto_Update

   3. Continue to determine the Deploy directory under the directory where the deployment engine script is stored.

When full search and deployment mark synchronization are not allowed, only the Deploy directory under the directory where the deployment engine script is stored is recognized.

Download template: Engine.Deploy.Rule.ISO

</dl></dl>

<br>
* Part 1: Prerequisite deployment
<br>
<dl><dd>

| Assignable path               | Deployment tag        | Description |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | Auto_Update           | Allow automatic updates |
| \Deploy\{allow, Not Allowed}  | Use_UTF8              | Beta: Use Unicode UTF-8 to provide global language support |
| \Deploy\Regional              | Zone marker           | Change system locale |
| \Deploy\{allow, Not Allowed}  | Disable_Network_Location_Wizard | Network Location Wizard |
| \Deploy\{allow, Not Allowed}  | Disable_Cleanup_Appx_Tasks | Appx cleanup maintenance tasks |
| \Deploy\{allow, Not Allowed}  | Disable_Cleanup_On_Demand_Language | Prevent cleanup of unused feature-on-demand language packs |
| \Deploy\{allow, Not Allowed}  | Disable_Cleanup_Unsed_Language | Prevent cleaning of unused language packs |
| \Deploy\{allow, Not Allowed}  | Prerequisites_Reboot  | Restart the computer<br>Restarting the computer after completing the prerequisite deployment can solve the problem that needs to be restarted to take effect. |

<dd></dl>

<br>
* Part 2: Complete the first deployment
<br>

<dl><dd>

| Assignable path               | Deployment tag        | Description |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | Popup_Engine          | Allow the main interface of the deployment engine to pop up for the first time |
| \Deploy\{allow, Not Allowed}  | Allow_First_Pre_Experience | Allow the first pre-experience, as planned |
| \Deploy\{allow, Not Allowed}  | Reset_Execution_Policy | Recovery PowerShell execution strategy: restricted |
| \Deploy\{allow, Not Allowed}  | Clear_Solutions       | Delete the entire solution |
| \Deploy\{allow, Not Allowed}  | Clear_Engine          | Delete the deployment engine, keep the others |
| \Deploy\{allow, Not Allowed}  | First_Experience_Reboot | Restart the computer<br>After the deployment is complete, there are no important events. It is recommended that you cancel. |

<dd></dl>


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
