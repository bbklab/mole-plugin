Summary: 	plugins for mole
Name: 		mole-plugin
Version: 	0.1
Release: 	beta1
License: 	GPLv3
Group:  	Extension
Packager: 	Zhang Guangzheng <zhang.elinks@gmail.com>
BuildRoot: 	/var/tmp/%{name}-%{version}-%{release}-root
Source0: 	mole-plugin-0.1-beta1.tgz
Requires:		mole >= 1.0, setup >= 2.5.58
Requires: 		coreutils >= 5.97, bash >= 3.1
Requires:		e2fsprogs >= 1.39, procps >= 3.2.7
Requires:		psmisc >= 22.2, util-linux >= 2.13
Requires:		SysVinit >= 2.86, nc >= 1.84
Requires: 		gawk >= 3.1.5, sed >= 4.1.5
Requires:		perl >= 5.8.8, grep >= 2.5.1
Requires:		tar >= 1.15.1, gzip >= 1.3.5
Requires:		curl >= 7.15.5, bc >= 1.06
Requires:		findutils >= 4.2.27, net-tools >= 1.60
Requires:		dmidecode >= 2.7, redhat-lsb >= 3.1
Requires:		glibc-common >= 2.5, pciutils >= 2.2.3
Requires:		ethtool >= 5, MegaCli >= 8.02.21
Requires:		bind-utils >= 9.3.3
Requires(post): 	chkconfig
Requires(preun): 	chkconfig, initscripts
Requires(postun): 	coreutils >= 5.97
#
# All of version requires are based on OS rhel5.1 release
#

%description 
plugins for mole

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
for p in `ls`
do
  cp -a ${p}/${p}	   $RPM_BUILD_ROOT/usr/local/esop/agent/mole/plugin/
  cp -a ${p}/conf/${p}.ini $RPM_BUILD_ROOT/usr/local/esop/agent/mole/conf/
  [ -f "${p}/docs/cn/readme" ] && cp -a ${p}/docs/cn/readme  $RPM_BUILD_ROOT/usr/local/esop/agent/mole/docs/cn/${p}.readme
  [ -f "${p}/docs/en/readme" ] && cp -a ${p}/docs/en/readme  $RPM_BUILD_ROOT/usr/local/esop/agent/mole/docs/en/${p}.readme
  cp -a ${p}/handler/      $RPM_BUILD_ROOT/usr/local/esop/agent/mole/
  cp -a ${p}/opt/          $RPM_BUILD_ROOT/usr/local/esop/agent/mole/
  cp -a ${p}/share/	   $RPM_BUILD_ROOT/usr/local/esop/agent/mole/
done

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

%post

%preun

%postun

%changelog
* Mon Mar  3 2014 Zhang Guangzheng<zhang.elinks@gmail.com>
- init buildrpm for esop-plugin-1.0-beta1.rpm
