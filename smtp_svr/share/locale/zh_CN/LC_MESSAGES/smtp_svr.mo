��          �            x     y          �  B   �  V   �  K   2  N   ~  A   �  G        W  A   o  J   �  C   �  :   @  D   {  /  �     �     �     �  F     ^   Y  X   �  P     D   b  F   �  )   �  G     K   `  D   �  B   �  G   4	                                                                 
       	       	%+#D 
  (%f seconds) ### ###   smtp_user or smtp_pass not defined, smtp login test skip ### ###  <font color=red> connect [%s:%d] failed in %d seconds, maybe in black ip list </font>  <font color=red> connect [%s:%d] failed in %d seconds, return [%s] </font>  <font color=red> smtp command: AUTH LOGIN return [code=%d message=%s] </font>  <font color=yellow> %s:%d smtp port not numberic </font> ### ###  <font color=yellow> smtp_host or smtp_port not defined </font> ### ###  check list: %s ### ###  connect [%s:%d] return welcome banner: ### [%s] (%f seconds) ###  smtp command: AUTH LOGIN return [code=%d message=%s] (%f seconds) ### ###  {crit}:{str}:{ SMTP SVR CRITICAL | %d/%d smtp check critical | %s } {ok}:{str}:{ SMTP SVR OK | %d/%d smtp check success | %s } {unknown}:{str}:{ SMTP SVR UNKNOWN | %d/%d smtp check unknown | %s } Report-Msgid-Bugs-To: zhangguangzheng@eyou.net
Last-Translator: Guangzheng Zhang <zhang.elinks@gmail.com>
Language-Team: EMINFO-LANGUAGE <zhang.elinks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Chinese
X-Poedit-Country: CHINA
 	%+#D 
  (耗时 %f 秒) ### ###   SMTP登录测试跳过, 因为用户或登录密码未设定 ### ###  <font color=red> 连接SMTP地址 %s:%d 在 %d 秒内失败 (有可能是被列入IP黑名单) <font color=red> 连接SMTP地址 %s:%d 在 %d 秒内失败, 失败信息: [%s] </font>  <font color=red> SMTP命令AUTH LOGIN: 返回代码:%d, 返回信息:%s </font>  <font color=yellow> %s:%d SMTP端口非整数数字 </font> ### ###  <font color=yellow> SMTP地址或SMTP端口未定义. </font> ### ###  要检查的SMTP地址列表: %s ### ###  连接SMTP地址 %s:%d 返回欢迎信息: ### [%s] (耗时 %f 秒) ### SMTP命令AUTH LOGIN: 返回代码:%d, 返回信息:%s (耗时 %f 秒) ###  {crit}:{str}:{ SMTP服务状态异常 | %d/%d 项检查异常 | %s } {ok}:{str}:{ SMTP服务状态正常 | %d/%d 项检查正常 | %s } {unknown}:{str}:{ SMTP服务状态未知 | %d/%d 项检查未知 | %s } 