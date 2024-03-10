Available languages
-
 * [United States - English](https://github.com/ilikeyi/Multilingual/blob/main/_Learn/Deployment.Tag/Readme.md)
 * 简体中文 - 中国

<br>

<h4><pre>使用部署标记干预部署过程</pre></h4>
<ul>部署引擎分为多部分，可通过添加更多的部署标记来进行干预部署过程，激活首次部署：.\Engine.ps1 -Force</ul>

<br>
* 共享部署标记
<br>
<dl><dd>

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

</dl></dl>

<br>
* 第一部分：先决部署
<br>
<dl><dd>

| 可分配路径                     | 部署标记               | 描述 |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | Auto_Update           | 允许自动更新 |
| \Deploy\{allow, Not Allowed}  | Use_UTF8              | Beta 版：使用 Unicode UTF-8 提供全球语言支持 |
| \Deploy\Regional              | 区域标记               | 更改系统区域设置 |
| \Deploy\{allow, Not Allowed}  | Disable_Network_Location_Wizard | 网络位置向导 |
| \Deploy\{allow, Not Allowed}  | Disable_Cleanup_Appx_Tasks | Appx 清理维护任务 |
| \Deploy\{allow, Not Allowed}  | Disable_Cleanup_On_Demand_Language | 阻止清理未使用的按需功能语言包 |
| \Deploy\{allow, Not Allowed}  | Disable_Cleanup_Unsed_Language | 阻止清理未使用的语言包 |
| \Deploy\{allow, Not Allowed}  | Prerequisites_Reboot  | 重新启动计算机<br>完成先决部署后重新启动计算机，可解决需重启才生效的问题。|

<dd></dl>

<br>
* 第二部分：完成首次部署
<br>

<dl><dd>

| 可分配路径                     | 部署标记               | 描述 |
|-------------------------------|-----------------------|---|
| \Deploy\{allow, Not Allowed}  | Popup_Engine          | 允许首次弹出部署引擎主界面 |
| \Deploy\{allow, Not Allowed}  | Allow_First_Pre_Experience | 允许首次预体验，按计划 |
| \Deploy\{allow, Not Allowed}  | Reset_Execution_Policy | 恢复 PowerShell 执行策略：受限 |
| \Deploy\{allow, Not Allowed}  | Clear_Solutions       | 删除整个解决方案 |
| \Deploy\{allow, Not Allowed}  | Clear_Engine          | 删除部署引擎，保留其它 |
| \Deploy\{allow, Not Allowed}  | First_Experience_Reboot | 重新启动计算机<br>部署完成后没有重要的事件，建议您取消。 |

<dd></dl>


## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
