Available languages
-
 * United States - English
 * [简体中文 - 中国](https://github.com/ilikeyi/Multilingual/blob/main/_Learn/Custom.upgrade.package/Readme.zh-CN.md)

<h4><pre>How to custom create an upgrade package</pre></h4>

<ul>1. Please skip the modification to continue using the current version. For example, the current version number: 1.0.0.0, create a new version number: 2.0.0.0, open \Modules\Engine.psd1, modify "ModuleVersion" to: 2.0.0.0</ul>
<ul>2. Modify the Modules\1.0.0.0 directory to 2.0.0.0. Note: Please change 1.0.0.0 according to each version number.</ul>
<ul>3. Re-specify the upgrade server and modify the URL connection:
   <dl>
      <dd>Open: Modules\1.0.0.0\Functions\Base\Update\Engine.Update.psm1, change:</dd>
      <dd>3.1.  Modify the minimum required version number: MinimumVersion. If sliding upgrade is supported, it can start from 1.0.0.0. If the script requires minimum 2.0.0.0, please change it to 2.0.0.0;</dd>
      <dd>3.2.  Respecify update server: $PreServerList.</dd>
   </dl>
</ul>

<br>
<ul>4. Run: .\_Create.Upgrade.Package.ps1</ul>

## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
