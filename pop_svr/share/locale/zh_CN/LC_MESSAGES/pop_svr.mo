��          �      <      �     �     �     �  ?   �  >     K   O  G   �  G   �  @   +  E   l     �  A   �  S     ?   `  A   �  8   �  B     /  ^     �     �     �  E   �  D   �  W   ;  I   �  I   �  C   '  D   k  (   �  F   �  X    	  D   y	  C   �	  A   
  F   D
                   	                                
                                                  	%+#D 
  (%f seconds) ### ###   pop_user or pop_pass not defined, pop login test skip ### ###  <font color=red> connect [%s:%d] failed in %d seconds </font>  <font color=red> connect [%s:%d] failed in %d seconds, return [%s] </font>  <font color=red> pop command: PASS return [code=%d message=%s] </font>  <font color=red> pop command: USER return [code=%d message=%s] </font>  <font color=yellow> %s:%d pop port not numberic </font> ### ###  <font color=yellow> pop_host or pop_port not defined </font> ### ###  check list: %s ### ###  connect [%s:%d] return welcome banner: ### [%s] (%f seconds) ###  pop command: PASS return [code=%d message=Authorized Success] (%f seconds) ### ###  pop command: USER return [code=%d message=%s] (%f seconds) ###  {crit}:{str}:{ POP SVR CRITICAL | %d/%d pop check critical | %s } {ok}:{str}:{ POP SVR OK | %d/%d pop check success | %s } {unknown}:{str}:{ POP SVR UNKNOWN | %d/%d pop check unknown | %s } Report-Msgid-Bugs-To: zhangguangzheng@eyou.net
Last-Translator: Guangzheng Zhang <zhang.elinks@gmail.com>
Language-Team: EMINFO-LANGUAGE <zhang.elinks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Chinese
X-Poedit-Country: CHINA
 	%+#D 
  (耗时 %f 秒) ### ###   POP登录测试跳过, 因为用户或登录密码未设定 ### ###  <font color=red> 连接POP地址 %s:%d 在 %d 秒内失败. </font>  <font color=red> 连接POP地址 %s:%d 在 %d 秒内失败, 失败信息: [%s] </font>  <font color=red> POP命令PASS: 返回代码:%d, 返回信息:%s </font>  <font color=red> POP命令USER: 返回代码:%d, 返回信息:%s </font>  <font color=yellow> %s:%d POP端口非整数数字 </font> ### ###  <font color=yellow> POP地址或POP端口未定义. </font> ### ###  要检查的POP地址列表: %s ### ###  连接POP地址 %s:%d 返回欢迎信息: ### [%s] (耗时 %f 秒) ### POP命令PASS: 返回代码:%d, 返回信息:Authorized Success (耗时 %f 秒) ### ###  POP命令USER: 返回代码:%d, 返回信息:%s (耗时 %f 秒) ###  {crit}:{str}:{ POP服务状态异常 | %d/%d 项检查异常 | %s } {ok}:{str}:{ POP服务状态正常 | %d/%d 项检查正常 | %s } {unknown}:{str}:{ POP服务状态未知 | %d/%d 项检查未知 | %s } 