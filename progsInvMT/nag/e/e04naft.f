      SUBROUTINE E04NAF(ITMAX,MSGLVL,N,NCLIN,NCTOTL,NROWA,NROWH,NCOLH,
     *                  BIGBND,A,BL,BU,CVEC,FEATOL,HESS,QPHESS,COLD,LP,
     *                  ORTHOG,X,ISTATE,ITER,OBJ,CLAMDA,IW,LENIW,W,LENW,
     *                  IFAIL)
C     MARK 12 RE-ISSUE. NAG COPYRIGHT 1986.
C
C *********************************************************************
C     E04NAF SOLVES QUADRATIC PROGRAMMING (QP) PROBLEMS OF THE FORM
C
C                MINIMIZE     C(T)*X  +  1/2 X(T)*H*X
C
C                SUBJECT TO           (  X  )
C                             BL  .LE.(     ).GE.  BU
C                                     ( A*X )
C
C
C     WHERE  (T)  DENOTES THE TRANSPOSE OF A COLUMN VECTOR.
C     THE SYMMETRIC MATRIX  H  MAY BE POSITIVE-DEFINITE, POSITIVE
C     SEMI-DEFINITE, OR INDEFINITE.
C
C     N  IS THE NUMBER OF VARIABLES (DIMENSION OF  X).
C
C     NCLIN  IS THE NUMBER OF GENERAL LINEAR CONSTRAINTS (ROWS OF  A).
C     (NCLIN MAY BE ZERO.)
C
C     THE MATRIX   H  IS DEFINED BY THE SUBROUTINE  QPHESS, WHICH
C     MUST COMPUTE THE MATRIX-VECTOR PRODUCT  H*X  FOR ANY VECTOR  X.
C
C     THE VECTOR  C  IS ENTERED IN THE ONE-DIMENSIONAL ARRAY  CVEC.
C
C     THE FIRST  N  COMPONENTS OF  BL  AND   BU  ARE LOWER AND UPPER
C     BOUNDS ON THE VARIABLES.  THE NEXT  NCLIN  COMPONENTS ARE
C     LOWER AND UPPER BOUNDS ON THE GENERAL LINEAR CONSTRAINTS.
C
C     THE MATRIX  A  OF COEFFICIENTS IN THE GENERAL LINEAR CONSTRAINTS
C     IS ENTERED AS THE TWO-DIMENSIONAL ARRAY  A  (OF DIMENSION
C     NROWA  BY  N).  IF NCLIN = 0,  A  IS NOT ACCESSED.
C
C     THE VECTOR  X  MUST CONTAIN AN INITIAL ESTIMATE OF THE SOLUTION,
C     AND WILL CONTAIN THE COMPUTED SOLUTION ON OUTPUT.
C
C
C
C     COMPLETE DOCUMENTATION FOR  E04NAF IS CONTAINED IN REPORT SOL
C     83-12, USERS GUIDE FOR SOL/QPSOL, BY P.E. GILL, W. MURRAY,
C     M.A. SAUNDERS AND M.H. WRIGHT, DEPARTMENT OF OPERATIONS
C     RESEARCH, STANFORD UNIVERSITY, STANFORD, CALIFORNIA 94305.
C
C     SYSTEMS OPTIMIZATION LABORATORY, STANFORD UNIVERSITY.
C     VERSION 1   OF DECEMBER 1981.
C     VERSION 2   OF     JUNE 1982.
C     VERSION 3   OF  JANUARY 1983.
C     VERSION 3.1 OF    APRIL 1983.
C     VERSION 3.2 OF    JUNE  1984.
C
C     COPYRIGHT  1983  STANFORD UNIVERSITY.
C
C THIS MATERIAL MAY BE REPRODUCED BY OR FOR THE U.S. GOVERNMENT PURSU-
C ANT TO THE COPYRIGHT LICENSE UNDER DAR CLAUSE 7-104.9(A) (1979 MAR).
C
C THIS MATERIAL IS BASED UPON WORK PARTIALLY SUPPORTED BY THE NATIONAL
C     SCIENCE FOUNDATION UNDER GRANTS MCS-7926009 AND ECS-8012974; THE
C     OFFICE OF NAVAL RESEARCH CONTRACT N00014-75-C-0267;  THE
C     DEPARTMENT OF ENERGY CONTRACT AM03-76SF00326, PA NO.
C     DE-AT03-76ER72018; AND THE ARMY RESEARCH OFFICE CONTRACT
C     DAA29-79-C-0110.
C *********************************************************************
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='E04NAF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  BIGBND, OBJ
      INTEGER           IFAIL, ITER, ITMAX, LENIW, LENW, MSGLVL, N,
     *                  NCLIN, NCOLH, NCTOTL, NROWA, NROWH
      LOGICAL           COLD, LP, ORTHOG
