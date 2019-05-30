#include "trust.h"

int main(void)
{
        char *buffer;
        const char *id = (const char*)malloc(sizeof(char) * 1000);
        const char *pwd = (const char*)malloc(sizeof(char) * 1000);
        const char *key = (const char*)malloc(sizeof(char) * 1000);
        const char *val = (const char*)malloc(sizeof(char) * 1000);
        buffer = (char*)malloc(sizeof(char) * 10);
     
        while (1) {
            int l;
            printf("input the mode ! \n");
            scanf("%d",&l);

            switch (l) {
                case 0:
                    printf("\n Store data: input the sesseion id, pwd, key, value \n");
                    scanf("%s",id);
                    scanf("%s",pwd);
                    scanf("%s",key);
                    scanf("%s",val);
                    store_data(id,pwd,key,val);
                    printf(" Stored in Secure Storage \n");

                    break;
                case 1:
                    printf("\n Read data: input the sesseion id, pwd, key \n");
                    scanf("%s",id);
                    scanf("%s",pwd);
                    scanf("%s",key);
                    read_data(id,pwd,key,buffer);
                    printf("data is %s \n",buffer);
                    break;
                case 2:
                    return 0;
            }
        }
}
