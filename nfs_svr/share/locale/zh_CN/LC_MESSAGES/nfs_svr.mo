��          �      <      �     �     �  "   �     �  !   �          >     U     f  ;   �  9   �  >   �  <   :  &   w  (   �  )   �  +   �  /       M     S     U  8   q     �  +   �     �       '     <   D  <   �  C   �  C     I   F  8   �  3   �  5   �                      
   	                                                                            	%+#D 
 ${critnum} nfs server check failed ${ip}:${i} mounted on ${mpoint} ${total} nfs server check success File: [/etc/mtab] not prepared. NFS SVR Check CRITICAL NFS SVR Check OK NFS Server: [${nfs_server_ip}] nfs local client services: [${failed_client_services}] dead nfs local client services: [${nfs_client_services}] alive nfs server [${ip}], services: [${failed_server_services}] dead nfs server [${ip}], services: [${nfs_server_services}] alive read nfs exports error: [${readerror}] read nfs exports list: [${path_exports}] utilite [/usr/sbin/rpcinfo] not prepared. utilite [/usr/sbin/showmount] not prepared. Report-Msgid-Bugs-To: zhangguangzheng@eyou.net
Last-Translator: Guangzheng Zhang <zhang.elinks@gmail.com>
Language-Team: EMINFO-LANGUAGE <zhang.elinks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Chinese
X-Poedit-Country: CHINA
 	%+#D 
 ${critnum} 项检查失败. NFS共享输出: ${ip}:${i} 挂载在本地的 ${mpoint} ${total} 项检查正常. [/etc/mtab] 文件不存在或为空文件. NFS服务检查失败 NFS服务检查正常 NFS服务器地址为: ${nfs_server_ip} NFS本地客户端服务 ${failed_client_services} 未运行 NFS本地客户端服务 ${nfs_client_services} 正常运行 NFS服务器 ${ip} 的NFS服务 ${failed_server_services} 未运行 NFS服务器 ${ip} 的NFS服务 ${nfs_server_services} 正常运行 读取NFS服务器的共享输出列表失败, 失败信息: ${readerror} 读取NFS服务器的共享输出列表: ${path_exports} [/usr/sbin/rpcinfo] 不存在或没有执行权限. [/usr/sbin/showmount] 不存在或没有执行权限. 