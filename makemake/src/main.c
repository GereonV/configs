#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _DEBUG
#define OUTPATH "Makefile.debug"
#define WINBINNAMELENGTH 18
#else
#define OUTPATH "Makefile"
#define WINBINNAMELENGTH 12
#endif

const char *cext = ".c", *cc = "gcc", *ext = "", *winext = ".exe", *debug = "debug", *release = "release", *installpath = "/usr/local/bin/";

const char *lower(char *const s) {
    for(size_t i = 0; i < strlen(s); i++)
        s[i] += 32 * (s[i] > 64 && s[i] < 91);
    return s;
}

static inline char *readfile(FILE *f) {
    fseek(f, 0, SEEK_END);
    long length = ftell(f);
    fseek(f, 0, SEEK_SET);
    char *const buffer = malloc(length + 1);
    fread(buffer, 1, length, f);
    buffer[length] = 0;
    for(size_t i = 0; i < length; i++)
        if(buffer[i] == '\r')
            for(size_t j = i; j < length; j++)
                buffer[j] = buffer[j + 1];
    return buffer;
}

int main(const int argc, const char *const *const argv) {
    if(argc % 2 == 0) {
        printf("Illegal usage: all options must be key-value-pairs\n");
        return -1;
    }
    for(int i = 1; i < argc; i += 2) {
        size_t keyLength = strlen(argv[i]) - 1; //release has 7 chars without "-" prefix
        if(!keyLength || keyLength > 7)
            goto error;
        char ogKey[8];
        strcpy(ogKey, argv[i]);
        const char *const key = lower(ogKey + 1), *const value = argv[i + 1];
        if(!strcmp(key, "cext"))
            cext = value;
        else if(!strcmp(key, "cc"))
            cc = value;
        else if(!strcmp(key, "ext"))
            cc = value;
        else if(!strcmp(key, "winext"))
            cc = value;
        else if(!strcmp(key, "debug"))
            debug = value;
        else if(!strcmp(key, "release"))
            release = value;
        else if(!strcmp(key, "path"))
            installpath = value;
        else
            goto error;
        continue;
    error:
        printf("Illegal usage: illegal key-value-pair - \"%s %s\"\n", argv[i], value);
        return -1;
    }
    
    const char *const template = "MakefileTemplate", *const output = OUTPATH, *validTemplate;
    int windirsize = strlen(argv[0]) - WINBINNAMELENGTH, wintemplatesize = windirsize + strlen(template) + 1;
    char *const templateLinux = malloc(strlen(template) + 18), *const templateWindows = malloc(wintemplatesize);
    strcpy(templateLinux, "/usr/local/share/");
    FILE *f = fopen(validTemplate = strcpy(templateLinux + 17, template) - 17, "rb");
    if(!f) {
        printf("Couldn't find file - \"%s\"\n", validTemplate);
        if(windirsize < 0)
            return -1;
        strncpy(templateWindows, argv[0], windirsize);
        f = fopen(validTemplate = strcpy(templateWindows + windirsize, template) - windirsize, "rb");
    }
    if(!f) {
        printf("Couldn't find file - \"%s\"\n", validTemplate);
        return -1;
    }
    printf("Using template-file \"%s\"\n", validTemplate);

    char cflags[256], ldflags[256];
    printf("C-Flags: ");
    fflush(stdout);
    fgets(cflags, 256, stdin);
    printf("Linker-Flags: ");
    fflush(stdout);
    fgets(ldflags, 256, stdin);

    char *const buffer = readfile(f);
    fclose(f);
    f = fopen(output, "w");
    fprintf(f, buffer, cext, cc, ext, winext, debug, release, installpath, cflags, ldflags);
    fclose(f);
    free(buffer);
}
