#include "trust.h"
void store_data(const char *session_name,
                const char *session_pwd,
                const char *data_key,
                const char *data_value)
{
    see_data input;
    input.data = data_value;
    input.length = strlen(input.data);

    see_init(session_name,session_pwd);
    
    see_write_secure_storage(data_key, 0, input);
    
    see_deinit();
}

void read_data(const char *session_name,
                const char *session_pwd,
                const char *data_key, 
                char *buffer)
{
    unsigned int storage_size;
    see_data output;
    
    see_init(session_name,session_pwd);

    see_get_size_secure_storage(data_key,
                                &storage_size);

    see_read_secure_storage(data_key, 0,
                            storage_size,
                            &output);
    
    snprintf(buffer, storage_size + 1,
            "%s", output.data);

    /** Delete data */
    see_delete_secure_storage(data_key);

    see_deinit();
}
