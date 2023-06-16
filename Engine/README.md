Available languages
-
 * United States - English
 * 日本 - 日本語
 * 대한민국 - 한국어
 * 简体中文 - 中国
 * 繁體中文 - 中國


<details>
  <summary>United States - English</summary>
  <h1>Automatically add languages installed on Windows system</h1>

The main function:
```
1. Support online upgrade;
2. Modify the script and press R to hot refresh;
3. Implement deployment rules according to the description file;
4. Get the installed language pack and add it automatically;
5. During the adding process, the S and SN versions are automatically judged and added according to the rules;
6. Processing mechanism:
   a. When encountering a monolingual version,
      Monolingual only,
           Automatically add the current language as the global preferred;

      When the monolingual version contains a multilingual pack,
           After adding the preferred language, when en-US is obtained in the language waiting to be added, it is added as the second language first;
           If en-US is not available, the installed language is randomly selected as the second language.

      For example, monolingual version tags: CoreSingle Lagoon, CoreCountrySpecific

   b. When encountering a multilingual version,
      After you add a preferred language, all installed languages are automatically added as secondary.

7. All conditions of "Language Overview" have been followed and met
   https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/languages-overview
```

## How to custom create an upgrade package
```
  a. If you continue to use the current version, please skip the modification, for example, the current version number: 1.0.0.0, create a new version number: 2.0.0.0,
     Open Multilingual\Modules\Engine.psd1, and modify ModuleVersion to: 2.0.0.0

  b. Modify the Modules\1.0.0.0 directory to 2.0.0.0;
     Note: 1.0.0.0 Please change it according to the version number.

  c. Re-specify the upgrade server and modify the URL connection:
     Open it: Modules\1.0.0.0\Functions\Base\Update\Engine.Update.psm1, Change: 
     c.1  To modify the minimum required version number: $Global:ChkLocalver, If the glide upgrade is supported starting at 1.0.0.0, if the script requires a minimum of 2.0.0.0, change to 2.0.0.0;
     c.2  To reassign the update server: $PreServerList。
```

The deployment engine is divided into multiple parts
-
You can intervene in the deployment process by adding more deployment tags, activate the first deployment:
.\Engine.ps1 -Force


* Shared deployment tags

| Path             | Deployment tag        | Description |
|------------------|-----------------------|---|
| \Deploy\Allow    | Is_Mark_Sync          | Allows full disk search and synchronization of deployment tags |

When enabling full disk search and synchronization of deployment tags, you can store deployment tags on any other disk, allowing or disallowing deployment, for example:
   1. The priority judgment deployment is marked as:
      D:\Yi\Deploy\Not Allowed\Auto_Update

   2. Continue to judge: D:\Yi\Deploy\Allow\Auto_Update

   3. Continue to judge the Deploy directory under the directory where the deployment engine script is stored.

When full disk search and synchronization of deployment tags are not allowed, only the Deploy directory under the directory where the deployment engine scripts are stored is recognized.

Download template: Engine.Deploy.Rule.ISO


* Part 1: Prerequisite deployment

| Assignable path               | Deployment tag        | Description |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | Auto_Update           | Allow automatic updates |
| \Deploy\{allow, Not Allowed}  | Use_UTF8              | Beta: Use Unicode UTF-8 to provide global language support |
| \Deploy\{allow, Not Allowed}  | Prerequisites_Reboot  | Restart the computer<br>Restarting the computer after completing the prerequisite deployment can solve the problem that needs to be restarted to take effect. |
| \Deploy\Regional              | Zone marker           | Change system locale |


* Part 2: Complete the first deployment

| Assignable path               | Deployment tag        | Description |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | Popup_Engine          | Allow the main interface of the deployment engine to pop up for the first time |
| \Deploy\{allow, Not Allowed}  | Allow_First_Pre_Experience | Allow the first pre-experience, as planned |
| \Deploy\{allow, Not Allowed}  | Reset_Execution_Policy | Recovery PowerShell execution strategy: restricted |
| \Deploy\{allow, Not Allowed}  | Clear_Solutions       | Delete the entire solution |
| \Deploy\{allow, Not Allowed}  | Clear_Engine          | Delete the deployment engine, keep the others |
| \Deploy\{allow, Not Allowed}  | First_Experience_Reboot | Restart the computer<br>After the deployment is complete, there are no important events. It is recommended that you cancel. |
</details>
 
