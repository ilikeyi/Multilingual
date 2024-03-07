Available languages
-
 * United States - English
 * [简体中文 - 中国](https://github.com/ilikeyi/Multilingual/blob/main/Readme.zh-CN.md)

<br>

Fully automatic addition of languages already installed on Windows systems

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