C     .. Array Arguments ..
      DOUBLE PRECISION  A(NROWA,N), BL(NCTOTL), BU(NCTOTL),
     *                  CLAMDA(NCTOTL), CVEC(N), FEATOL(NCTOTL),
     *                  HESS(NROWH,NCOLH), W(LENW), X(N)
      INTEGER           ISTATE(NCTOTL), IW(LENIW)
C     .. Subroutine Arguments ..
      EXTERNAL          QPHESS
C     .. Scalars in Common ..
      DOUBLE PRECISION  ASIZE, DTMAX, DTMIN
      INTEGER           ISTART, LENNAM, MSG, NCOLRT, NOUT, NQ, NROWRT
      LOGICAL           SCLDQP
C     .. Arrays in Common ..
      DOUBLE PRECISION  PARM(10), WMACH(15)
      INTEGER           LOCLP(15)
C     .. Local Scalars ..
      DOUBLE PRECISION  BIGDX, EPSMCH, EPSPT9, POINT9, TOLACT, XNORM
      INTEGER           INFORM, ITMX, L, LAX, LCRASH, LITOTL, LKACTV,
     *                  LKFREE, LNAMES, LPX, LSCALE, LWRK, LWTOTL,
     *                  MAXACT, MINACT, MINFXD, MXCOLZ, MXFREE, NACTIV,
     *                  NALG, NCNLN, NERROR, NFREE, NROWJ, NUMINF
      LOGICAL           MINSUM, NAMED, UNITQ, VERTEX
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
      CHARACTER*2       LPQP(2)
      CHARACTER*90      REC(2)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          E04MBW, E04MBY, E04NAV, E04NAX, E04VDV, E04VDY,
     *                  X02ZAZ, X04BAF
C     .. Intrinsic Functions ..
      INTRINSIC         MAX, MIN
C     .. Common blocks ..
      COMMON            /AE04VC/NOUT, MSG, ISTART
      COMMON            /AX02ZA/WMACH
      COMMON            /BE04VC/LENNAM, NROWRT, NCOLRT, NQ
      COMMON            /CE04VC/PARM
      COMMON            /DE04VC/LOCLP
      COMMON            /HE04VC/ASIZE, DTMAX, DTMIN
      COMMON            /JE04VC/SCLDQP
C     .. Save statement ..
      SAVE              /AX02ZA/
C     .. Data statements ..
      DATA              LPQP(1), LPQP(2)/'LP', 'QP'/
      DATA              POINT9/0.9D+0/
C     .. Executable Statements ..
C
C     SET THE MACHINE-DEPENDENT CONSTANTS.
C
      CALL X02ZAZ
      EPSMCH = WMACH(3)
      NOUT = WMACH(11)
C
C     IF ITMAX IS NOT POSITIVE ON ENTRY SET IT TO 50.
C
      ITMX = ITMAX
      IF (ITMX.LE.0) ITMX = 50
C
C     E04NAF WILL PROVIDE DEFAULT NAMES FOR VARIABLES DURING PRINTING.
C
      NAMED = .FALSE.
C
C     IF THERE IS NO FEASIBLE POINT FOR THE LINEAR CONSTRAINTS AND
C     BOUNDS, COMPUTE THE MINIMUM SUM OF INFEASIBILITIES.
C     IT IS NOT NECESSARY TO START THE QP PHASE AT A VERTEX.
C
      MINSUM = .TRUE.
      VERTEX = .FALSE.
C
C     ANY CHANGE IN X THAT IS GREATER THAN  BIGDX  WILL BE REGARDED
C     AS AN INFINITE STEP.
C
      BIGDX = 1.0D+20
C
C     DURING SELECTION OF THE INITIAL WORKING SET (BY CRASH),
C     CONSTRAINTS WITH RESIDUALS LESS THAN  TOLACT  WILL BE MADE ACTIVE.
C
      TOLACT = 0.01D+0
C
      EPSPT9 = EPSMCH**(POINT9)
C
      PARM(1) = BIGBND
      PARM(2) = BIGDX
      PARM(3) = TOLACT
      PARM(4) = EPSPT9
C
C     ASSIGN THE DIMENSIONS OF ARRAYS IN THE PARAMETER LIST OF E04NAX.
C     ECONOMIES OF STORAGE ARE POSSIBLE IF THE MINIMUM NUMBER OF ACTIVE
C     CONSTRAINTS AND THE MINIMUM NUMBER OF FIXED VARIABLES ARE KNOWN IN
C     ADVANCE.  THE EXPERT USER SHOULD ALTER  MINACT  AND  MINFXD
C     ACCORDINGLY.
C     IF A LINEAR PROGRAM IS BEING SOLVED AND THE MATRIX OF GENERAL
C     CONSTRAINTS IS FAT,  I.E.,  NCLIN .LT. N,  A NON-ZERO VALUE IS
C     KNOWN FOR  MINFXD.  NOTE THAT IN THIS CASE,  VERTEX  MUST BE
C     .TRUE..
C
      MINACT = 0
      MINFXD = 0
