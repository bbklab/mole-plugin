��          �      \      �     �     �     �     �     �          %     @  _   [     �     �  U   �  -   8     f     s     �  '   �  (   �  (   �  /       D     J     L     c  +   q     �     �     �  V   �     Q     k  X   �  x   �     W     j     �  "   �  #   �  $   �                                                          	                                     
    	%+#D 
 Check List: Check Pairs: Pairs: [${pairs}] is invalid Traffic Flow Check OK Traffic Flow Check UNKNOWN Traffic Flow Check WARNING [/sys/class/net/${inet_face}] not an exists direcoty, maybe interface [${inet_face}] not exists bytes flowin rate: bytes flowout rate: ibytes_limit=[${ibytes_limit}] or obytes_limit=[${obytes_limit}] format unrecognised. inet_face/ibytes_limit/obytes_limit required: not numberic packs flowin rate: packs flowout rate: total: ${oknum}/${total} check success. total: ${unknum}/${total} check unknown. total: ${warnnum}/${total} check failed. Report-Msgid-Bugs-To: zhangguangzheng@eyou.net
Last-Translator: Guangzheng Zhang <zhang.elinks@gmail.com>
Language-Team: EMINFO-LANGUAGE <zhang.elinks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Chinese
X-Poedit-Country: CHINA
 	%+#D 
 检查的网卡列表: 检查网卡: 网卡检测配置格式不识别: ${pairs} 网卡流量速度检查正常 网卡流量速度检查未知 网卡流量速度检查告警 目录/sys/class/net/${inet_face}不存在, 或许并不存在网卡设备${inet_face} 网卡入口流量速度: 网卡出口流量速度: 入口流量限制${ibytes_limit} 或 出口流量限制${obytes_limit} 格式不正确. 至少需要如下三个参数: 网卡设备名inet_face, 入口流量限制ibytes_limit, 出口流量限制obytes_limit 不是整数数字 网卡入口数据包速度: 网卡出口数据包速度: ${oknum}/${total} 项检查正常. ${unknum}/${total} 项检查未知. ${warnnum}/${total} 项检查告警. 