#!/usr/bin/perl -w
# Author: Stefan Worm, 2007 ( alphacentaurie@yahoo.de )

# Description:
#     The Plugin check_iberr.pl checks and reports the status of 
#     InfiniBand Network Adapters (RcvErrors, LinkDowned, 
#     ExcBufOverrunErrors, etc.) either it check the performance/error 
#     counters remotely via InfinBand (very fast) or with the help of 
#     NRPE on the specific host.

# Preconditions:
#    1) - to run this script in a more secure way, please use the '-T' 
#         option of the Perl interpreter ("#!/usr/bin/perl -Tw" instead 
#         of "#!/usr/bin/perl -w") in the first line of this script) and 
#         comment out the three lines starting with "$ENV" at the 
#         beginning of the program-code of this script
#       - unfortunately for this, the OFED-'ibcheckerrs' script has to 
#         be patched
#         (reason: the OFED-'ibcheckerrs' script executes just 'awk' 
#         instead of '/bin/awk' which is not compatible with the '-T' 
#         option of Perl that is recommended to use)
#    2a) copy the file 'ibcheckerrs_patched' which should have been in the 
#        collection of this script to your ofed-directory [only if your
#        'awk' path is '/usr/bin/awk', otherwise see 2b)]
# or 2b) - subsitute the 2-3 occurrences of 'awk' command in in the 
#          'ibcheckerrs' script with the full path of your 'awk' 
#           (e.g. '/usr/bin/awk' or '/bin/awk')
#        - for this, you can use for example the following VI command:
#          ':%s/awk/\/bin\/awk/'
#    3a) - setuid for following OFED-Tools: 'ibcheckerrs'
#          (and maybe 'ibcheckerrs_patched'), 'perfquery' and 'ibaddr'
#        - go to your OFED-directory, e.g. '/usr/ofed/bin';
#          execute: 'sudo chmod +s ibaddr perfquery ibcheckerrs ibcheckerrs_patched'
#          or: sudo su; [or: su;] 'chmod +s ibaddr perfquery ibcheckerrs ibcheckerrs_patched'
# or 3b) run the script with superuser rights 
#        (e.g. directly as root or via sudo)
#    4) you also need to "install" the NSCA tool of Nagios
#       (finally you need only the 'send_nsca' binary and the 
#       'send_nsca.cfg' file, which usually don't have to be changed)
#    5) on the host to which the results of the script should be 
#       sent (see '-m'), the NSCA-Daemon must be running
#    6) the OFED-Tools must be installed 
#       (http://www.openfabrics.org/downloads.html > ofed 1.1)

# Examples for execution:
# ./check_iberr.pl -m Nagios-IP -H Hostname-to-be-monitored -G InfiniBand-GUID
# ./check_iberr.pl -m 192.168.1.98 -H c5-2 -G localhost
# ./check_iberr.pl -m 192.168.1.98 -H c5-2 -G 0x0002c90200007615 -c 4
# ./check_iberr.pl -b -m 192.168.1.98 -H c5-2 -G 0x002c9010c57ed00 -c 4 -p 1 -f /usr/ofed/bin/thresholds-file.txt -d /usr/ofed-dir -n /usr/nagios/send_nsca-dir -g /etc/nagios/send_nsca.cfg-dir
# (For the format of the threshold file see the end of this script.)

use POSIX;
use strict;
use Getopt::Long;
use vars qw($opt_V $opt_h $opt_b $opt_r $opt_u $opt_m $opt_H $opt_G $opt_l
            $opt_p $opt_c $opt_d $opt_n $opt_g $opt_f $PROGNAME);

my (%ERRORS) = ("UNKNOWN" => 3,"OK" => 0,'WARNING' => 1,"CRITICAL" => 2);
$PROGNAME = "check_iberr";

sub print_revision ($$);
sub usage;
sub support();
sub print_help ();
sub print_usage ();

# comment out the the following three lines if you use the '-T' option 
# (recommended because of security reason), but before doing this, make 
# sure that the OFED-'ibcheckerrs' script is pateched (see above)
#$ENV{'PATH'}='';
#$ENV{'BASH_ENV'}='';
#$ENV{'ENV'}='';

