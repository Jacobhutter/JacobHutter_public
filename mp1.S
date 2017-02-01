
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

  pushl %ebp # save old frame Pointer
  movl  %esp,%ebp #point to new frame
  movl mp1_list_head,%ebx # get starting struct address
loop:
  testl %ebx, %ebx # null test
  je done

  subw $1,COUNTDOWN(%ebx) # countdown--
  movw COUNTDOWN(%ebx),%dx
  testw %dx,%dx # test for zero in countdown
  jne valid # jump if countdown not zero

  movw STATUS(%ebx),%dx
  testw %dx,%dx # test for zero in status
  je off_status
  jmp on_status

off_status: # status is currently 0
  xorl %ecx,%ecx
  xorl %eax,%eax
  movw $1, STATUS(%ebx) # change status to 1
  movb ON_CHAR(%ebx),%cl # give on_char
  movw LOCATION(%ebx),%ax # give location ( assumed to be valid because of add)
  addw %ax,%ax # multiply by 2
  call mp1_poke
  movw ON_LENGTH(%ebx),%di # on_length into countdown
  movw %di,COUNTDOWN(%ebx)
  jmp valid

on_status:
  xorl %ecx,%ecx
  xorl %eax,%eax
  movw $0, STATUS(%ebx) # change status to 0
  movb OFF_CHAR(%ebx),%cl # give off_char
  movw LOCATION(%ebx),%ax # give location ( assumed to be valid because of add)
  addw %ax,%ax # multiply by 2
  call mp1_poke
  movw OFF_LENGTH(%ebx),%di
  movw %di,COUNTDOWN(%ebx) # off_length into countdown
  jmp valid


valid:
  movl NEXT(%ebx),%ebx # move to next struct in list
  jmp loop

done:
  leave
	ret

mp1_ioctl: # eax will contain return value of int
  pushl %ebp
  movl %esp,%ebp #
  movl 12(%ebp),%ebx # move cmd into ebx
  xorl %edx,%edx
  addl $3,%edx
  cmpl %edx,%ebx # ebx - edx
  ja invalid # check for invalid commands
  jmp *jump_table(,%ebx,4)
  xorl %eax,%eax
  leave
  ret

invalid_free:
  pushl %ecx # free memory
  call mp1_free
  popl %ecx # pop off paramter
invalid:
  xorl %eax,%eax # clear return value
  subl $1,%eax # put in -1
  leave
  ret

jump_table:
.long mp1_ioctl_add,mp1_ioctl_remove,mp1_ioctl_find,mp1_ioctl_sync # jump table logic


mp1_ioctl_add:

  movl 8(%ebp),%ebx # get arg (pointer to struct )
  testl %ebx,%ebx
  je invalid # null test arg
  pushl $16 # push parameter
  call mp1_malloc # eax holds void * return value
  addl $4,%esp # pop off initial parameter
  testl %eax,%eax
  je invalid # return negative one if return null from malloc

  movl %eax, %ecx # hold copy of address
  pushl $16 # push length of mp1_blink_struct
  pushl %ebx # push from address
  pushl %ecx # push to address
  call mp1_copy_from_user
  popl %ecx
  addl $8,%esp # pop off params
  testl %eax,%eax
  jne invalid_free # return negative one if returned not zero

  movw ON_LENGTH(%ecx),%dx
  movw %dx,COUNTDOWN(%ecx)

  movl $1,STATUS(%ecx) # set status field to 1


  movl mp1_list_head,%edi
  movl %edi,NEXT(%ecx)
  movl %ecx,mp1_list_head # make current node the new head by filling in address

  movw LOCATION(%ecx),%dx # get starting address of location offset
  movw $3998,%ax # max offset
  cmpw %ax,%dx # edx - eax
  ja invalid_free
  xorl %eax,%eax
  movw %dx,%ax # prep eax for poke
  addw %ax,%ax # double
  movb ON_CHAR(%ecx),%cl # prep cl for poke with on char
  call mp1_poke
  xorl %eax,%eax # return 0

  leave
	ret

mp1_ioctl_remove:
  leave
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
  leave
	ret

mp1_ioctl_sync:
/*
  movw 8(%ebp),%ebx # get arg lower 16 bits ,second , ecx,ebx is full 32 bit word
  movw 6(%ebp),%ecx # get arg upper 16 bits ,first
*/
  leave
	ret

.end
