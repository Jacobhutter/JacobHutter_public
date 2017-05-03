#ifndef MUS_FILE_H
#define MUS_FILE_H

#include "file_system.h"
#include "sound.h"
#include "lib.h"

/* Opens file */
int32_t mus_open(const uint8_t *);

/* Closes file system driver */
int32_t mus_close(int32_t);

/* Reads from file system */
int32_t mus_read(int32_t, void *,int32_t);

/* Does nothing, read only file system */
int32_t mus_write(int32_t, const char *,int32_t);


#endif