<details>
  <summary>简体中文 - 中国</summary>
  <h1>全自动添加 Windows 系统已安装的语言</h1>

主要功能：
```
1、支持在线升级；
2、修改脚本按 R 可热刷新；
3、根据描述文件来实现部署规则；
4、获取已安装的语言包，自动添加；
5、添加过程中，自动判断 S、SN 版，按规则添加；
6、处理机制：
   a. 遇到单语版时，
      仅单语时，
           自动添加当前语言为全局首选；

      单语版包含多语言包时，
           添加首选语言后，获取等待添加的语言里有 en-US 时，则优先添加为第二语言；
           如果没有 en-US 时，随机选择已安装的语言为第二语言。

      例如单语版本标记：CoreSingleLanguage, CoreCountrySpecific

   b. 遇到多语版时，
      添加首选语言后，自动添加已安装的所有语言。

7、已遵循并满足“语言概述”的所有条件
   https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/languages-overview
```

## 如何自定义创建升级包

  a、继续使用当前版本请跳过修改，例如当前版本号：1.0.0.0，创建为新的版本号：2.0.0.0，
     打开 \Multilingual\Modules\Engine.psd1，修改“ModuleVersion”为：2.0.0.0

  b、将 Modules\1.0.0.0 目录修改为 2.0.0.0；
     注意：1.0.0.0 请根据每版本号进行更改。

  c、重新指定升级服务器，修改 URL 连接：
     打开：Modules\1.0.0.0\Functions\Base\Update\Engine.Update.psm1，更改：
     c.1  修改最低要求版本号：$Global:ChkLocalver，如果支持滑行升级可从 1.0.0.0 开始，如果脚本最低要求 2.0.0.0 开始，请更改为 2.0.0.0；
     c.2  重新指定更新服务器：$PreServerList。

  d、运行：
     .\_Create.Upgrade.Package.ps1


部署引擎分为多部分
-
可通过添加更多的部署标记来进行干预部署过程，激活首次部署：
.\Engine.ps1 -Force


* 共享部署标记

| 路径             | 部署标记               | 描述 |
|------------------|-----------------------|---|
| \Deploy\Allow    | Is_Mark_Sync          | 允许全盘搜索并同步部署标记 |

允许全盘搜索并同步部署标记时，你可以在其它任意磁盘存放部署标记，可允许部署和不允许部署，例如：
   1、优先判断部署标记为：
      D:\Yi\Deploy\Not Allowed\Auto_Update

   2、继续判断：D:\Yi\Deploy\Allow\Auto_Update

   3、继续判断部署引擎脚本存放目录下的 Deploy 目录。

不允许全盘搜索并同步部署标记时，仅识别部署引擎脚本存放目录下的 Deploy 目录。

下载模板：Engine.Deploy.Rule.ISO


* 第一部分：先决部署

| 可分配路径                     | 部署标记               | 描述 |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | Auto_Update           | 允许自动更新 |
| \Deploy\{allow, Not Allowed}  | Use_UTF8              | Beta 版：使用 Unicode UTF-8 提供全球语言支持 |
| \Deploy\{allow, Not Allowed}  | Prerequisites_Reboot  | 重新启动计算机<br>完成先决部署后重新启动计算机，可解决需重启才生效的问题。 |
| \Deploy\Regional              | 区域标记               | 更改系统区域设置 |


* 第二部分：完成首次部署

| 可分配路径                     | 部署标记               | 描述 |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | Popup_Engine          | 允许首次弹出部署引擎主界面 |
| \Deploy\{allow, Not Allowed}  | Allow_First_Pre_Experience | 允许首次预体验，按计划 |
| \Deploy\{allow, Not Allowed}  | Reset_Execution_Policy | 恢复 PowerShell 执行策略：受限 |
| \Deploy\{allow, Not Allowed}  | Clear_Solutions       | 删除整个解决方案 |
| \Deploy\{allow, Not Allowed}  | Clear_Engine          | 删除部署引擎，保留其它 |
| \Deploy\{allow, Not Allowed}  | First_Experience_Reboot | 重新启动计算机<br>部署完成后没有重要的事件，建议您取消。 |
</details>


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
