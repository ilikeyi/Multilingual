QUICK DOWNLOAD GUIDE
-

Open "Terminal" or "PowerShell ISE" as an administrator, paste the following command line into the "Terminal" dialog box, and press Enter to start running;

<br>

Open "Terminal" or "PowerShell ISE" as an administrator, set PowerShell execution policy: Bypass, PS command line:
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

<br>

a) Prioritize downloading from Github node
```
irm https://github.com/ilikeyi/Multilingual/raw/main/get.ps1 | iex
```

<br>

b) Prioritize downloading from Yi node
```
irm https://fengyi.tel/download/solutions/update/Multilingual/get.ps1 | iex
```

<p>When it cannot be downloaded, it will be automatically downloaded from other nodes and run automatically after the download is completed.</p>

<br>

Available languages
-
 * United States - English
 * [简体中文 - 中国](https://github.com/ilikeyi/Multilingual/blob/main/_Learn/Readme.zh-CN.md)

<br>

Fully automatic addition of languages already installed on Windows systems

<h4><pre>Require</pre></h4>
<p>PowerShell Version</p>

* PowerShell 5.1
    * Requires Windows 11, Windows 10, Windows Server 2022, Windows Server vNext or the 5.1 version that comes with the system by default. You can optionally upgrade to the latest version of PowerShell 7.

<br>

* PowerShell 7
    * To get the latest version, go to https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows, select the version you want to download, download and install.

<br>

<h4><pre>Command Line</pre></h4>

* You can choose "Terminal" or "PowerShell ISE". If "Terminal" is not installed, please go to https://github.com/microsoft/terminal/releases to download;

* Open "Terminal" or "PowerShell ISE" as an administrator, set PowerShell execution policy: Bypass, PS command line:

```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

   * After the download is completed, unzip it to any disk, for example, unzip it to: D:\Multilingual

   * After finding D:\Multilingual\Engine\Engine.ps1, right-click the file and select Run as PowerShell, or copy the path and paste it into "Terminal" or "PowerShell ISE" to run. For the path with a colon, add the & character in the command line , example: & "D:\Multilingual\Engine\Engine.ps1"

<br>
<h4><pre>The main function: </pre></h4>
<ul>1. Support online upgrade;</ul>
<ul>2. Support hot refresh after modifying the script;</ul>
<ul>3. Customized creation of upgrade packages</ul>
<ul><dl><dd>

[Learn: How to create a custom upgrade package](https://github.com/ilikeyi/Multilingual/blob/main/_Learn/Custom.upgrade.package/Readme.md)
</ul></dl></dd>

<br>
<ul>4. Custom deployment mechanism
   <dl>
      <dd>4.1. Implement deployment rules according to description files;</dd>
      <dd>4.2. Get the installed language pack and add it automatically;</dd>
      <dd>4.3. During the adding process, the S and SN versions are automatically determined and added according to the rules;</dd>
      <dd>4.4. Automatic addition mechanism: 
         <dl>
            <dd>4.4.1. When encountering the monolingual version, 
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
            <dd>4.4.2. When encountering the multilingual version,
               <dl>
                  <dd>After adding your preferred language, all installed languages are automatically added.</dd>
               </dl>
            </dd>
         </dl>
      </dd>
   </dl>
</ul>

<br>
<ul>5. Custom deployment tags</ul>
<ul><dl><dd>

[Learn: Use deployment tags to intervene in the deployment process](https://github.com/ilikeyi/Multilingual/tree/main/_Learn/Deployment.Tag)
</ul></dl></dd>

<br>

## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
