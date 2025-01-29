# Example

```c
$ cat stack-overflow/bug.c 

#include <string.h>

int main(int argc, char **argv) {
	char buf[32];
	strcpy (buf, argv[1]);
	return 0;
}
```

```c
$ r2 buffer-overflow/a.out
[0x100003f58]> decai -d
int main(int argc, char **argv, char **envp) {
    char buffer[32];
    int result = 0;
    
    if (argc > 1 && argv[1] != NULL) {
        strcpy(buffer, argv[1]);
    }
    
    return result;
}
```

