# Multilingual
Automatically add known languages

全自动添加 Windows 系统已安装的语言
-

主要功能：
```
1、支持在线升级；
2、修改脚本按 R 可热刷新；
3、根据描述文件来实现部署规则；
4、获取已安装的语言包，自动添加；
5、添加过程中，自动判断 S、SN 版，按规则添加；
6、已遵循并满足“语言概述”的所有条件
   https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/languages-overview
```

可用语言
-
 * United States - English
 * 日本 - 日本語
 * 대한민국 - 한국어
 * Россия - Русский
 * 简体中文 - 中国
 * 繁體中文 - 中國


部署引擎分为多部分
-
可通过添加更多的部署标记来进行干预部署过程。


* 共享部署标记

| 路径             | 部署标记               | 描述 |
|------------------|-----------------------|---|
| \Deploy\Allow    | IsMarkSync            | 允许全盘搜索并同步部署标记 |

允许全盘搜索并同步部署标记时，你可以在其它任意磁盘存放部署标记，可允许部署和不允许部署，例如：
   1、优先判断部署标记为：
      D:\Yi\Deploy\Not Allowed\AutoUpdate

   2、继续判断：D:\Yi\Deploy\Allow\AutoUpdate

   3、继续判断部署引擎脚本存放目录下的 Deploy 目录。

不允许全盘搜索并同步部署标记时，仅识别部署引擎脚本存放目录下的 Deploy 目录。

下载模板：Yi.Deploy.Rule.ISO


* 第一部分：先决部署

| 可分配路径                     | 部署标记               | 描述 |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | AutoUpdate            | 允许自动更新 |
| \Deploy\{allow, Not Allowed}  | ExcludeDefender       | 添加主目录到 Defend 排除目录 |
| \Deploy\{allow, Not Allowed}  | SyncVolumeName        | 系统盘卷标名与主目录相同 |
| \Deploy\{allow, Not Allowed}  | UseUTF8               | Beta 版：使用 Unicode UTF-8 提供全球语言支持 |
| \Deploy\{allow, Not Allowed}  | PrerequisitesReboot   | 重新启动计算机<br>完成先决部署后重新启动计算机，可解决需重启才生效的问题。 |
| \Deploy\Regional              | 区域标记               | 更改系统区域设置 |


* 第二部分：完成首次部署

| 可分配路径                     | 部署标记               | 描述 |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | PopupEngine           | 允许首次弹出部署引擎主界面 |
| \Deploy\{allow, Not Allowed}  | FirstPreExperience    | 允许首次预体验，按计划 |
| \Deploy\{allow, Not Allowed}  | ResetExecutionPolicy  | 恢复 PowerShell 执行策略：受限 |
| \Deploy\{allow, Not Allowed}  | ClearSolutions        | 删除整个解决方案 |
| \Deploy\{allow, Not Allowed}  | ClearEngine           | 删除部署引擎，保留其它 |
| \Deploy\{allow, Not Allowed}  | PrerequisitesReboot   | 重新启动计算机<br>部署完成后没有重要的事件，建议您取消。 |


## 协议

在 MIT 许可下分发。 有关更多信息，请参阅“许可证”。


## 联系我们

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

项目连接: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
