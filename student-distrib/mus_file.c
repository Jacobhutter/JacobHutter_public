#include "mus_file.h"


int32_t get_freq(char* note) {

	if (note == NULL)
		return -1;

	if ((note[0] == 'C' && note[1] == '#') || (note[0] == 'D' && note[1] == 'b'))
		return 277;
	else if ((note[0] == 'D' && note[1] == '#') || (note[0] == 'E' && note[1] == 'b'))
		return 311;
	else if ((note[0] == 'F' && note[1] == '#') || (note[0] == 'G' && note[1] == 'b'))
		return 370;
	else if ((note[0] == 'G' && note[1] == '#') || (note[0] == 'A' && note[1] == 'b'))
		return 415;
	else if ((note[0] == 'A' && note[1] == '#') || (note[0] == 'B' && note[1] == 'b'))
		return 466;
	else if (note[0] == 'C')
		return 262;
	else if (note[0] == 'D')
		return 294;
	else if (note[0] == 'E')
		return 330;
	else if (note[0] == 'F')
		return 349;
	else if (note[0] == 'G')
		return 392;
	else if (note[0] == 'A')
		return 440;
	else if (note[0] == 'B')
		return 494;

	return -1;

}

/* Opens file */
int32_t mus_open(const uint8_t * file_name) {
	return file_open(file_name);
}

/* Closes file system driver */
int32_t mus_close(int32_t fd) {
	return file_close(fd);
}

/* Reads from file system */
int32_t mus_read(int32_t fd, void * buf, int32_t nbytes) {
	if (buf == NULL)
		return -1;

	// TODO: Parse buf and play sound
	return file_read(fd, buf, nbytes);
}

/* Does nothing, read only file system */
int32_t mus_write(int32_t fd, const char * buf, int32_t nbytes) {
	return file_write(fd, buf, nbytes);
}

int32_t parse_file(char* buf, int32_t nbytes) {

	char note[4];
	int i, j, q;
	int32_t freq;

	if (buf == NULL)
		return -1;

	j = 0;
	for (i = 0; i < nbytes; i++) {
		if (buf[i] != ' ') {
			note[j] = buf[i];
			j++;
		} else /*if (buf[i] == ' ' || i == nbytes - 1)*/ {
			freq = get_freq(note);
			if (freq != -1) {
				for (q = 0; q < 300000; q++) {
					play_sound(freq);
				}
				nosound();
			}
			j = 0;
		}
		if (j > 3)
			j = 0;
	}
	return i;
}
