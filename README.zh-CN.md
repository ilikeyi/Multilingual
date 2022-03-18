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


部署引擎分为二部分
-
可通过描述文件来干预部署过程。

* 第一部分：先决部署

| 路径             | 配置文件               | 描述 |
|------------------|-----------------------|---|
| \Deploy          | DoNotUpdate           | 阻止部署引擎自动更新 |
| \Deploy          | ExcludeDefender       | 添加主目录到 Defend 排除目录 |
| \Deploy          | SyncVolumeName        | 系统盘卷标名与主目录相同 |
| \Deploy          | UseUTF8               | Beta 版：使用 Unicode UTF-8 提供全球语言支持 |
| \Deploy\Regional | 区域标记               | 更改系统区域设置 |
| \Deploy          | PrerequisitesReboot   | 重新启动计算机<br>完成先决部署后重新启动计算机，可解决需重启才生效的问题。 |


* 第二部分：完成首次部署

| 路径             | 配置文件               | 描述 |
|------------------|-----------------------|---|
| \Deploy          | PopupEngine           | 允许首次弹出部署引擎主界面 |
| \Deploy          | FirstPreExperience    | 允许首次预体验，按计划 |
| \Deploy          | ResetExecutionPolicy  | 恢复 PowerShell 执行策略：受限 |
| \Deploy          | ClearSolutions        | 删除整个解决方案 |
| \Deploy          | ClearEngine           | 删除部署引擎，保留其它 |
| \Deploy          | PrerequisitesReboot   | 重新启动计算机<br>部署完成后没有重要的事件，建议您取消。 |



## 协议

在 MIT 许可下分发。 有关更多信息，请参阅“许可证”。


## 联系我们

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

项目连接: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
