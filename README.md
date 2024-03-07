Available languages
-
 * United States - English
 * 简体中文 - 中国

<br>

全自动添加 Windows 系统已安装的语言

<h4><pre>主要功能：</pre></h4>
<ul>1. 支持在线升级；</ul>
<ul>2. 修改脚本后支持热刷新；</ul>
<ul>3. 根据描述文件来实现部署规则；</ul>
<ul>4. 如何自定义创建升级包
   <dl>
      <dd>4.1. 继续使用当前版本请跳过修改，例如当前版本号：1.0.0.0，创建为新的版本号：2.0.0.0，打开 \Multilingual\Modules\Engine.psd1，修改“ModuleVersion”为：2.0.0.0</dd>
      <dd>4.2. 将 Modules\1.0.0.0 目录修改为 2.0.0.0，注意：1.0.0.0 请根据每版本号进行更改。</dd>
      <dd>4.3. 重新指定升级服务器，修改 URL 连接：
         <dl>
            <dd>打开：Modules\1.0.0.0\Functions\Base\Update\Engine.Update.psm1，更改：</dd>
            <dd>c.1  修改最低要求版本号：$Global:ChkLocalver，如果支持滑行升级可从 1.0.0.0 开始，如果脚本最低要求 2.0.0.0 开始，请更改为 2.0.0.0；</dd>
            <dd>c.2  重新指定更新服务器：$PreServerList。</dd>
         </dl>
      </dd>

<br>
      <dd>4.4. 运行：.\_Create.Upgrade.Package.ps1</dd>
   </dl>
</ul>

<br>
<ul>5. 自定义部署：
   <dl>
      <dd>4.1. 获取已安装的语言包，自动添加；</dd>
      <dd>4.2. 添加过程中，自动判断 S、SN 版，按规则添加；</dd>
      <dd>4.3. 部署时自动添加机制：
         <dl>
            <dd>4.3.1. 遇到单语版时，
               <dl>
                  <dd>仅单语时，自动添加当前语言为全局首选；</dd>
                  <dd>单语版包含多语言包时，
                     <dl>
                        <dd>添加首选语言后，获取等待添加的语言里有 en-US 时，则优先添加为第二语言；</dd>
                        <dd>如果没有 en-US 时，随机选择已安装的语言为第二语言。</dd>
                        <dd>例如单语版本标记：CoreSingleLanguage, CoreCountrySpecific</dd>
                     </dl>
                  </dd>
               </dl>
            </dd>

<br>
            <dd>4.3.2. 遇到多语版时，
               <dl>
                  <dd>添加首选语言后，自动添加已安装的所有语言。</dd>
               </dl>
            </dd>
         </dl>
      </dd>
   </dl>
</ul>

<br>

<h4><pre>部署引擎分为多部分</pre></h4>
<ul>可通过添加更多的部署标记来进行干预部署过程，激活首次部署：.\Engine.ps1 -Force</ul>

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
