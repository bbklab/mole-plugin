Þ    /        C                     -   !  *   O  +   z  ,   ¦     Ó     ß     ì     	     $     :     U  _   p     Ð  9   ã  9        W  :   k  :   ¦     á  U   ÿ  :   U  R        ã  U   ù  (   O     x  -     G   ¹  *   	  M   ,	     z	  U   	  :   Ý	  R   
     k
  G   
  *   É
  M   ô
     B  5   U  5        Á  6   Õ  6     -  C     q     w  -   y  +   §  ,   Ó  -         .     E  +   S               ½     Ü  V   û     R  O   l  O   ¼       O   &  O   v     Æ  O   å  @   5  L   v     Ã  X   à  &   9     `  x   z  A   ó  2   5  G   h     °  O   Ã  @     L   T     ¡  A   ¾  2      G   3     {  N     N   ç     6  N   S  N   ¢             /   !                           ,         "           #       &          
       '                       .         $   +          %              (                             	             *                        )      -       	%+#D 
 ${critnum}/${total} interface check critical. ${oknum}/${total} interface check success. ${unknum}/${total} interface check unknown. ${warnnum}/${total} interface check warning. Check List: Check Pairs: Pairs: [${pairs}] is invalid Traffic Flow Check CRITCAL Traffic Flow Check OK Traffic Flow Check UNKNOWN Traffic Flow Check WARNING [/sys/class/net/${inet_face}] not an exists direcoty, maybe interface [${inet_face}] not exists bytes flowin rate: bytes flowin rate: ${ib_rate_m}M/s >= ${IB_CRIT_LIMIT}M/s bytes flowin rate: ${ib_rate_m}M/s >= ${IB_WARN_LIMIT}M/s bytes flowout rate: bytes flowout rate: ${ob_rate_m}M/s >= ${OB_CRIT_LIMIT}M/s bytes flowout rate: ${ob_rate_m}M/s >= ${OB_WARN_LIMIT}M/s config ifdev_lst not defined. ibytes_limit [${orig_ibytes_limit}] is invalid multi threshold on int or float check. ibytes_limit [${orig_ibytes_limit}] should be int or float ibytes_limit [${orig_ibytes_limit}] warn threshold must lower than crit threshold. ibytes_limit required ibytes_limit=[${ibytes_limit}] or obytes_limit=[${obytes_limit}] format unrecognised. inet interface [${inet_face}] not exists inet_face required inet_face/ibytes_limit/obytes_limit required: ipacks_limit [${ipacks_limit}] is invalid multi threshold on int check. ipacks_limit [${ipacks_limit}] must be int ipacks_limit [${ipacks_limit}] warn threshold must lower than crit threshold. not numberic obytes_limit [${orig_obytes_limit}] is invalid multi threshold on int or float check. obytes_limit [${orig_obytes_limit}] should be int or float obytes_limit [${orig_obytes_limit}] warn threshold must lower than crit threshold. obytes_limit required opacks_limit [${opacks_limit}] is invalid multi threshold on int check. opacks_limit [${opacks_limit}] must be int opacks_limit [${opacks_limit}] warn threshold must lower than crit threshold. packs flowin rate: packs flowin rate: ${ip_rate}/s >= ${IP_CRIT_LIMIT}/s packs flowin rate: ${ip_rate}/s >= ${IP_WARN_LIMIT}/s packs flowout rate: packs flowout rate: ${op_rate}/s >= ${OP_CRIT_LIMIT}/s packs flowout rate: ${op_rate}/s >= ${OP_WARN_LIMIT}/s Report-Msgid-Bugs-To: zhangguangzheng@eyou.net
Last-Translator: Guangzheng Zhang <zhang.elinks@gmail.com>
Language-Team: MOLE-LANGUAGE <zhang.elinks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Chinese
X-Poedit-Country: CHINA
 	%+#D 
 ${critnum}/${total} ç½å¡æµéæ£æ¥æé. ${oknum}/${total} ç½å¡æµéæ£æ¥æ­£å¸¸. ${unknum}/${total} ç½å¡æµéæ£æ¥æªç¥. ${warnnum}/${total} ç½å¡æµéæ£æ¥åè­¦. æ£æ¥çç½å¡åè¡¨: æ£æ¥ç½å¡: ç½å¡æ£æµéç½®æ ¼å¼ä¸è¯å«: ${pairs} ç½å¡æµééåº¦æ£æ¥æé ç½å¡æµééåº¦æ£æ¥æ­£å¸¸ ç½å¡æµééåº¦æ£æ¥æªç¥ ç½å¡æµééåº¦æ£æ¥åè­¦ ç®å½/sys/class/net/${inet_face}ä¸å­å¨, æè®¸å¹¶ä¸å­å¨ç½å¡è®¾å¤${inet_face} ç½å¡å¥å£æµééåº¦: ç½å¡å¥å£æµééåº¦: ${ib_rate_m}M/s è¶åºæééå¼${IB_CRIT_LIMIT}M/s ç½å¡å¥å£æµééåº¦: ${ib_rate_m}M/s è¶åºè­¦åéå¼${IB_WARN_LIMIT}M/s ç½å¡åºå£æµééåº¦: ç½å¡åºå£æµééåº¦: ${ob_rate_m}M/s è¶åºæééå¼${OB_CRIT_LIMIT}M/s ç½å¡åºå£æµééåº¦: ${ob_rate_m}M/s è¶åºè­¦åéå¼${OB_WARN_LIMIT}M/s éç½®é¡¹ ifdev_lst æªå®ä¹. å¥æµééå¶ [${orig_ibytes_limit}] æ¯ä¸ªéå¼é½åºè¯¥æ¯æ´æ°æå°æ°. å¥æµééå¶ [${orig_ibytes_limit}] åºè¯¥æ¯æ´æ°æå°æ°. å¥æµééå¶ [${orig_ibytes_limit}] è­¦åéå¼å¿é¡»å°äºæééå¼. éè¦æå®å¥æµééå¶. å¥å£æµééå¶${ibytes_limit} æ åºå£æµééå¶${obytes_limit} æ ¼å¼ä¸æ­£ç¡®. ç½å¡è®¾å¤ [${inet_face}] ä¸å­å¨. éè¦æå®ç½å¡åç§°. è³å°éè¦å¦ä¸ä¸ä¸ªåæ°: ç½å¡è®¾å¤åinet_face, å¥å£æµééå¶ibytes_limit, åºå£æµééå¶obytes_limit å¥åæ°éå¶ [${ipacks_limit}] æ¯ä¸ªéå¼é½åºè¯¥æ¯æ´æ°. å¥åæ°éå¶ [${ipacks_limit}] åºè¯¥æ¯æ´æ°. å¥åæ°éå¶ [${ipacks_limit}] è­¦åéå¼å¿é¡»å°äºæééå¼. ä¸æ¯æ´æ°æ°å­ åºæµééå¶ [${orig_obytes_limit}] æ¯ä¸ªéå¼é½åºè¯¥æ¯æ´æ°æå°æ°. åºæµééå¶ [${orig_obytes_limit}] åºè¯¥æ¯æ´æ°æå°æ°. åºæµééå¶ [${orig_obytes_limit}] è­¦åéå¼å¿é¡»å°äºæééå¼. éè¦æå®åºæµééå¶. åºåæ°éå¶ [${opacks_limit}] æ¯ä¸ªéå¼é½åºè¯¥æ¯æ´æ°. åºåæ°éå¶ [${opacks_limit}] åºè¯¥æ¯æ´æ°. åºåæ°éå¶ [${opacks_limit}] è­¦åéå¼å¿é¡»å°äºæééå¼. ç½å¡å¥å£æ°æ®åéåº¦: ç½å¡å¥å£æ°æ®åéåº¦: ${ip_rate}/s è¶åºæééå¼${IP_CRIT_LIMIT}/s ç½å¡å¥å£æ°æ®åéåº¦: ${ip_rate}/s è¶åºè­¦åéå¼${IP_WARN_LIMIT}/s ç½å¡åºå£æ°æ®åéåº¦: ç½å¡åºå£æ°æ®åéåº¦: ${op_rate}/s è¶åºæééå¼${OP_CRIT_LIMIT}/s ç½å¡åºå£æ°æ®åéåº¦: ${op_rate}/s è¶åºè­¦åéå¼${OP_WARN_LIMIT}/s 