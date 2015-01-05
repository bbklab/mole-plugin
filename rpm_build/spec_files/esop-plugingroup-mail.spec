Summary: 	esop plugin-group for mail system
Name: 		esop-plugingroup-mail
Version: 	0.3
Release:	rhel
License: 	GPLv3
Group:  	Extension
Packager: 	Zhang Guangzheng <zhang.elinks@gmail.com>
BuildRoot: 	/var/tmp/%{name}-%{version}-%{release}-root
Source0: 	esop-plugingroup-mail-0.3-rhel.tgz
Requires:		esop >= 1.2.0
Requires:		bind-utils >= 9.3.3
Requires:		findutils >= 4.2.27
Requires:		perl >= 5.8.8
#
# All of version requires are based on OS rhel5.1 release
#

%description 
esop plugin group for mail system

%prep
%setup -q

cat << \EOF > %{_builddir}/%{name}-plreq
#!/bin/sh
%{__perl_requires} $* |\
sed -e '/perl(JSON)/d' |\
sed -e '/perl(Locale::Messages)/d'
EOF
%define __perl_requires %{_builddir}/%{name}-plreq
chmod 755 %{__perl_requires}

%build

%install 
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/plugin/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/conf/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/docs/{cn,en}/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/handler/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/opt/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/share/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/upgrade/
for p in dns_svr http_svr imap_svr pop_svr smtp_svr emp_mailqueue emp_smtpauth_limit remote_mailtest dnsbl
do
  /bin/cp -a ${p}/${p}	   		$RPM_BUILD_ROOT/usr/local/esop/agent/mole/plugin/
  /bin/cp -a ${p}/conf/${p}.ini 	$RPM_BUILD_ROOT/usr/local/esop/agent/mole/conf/
  [ -f "${p}/docs/cn/readme" ] && cp -a ${p}/docs/cn/readme  $RPM_BUILD_ROOT/usr/local/esop/agent/mole/docs/cn/${p}.readme
  [ -f "${p}/docs/en/readme" ] && cp -a ${p}/docs/en/readme  $RPM_BUILD_ROOT/usr/local/esop/agent/mole/docs/en/${p}.readme
  /bin/cp -a ${p}/handler/      	$RPM_BUILD_ROOT/usr/local/esop/agent/mole/
  /bin/cp -a ${p}/opt/          	$RPM_BUILD_ROOT/usr/local/esop/agent/mole/
  /bin/cp -a ${p}/share/	   	$RPM_BUILD_ROOT/usr/local/esop/agent/mole/
done
/bin/cp -a esop-plugingroup-mail_upgrade $RPM_BUILD_ROOT/usr/local/esop/agent/mole/upgrade/

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/local/esop/agent/mole/plugin/
/usr/local/esop/agent/mole/conf/
/usr/local/esop/agent/mole/docs/
/usr/local/esop/agent/mole/handler/
/usr/local/esop/agent/mole/opt/
/usr/local/esop/agent/mole/share/
/usr/local/esop/agent/mole/upgrade/

%pre
# backup old version config files / save old version
if /bin/rpm -qi "esop-plugingroup-mail" >/dev/null 2>&1; then
	# following abandoned: as %{version} will be replaced by fix string {VERSION} on rpm executing
	# OLD_ESOP_VERSION=$( /bin/rpm -q --queryformat "%{version}" "esop-plugingroup-mail" 2>&- )
	OLD_ESOP_VERSION=$( /usr/local/esop/agent/mole/plugin/emp_mailqueue version 2>&- )
	if [ ! -z "${OLD_ESOP_VERSION//[0-9.]}" ]; then
		OLD_ESOP_VERSION="0.1"		# 0.1 do NOT support version
	fi
	if [ -n "${OLD_ESOP_VERSION}" ]; then
		OLD_ESOP_SAVEDIR="/var/tmp/oldesop-plugingroup-mail-rpmsavedir"
		OLD_ESOP_VERFILE="${OLD_ESOP_SAVEDIR}/.version_upgrade-esop-plugingroup-mail"
		if /bin/mkdir -p "${OLD_ESOP_SAVEDIR}/" >/dev/null 2>&1; then
			if echo -en "${OLD_ESOP_VERSION}" > "${OLD_ESOP_VERFILE}" 2>/dev/null; then
				MOLE_CONF_PATH="/usr/local/esop/agent/mole/conf"
				/bin/cp -arf "${MOLE_CONF_PATH}" "${OLD_ESOP_SAVEDIR}" >/dev/null 2>&1
			fi
		fi
	fi
fi
:

%post
# init plugin configs
plugins=( dns_svr http_svr imap_svr pop_svr smtp_svr emp_mailqueue emp_smtpauth_limit remote_mailtest dnsbl )
/bin/bash /usr/local/esop/agent/mole/bin/autoconf rpminit ${plugins[*]}

# upgrade old version
ESOP_UPGRADE_MODE=1 ESOP_RPM_UPGRADE=1 /bin/bash /usr/local/esop/agent/mole/upgrade/esop-plugingroup-mail_upgrade
:

%preun
:

%postun
:

%changelog
* Mon Jan  5 2015 Zhang Guangzheng<zhangguangzheng@eyou.net>
- 发布: 0.3 正式版
- 新增: 新增加插件emp_smtpauth_limit, 用于限制eYou5/8邮件系统中的账户单日SMTP认证次数
- 新增: 新增加插件remote_mailtest, 用于测试当前服务器能否和指定域名的邮箱进行SMTP通讯
- 新增: 新增插件dnsbl, 用于查询出口IP是否被列入DNSBL服务器黑名单
- 修正: 若干bug修复
* Wed Sep 17 2014 Zhang Guangzheng<zhangguangzheng@eyou.net>
- 发布: 0.2 正式版
- 新增: 插件emp_mailqueue支持多阈值配置
- 新增: 插件http_svr详细输出中增加各步骤耗时信息
- 新增: 插件http_svr自动跟踪3XX的HTTP响应
- 新增: RPM升级过程中自动进行旧版保留数据的升级和校验
- 修正: 若干bug修复
* Mon May 26 2014 Zhang Guangzheng<zhangguangzheng@eyou.net>
- 发布: 0.1 正式版
- 调整: 若干插件的输出样式
- 修正: 若干bug
* Tue Apr  8 2014 Zhang Guangzheng<zhangguangzheng@eyou.net>
- 发布: 0.1-beta1
