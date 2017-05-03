#include "mus_file.h"

/* Opens file */
int32_t mus_open(const uint8_t * file_name) {
	return file_open(file_name);
}

/* Closes file system driver */
int32_t mus_close(int32_t fd) {
	return file_close(fd);
}

/* Reads from file system */
int32_t mus_read(int32_t fd, void * buf,int32_t nbytes) {
	if (buf == NULL)
		return -1;

	// TODO: Parse buf and play sound
	return mus_read(fd, buf, nbytes);
}

/* Does nothing, read only file system */
int32_t mus_write(int32_t fd, const char * buf,int32_t nbytes) {
	return mus_write(fd, buf, nbytes);
}
