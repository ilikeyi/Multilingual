Available languages
-
 * United States - English
 * 简体中文 - 中国

<br>

<如何自定义创建升级包

<ul>
   <dl>
      <dd>4.1. 继续使用当前版本请跳过修改，例如当前版本号：1.0.0.0，创建为新的版本号：2.0.0.0，打开 \Multilingual\Modules\Engine.psd1，修改“ModuleVersion”为：2.0.0.0</dd>
      <dd>4.2. 将 Modules\1.0.0.0 目录修改为 2.0.0.0，注意：1.0.0.0 请根据每版本号进行更改。</dd>
      <dd>4.3. 重新指定升级服务器，修改 URL 连接：
         <dl>
            <dd>打开：Modules\1.0.0.0\Functions\Base\Update\Engine.Update.psm1，更改：</dd>
            <dd>c.1  修改最低要求版本号：MinimumVersion，如果支持滑行升级可从 1.0.0.0 开始，如果脚本最低要求 2.0.0.0 开始，请更改为 2.0.0.0；</dd>
            <dd>c.2  重新指定更新服务器：$PreServerList。</dd>
         </dl>
      </dd>

<br>
      <dd>4.4. 运行：.\_Create.Upgrade.Package.ps1</dd>
   </dl>
</ul>

## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
