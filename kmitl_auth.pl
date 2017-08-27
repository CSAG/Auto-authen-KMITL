use LWP::UserAgent;
use HTTP::Cookies;
use Term::ReadKey;

$username=shif;
$password=shif;
system("clear");

print " ____  __   __   ____  ____      _      ____   ____    ___   _  _____   \n";
print "| __ ) \\ \\ / /  / ___|/ ___|    / \\    / ___| |___ \\  / _ \\ / ||___  | \n";
print "|  _ \\  \\ V /  | |    \\___ \\   / _ \\  | |  _    __) || | | || |   / /  \n";
print "| |_) |  | |   | |___  ___) | / ___ \\ | |_| |  / __/ | |_| || |  / /   \n";
print "|____/   |_|    \\____||____/ /_/   \\_\\ \\____| |_____| \\___/ |_| /_/    \n";
print "\n";
print "\n";
exit unless($username && $password);

%ssl_opts=(
	verify_hostname => 0,
	SSL_verify_mode => 0x00,
);
$cookie_jar=HTTP::Cookies->new(autosave=>1, hide_cookie2=>1);
$agent=LWP::UserAgent->new(
	agent => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0',
	ssl_opts => {%ssl_opts},
	timeout => 1,
	max_redirect => 0,
	cookie_jar => $cookie_jar
);
while(1) {
	$time=localtime;
	$checkConnection = checkConnection();
	if($checkConnection == 1) {
		print "[$time] Connection OK...\n";
	}else {
		print "[$time] Connection Heartbeat!!!\n";
		login();
	}
	sleep 60;
}

sub login {
		$content=$agent->post('https://10.252.23.2:8445/PortalServer/Webauth/webAuthAction!login.action',[
		'userName' => $username,
		'password' => $password,
		'validCode' => '',
		'authLan' => 'en',
		'hasValidateNextUpdatePassword' => 'true',
		'browserFlag' => 'en',
		'ClientIp' => ''
	])->as_string;
	print " Finish Sign in\n\n";
}
sub checkConnection {
	$content = $agent->get('http://188.166.177.132/check/')->as_string;
	if($content=~/nac\.kmitl\.ac\.th/) {
		return 'nac.kmitl.ac.th';
	}
	elsif($content=~/Hello planet!\n/) {
		return 1;
	}
	return $content;
}
