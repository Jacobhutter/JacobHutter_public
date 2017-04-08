#include "file_system.h"

#define BLOCK 64
#define BLOCK_OFF 16 /* Integer offset for each block */

#define MEM_BLOCK 4096 /* 4kB */
#define kB 1024 /* Integer offset for each memory space */

#define MAX_NAME 32
#define BASE 10

#define PROGRAM_ADDR /*0x08000000*/ 0x08048000

static unsigned long* boot_block_addr;
static unsigned long num_inode, data_blocks, dir_entries;

static unsigned char ELF[] = {0x7f, 0x45, 0x4c, 0x46};

/*
 * init_file_system
 *   DESCRIPTION: Initializes file system driver
 *   INPUTS: addr - pointer to start of file system
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: Adds data to global vars
 */
void init_file_system(unsigned long * addr) {
    boot_block_addr = addr;
    dir_entries = *boot_block_addr;
    num_inode = *(boot_block_addr + 1);
    data_blocks = *(boot_block_addr + 2);

    // printf("%d, %d, %d\n", dir_entries, num_inode, data_blocks);

    // printf("0x%#x, 0x%#x\n", boot_block_addr, curr);

}

/*
 * read_dentry_by_name
 *   DESCRIPTION: Gets dentry based off name
 *   INPUTS: fname - name of file
 *           dentry - dentry_t to copy to
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: Copies dentry_t with name fname to dentry
 */
int32_t read_dentry_by_name(const uint8_t * fname, dentry_t* dentry) {

    dentry_t* curr;
    int i;

    // Gets address of first dentry
    curr = (dentry_t*)(boot_block_addr + BLOCK_OFF);

    // Runs through list to find file name
    for (i = 0; i < dir_entries; i++) {

        // If the names are equal, copy and return
        if (check_string(fname, (uint8_t*)curr)) {
            *dentry = *curr;
            return 0;
        }
        curr++;
    }
    // Not found
    return -1;
}

/*
 * read_dentry_by_index
 *   DESCRIPTION: Gets dentry based off index
 *   INPUTS: index - index of dentry
 *           dentry - dentry_t to copy to
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: Copies dentry_t with inode index to dentry
 */
int32_t read_dentry_by_index(uint32_t index, dentry_t* dentry) {

    dentry_t* curr;

    // Tried to access file that didn't exist
    if (index >= dir_entries)
        return -1;

    // Gets address of dentry
    // One offset for boot block
    curr = (dentry_t*)(boot_block_addr + (index + 1) * BLOCK_OFF);

    *dentry = *curr;

    return 0;
}

/*
 * read_data
 *   DESCRIPTION: Reads data from file system
 *   INPUTS: inode - inode to begin at
 *           offset - offset of 1st data block to start reading from
 *           buf - buffer to write data to
 *           length - number of bytes to read
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: Copies data of length bytes to buffer
 */
int32_t read_data(uint32_t inode, uint32_t offset, uint8_t* buf, uint32_t length) {

    int* init_inode_addr, *inode_addr;
    char* init_data_addr, *data_addr;
    int block_length, data_num, min, i, j, k;
    int data_offset;

    // Gets offset of data block
    data_offset = offset / MEM_BLOCK;

    // Gets offset of where to read in memeory
    offset %= MEM_BLOCK;

    // Gets start of inode blocks and data blocks
    init_inode_addr = (int*)(boot_block_addr + kB);
    init_data_addr = (char*)(boot_block_addr + (kB + num_inode * kB));

    if (inode >= num_inode)
        return -1;

    // Gets inode block
    inode_addr = init_inode_addr + (inode * kB);

    // Gets length of block
    block_length = *inode_addr;

    // Idk if needed, come back later
    min = (length > block_length) ? block_length : length;


    i = 0;
    k = 1;
    // Runs until read all blocks
    while (i < length) {
        // Gets the data block number
        data_num = *(inode_addr + k + data_offset);
        // Checks for invalid data
        if (data_num >= data_blocks)
            return i; // Returns number of bytes read
        // Gets the data address to start read from
        data_addr = init_data_addr + (data_num * MEM_BLOCK);
        data_addr += offset;
        j = 0;
        // Runs through data block until end of block or end of needed read
        while (j < MEM_BLOCK - offset && i < length) {
            buf[i] = *data_addr;
            data_addr++;
            i++;
            j++;
        }
        // Deletes offset because no longer needed
        offset = 0;
        // Increments inode index
        k++;
    }


    return 0;
}

