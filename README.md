Available languages
-
 * United States - English
 * [简体中文 - 中国](https://github.com/ilikeyi/Multilingual/blob/main/Readme.zh-CN.md)

<br>

Fully automatic addition of languages already installed on Windows systems

<br>

Yi's Optimiz Private

<h4><pre>要求：</pre></h4>
<p>PowerShell 版本</p>

* PowerShell 5.1
    * 需要 Windows 11、Windows 10、Windows Server 2022、Windows Server vNext 或系统默认自带的 5.1 版本，可选升级最新版 PowerShell 7。

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
<h4><pre>The main function: </pre></h4>
<ul>1. Support online upgrade;</ul>
<ul>2. Support hot refresh after modifying the script;</ul>
<ul>3. Implement deployment rules according to description files;</ul>
<ul>4. Customized creation of upgrade packages</ul>
<ul>

[Learn: How to create a custom upgrade package](https://github.com/ilikeyi/Multilingual/blob/main/Learn/Custom.upgrade.package/Readme.md)
</ul>

<br>
<ul>5. Custom deployment mechanism
   <dl>
      <dd>4.1. Get the installed language pack and add it automatically;</dd>
      <dd>4.2. During the adding process, the S and SN versions are automatically determined and added according to the rules;</dd>
      <dd>4.3. Automatic addition mechanism: 
         <dl>
            <dd>4.3.1. When encountering the monolingual version, 
               <dl>
                  <dd>When only single language is used, the current language is automatically added as the global preferred language; </dd>
                  <dd>When the monolingual version contains multi-language packages, 
                     <dl>
                        <dd>After adding the preferred language, if en-US is among the languages waiting to be added, it will be added as the second language first;</dd>
                        <dd>If there is no en-US, the installed language is randomly selected as the second language.</dd>
                        <dd>For example, monolingual version markup: CoreSingleLanguage, CoreCountrySpecific</dd>
                     </dl>
                  </dd>
               </dl>
            </dd>

<br>
            <dd>4.3.2. When encountering the multilingual version,
               <dl>
                  <dd>After adding your preferred language, all installed languages are automatically added.</dd>
               </dl>
            </dd>
         </dl>
      </dd>
   </dl>
</ul>

<br>
<ul>6. Custom deployment tags</ul>
<ul>

[Learn: Use deployment tags to intervene in the deployment process](https://github.com/ilikeyi/Multilingual/tree/main/Learn/Deployment.Tag)</ul>

<br>

## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
