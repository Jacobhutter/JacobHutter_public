
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

mp1_rtc_tasklet: # tasklet will update countdown and alternate on and off characters

  pushl %ebp
  movl  %esp,%ebp

  pushl %ebx
  pushl %esi
  pushl %edi

  movl mp1_list_head,%ebx # get starting struct address
loop:
  xorl %edx,%edx
  testl %ebx, %ebx # null test
  je done
  decw COUNTDOWN(%ebx) # countdown--
  movw COUNTDOWN(%ebx),%dx
  testw %dx,%dx # test for zero in countdown
  jne valid

  movw STATUS(%ebx),%dx
  testw %dx,%dx # test for zero in status
  je off_status
  jmp on_status
off_status: # status is currently 0

  xorl %ecx,%ecx
  xorl %eax,%eax
  xorl %edi,%edi
  movw $1, STATUS(%ebx) # change status to 1
  movb ON_CHAR(%ebx),%cl # give on_char
  movw LOCATION(%ebx),%ax # give location ( assumed to be valid because of add)
  addw %ax,%ax
  call mp1_poke
  movw ON_LENGTH(%ebx),%di # on_length into countdown
  movw %di,COUNTDOWN(%ebx)
  jmp valid

on_status: # status is currently 1
  xorl %ecx,%ecx
  xorl %eax,%eax
  xorl %edi,%edi
  movw $0, STATUS(%ebx) # change status to 0
  movb OFF_CHAR(%ebx),%cl # give off_char
  movw LOCATION(%ebx),%ax # give location ( assumed to be valid because of add)
  addw %ax,%ax
  call mp1_poke
  movw OFF_LENGTH(%ebx),%di
  movw %di,COUNTDOWN(%ebx) # off_length into countdown
  jmp valid

valid:
  movl NEXT(%ebx),%ebx # move to next struct in list
  jmp loop

done:
  popl %edi
  popl %esi
  popl %ebx

  leave
	ret
# dispatch function will route to current function based on command
mp1_ioctl: # eax will contain return value of int

  movl 8(%esp),%ecx # move cmd into ebx
  xorl %edx,%edx
  addl $3,%edx
  cmpl %edx,%ecx
  ja invalid # check for invalid commands
  jmp *jump_table(,%ecx,4)
  ret

  jump_table:
  .long mp1_ioctl_add,mp1_ioctl_remove,mp1_ioctl_find,mp1_ioctl_sync # jump table logic

invalid_free:
  pushl %ecx
  call mp1_free
  popl %ecx
invalid:
  xorl %eax,%eax
  subl $1,%eax

  popl %edi
  popl %esi
  popl %ebx
  leave
  ret


mp1_ioctl_add: # set up new node based on copy and initial conditions and push to buffer
  pushl %ebp
  movl %esp,%ebp

  pushl %ebx
  pushl %esi
  pushl %edi

  movl 8(%ebp),%ebx # get arg (pointer to struct)
  testl %ebx,%ebx
  je invalid

  xorl %edi,%edi
  movw $1999,%di
  cmpw %di,LOCATION(%ebx) # check for invalid location
  ja invalid

  pushl $16 # push parameter
  call mp1_malloc # eax holds void * return value
  addl $4,%esp # pop off initial parameter
  testl %eax,%eax
  je invalid

  movl %eax, %ecx # hold copy of address

  pushl $16 # push length of mp1_blink_struct
  pushl %ebx # push from address
  pushl %ecx # push to address
  call mp1_copy_from_user
  popl %ecx
  addl $8,%esp
  testl %eax,%eax
  jne invalid_free

  xorl %edx,%edx
  movw ON_LENGTH(%ecx),%dx
  movw %dx,COUNTDOWN(%ecx)

  movw $1,STATUS(%ecx) # set status field to 1

  movl mp1_list_head,%edi
  movl %edi,NEXT(%ecx)
  movl %ecx,mp1_list_head # make current node the new head by filling in address
  movl %ecx,%edi

  xorl %edx,%edx
  movw LOCATION(%edi),%dx # get starting address of location offset
  xorl %eax,%eax
  movw %dx,%ax # prep eax for poke
  addw %ax,%ax
  xorl %ecx,%ecx
  movb ON_CHAR(%edi),%cl # prep cl for poke with on char
  call mp1_poke

  xorl %eax,%eax

  popl %edi
  popl %esi
  popl %ebx

  leave
	ret