/*
 * file_open
 *   DESCRIPTION: Opens file
 *   INPUTS: file - name of file to open
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: Adds data to global vars
 */
int32_t file_open(uint8_t* file) {

    return 0;
}

/*
 * file_close
 *   DESCRIPTION: Closes file system driver
 *   INPUTS: fd - file descriptor
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
int32_t file_close(int32_t fd) {
    return 0;
}

/*
 * file_read
 *   DESCRIPTION: Reads from file system
 *   INPUTS: fd - file descriptor
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
int32_t file_read(int32_t fd) {
    return -1;
}

/*
 * file_write
 *   DESCRIPTION: Does nothing, read only file system
 *   INPUTS: fd - file descriptor
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
int32_t file_write(int32_t fd) {
    return -1;
}

/*
 * dir_open
 *   DESCRIPTION: Opens directory
 *   INPUTS: directory - directory to open
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
int32_t dir_open(uint8_t* directory) {
    return 0;
}

/*
 * dir_close
 *   DESCRIPTION: Closes directory
 *   INPUTS: fd - file descriptor
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
int32_t dir_close(int32_t fd) {
    return 0;
}

/*
 * dir_wrtie
 *   DESCRIPTION: Does nothing, read only file system
 *   INPUTS: fd - file descriptor
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
int32_t dir_write(int32_t fd) {
    return -1;
}

/*
 * dir_read
 *   DESCRIPTION: Reads files in directory
 *   INPUTS: fd - file descriptor
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
int32_t dir_read(int32_t fd) {
    // dentry_t curr;
    // int i;
    // for (i = 0; i < dir_entries; i++) {
    //  read_dentry_by_index(i, &curr);
    //  print_file_name((char*)&(curr.file_name));
    // }

    return 0;
}

/*
 * get_file_size
 *   DESCRIPTION: Gets file size in bytes
 *   INPUTS: file - dentry of file
 *   OUTPUTS: none
 *   RETURN VALUE: size of file in bytes
 *   SIDE EFFECTS: none
 */
unsigned long get_file_size(dentry_t file) {
    unsigned long * inode_addr = (boot_block_addr + kB) + (file.i_node_num * kB);

    return *inode_addr;
}

// void test1() {
//  // dentry_t temp;
//  // int i, j;
//  // for (i = 0; i < dir_entries; i++) {
//  //  read_dentry_by_index(i, &temp);
//  //  print_file_name(&(temp.file_name));
//  // }

//  // char buf[275];
//  // printf("\n\n");

//  // printf("Hello\n");

//  // i = read_dentry_by_name("frame1.txt", &temp);

//  // if (i >= 0)
//  //  print_file_name(&(temp.file_name));

//  // if (i >= 0) {
//  //  read_data(temp.i_node_num, 0, buf, 275);
//  // }

//  // for (i = 0; i < 11; i++)
//  //  for (j = 0; j < 25; j++)
//  //      printf("%c", buf[i * 25 + j]);

//  // printf("\n");

//  // printf("%d\n", check_string("", ""));


//  // print_file_name("Hello000000000000000000000000000");


// }

/*
 * print_file_name
 *   DESCRIPTION: Prints file name to screen
 *   INPUTS: a - string to print
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: Prints file name to screen
 */
void print_file_name(char* a) {

    terminal_write((const void *) a, (int32_t) MAX_NAME);

}

/*
 * check_string
 *   DESCRIPTION: Checks two string if they're equal
 *   INPUTS: s1 - first string
 *           s2 - second string
 *   OUTPUTS: none
 *   RETURN VALUE: 1 if equal, 0 if not
 *   SIDE EFFECTS: none
 */
int check_string(const uint8_t* s1, uint8_t* s2) {
    int i;
    int length = (strlen((const int8_t*)s1) > MAX_NAME) ? MAX_NAME : strlen((const int8_t*)s1);

    // Runs through string to see if equal
    for (i = 0; i < length; i++) {
        if (s1[i] == '%') return 1;
        if ((s1[i] != s2[i])) {
            return 0;
        }
    }

    return 1;
}

