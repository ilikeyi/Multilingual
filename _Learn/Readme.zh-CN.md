快速下载指南
-

以管理员身份打开“Terminal”或“PowerShell ISE”，将以下命令行粘贴到“Terminal”对话框，按回车键（Enter）后开始运行；

<br>

以管理员身份打开“Terminal”或“PowerShell ISE”，设置 PowerShell 执行策略：绕过，PS 命令行：
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

<br>

a) 优先从 Github 节点下载
```
irm https://github.com/ilikeyi/Multilingual/raw/main/get.ps1 | iex
```

<br>

b) 优先从 Yi 节点下载
```
irm https://fengyi.tel/download/solutions/update/Multilingual/get.ps1 | iex
```

<p>无法下载时，自动从其它节点下载，下载完成后自动运行。</p>

<br>

Available languages
-
 * [United States - English](https://github.com/ilikeyi/Multilingual)
 * 简体中文 - 中国

<br>

全自动添加 Windows 系统已安装的语言

<h4><pre>要求：</pre></h4>
<p>PowerShell 版本</p>

* PowerShell 5.1
    * 需要 Windows 11、Windows 10、Windows Server 2022、Windows Server vNext 或系统默认自带的 5.1 版本，可选升级最新版 PowerShell 7。

<br>

* PowerShell 7
    * 获取最新版，前往 https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows 后，选择需要下载的版本，下载后并安装。

<br>

<h4><pre>命令行</pre></h4>

* 可选“Terminal ”或“PowerShell ISE”，未安装“Terminal”，请前往 https://github.com/microsoft/terminal/releases 后下载；

* 以管理员身份打开“Terminal”或“PowerShell ISE”，设置 PowerShell 执行策略：绕过，PS 命令行：

```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

   * 下载完成后，解压到任意盘，例如解压到：D:\Yi.Optimiz.Private

   * 找到 D:\Yi.Optimiz.Private\Engine\Engine.ps1 后，点击文件右键，选择以 PowerShell 运行，或复制路径，粘贴到“Terminal ”或“PowerShell ISE”里运行，带冒号的路径，在命令行添加  & 字符，示例：& "D:\Yi.Optimiz.Private\Engine\Engine.ps1"

<br>
<h4><pre>主要功能：</pre></h4>
<ul>1. 支持在线升级；</ul>
<ul>2. 修改脚本后支持热刷新；</ul>
<ul>3. 自定义创建升级包</ul>
<ul><dl><dd>

[学习：如何创建自定义升级包](https://github.com/ilikeyi/Multilingual/blob/main/_Learn/Custom.upgrade.package/Readme.md)
</ul></dl></dd>

<br>
<ul>4. 自定义部署机制
   <dl>
      <dd>4.1. 根据描述文件来实现部署规则；</dd>
      <dd>4.1. 获取已安装的语言包，自动添加；</dd>
      <dd>4.2. 添加过程中，自动判断 S、SN 版，按规则添加；</dd>
      <dd>4.3. 自动添加机制：
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
<ul>5. 自定义部署标记</ul>
<ul><dl><dd>

[学习：使用部署标记干预部署过程](https://github.com/ilikeyi/Multilingual/tree/main/_Learn/Deployment.Tag)
</ul></dl></dd>

<br>

## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
