��          �            x     y       M   �  M   �          .      A  "   b  !   �     �     �     �  %   �  '     ?   /  -  o     �     �  >   �  ]   �     B  !   \  "   ~  #   �  $   �     �          &  1   D  '   v  C   �                                     
           	                               	%+#D 
 ${dev} (${mpoint}) io busy percent: [${util}%] <= uplimit: [${util_uplimit}%] ${dev} (${mpoint}) io busy percent: [${util}%] >= uplimit: [${util_uplimit}%] ${dev} not exist ${dev} not mounted ${oknum}/${total} check success. ${unknnum}/${total} check unknown. ${warnnum}/${total} check failed. IOStat Cehck OK IOStat Check UNKNOWN IOStat Check WARNING Util: [/usr/bin/iostat] not prepared. config {dev_list} empty, nothing to do. util_uplimit [${util_uplimit}] should be int and between 0-100. Report-Msgid-Bugs-To: zhangguangzheng@eyou.net
Last-Translator: Guangzheng Zhang <zhang.elinks@gmail.com>
Language-Team: MOLE-LANGUAGE <zhang.elinks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Chinese
X-Poedit-Country: CHINA
 	%+#D 
 设备: ${dev} (挂载点${mpoint}) IO繁忙程度为 ${util}% 设备: ${dev} (挂载点${mpoint}) IO繁忙程度为 ${util}%, 超出上限 ${util_uplimit}% 设备: ${dev} 不存在. 设备: ${dev} 未挂载到系统 ${oknum}/${total} 项检查正常. ${unknnum}/${total} 项检查未知 ${warnnum}/${total} 项检查告警. 磁盘IO繁忙度检查正常 磁盘IO繁忙度检查未知 磁盘IO繁忙度检查告警 [/usr/bin/iostat] 不存在或没有执行权限. 插件配置参数 {dev_list} 未设定 util_uplimit配置 [${util_uplimit}] 应该是1-100之间的整数. 