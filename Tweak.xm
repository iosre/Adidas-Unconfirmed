#import <substrate.h>

extern "C" int stat(const char *file_name, struct stat *buf);

int (*old_stat)(const char *file_name, struct stat *buf);

int new_stat(const char *file_name, struct stat *buf)
{
	if (
			strcmp(file_name, "Library/MobileSubstrate/MobileSubstrate.dylib") == 0 ||
			strcmp(file_name, "Applications/Cydia.app") == 0 ||
			strcmp(file_name, "var/cache/apt") == 0 ||
			strcmp(file_name, "var/lib/cydia") == 0 ||
			strcmp(file_name, "var/log/syslog") == 0 ||
			strcmp(file_name, "var/tmp/cydia.log") == 0 ||
			strcmp(file_name, "bin/bash") == 0 ||
			strcmp(file_name, "bin/sh") == 0 ||
			strcmp(file_name, "usr/sbin/sshd") == 0 ||
			strcmp(file_name, "usr/libexec/ssh-keysign") == 0 ||
			strcmp(file_name, "etc/ssh/sshd_config") == 0 ||
			strcmp(file_name, "etc/apt") == 0
	   ) return -1;
	return old_stat(file_name, buf);
}

pid_t (*old_fork)(void);

pid_t new_fork(void)
{
	return -1;
}

%ctor
{
	@autoreleasepool
	{
		MSHookFunction((void *)stat, (void *)new_stat, (void **)&old_stat);		
		MSHookFunction((void *)fork, (void *)new_fork, (void **)&old_fork);		
	}
}