/*
 * list_all_files
 *   DESCRIPTION: Lists files and size in current directory
 *   INPUTS: none
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
void list_all_files() {
    dentry_t curr;
    int i, size, temp;
    for (i = 0; i < dir_entries; i++) {
        read_dentry_by_index(i, &curr);
        // Gets file size
        size = *(boot_block_addr + kB + (curr.i_node_num * kB));
        temp = curr.file_type + 48;
        // Prints out file descriptions
        terminal_write("File name: ", 11);
        print_file_name((char*) & (curr.file_name));
        terminal_write(" , File type: ", 14);
        terminal_write((const void*) (&temp), 1);
        terminal_write(", file size: ", 13);
        printInt(size);
        terminal_write("\n", 1);


    }
}

/*
 * read_file_by_dentry
 *   DESCRIPTION: Reads file specified by dentry
 *   INPUTS: file - file to read from
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
uint32_t read_file_by_dentry(dentry_t file) {
    int size, read_size, j;
    unsigned char buffer[kB];

    size = (int)get_file_size(file);

    j = 0;
    while (size > 0) {
        // Reads smallest amount of bytes
        read_size = (size > kB) ? kB : size;

        // Updates needed read left
        size -= kB;

        // Reads data
        if (read_data(file.i_node_num, j * kB, buffer, read_size) != 0)
            return -1;

        // Prints current buffer to screen
        terminal_write((const void*) buffer, (int32_t) read_size);

        j++;

    }
    // Writes file name to screen
    terminal_write("\nFile name: ", 12);
    print_file_name(file.file_name);
    terminal_write("\n", 1);

    return 0;

}

/*
 * read_file_by_name
 *   DESCRIPTION: Reads file specified by name
 *   INPUTS: name - name of file to read from
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
uint32_t read_file_by_name(char* name) {
    dentry_t file;
    // Gets the dentry
    if (read_dentry_by_name((uint8_t*)name, &file) == -1)
        return -1;

    return read_file_by_dentry(file);

}

/*
 * read_file_by_index
 *   DESCRIPTION: Reads file specified by index
 *   INPUTS: name - index of file to read from
 *   OUTPUTS: none
 *   RETURN VALUE: 0 on success, -1 on failure
 *   SIDE EFFECTS: none
 */
uint32_t read_file_by_index(uint32_t index) {
    dentry_t file;

    // Gets dentry
    if (read_dentry_by_index(index, &file) == -1)
        return -1;

    return read_file_by_dentry(file);

}
/*
 * intToChar
 *   DESCRIPTION: Convert integer digit to ASCII character
 *   INPUTS: a - integer digit to convert
 *   OUTPUTS: none
 *   RETURN VALUE: equivalent ASCII character
 *   SIDE EFFECTS: none
 */
char
intToChar(int a) {
    // Adds 48 to get integer offset
    return (char)(a + 48);
}

/*
 * printInt
 *   DESCRIPTION: Print integer to console
 *   INPUTS: num - integer to be printed to console
 *   OUTPUTS: integer to console
 *   RETURN VALUE: Void
 *   SIDE EFFECTS: none
 */
void printInt(int num) {
    int temp;

    temp = num + 48;
    if (num < BASE) {
        terminal_write((const void*) (&temp), 1);
        return;
    }

    printInt(num / BASE);
    temp = num % BASE;
    temp += 48;
    terminal_write((const void*) (&temp), 1);
}

int check_ELF(dentry_t file) {
    unsigned char buffer[4];
    int i;

    read_data(file.i_node_num, 0, buffer, 4);

    for (i = 0; i < 4; i++)
        if (buffer[i] != ELF[i])
            return 0;

    return 1;
}

void load_file(dentry_t file) {

    int* init_inode_addr, *inode_addr;
    char* init_data_addr, *data_addr;
    int file_size, i, inode;

    inode = file.i_node_num;

    // Gets start of inode blocks and data blocks
    init_inode_addr = (int*)(boot_block_addr + kB);
    init_data_addr = (char*)(boot_block_addr + (kB + num_inode * kB));

    if (inode >= num_inode)
        return;

    // Gets inode block
    inode_addr = init_inode_addr + (inode * kB);

    file_size = *inode_addr;
    inode_addr++;

    i = 0;

    // unsigned long *temp;
    // temp = (unsigned long*)PROGRAM_ADDR;
    // *temp = 5;
    while (file_size > 0) {

        if (file_size - (4 * kB) >= 4 * kB) {
            memcpy((void*)(PROGRAM_ADDR + i * (4 * kB)),
                   (const void*)(*inode_addr), 4 * kB);
            file_size -= (4 * kB);
            inode_addr++;
            i++;
        } else {
            memcpy((void *)(PROGRAM_ADDR + i * (4 * kB)),
                   (const void *)(*inode_addr), file_size);
            file_size -= (4 * kB);
        }
        file_size = 0;
    }

    return;

}