mp1_ioctl_remove: # remove all dynamically allocated data by looking for location signature

pushl %ebp
movl %esp,%ebp

  pushl %ebx
  pushl %esi
  pushl %edi

  xorl %ebx,%ebx
  movw 8(%ebp),%bx # get arg (location to search for)
  movl mp1_list_head,%edi
  movl $0,%edx # edx will hold prev node
srch:
  testl %edi,%edi
  je invalid
  cmpw LOCATION(%edi),%bx # compare what we want vs what we have
  je deletion
  movl %edi,%edx
  movl NEXT(%edi),%edi
  jmp srch
deletion: # normal deletion pattern
  testl %edx,%edx
  je special_deletion # to reset head
  movl NEXT(%edi),%eax
  movl %eax,NEXT(%edx) # skip over item in the list
  pushl %edi
  call mp1_free
  addl $4,%esp
  xorl %eax,%eax

  popl %edi
  popl %esi
  popl %ebx

  leave
  ret
special_deletion: # head is to be removed
  movl NEXT(%edi),%eax
  movl %eax,mp1_list_head
  pushl %edi
  call mp1_free
  addl $4,%esp
  xorl %eax,%eax

  popl %edi
  popl %esi
  popl %ebx

  leave

  ret


mp1_ioctl_find: # find and return copy based on location signature

pushl %ebp
movl %esp,%ebp

  pushl %ebx
  pushl %esi
  pushl %edi

  movl 8(%ebp),%ebx # get arg (2 bytes each of locations)
  testl %ebx,%ebx
  je invalid
  xorl %eax,%eax
  movw LOCATION(%ebx),%ax #get location of searched for node
  movl mp1_list_head,%ecx
search:
  testl %ecx,%ecx
  je invalid # null test for list
  cmpw LOCATION(%ecx),%ax
  je found
  movl NEXT(%ecx),%ecx # go to next item in list
  jmp search
found:
  pushl $16 # push size
  pushl %ecx # push from parameter
  pushl %ebx # push to parameter
  call mp1_copy_to_user
  popl %ebx
  addl $8,%esp
  testl %eax,%eax
  jne invalid
  movl %ebx,8(%ebp) # update arg
  xorl %eax,%eax

  popl %edi
  popl %esi 
  popl %ebx

  leave

	ret

mp1_ioctl_sync: # find random location and sync its movement to another location by means of copying over data

pushl %ebp
movl %esp,%ebp #

  pushl %ebx
  pushl %esi
  pushl %edi

  xorl %ebx,%ebx
  xorl %ecx,%ecx
  xorl %eax,%eax
  movw 8(%ebp),%bx # get arg lower 16 bits ,second , ecx,ebx is full 32 bit word
  movw 10(%ebp),%cx # get arg upper 16 bits ,first # location of first blink
  movl mp1_list_head,%edi # get head node address
  movl mp1_list_head,%edx
finder1:
  testl %edi,%edi #
  je invalid # null check
  movw LOCATION(%edi),%ax
  cmpw LOCATION(%edi),%cx
  je finder2 # %edi holds address of first location
  movl NEXT(%edi),%edi
  jmp finder1 # else go to next
finder2:
  testl %edx,%edx #
  je invalid
  cmpw LOCATION(%edx),%bx
  je found_both
  movl NEXT(%edx),%edx
  jmp finder2
found_both: # copy over values
  movw ON_LENGTH(%edi),%ax
  movw %ax,ON_LENGTH(%edx)
  movw OFF_LENGTH(%edi),%ax
  movw %ax,OFF_LENGTH(%edx)
  movw COUNTDOWN(%edi),%ax
  movw %ax,COUNTDOWN(%edx)
  movw STATUS(%edi),%ax
  movw %ax,STATUS(%edx)
  testw %ax,%ax # test status
  je put_off
  jmp put_on
put_off:
  xorl %ecx,%ecx
  xorl %eax,%eax
  movb OFF_CHAR(%edx),%cl
  movw LOCATION(%edx),%ax
  addw %ax,%ax # double it
  call mp1_poke
  jmp finish

put_on:
  xorl %ecx,%ecx
  xorl %eax,%eax
  movb ON_CHAR(%edx),%cl
  movw LOCATION(%edx),%ax
  addw %ax,%ax # double it
  call mp1_poke
  jmp finish

finish:
  xorl %eax,%eax

  popl %edi
  popl %esi # return callee save registers
  popl %ebx

  leave
	ret
