#ifndef TEE_API
#define TEE_API

#include <artik/security.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

void store_data(const char *session_name,const char *session_pwd,const char *data_key,const char *data_value);
void read_data(const char *session_name,const char *session_pwd, const char *data_key, char *buffer);

#endif
