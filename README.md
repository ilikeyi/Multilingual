# Multilingual
Automatically add known languages


Automatically add known languages
-

The main function:
```
1. Support automatic upgrade;
2. Support multi-language language pack, you can add others by yourself;
3. Obtain the language packs installed in the Windows operating system and add them automatically;
4. Automatically obtain the monolingual version and non-monolingual version adding rules;
```

全自动添加 Windows 系统已安装的语言
-

主要功能：
```
1、支持在线升级；
2、获取 Windows 操作系统已安装的语言包，自动添加；
3、添加过程中，自动判断 S、SN 版，按规则添加；
4、已遵循并满足 [语言概述](https://docs.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/languages-overview) 的所有条件
```

部署引擎分为二部分
-
可通过描述文件来干预部署过程。

* 第一部分：先决部署

| 路径 | 描述文件 | 名称 |
|---|---|---|
| \Deploy | DoNotUpdate | 阻止部署引擎自动更新 |
| \Deploy | ExcludeDefender | 添加主目录到 Defend 排除目录 |
| \Deploy | SyncVolumeName | 系统盘卷标名与主目录相同 |
| \Deploy | UseUTF8 | Beta 版：使用 Unicode UTF-8 提供全球语言支持 |
| \Deploy\Regional | 区域标记 | 更改系统区域设置 |
| \Deploy | PrerequisitesReboot | 重新启动计算机<br>完成先决部署后重新启动计算机，可解决需重启才生效的问题。 |


* 第二部分：完成首次部署

| 路径 | 描述文件 | 名称 |
|---|---|---|
| \Deploy | PopupEngine | 允许首次弹出部署引擎主界面 |
| \Deploy | FirstPreExperience | 允许首次弹出部署引擎主界面 |
| \Deploy | PopupEngine | 允许首次预体验，按计划 |
| \Deploy | ResetExecutionPolicy | 恢复 PowerShell 执行策略：受限 |
| \Deploy | ClearSolutions | 删除整个解决方案 |
| \Deploy | ClearEngine | 删除部署引擎，保留其它 |
| \Deploy | FirstExperienceReboot | 重新启动计算机<br>部署完成后没有重要的事件，建议您取消。 |
