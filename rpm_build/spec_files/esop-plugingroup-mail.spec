Summary: 	esop plugin-group for mail system
Name: 		esop-plugingroup-mail
Version: 	0.1
Release: 	beta1
License: 	GPLv3
Group:  	Extension
Packager: 	Zhang Guangzheng <zhang.elinks@gmail.com>
BuildRoot: 	/var/tmp/%{name}-%{version}-%{release}-root
Source0: 	esop-plugingroup-mail-0.1-beta1.tgz
Requires:		esop >= 1.0-beta2 
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
* Fri Apr  4 2014 Zhang Guangzheng<zhang.elinks@gmail.com>
- 发布: 0.1-beta1