C
      IF (LP .AND. NCLIN.LT.N) MINFXD = N - NCLIN - 1
      IF (LP .AND. NCLIN.LT.N) VERTEX = .TRUE.
C
      MXFREE = N - MINFXD
      MAXACT = MAX(1,MIN(N,NCLIN))
      MXCOLZ = N - (MINFXD+MINACT)
      NQ = MAX(1,MXFREE)
      NROWRT = MAX(MXCOLZ,MAXACT)
      NCOLRT = MAX(1,MXFREE)
C
      NCNLN = 0
      LENNAM = 1
C
C     ALLOCATE CERTAIN ARRAYS THAT ARE NOT DONE IN  E04VDY.
C
      LNAMES = 1
      LITOTL = 0
C
      LAX = 1
      LWTOTL = LAX + NROWA - 1
C
C     ALLOCATE REMAINING WORK ARRAYS.
C
      NALG = 2
      LOCLP(1) = LNAMES
      CALL E04VDY(NALG,N,NCLIN,NCNLN,NCTOTL,NROWA,NROWJ,LITOTL,LWTOTL)
C
      LKACTV = LOCLP(2)
      LKFREE = LOCLP(3)
C
      LPX = LOCLP(6)
      LWRK = LOCLP(11)
C
C     SET THE MESSAGE LEVEL FOR  E04MBW, E04NAV, E04VDV  AND  E04MBY.
C
      MSG = 0
      IF (MSGLVL.GE.5) MSG = 5
      IF (LP .OR. MSGLVL.GE.15) MSG = MSGLVL
C
C     *** THE FOLLOWING STATEMENT MUST BE EXECUTED IF  ISTART   ***
C     *** IS NOT SET IN THE CALLING ROUTINE.                    ***
C
      ISTART = 0
C
      LCRASH = 1
      IF (COLD) LCRASH = 0
C
C     CHECK INPUT PARAMETERS AND STORAGE LIMITS.
C
      IF (MSGLVL.EQ.99) CALL E04MBW(N,NCLIN,NCTOTL,NROWA,LCRASH,LP,
     *                              MINSUM,NAMED,VERTEX,ISTATE,A,W(LAX),
     *                              BL,BU,CVEC,X)
C
      IF (MSGLVL.EQ.99) CALL E04NAV(N,NROWH,NCOLH,CVEC,HESS,QPHESS,
     *                              W(LWRK),W(LPX))
C
      CALL E04VDV(NERROR,LENIW,LENW,LITOTL,LWTOTL,NROWA,N,NCLIN,NCNLN,
     *            NCTOTL,ISTATE,IW(LKACTV),LCRASH,NAMED,IW(LNAMES),
     *            LENNAM,BIGBND,A,BL,BU,FEATOL,X)
C
      ITER = 0
      IF (NERROR.EQ.0) GO TO 20
      IF (MSGLVL.GT.0) THEN
         WRITE (REC,FMT=99990) NERROR
         CALL X04BAF(NOUT,REC(1))
         CALL X04BAF(NOUT,REC(2))
      END IF
      IFAIL = P01ABF(IFAIL,9,SRNAME,0,P01REC)
      RETURN
   20 CONTINUE
C
C     NO SCALING IS PROVIDED BY THIS VERSION OF  E04NAF.
C     GIVE A FAKE VALUE FOR THE START OF THE SCALE ARRAY.
C
      SCLDQP = .FALSE.
      LSCALE = 1
C
C ---------------------------------------------------------------------
C     CALL  E04MBY  TO OBTAIN A FEASIBLE POINT, OR SOLVE A LINEAR
C     PROBLEM.
C ---------------------------------------------------------------------
      CALL E04MBY(LP,MINSUM,NAMED,ORTHOG,UNITQ,VERTEX,INFORM,ITER,ITMX,
     *            LCRASH,N,NCLIN,NCTOTL,NROWA,NACTIV,NFREE,NUMINF,
     *            ISTATE,IW(LKACTV),IW(LKFREE),OBJ,XNORM,A,W(LAX),BL,BU,
     *            CLAMDA,CVEC,FEATOL,X,IW,LENIW,W,LENW)
C
      IF (LP) GO TO 40
      IF (INFORM.EQ.0) GO TO 60