# Reads the input options of the script
Getopt::Long::Configure('bundling');
GetOptions ( "V"   => \$opt_V, "version"          => \$opt_V,
             "h"   => \$opt_h, "help"             => \$opt_h,
             "b"   => \$opt_b, "bug"              => \$opt_b,
             "r"   => \$opt_r, "reset"            => \$opt_r,
             "u"   => \$opt_u, "update"           => \$opt_u,
             "m=s" => \$opt_m, "monitoringhost=s" => \$opt_m,
             "H=s" => \$opt_H, "hostname=s"       => \$opt_H,
             "G=s" => \$opt_G, "portguid=s"       => \$opt_G,
             "l=s" => \$opt_l, "lid=s"            => \$opt_l,
             "p=s" => \$opt_p, "portnumber=s"     => \$opt_p,
             "c=s" => \$opt_c, "critical=s"       => \$opt_c,
             "d=s" => \$opt_d, "ofeddir=s"        => \$opt_d,
             "n=s" => \$opt_n, "sendnscabindir=s" => \$opt_n,
             "g=s" => \$opt_g, "sendnscacfgdir=s" => \$opt_g,
             "f=s" => \$opt_f, "thresholdfile=s"  => \$opt_f  );

# Verify the correctness of the input options
if ($opt_V) {
   print_revision($PROGNAME,'$Revision: 0.4 $');
   exit $ERRORS{'OK'};
}

if ($opt_h) {
   print_help(); exit $ERRORS{'OK'};
}

if (($opt_r) && ($opt_b)) {
   print "resetting performance (error) counters\n";
}

if (($opt_u) && ($opt_b)) {
   print "updating all performance (error) counters\n";
}

($opt_m)  || ($opt_m = 'localhost');
my $monhost = $1 if ($opt_m =~ /([-.A-Za-z0-9]+)/);
($monhost) || usage("Invalid address: $opt_m\n");

($opt_H) || usage("Warning: host IP address not specified\n");
my $hostname = $1 if ($opt_H =~ /([-.A-Za-z0-9]+)/);
($hostname) || usage("Invalid host IP address: $opt_H\n");

$opt_G || ($opt_G = 'localhost');
my $portguid = $1 if ($opt_G =~ /([-.A-Za-z0-9]+)/);
($portguid) || usage("Invalid portguid address: $opt_G\n");

($opt_l) || ($opt_l = 'none');  
my $portlid = $1 if ($opt_l =~ /([-.A-Za-z0-9]+)/);
($portlid) || usage("Invalid LID address: $opt_l\n");

($opt_c) || ($opt_c = 10);
my $critical = $1 if ($opt_c =~ /([0-9]{1,5}|66000)/);
($critical) || usage("Invalid critical threshold factor\n");

($opt_p) || ($opt_p = 1);
my $portnr = $1 if ($opt_p =~ /([0-9]{1,2}|100)+/);
($portnr) || usage("Invalid port number (usually: 1): $opt_p\n");

($opt_d) || ($opt_d = '/usr/ofed/bin');
my $ofed = $1 if ($opt_d =~ /([-.A-Za-z0-9\/]+)/);
($ofed) || usage("Invalid OFED directory (usually: /usr/ofed/bin): $opt_d\n");

