��          �      L      �     �     �  9   �  ]     ^   a  ;   �  ]   �     Z     s     �     �     �      �     �     �  %        =  (   Z  /  �     �     �  _   �  �     �   �  ^   (  �   �     
     &     B  +   ^     �  #   �     �  )   �  2   	  #   C	  .   g	                  
          	                                                                        	%+#D 
 ${device} -> ${mount} (${fstype}) : spare [${spare_pct}%] ${device} -> ${mount} (${fstype}) : spare [${spare_pct}%] <= [${disk_spare_percent_uplimit}%] ${device} -> ${mount} (${fstype}) : spare [${spare_pct}%] <= [${inode_spare_percent_uplimit}%] ${device} -> ${mount} (${fstype}) : spare [${spare_space}M] ${device} -> ${mount} (${fstype}) : spare [${spare_space}M] <= [${disk_spare_space_uplimit}M] ${warnnum} check failed. Disk Space Check OK Disk Space Check WARNING File: [/etc/mtab] not prepared. Inode Check SKIP. as mount point=[${fmount}] Space Check Util: [/bin/df] not prepared. disk-space, disk-inode check success. filed number [${fdnum}] <> 7 percent filed [${fpercent}] unrecognized Report-Msgid-Bugs-To: zhangguangzheng@eyou.net
Last-Translator: Guangzheng Zhang <zhang.elinks@gmail.com>
Language-Team: EMINFO-LANGUAGE <zhang.elinks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Chinese
X-Poedit-Country: CHINA
 	%+#D 
 设备: ${device}, 挂载点为${mount}, 分区类型${fstype}, 可用百分比为${spare_pct}% 设备: ${device}, 挂载点为${mount}, 分区类型${fstype}, 可用百分比为${spare_pct}%, 低于${disk_spare_percent_uplimit}% 设备: ${device}, 挂载点为${mount}, 分区类型${fstype}, 可用百分比为${spare_pct}%, 低于${inode_spare_percent_uplimit}% 设备: ${device}, 挂载点为${mount}, 分区类型${fstype}, 可用空间为${spare_space}M 设备: ${device}, 挂载点为${mount}, 分区类型${fstype}, 可用空间为${spare_space}M, 低于${disk_spare_space_uplimit}M ${warnnum} 项检查告警. 磁盘使用率检查正常 磁盘使用率检查告警 [/etc/mtab] 文件不存在或为空文件. 磁盘节点使用率检查 跳过挂载点 ${fmount} 的检查 磁盘空间使用率检查 [/bin/df] 不存在或没有执行权限. 磁盘空间使用率,磁盘节点使用率正常. 字段个数为${fdnum}, 不等于7 使用率字段格式无法识别: ${fpercent} 