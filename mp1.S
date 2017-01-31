
.data					# section declaration

        # Useful offset constants for accessing members of a
        # struct mp1_blink_struct structure
        LOCATION   = 0
        ON_CHAR    = 2
        OFF_CHAR   = 3
        ON_LENGTH  = 4
        OFF_LENGTH = 6
        COUNTDOWN  = 8
        STATUS     = 10
        NEXT       = 12

        STRUCT_SIZE = 16

# Pointer to head of list (initialized to NULL)
mp1_list_head:
        .long   0

.text					# section declaration

# Export the function symbol names

.global mp1_rtc_tasklet
.global mp1_ioctl

# void mp1_poke(void);
#
# Interface: Register-based arguments (not C-style)
#    Inputs: %cl  - The byte you wish to write
#            %eax - Offset from the start of video memory that you wish
#                   to write to
#   Outputs: Text-mode video screen is written to at location %eax with
#            the byte in %cl
# Registers: Clobbers EDX
mp1_poke:

	movl    vmem_base_addr(,1),%edx
	movb    %cl,(%edx,%eax,1)
	ret

mp1_rtc_tasklet:
/*
  pushl %ebp # save old frame Pointer
  movl  %esp,%ebp #point to new frame
  movl mp1_list_head,%ebx # get starting struct address
loop:
  testl %ebx, %ebx # null test
  je done

  subl $1,8(%ebx) # countdown--
  testl 8(%ebx),8(%ebx) # test for zero in countdown
  jne valid

  testl 10(%ebx),10(%ebx) # and status together
  je off_status
  jmp on_status

off_status: # status is currently 0
  addl $1, 10(%ebx) # change status to 1
  movb 2(%ebx),%cl # give on_char
  movl (%ebx),%eax # give location ( assumed to be valid because of add)
  call mp1_poke
  movl 4(%ebx),8(%ebx) # on_length into countdown
  jmp valid

on_status:
  subl $1, 10(%ebx) # change status to 0
  movb 3(%ebx),%cl # give off_char
  movl (%ebx),%eax # give location ( assumed to be valid because of add)
  call mp1_poke
  movl 6(%ebx),8(%ebx) # off_length into countdown
  jmp valid


valid:
  movl 12(%ebx),%ebx # move to next struct in list
  jmp loop

done:
  leave
*/
	ret

mp1_ioctl: # eax will contain return value of int
  pushl %ebp # save old frame Pointer
  movl  %esp,%ebp #point to new frame
  movl 12(%ebp),%ebx # move cmd into ebx
  xorl %edx,%edx
  addl $3,%edx
  cmpl %edx,%ebx # ebx - edx
  ja invalid # check for invalid commands
  movl jump_table(,%ebx,4),%ebx # add offset
  jmp *%ebx
  xorl %eax,%eax
  leave
  ret
  /*
invalid_free:
  pushl %ecx # free memory
  call mp1_free
  popl %ecx # pop off paramter
  */
invalid:
  xorl %eax,%eax # clear return value
  subl $1,%eax # put in -1
  ret

jump_table:
.long mp1_ioctl_add,mp1_ioctl_remove,mp1_ioctl_find,mp1_ioctl_sync # jump table logic


mp1_ioctl_add:
/*
  movl 8(%ebp),%ebx # get arg (pointer to struct )
  pushl %ebx # push parameter
  call mp1_malloc # eax holds void * return value
  popl %ebx # pop off initial parameter
  testl %eax,%eax
  je invalid # return negative one if return null from malloc

  movl %eax, %ecx # hold copy of address
  pushl $16 # push length of mp1_blink_struct
  pushl %ebx # push from address
  pushl %ecx # push to address
  call mp1_copy_from_user
  popl %ecx
  popl %ebx
  popl
  testl %eax,%eax
  jne invalid_free # return negative one if returned not zero

  movl %ecx,%edx
  addl $8,%edx # add offset for address of countdown
  movl %ecx,%eax
  addl $4,%eax
  movl (%eax),%eax # get value of on length
  movl %eax,(%edx) # store on_length into countdown

  addl $2,%edx # add offset to address (ecx still holds head)
  movl $1,(%edx) # set status field to 1

  addl $2,%edx # edx now holds starting address of next *
  movl (mp1_list_head),(%edx) # cur head next = prev head
  subl $12,%edx
  movl %edx,(mp1_list_head) # make current node the new head by filling in address

  movl (%edx),%edx # get starting address of location offset
  movl $3998,%eax # max offset
  cmpl %eax,%edx # edx - eax
  ja invalid_free
  movl %edx,%eax # prep eax for poke
  movb 2(%ecx),%cl # prep cl for poke with on char
  call mp1_poke
  xorl %eax,%eax # return 0
*/
	ret

mp1_ioctl_remove:
	ret

mp1_ioctl_find:
/*
  movl 8(%ebp),%ebx # get arg (pointer to struct)
  testl %ebx,%ebx
  je invalid # null test
  movl (%ebx),%ebx #get location of searched for node
  movl mp1_list_head,%ecx # give ecx the head node
search:
  testl %ecx,%ecx
  je invalid # null test for list
  cmpl (%ecx),$ebx # (%ebx - %ecx)
  je found
  movl 12(%ecx),%ecx # go to next item in list
  jmp search
found:
  pushl %16 # push size
  pushl %ecx # push from
  pushl 8(%ebp) # push to
  call mp1_copy_to_user
  popl
  popl
  popl
  testl %eax,%eax
  jne invalid # return -1 if return value is not zero from copy call
  xorl %eax,%eax # return 0
*/
	ret

mp1_ioctl_sync:
/*
  movw 8(%ebp),%ebx # get arg lower 16 bits ,second , ecx,ebx is full 32 bit word 
  movw 6(%ebp),%ecx # get arg upper 16 bits ,first
*/
	ret

.end