($opt_n) || ($opt_n = '/usr/bin');
my $sendnscabindir = $1 if ($opt_n =~ /([-.A-Za-z0-9\/]+)/);
($sendnscabindir) || usage("Invalid directory
                            (usually: /usr/bin): $sendnscabindir\n");

($opt_g) || ($opt_g = '/etc/nsca');
my $sendnscacfgdir = $1 if ($opt_g =~ /([-.A-Za-z0-9\/]+)/);
($sendnscacfgdir) || usage("Invalid directory
                            (usually: /etc/nsca): $sendnscacfgdir\n");

my $thresholdfile='';
if ($opt_f) { $thresholdfile = $1 if ($opt_f =~ /([-.A-Za-z0-9\/\_]+)/);
}

my $lidstr='';
if ($portguid eq "localhost") {
        if ($portlid eq "none") {
             $lidstr = `$ofed/ibaddr`;
        } else { $lidstr = `$ofed/ibaddr $portlid`; }
} else { $lidstr = `$ofed/ibaddr -G $portguid`;
       }

my @test=split(/ /,$lidstr);
if ($opt_b) {print "LIDstr: $lidstr";}

# - checks if the script was executed with sufficient rights
# - get the LID, based on the given GID
if ("GID" ne $test[0] ) {
        if ($opt_b) {
           print "test[1]: $test[1] - Error: This script was possibly
                  not started with superuser rights.\n";
        }
        alarm(2); # alarm is set to 2 seconds
        $lidstr = `/usr/bin/sudo $ofed/ibaddr -G $portguid`;
        alarm(0); # cancel the alarm if everything is alright
        if ($opt_b) {
           print "LIDstr: $lidstr";
        }
        @test=split(/ /,$lidstr);
        if ($test[4] eq "resolve") {
            print "The LID that was passed does not exist.\n";
            exit $ERRORS{'UNKNOWN'};
        }
        if ($test[5] eq "path_query") {
            print "The GUID that was passed does not exist.\n";
            exit $ERRORS{'UNKNOWN'};
        }
        if ("GID" ne $test[0]){
                if ($opt_b) {
                   print "test[1]: $test[1] - Error: This script needs
                          superuser rights (must be started as ROOT or SUDO
                          must be configured).\n";
                }
                print "Script could not be executed without errors: Possibly
                       missing rights (no ROOT, no SUDO) or output format of
                       parsed tools (ibaddr) has changed.\n";
                exit $ERRORS{'UNKNOWN'};
        }
        my $noroot = 1;
}

my $sublidstr = $1 if ($test[4] =~ /([-.x0-9a-zA-Z]*)/);
if ($opt_b) { print "sublidstr: $sublidstr (test[4]: $test[4]\n"; }

# the performance counters are read
my @result='';
if ($opt_f) {
   @result = `$ofed/ibcheckerrs -v -t $thresholdfile $sublidstr $portnr`;
   } else {
     @result = `$ofed/ibcheckerrs -v  $sublidstr $portnr`;
}

my $anzresult = scalar(@result)-1;
my $i=0;
my @temp;
my @nsca_send;
my $thstr='';
my $thint=0;
my $thcrit=0;
my $value=0;
my $crit_val_ocured=0;
my (%th)=( 'RcvErrors', "4", 'RcvRemotePhysErrors', "5",
           'XmtConstraintErrors', "8", 'RcvConstraintErrors', "9",
           'SymbolErrors', "1", 'LinkRecovers', "2", 'LinkDowned', "3",
           'RcvSwRelayErrors', "6", 'XmtDiscards', "7", 'VL15Dropped', "12",
           'LinkIntegrityErrors', "10", 'ExcBufOverrunErrors', "11" );

# checks if the output of the performance check has the expected format
@temp=split(/ /,$result[$anzresult]);
if ("check" ne $temp[1]) {
        # if not: try another way to check the performance counters 
        if ($opt_f) {
           @result = `/usr/bin/sudo $ofed/ibcheckerrs_patched -v -t
                      $thresholdfile $sublidstr $portnr`;
           } else {
             @result = `/usr/bin/sudo $ofed/ibcheckerrs_patched -v  $sublidstr $portnr`;
        }
        $anzresult = scalar(@result)-1;
        @temp=split(/ /,$result[$anzresult]);
        if ("check" ne $temp[1]) {
           print "Script could not be executed without errors: Possibly the
                  output format of parsed tools (ibcheckerrs) has changed.\n";
           exit $ERRORS{'UNKNOWN'};
        }
}

# - if minimum one value exceeds a threshold, this will be reported
#   by sending NSCA reports to the monitoring server (one per value)
if (($anzresult >= 1) || ($opt_u)){
   if ($opt_b) {
      if (!open( WRITEME, "| $sendnscabindir/send_nsca $monhost -c
                           $sendnscacfgdir/send_nsca.cfg")) {
                     print "Script could not be executed without errors: SEND_NSCA
                            could not be executed (executable missing?).\n";
                     exit $ERRORS{'UNKNOWN'};
      }
   } else {
     if (!open( WRITEME, "| $sendnscabindir/send_nsca $monhost -c
                          $sendnscacfgdir/send_nsca.cfg 1>/dev/null")) {
        print "Script could not be executed without errors: SEND_NSCA
               could not be executed (executable missing?).\n";
        exit $ERRORS{'UNKNOWN'};
     }
   }
   for ($i=0; $i<$anzresult; $i++){
       @temp=split(/ /,$result[$i]);
       $thstr = $temp[6];
       chop($thstr); chop($thstr);
       $thint = int($thstr);
       $thcrit= $thint * $critical;
       $value=int($temp[4]);
       if ( int($temp[4]) < $thcrit ) {
          print WRITEME "$hostname\tIB_$temp[2]\t1\tThreshold exceeded:
                         $temp[4] $temp[5] $temp[6]\n\n";
          if ($opt_b) {
             print "warning"; print " --- temp4: --$temp[4]--;
                    value: --$value--; thcrit:  --$thcrit--\n";
          }
       } else { print WRITEME "$hostname\tIB_$temp[2]\t2\tThreshold
                               exceeded: $temp[4] (Critical: $thcrit)\n\n";
            if ($opt_b) {print "critical"; print " --- temp4: --$temp[4]--;
                                value: --$value--; thcrit: --$thcrit--\n";
            }
            $crit_val_ocured=$crit_val_ocured+1;
        }
        delete( $th{$temp[2]} );
        }

        my @errnames = keys( %th );
        for ($i=0;$i<scalar(@errnames);$i++) {
             print WRITEME "$hostname\tIB_$errnames[$i]\t0\tOK:
                            value below threshold\n\n";
             if ($opt_b) {
                 print "OK: "; print " --- errnames
                       --$errnames[$i]--; i: --$i--;\n";
             }
        }
        if ($opt_b) {
            print "Errornames without exceeding a threshold:
                   @errnames; Total: "; print scalar(@errnames);
        }
   close(WRITEME);
}

# if the reset option is set: the performance counters are reseted
my $errcode=0;
if ($opt_r) {
   $errcode = system("$ofed/perfquery -R $sublidstr $portnr");
   if ($errcode != 0) {
       $errcode=0;
       $errcode = system("/usr/bin/sudo $ofed/perfquery -R $sublidstr $portnr");
       if ($errcode != 0) {
          if ($opt_b) { print "\nSomething went wrong! Errcode: $errcode\n"; }
          exit $ERRORS{'UNKNOWN'};
          }
       }
   if ($opt_b) { print "\nerrcode: $errcode (should be '0')\n"; }
}



if ($opt_b) {
   print "Following error counters had values above
          threshold ($anzresult total): \n";
   for ($i=0; $i<$anzresult+1; $i++){
        print "$result[$i]";
   }
}

# - if critical errors or warning occured or everything was alright,
#   different return values were given to Nagios
if ($crit_val_ocured>0) {
   print "$crit_val_ocured value(s) exceeded critical thereshold.\n";
   exit $ERRORS{'CRITICAL'};
}

if ($anzresult>0) {
   print "$anzresult value(s) exceeded warning thereshold.\n";
   exit $ERRORS{'WARNING'};
}

if ($opt_r) {
    print "Resetting of all performance (error) counters successful.\n";
} else {
  print "everything alright\n";
  }

exit $ERRORS{'OK'};

# a few subroutine are defined as follows:
sub print_usage () {
    print "Usage: $PROGNAME [-r] [-u] -H <hostname> [-m <monitoringhost>]
           [-G <portguid>] [-l <lid>] [-p <portnumber>] [-c <crit>] [-d <dir-ofed>]
           [-n<dir-send_nsca>] [-g <dir-send_nsca.cfg>] [-f <thresholdfile>] \n";
}

sub print_help () {
        print_revision($PROGNAME,'$Revision: 0.4 $');
        print "Copyright (c) 2007 Stefan Worm

 This plugin reports if errors at ports of an Infiniband interface have occured.

        ";
        print_usage();
        print "

 -b, --bug
    prints debug messages to STDOUT
 -r, --reset
    reset all performance (error) counters
 -u, --update
    update all performance (error) values
 -H, --hostname=STRING
    Name of the host in which the IB  should be checked
    (exactly the same as defined in Nagios)
 -m, --monitoringhost=IP-Address
    IP address of the monitoring host
    (To where the results of this script should be sent to?)
 -G, --portguid=HEX
    portguid number of the IB device to be checked (Default: localhost)
 -l, --lid=HEX
    lid number of the IB device to be checked
 -p, --portnumber=INTEGER
    portnumber of the IB device to be checked (DEFAULT: 1)
 -c, --critical=INTEGER
    factor of the exceeding of the warning-threshold when
    a CRITICAL status will result (DEFAULT: 10)
 -d, --dirofed=full-directory-path
    Full directory path for the ofed-tools (DEFAULT: /usr/ofed/bin)
 -n, --sendnscabindir=full-directory-path
    Full directory path for the send_nsca binary (DEFAULT: /usr/bin)
 -g, --sendnscacfgdir=full-directory-path
    Full directory path for the send_nsca.cfg config file (DEFAULT: /etc/nsca)
 -f, --filename=threshold-file
    Custom thresholds file with full path
    (DEFAULT THRESHOLD: between 10 or 100 depending on the value)

 ";
        support();
}
sub print_revision ($$) {
   my $commandName = shift;
   my $pluginRevision = shift;
   $pluginRevision =~ s/^\$Revision: //;
   $pluginRevision =~ s/ \$\s*$//;
   print "$commandName (nagios-plugins 1.4.4) $pluginRevision\n";
   print "This nagios plugin come with ABSOLUTELY NO WARRANTY. You may
          redistribute copies of the plugin under the terms of the GNU
          General Public License. For more information about these
          matters, see the file named COPYING.\n";
}

sub support () {
   my $support='Send email to the author if you have questions\n
                regarding use of this software. ';
        $support =~ s/@/\@/g;
        $support =~ s/\\n/\n/g;
        print $support;
}

sub usage {
   my $format=shift;
   printf($format,@_);
   exit $ERRORS{'UNKNOWN'};
}

#######################################################################################
#
# - The following Nagios-Config Examples create a situation in where the host named c5-2
#   should be monitored regarding its Infiniband (IB) error counters via nrpe
#      + this is suitable if the Nagios-host is not connected via IB with
#        the host that should be monitored
#      + but if so, the check_iberr.pl can be executed directly on the Nagios-host
#        and the error-counters check could be made directly via IB-network
#        which brings a little bit more performance
# - The result is that:
#     + every 5 min. the error counters will be checked and only if the state of an error
#       counter has changes this will be (passively) reported to Nagios
#     + every 59 minutes the status of all values will be passively updated and reported to Nagios
#     + every 24h all error counters will be reset
#
# define host{
#         use                     generic-host            ; Name of host template to use (Nagios-Standard-Template)
#         host_name               c5-2
#         alias                   Compute-5-2
#         address                 192.168.1.52
#         check_command           check-host-alive
#         parents                 jack
#         max_check_attempts      10
#         check_period            24x7
#         notification_interval   120
#         notification_period     24x7
#         notification_options    d,r
#         contact_groups          admins
#         }
#
# define service{
#         use                             generic-service         ; Name of service template to use (Nagios-Standard-Template)
#         host_name                       c5-2
#         service_description             iberr_nsca_trigger
#         is_volatile                     0
#         check_period                    24x7
#         max_check_attempts              4
#         normal_check_interval           5
#         retry_check_interval            1
#         contact_groups                  admins
#         notification_options            w,u,c,r
#         notification_interval           960
#         notification_period             24x7
#         check_command                   ibcheckerr!0x0002c9010ad27db1  ;InfiniBand Port GUID
#       }
#
# define service{
#         use                             generic-service         ; Name of service template to use
#         host_name                       c5-2
#         service_description             iberr_nsca_update_trigger
#         is_volatile                     0
#         check_period                    24x7
#         max_check_attempts              4
#         normal_check_interval           59 ;min
#         retry_check_interval            1
#         contact_groups                  admins
#         notification_options            w,u,c,r
#         notification_interval           960
#         notification_period             24x7
#         check_command                   ibcheckerr_update!0x0002c9010ad27db1  
#       }
#
# define service{
#         use                             generic-service         ; Name of service template to use
#         host_name                       c5-2
#         service_description             iberr_nsca_reset_trigger
#         is_volatile                     0
#         check_period                    24x7
#         max_check_attempts              4
#         normal_check_interval           1440 ;in minutes (1440 min. eqals 1 day)
#         retry_check_interval            1
#         contact_groups                  admins
#         notification_options            w,u,c,r
#         notification_interval           1960
#         notification_period             24x7
#         check_command                   ibcheckerr_reset!0x0002c9010ad27db1 
#
# }
#
# ----------------------------------------------------------
# - The following configurations defines a generic service for passive checks
#   and the appropriate real services regarding the error counters of Infiniband
#
# define service{
#         name                            generic-iberrors-service ; The 'name' of this service template
#         active_checks_enabled           0       ; Active service checks are enabled
#         passive_checks_enabled          1       ; Passive service checks are enabled/accepted
#         parallelize_check               1       ; Active service checks should be parallelized (disabling this can lead to major performance problems)
#         obsess_over_service             1       ; We should obsess over this service (if necessary)
#         check_freshness                 1       ; Default is to NOT check service 'freshness'
#         freshness_threshold             3600    ; seconds
#         notifications_enabled           1       ; Service notifications are enabled
#         event_handler_enabled           1       ; Service event handler is enabled
#         flap_detection_enabled          1       ; Flap detection is enabled
#         failure_prediction_enabled      1       ; Failure prediction is enabled
#         process_perf_data               1       ; Process performance data
#         retain_status_information       1       ; Retain status information across program restarts
#         retain_nonstatus_information    1       ; Retain non-status information across program restarts
#         is_volatile                     0
#         check_period                    24x7
#         max_check_attempts              4
#         normal_check_interval           5
#         retry_check_interval            1
#         contact_groups                  admins
#         notification_options            w,u,c,r
#         notification_interval           960
#         notification_period             24x7
#         servicegroups                   iberrors
#         check_command                   check_dummy_iberrors!1!"The status of this passive value is not up to date any longer - something could be wrong"; if the fresness_freshold ist exceeded, this command is executed (it returns the status of 'Warning')
#         register                        0       ; DONT REGISTER THIS DEFINITION - ITS NOT A REAL SERVICE, JUST A TEMPLATE!
#         }
#
# # Services for Checking the IB-Errors
# define service{
#         use                             generic-iberrors-service         ; Name of service template to use
#         host_name                       c5-2
#         service_description             IB_SymbolErrors
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_LinkRecovers
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_LinkDowned
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_RcvErrors
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_RcvRemotePhysErrors
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_RcvSwRelayErrors
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_XmtDiscards
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_XmtConstraintErrors
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_RcvConstraintErrors
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_LinkIntegrityErrors
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_ExcBufOverrunErrors
#         }
# define service{
#         use                             generic-iberrors-service    
#         host_name                       c5-2
#         service_description             IB_VL15Dropped
#         }
#
# -----------------------------------------------
# - If you want to execute the check_iberr.pl script remote via nrpe you can use the following
# configurations as a blueprint
# - If you want to execute the check_iberr.pl locally alter them as described below
#
# define command{
#         command_name    ibcheckerr
#         command_line    $USER1$/check_nrpe -H $HOSTADDRESS$ -c check_iberr -a 192.168.1.98 $HOSTNAME$ $ARG1$
#         ;command_line   /usr/check-dir/check_iberr.pl -m 192.168.1.98 -H $ARG1$ -G $ARG1$
#         ; Use the line above if you want to execute the check_iberr.pl locally instead of remote via nrpe
#         }
# define command{
#         command_name    ibcheckerr_update
#         command_line    $USER1$/check_nrpe -H $HOSTADDRESS$ -c check_iberr_update -a 192.168.1.98 $HOSTNAME$ $ARG1$
#         }
# define command{
#         command_name    ibcheckerr_reset
#         command_line    $USER1$/check_nrpe -H $HOSTADDRESS$ -c check_iberr_reset -a 192.168.1.98 $HOSTNAME$ $ARG1$
#         }
#
# -------------------------------------------------------
# The NRPE-Config would look like:
#  - Note: the path has usally be changed regarding where you have check_iberr.pl in your
#          filesystem
#  - Note2: If you use one or more of the several options of check_iberr.pl, you have
#           write them down at this point
#
# command[check_iberr]=/usr/check-dir/check_iberr.pl -m $ARG1$ -H $ARG2$ -G $ARG3$
# command[check_iberr_update]=/usr/check-dir/check_iberr.pl -m $ARG1$ -H $ARG2$ -G $ARG3$ -u
# command[check_iberr_reset]=/usr/check-dir/check_iberr.pl -m $ARG1$ -H $ARG2$ -G $ARG3$ -r
   
# --------------------------------------------------------
# Format of the Threshold File:
# (just put the values which threshold should be changed
#  into a textfile [of course without the comment signs (hashs)])
#
# --- Value-Name=Threshold-Value: 
# SymbolErrors=1
# LinkRecovers=1
# LinkDowned=1
# RcvErrors=1
# RcvRemotePhysErrors=1
# RcvSwRelayErrors=1
# XmtDiscards=1
# XmtConstraintErrors=1
# RcvConstraintErrors=1
# LinkIntegrityErrors=1
# ExcBufOverrunErrors=1
# VL15Dropped=1
#

