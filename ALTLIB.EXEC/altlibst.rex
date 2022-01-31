/* --------------------  rexx procedure  -------------------- *
 | Name:      ALTLIBST                                        |
 |                                                            |
 | Function:  Display the active altlib allocations by        |
 |            type, ddname, and dataset name                  |
 |                                                            |
 | Syntax:    %altlibst                                       |
 |                                                            |
 | Author:    Lionel B. Dyck                                  |
 |                                                            |
 | History:  (most recent on top)                             |
 |            2022/01/30 LBD - Creation                       |
 |                                                            |
 * ---------------------------------------------------------- */

  Call outtrap 'trap.'
  'altlib display'
  Call outtrap 'off'
  call get_dd_and_dsns

  if left(trap.1,3) = 'IKJ'
     then sp = 1
     else sp = 0

  Say 'Current ALTLIB Allocations:'
  do i = 2 to trap.0
     type = subword(trap.i,1+sp,2)
     parse value trap.i with .'='ddn
    if wordpos('Stacked', trap.i) > 0 then stack = 'Stacked'
    else stack = ''
     Say type '('ddn')' stack
     do iac = 1 to words(hold.ddn)
        say left(' ',12) word(hold.ddn,iac)
        end
     end
exit 0

  Get_dd_and_dsns:
  call outtrap 't.'
  'lista sta'
  call outtrap 'off'
  hold. = ''
  do i = 2 to t.0   /* skip 1st records */
    Select
      When wordpos(word(t.i,1),'NULLFILE TERMFILE') > 0 then  do
        ddn = word(t.i,2)
        dsn = word(t.i,1)
        hold.ddn = dsn
        ddnames = ddnames ddn
      end
      When words(t.i) = 1 & ,
        wordpos(word(t.i,1),'KEEP CATLG DELETE') = 0 then
        dsn = word(t.i,1)
      When words(t.i) = 1 & ,
        wordpos(word(t.i,1),'KEEP CATLG DELETE') > 0 then do
        hold.ddn = hold.ddn dsn
        end
      When words(t.i) = 2 then do
        ddn = word(t.i,1)
        hold.ddn = hold.ddn strip(dsn)
        ddnames = ddnames ddn
      end
      Otherwise nop
    end
  end
  return