C
C     TROUBLE IN  E04MBY.
C
C     INFORM CANNOT BE GIVEN THE VALUE  2  WHEN FINDING A FEASIBLE
C     POINT, SO IT IS NECESSARY TO DECREMENT ALL THE VALUES OF  INFORM
C     THAT ARE GREATER THAN  2.
C
      IF (INFORM.GT.2) INFORM = INFORM - 1
      INFORM = INFORM + 5
      GO TO 80
C
C     THE PROBLEM WAS AN LP, NOT A QP.
C
   40 IF (INFORM.GT.2) INFORM = INFORM + 4
      IF (INFORM.EQ.1) INFORM = 6
      GO TO 80
C
C ---------------------------------------------------------------------
C     CALL  E04NAX  TO SOLVE A QUADRATIC PROBLEM.
C ---------------------------------------------------------------------
C
   60 MSG = MSGLVL
C
C     *** THE FOLLOWING STATEMENT MUST BE EXECUTED IF  ISTART   ***
C     *** IS NOT SET IN THE CALLING ROUTINE.                    ***
C
      ISTART = 0
C
      CALL E04NAX(NAMED,ORTHOG,UNITQ,INFORM,ITER,ITMX,N,NCLIN,NCTOTL,
     *            NROWA,NROWH,NCOLH,NACTIV,NFREE,QPHESS,ISTATE,
     *            IW(LKACTV),IW(LKFREE),OBJ,XNORM,A,W(LAX),BL,BU,CLAMDA,
     *            CVEC,FEATOL,HESS,W(LSCALE),X,IW,LENIW,W,LENW)
C
C     PRINT MESSAGES IF REQUIRED.
C
C
   80 IF (MSGLVL.LE.0) GO TO 100
      IF (LP) L = 1
      IF ( .NOT. LP) L = 2
      IF (INFORM.EQ.0) WRITE (REC,FMT=99999) LPQP(L)
      IF (INFORM.EQ.1) WRITE (REC,FMT=99998)
      IF (INFORM.EQ.2) WRITE (REC,FMT=99997) LPQP(L)
      IF (INFORM.EQ.3) WRITE (REC,FMT=99996)
      IF (INFORM.EQ.4) WRITE (REC,FMT=99995)
      IF (INFORM.EQ.5) WRITE (REC,FMT=99994)
      IF (INFORM.EQ.6) WRITE (REC,FMT=99993)
      IF (INFORM.EQ.7) WRITE (REC,FMT=99992)
      IF (INFORM.EQ.8) WRITE (REC,FMT=99991)
      IF (INFORM.GE.0 .AND. INFORM.LE.8) THEN
         CALL X04BAF(NOUT,REC(1))
         CALL X04BAF(NOUT,REC(2))
      END IF
C
      IF (NUMINF.EQ.0) WRITE (REC,FMT=99989) LPQP(L), OBJ
      IF (NUMINF.GT.0) WRITE (REC,FMT=99988) OBJ
      IF (NUMINF.GE.0) THEN
         CALL X04BAF(NOUT,REC(1))
         CALL X04BAF(NOUT,REC(2))
      END IF
  100 CONTINUE
      IF (INFORM.NE.0) GO TO 120
      IFAIL = 0
      RETURN
  120 CONTINUE
      IFAIL = P01ABF(IFAIL,INFORM,SRNAME,0,P01REC)
      RETURN
C
C
C     END OF E04NAF (QPSOL)
99999 FORMAT (/' EXIT E04NAF- OPTIMAL ',A2,' SOLUTION.')
99998 FORMAT (/' EXIT E04NAF- WEAK LOCAL MINIMUM.')
99997 FORMAT (/' EXIT E04NAF- ',A2,' SOLUTION IS UNBOUNDED.')
99996 FORMAT (/' EXIT E04NAF- ZERO MULTIPLIERS.')
99995 FORMAT (/' EXIT E04NAF- TOO MANY ITERATIONS WITHOUT CHANGING X.')
99994 FORMAT (/' EXIT E04NAF- TOO MANY ITERATIONS.')
99993 FORMAT (/' EXIT E04NAF- CANNOT SATISFY THE LINEAR CONSTRAINTS.')
99992 FORMAT (/' EXIT E04NAF- TOO MANY ITERATIONS WITHOUT CHANGING X D',
     *  'URING THE LP PHASE.')
99991 FORMAT (/' EXIT E04NAF- TOO MANY ITERATIONS DURING THE LP PHASE.')
99990 FORMAT (/' EXIT E04NAF- ',I10,' ERRORS FOUND IN THE INPUT PARAME',
     *  'TERS.  PROBLEM ABANDONED.')
99989 FORMAT (/' FINAL ',A2,' OBJECTIVE VALUE =',G16.7)
99988 FORMAT (/' FINAL SUM OF INFEASIBILITIES =',G16.7)
      END
