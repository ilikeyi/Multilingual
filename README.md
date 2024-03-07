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
<ul>4. 自定义创建升级包</ul>
<ul>

[学习：如何创建自定义升级包](https://github.com/ilikeyi/Multilingual/blob/main/Learn/Custom.upgrade.package/Readme.md)
</ul>

<br>
<ul>5. 自定义部署机制
   <dl>
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
<ul>6. 自定义部署标记</ul>
<ul>

[学习：使用部署标记干预部署过程](https://github.com/ilikeyi/Multilingual/tree/main/Learn/Deployment.Tag)</ul>

<br>

## License

Distributed under the MIT License. See `LICENSE` for more information.


## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/Multilingual](https://github.com/ilikeyi/Multilingual)
