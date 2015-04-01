      SUBROUTINE E04NAX(NAMED,ORTHOG,UNITQ,INFORM,ITER,ITMAX,N,NCLIN,
     *                  NCTOTL,NROWA,NROWH,NCOLH,NACTIV,NFREE,QPHESS,
     *                  ISTATE,KACTIV,KFREE,OBJQP,XNORM,A,AX,BL,BU,
     *                  CLAMDA,CVEC,FEATOL,HESS,SCALE,X,IW,LIW,W,LW)
C     MARK 12 RE-ISSUE. NAG COPYRIGHT 1986.
C
C *********************************************************************
C     E04NAX, A SUBROUTINE FOR INDEFINITE QUADRATIC PROGRAMMING.
C     IT IS ASSUMED THAT A PREVIOUS CALL TO EITHER  LPCORE  OR  E04NAX
C     HAS DEFINED AN INITIAL WORKING SET OF LINEAR CONSTRAINTS AND
C     BOUNDS. ISTATE, KACTIV  AND  KFREE  WILL HAVE BEEN SET
C     ACCORDINGLY, AND THE ARRAYS  RT  AND  ZY  WILL CONTAIN THE TQ
C     FACTORIZATION OF THE MATRIX WHOSE ROWS ARE THE GRADIENTS OF THE
C     ACTIVE LINEAR CONSTRAINTS WITH THE COLUMNS CORRESPONDING TO THE
C     ACTIVE BOUNDS REMOVED.  THE TQ FACTORIZATION OF THE RESULTING
C     (NACTIV BY NFREE) MATRIX IS  A(FREE)*Q = (0 T),  WHERE  Q  IS
C     (NFREE BY NFREE) AND  T  IS REVERSE-TRIANGULAR.
C
C     VALUES OF ISTATE(J) FOR THE LINEAR CONSTRAINTS.......
C
C     ISTATE(J)
C     ---------
C          0   CONSTRAINT  J  IS NOT IN THE WORKING SET.
C          1   CONSTRAINT  J  IS IN THE WORKING SET AT ITS LOWER BOUND.
C          2   CONSTRAINT  J  IS IN THE WORKING SET AT ITS UPPER BOUND.
C          3   CONSTRAINT  J  IS IN THE WORKING SET AS AN EQUALITY.
C          4   THE J-TH VARIABLE IS TEMPORARILY FIXED AT THE VALUE X(J).
C              THE CORRESPONDING ARTIFICIAL BOUND IS INCLUDED IN THE
C              WORKING SET (THE  TQ  FACTORIZATION IS ADJUSTED
C              ACCORDINGLY).
C
C     CONSTRAINT  J  MAY BE VIOLATED BY AS MUCH AS  FEATOL(J).
C
C     SYSTEMS OPTIMIZATION LABORATORY, STANFORD UNIVERSITY.
C     VERSION 1   OF DECEMBER 1981.
C     VERSION 2   OF     JUNE 1982.
C     VERSION 3   OF  JANUARY 1983.
C     VERSION 3.1 OF    APRIL 1983.
C     VERSION 3.2 OF    APRIL 1984.
C
C     COPYRIGHT  1983  STANFORD UNIVERSITY.
C
C THIS MATERIAL MAY BE REPRODUCED BY OR FOR THE U.S. GOVERNMENT PURSU-
C ANT TO THE COPYRIGHT LICENSE UNDER DAR CLAUSE 7-104.9(A) (1979 MAR).
C
C THIS MATERIAL IS BASED UPON WORK PARTIALLY SUPPORTED BY THE NATIONAL
C     SCIENCE FOUNDATION UNDER GRANTS MCS-7926009 AND ECS-8012974; THE
C     DEPARTMENT OF ENERGY CONTRACT AM03-76SF00326, PA NO. DE-AT03-
C     76ER72018; AND THE ARMY RESEARCH OFFICE CONTRACT DAA29-79-C-0110.
C
C *********************************************************************
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  OBJQP, XNORM
      INTEGER           INFORM, ITER, ITMAX, LIW, LW, N, NACTIV, NCLIN,
     *                  NCOLH, NCTOTL, NFREE, NROWA, NROWH
      LOGICAL           NAMED, ORTHOG, UNITQ
C     .. Array Arguments ..
      DOUBLE PRECISION  A(NROWA,N), AX(NROWA), BL(NCTOTL), BU(NCTOTL),
     *                  CLAMDA(NCTOTL), CVEC(N), FEATOL(NCTOTL),
     *                  HESS(NROWH,NCOLH), SCALE(NCTOTL), W(LW), X(N)
      INTEGER           ISTATE(NCTOTL), IW(LIW), KACTIV(N), KFREE(N)
C     .. Subroutine Arguments ..
      EXTERNAL          QPHESS
C     .. Scalars in Common ..
      DOUBLE PRECISION  ASIZE, DTMAX, DTMIN
      INTEGER           ISTART, LENNAM, MSG, NCOLRT, NOUT, NQ, NROWRT
C     .. Arrays in Common ..
      DOUBLE PRECISION  PARM(10), WMACH(15)
      INTEGER           LOCLP(15)
C     .. Local Scalars ..
      DOUBLE PRECISION  ALFA, ALFHIT, ANORM, ATPHIT, BIGALF, BIGBND,
     *                  BIGDX, BND, CONDH, CONDMX, CONDT, CSLAST, DINKY,
     *                  DRMAX, DRMIN, EMAX, EPSMCH, EPSPT9, FLMAX,
     *                  GFIXED, GFNORM, GTP, HSIZE, OBJSIZ, ONE, PALFA,
     *                  PNORM, RDLAST, RTMAX, SMLLST, SNLAST, ZERO,
     *                  ZTGNRM
      INTEGER           IADD, IDUMMY, IFIX, ISDEL, ISSAVE, JADD, JDEL,
     *                  JDSAVE, JSMLST, KB, KDEL, KGFIX, KSMLST, LANORM,
     *                  LAP, LENR, LNAMES, LPX, LQTG, LRLAM, LROWA, LRT,
     *                  LWRK, LZY, MODE, MSGLVL, MSTALL, NCLIN0, NCNLN,
     *                  NCOLR, NCOLZ, NFIXED, NHESS, NROWJ, NSTALL,
     *                  NUMINF
      LOGICAL           FIRSTV, HITLOW, IFAIL, MODFYG, MODFYR, NOCURV,
     *                  NULLR, POSDEF, REFINE, RENEWR, STALL, UNCON,
     *                  UNITPG, ZEROLM
      CHARACTER*2       LPROB
C     .. Local Arrays ..
      CHARACTER*50      REC(3)
C     .. External Functions ..
      DOUBLE PRECISION  F06BLF, DNRM2
      EXTERNAL          F06BLF, DNRM2
C     .. External Subroutines ..
      EXTERNAL          E04NAT, E04NAU, E04NAW, E04NAY, E04NAZ, E04VDQ,
     *                  E04VDS, E04VDT, E04VDU, E04VDW, E04VDZ, F06FLF,
     *                  DAXPY, X04BAF
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, MAX, SQRT
C     .. Common blocks ..
      COMMON            /AE04VC/NOUT, MSG, ISTART
      COMMON            /AX02ZA/WMACH
      COMMON            /BE04VC/LENNAM, NROWRT, NCOLRT, NQ
      COMMON            /CE04VC/PARM
      COMMON            /DE04VC/LOCLP
      COMMON            /HE04VC/ASIZE, DTMAX, DTMIN
C     .. Save statement ..
      SAVE              /AX02ZA/
C     .. Data statements ..
      DATA              ZERO, ONE/0.0D+0, 1.0D+0/
      DATA              LPROB/'QP'/
      DATA              MSTALL/50/
C     .. Executable Statements ..
C
C     SPECIFY MACHINE-DEPENDENT PARAMETERS.
C
      EPSMCH = WMACH(3)
      FLMAX = WMACH(7)
      RTMAX = WMACH(8)
C
      LNAMES = LOCLP(1)
      LANORM = LOCLP(4)
      LAP = LOCLP(5)
      LPX = LOCLP(6)
      LQTG = LOCLP(7)
      LRLAM = LOCLP(8)
      LRT = LOCLP(9)
      LZY = LOCLP(10)
      LWRK = LOCLP(11)
C
C     INITIALIZE
C
      INFORM = 0
      ITER = 0
      JADD = 0
      JDEL = 0
      JDSAVE = 0
      LROWA = NROWA*(N-1) + 1
      NCLIN0 = MAX(NCLIN,1)
      NCNLN = 0
      NCOLZ = NFREE - NACTIV
      NROWJ = 1
      NSTALL = 0
      NHESS = 0
      NUMINF = 0
C
      MSGLVL = MSG
      MSG = 0
      IF (ISTART.EQ.0) MSG = MSGLVL
C
      BIGBND = PARM(1)
      BIGDX = PARM(2)
      EPSPT9 = PARM(4)
C
      ALFA = ZERO
      CONDMX = FLMAX
      DRMAX = ONE
      DRMIN = ONE
      EMAX = ZERO
      HSIZE = ONE
C
      FIRSTV = .FALSE.
      MODFYR = .TRUE.
      MODFYG = .TRUE.
      NOCURV = .FALSE.
      NULLR = .FALSE.
      POSDEF = .TRUE.
      REFINE = .FALSE.
      STALL = .TRUE.
      UNCON = .FALSE.
      UNITPG = .FALSE.
      ZEROLM = .FALSE.
C
C ---------------------------------------------------------------------
C     GIVEN THE  TQ  FACTORIZATION OF THE MATRIX OF CONSTRAINTS IN THE
C     WORKING SET, COMPUTE THE FOLLOWING QUANTITIES....
C     (1) THE CHOLESKY FACTOR  R,  OF  Z(T)HZ  (IF  Z(T)HZ  IS NOT
C      POSITIVE DEFINITE, FIND A POSITIVE-DEFINITE  (NCOLR)-TH  ORDER
C      PRINCIPAL SUBMATRIX OF  Z(T)H Z,
C     (2) THE  QP  OBJECTIVE FUNCTION,
C     (3) THE VECTOR  Q(FREE)(T)G(FREE),
C     (4) THE VECTOR  G(FIXED).
C
C     USE THE ARRAY  RLAM  AS TEMPORARY WORK SPACE.
C ---------------------------------------------------------------------
      CALL E04NAW(UNITQ,QPHESS,N,NCOLR,NCOLZ,NCTOTL,NFREE,NHESS,NQ,
     *            NROWH,NCOLH,NROWRT,NCOLRT,KFREE,HSIZE,HESS,W(LRT),
     *            SCALE,W(LZY),W(LRLAM),W(LWRK))
C
      MODE = 1
      CALL E04NAU(MODE,UNITQ,QPHESS,N,NACTIV,NCTOTL,NFREE,NHESS,NQ,
     *            NROWH,NCOLH,JADD,KACTIV,KFREE,ALFA,OBJQP,GFIXED,GTP,
     *            CVEC,HESS,W(LPX),W(LQTG),SCALE,X,W(LZY),W(LWRK),
     *            W(LRLAM))
C
C .......................START OF THE MAIN LOOP........................
C
C     DURING THE MAIN LOOP, ONE OF THREE THINGS WILL HAPPEN
C     (  I) THE CONVERGENCE CRITERION WILL BE SATISFIED AND THE
C        ALGORITHM WILL TERMINATE.
C     ( II) A LINEAR CONSTRAINT WILL BE DELETED.
C     (III) A DIRECTION OF SEARCH WILL BE COMPUTED AND A CONSTRAINT MAY
C        BE ADDED TO THE WORKING SET (NOTE THAT A ZERO STEP MAY BE TAKEN
C        ALONG THE SEARCH DIRECTION).
C
C     THESE COMPUTATIONS OCCUR IN SECTIONS I, II, AND III OF THE MAIN
C     LOOP.
C
C ---------------------------------------------------------------------
C     ******* SECTION I.  TEST FOR CONVERGENCE *******
C ---------------------------------------------------------------------
C     COMPUTE THE NORMS OF THE PROJECTED GRADIENT AND THE GRADIENT WITH
C     RESPECT TO THE FREE VARIABLES.
C
   20 ZTGNRM = ZERO
      IF (NCOLR.GT.0) ZTGNRM = DNRM2(NCOLR,W(LQTG),1)
      GFNORM = ZTGNRM
      IF (NFREE.GT.0 .AND. NACTIV.GT.0) GFNORM = DNRM2(NFREE,W(LQTG),1)
C
C     DEFINE SMALL QUANTITIES THAT REFLECT THE MAGNITUDE OF  C,  X,  H
C     AND THE MATRIX OF CONSTRAINTS IN THE WORKING SET.
C
      OBJSIZ = (EPSMCH+ABS(OBJQP))/(EPSMCH+XNORM)
      ANORM = ZERO
      IF (NACTIV.GT.0) ANORM = ABS(DTMAX)
      DINKY = EPSPT9*MAX(ANORM,OBJSIZ,GFNORM)
C
      IF (MSG.GE.80) THEN
         WRITE (REC,FMT=99998) ZTGNRM, DINKY
         CALL X04BAF(NOUT,REC(1))
         CALL X04BAF(NOUT,REC(2))
         CALL X04BAF(NOUT,REC(3))
      END IF
C
C ---------------------------------------------------------------------
C     PRINT THE DETAILS OF THIS ITERATION.
C ---------------------------------------------------------------------
C     USE THE LARGEST AND SMALLEST DIAGONALS OF  R  TO ESTIMATE THE
C     CONDITION NUMBER OF THE PROJECTED HESSIAN MATRIX.
C
      CONDT = F06BLF(DTMAX,DTMIN,IFAIL)
      IF (IFAIL .AND. DTMAX.EQ.ZERO) CONDT = FLMAX
C
      LENR = NROWRT*NCOLR
      IF (NCOLR.GT.0) CALL F06FLF(NCOLR,W(LRT),NROWRT+1,DRMAX,DRMIN)
      CONDH = F06BLF(DRMAX,DRMIN,IFAIL)
      IF (IFAIL .AND. DRMAX.EQ.ZERO) CONDH = FLMAX
      IF (CONDH.GE.RTMAX) CONDH = FLMAX
      IF (CONDH.LT.RTMAX) CONDH = CONDH*CONDH
C
      CALL E04NAT(ORTHOG,ISDEL,ITER,JADD,JDEL,NACTIV,NCOLR,NCOLZ,NFREE,
     *            N,NCLIN,NCLIN0,NCTOTL,NROWA,NROWRT,NCOLRT,NHESS,
     *            ISTATE,KFREE,ALFA,CONDH,CONDT,OBJQP,GFNORM,ZTGNRM,
     *            EMAX,A,W(LRT),X,W(LWRK),W(LAP))
C
      JADD = 0
      JDEL = 0
C
      IF ( .NOT. POSDEF) GO TO 80
      IF (ZTGNRM.LE.DINKY) UNITPG = .TRUE.
      IF (ZTGNRM.LE.DINKY) GO TO 40
C
      IF ( .NOT. UNCON) REFINE = .FALSE.
      IF ( .NOT. UNCON) GO TO 80
C
      IF (UNITPG) UNITPG = .FALSE.
C
      IF (ZTGNRM.LE.SQRT(DINKY)) GO TO 40
C
      IF (REFINE) GO TO 40
C
      REFINE = .TRUE.
      GO TO 80
C
C ---------------------------------------------------------------------
C     THE PROJECTED GRADIENT IS NEGLIGIBLE AND THE PROJECTED HESSIAN
C     IS POSITIVE DEFINITE.  IF  R  IS NOT COMPLETE IT MUST BE
C     EXPANDED.  OTHERWISE, IF THE CURRENT POINT IS NOT OPTIMAL,
C     A CONSTRAINT MUST BE DELETED FROM THE WORKING SET.
C ---------------------------------------------------------------------
   40 ALFA = ZERO
      UNCON = .FALSE.
      REFINE = .FALSE.
      JDEL = -(NCOLR+1)
      IF (NCOLR.LT.NCOLZ) GO TO 60
C
      CALL E04VDS(LPROB,N,NCLIN0,NCTOTL,NACTIV,NCOLZ,NFREE,NROWA,NROWRT,
     *            NCOLRT,JSMLST,KSMLST,SMLLST,ISTATE,KACTIV,A,W(LANORM),
     *            W(LQTG),W(LRLAM),W(LRT))
C
C ---------------------------------------------------------------------
C     TEST FOR CONVERGENCE.  IF THE LEAST (ADJUSTED) MULTIPLIER IS
C     GREATER THAN THE SMALL POSITIVE QUANTITY  DINKY,  AN ADEQUATE
C     SOLUTION HAS BEEN FOUND.
C ---------------------------------------------------------------------
      IF (SMLLST.GT.DINKY) GO TO 260
C
C ---------------------------------------------------------------------
C     ***** SECTION II.  DELETE A CONSTRAINT FROM THE WORKING SET *****
C ---------------------------------------------------------------------
C     DELETE THE CONSTRAINT WITH THE LEAST (ADJUSTED) MULTIPLIER.
C
C     FIRST CHECK IF THERE ARE ANY TINY MULTIPLIERS
C
      IF (SMLLST.GT.(-DINKY)) ZEROLM = .TRUE.
      JDEL = JSMLST
      JDSAVE = JSMLST
      KDEL = KSMLST
      ISDEL = ISTATE(JDEL)
      ISSAVE = ISDEL
      ISTATE(JDEL) = 0
C
C     UPDATE THE  TQ  FACTORIZATION OF THE MATRIX OF CONSTRAINTS IN THE
C     WORKING SET.
C
      CALL E04VDU(MODFYG,ORTHOG,UNITQ,JDEL,KDEL,NACTIV,NCOLZ,NFREE,N,NQ,
     *            NROWA,NROWRT,NCOLRT,KACTIV,KFREE,A,W(LQTG),W(LRT),
     *            W(LZY))
C
      NCOLZ = NCOLZ + 1
      IF (JDEL.LE.N) NFREE = NFREE + 1
      IF (JDEL.GT.N) NACTIV = NACTIV - 1
C
C ---------------------------------------------------------------------
C     THE PROJECTED HESSIAN IS EXPANDED BY A ROW AND COLUMN.  COMPUTE
C     THE ELEMENTS OF THE NEW COLUMN OF THE CHOLESKY FACTOR  R.
C     USE THE ARRAY  P  AS TEMPORARY WORK SPACE.
C ---------------------------------------------------------------------
   60 RENEWR = .TRUE.
      NCOLR = NCOLR + 1
      CALL E04NAY(NOCURV,POSDEF,RENEWR,UNITQ,QPHESS,N,NCOLR,NCTOTL,
     *            NFREE,NQ,NROWH,NCOLH,NROWRT,NCOLRT,NHESS,KFREE,CSLAST,
     *            SNLAST,DRMAX,EMAX,HSIZE,RDLAST,HESS,W(LRT),SCALE,
     *            W(LZY),W(LPX),W(LWRK))
C
C     REPEAT THE MAIN LOOP.
C
      GO TO 20
C
C ---------------------------------------------------------------------
C     ******* SECTION III.  COMPUTE THE SEARCH DIRECTION *******
C ---------------------------------------------------------------------
C     FIRST, CHECK FOR A WEAK LOCAL MINIMUM. EXIT IF THE NORM OF THE
C     PROJECTED GRADIENT IS SMALL AND THE CURVATURE ALONG  P  IS NOT
C     SIGNIFICANT.  ALSO, CHECK FOR TOO MANY ITERATIONS AND UPDATE THE
C     ITERATION COUNT.  THE ITERATION COUNTER IS ONLY UPDATED WHEN A
C     SEARCH DIRECTION IS COMPUTED.
C
   80 IF (ZTGNRM.LT.DINKY .AND. NCOLR.EQ.NCOLZ .AND. NOCURV) GO TO 280
      IF (ZEROLM .AND. NOCURV) GO TO 280
      IF (ITER.GE.ITMAX) GO TO 360
      ITER = ITER + 1
      IF (ITER.GE.ISTART) MSG = MSGLVL
C
      CALL E04VDT(NULLR,UNITPG,UNITQ,N,NCLIN,NCLIN0,NCTOTL,NQ,NROWA,
     *            NROWRT,NCOLRT,NCOLR,NCOLZ,NFREE,ISTATE,KFREE,DINKY,
     *            GTP,PNORM,RDLAST,ZTGNRM,A,W(LAP),W(LPX),W(LQTG),W(LRT)
     *            ,W(LWRK),W(LZY),W(LWRK))
C
C     IF A CONSTRAINT HAS JUST BEEN DELETED AND THE PROJECTED GRADIENT
C     IS SMALL (THIS CAN ONLY OCCUR HERE WHEN THE PROJECTED HESSIAN IS
C     INDEFINITE), THE SIGN OF  P  MAY BE INCORRECT BECAUSE OF ROUNDING
C     ERRORS IN THE COMPUTATION OF  ZTG.  FIX THE SIGN OF  P  BY
C     FORCING IT TO SATISFY THE CONSTRAINT THAT WAS JUST DELETED.
C
      IF ((JDSAVE.GT.0 .AND. ZTGNRM.LE.DINKY) .OR. ZEROLM)
     *    CALL E04NAZ(N,NCLIN,NCLIN0,ISSAVE,JDSAVE,W(LAP),W(LPX))
C
C ---------------------------------------------------------------------
C     FIND THE CONSTRAINT WE BUMP INTO ALONG P.
C     UPDATE X AND A*X IF THE STEP ALFA IS NONZERO.
C ---------------------------------------------------------------------
C     ALFHIT  IS INITIALIZED TO  BIGALF.  IF IT REMAINS THAT WAY AFTER
C     THE CALL TO E04VDW, IT WILL BE REGARDED AS INFINITE.
C
      BIGALF = F06BLF(BIGDX,PNORM,IFAIL)
      IF (IFAIL .AND. BIGDX.EQ.ZERO) BIGALF = FLMAX
C
      CALL E04VDW(FIRSTV,HITLOW,ISTATE,INFORM,JADD,N,NROWA,NCLIN,NCLIN0,
     *            NCTOTL,NUMINF,ALFHIT,PALFA,ATPHIT,BIGALF,BIGBND,PNORM,
     *            W(LANORM),W(LAP),AX,BL,BU,FEATOL,W(LPX),X)
C
C     IF THE PROJECTED HESSIAN IS POSITIVE DEFINITE, THE STEP
C     ALFA = 1.0 WILL BE THE STEP TO THE MINIMUM OF THE QUADRATIC
C     FUNCTION ON THE CURRENT SUBSPACE.
C
      ALFA = ONE
C
C     IF THE STEP TO THE MINIMUM ON THE SUBSPACE IS LESS THAN THE
C     DISTANCE TO THE NEAREST CONSTRAINT,  THE CONSTRAINT IS NOT ADDED
C     TO THE WORKING SET.
C
      UNCON = PALFA .GT. ONE .AND. POSDEF
      IF (UNCON) JADD = 0
      IF ( .NOT. UNCON) ALFA = ALFHIT
C
C     CHECK FOR AN UNBOUNDED SOLUTION.
C
      IF (ALFA.GE.BIGALF) GO TO 300
C
C     TEST IF THE CHANGE IN  X  IS NEGLIGIBLE.
C
      STALL = ABS(ALFA*PNORM) .LE. EPSPT9*XNORM
      IF ( .NOT. STALL) GO TO 100
C
C     TAKE A ZERO STEP.
C     EXIT IF MORE THAN  50  ITERATIONS OCCUR WITHOUT CHANGING  X.
C     IF SUCH AN EXIT IS MADE WHEN THERE ARE SOME NEAR-ZERO
C     MULTIPLIERS, THE USER SHOULD CALL A SEPARATE ROUTINE THAT
C     CHECKS THE SOLUTION.
C
      ALFA = ZERO
      NSTALL = NSTALL + 1
      IF (NSTALL.LE.MSTALL) GO TO 120
      GO TO 340
C
C ---------------------------------------------------------------------
C     COMPUTE THE NEW VALUE OF THE QP OBJECTIVE FUNCTION.  IF ITS
C     VALUE HAS NOT INCREASED,  UPDATE  OBJQP,  Q(FREE)(T)G(FREE)  AND
C     G(FIXED). AN INCREASE IN THE OBJECTIVE CAN OCCUR ONLY AFTER A
C     MOVE ALONG A DIRECTION OF NEGATIVE CURVATURE FROM A POINT WITH
C     TINY MULTIPLIERS. USE THE ARRAY  RLAM  AS TEMPORARY STORAGE.
C ---------------------------------------------------------------------
  100 MODE = 2
      CALL E04NAU(MODE,UNITQ,QPHESS,N,NACTIV,NCTOTL,NFREE,NHESS,NQ,
     *            NROWH,NCOLH,JADD,KACTIV,KFREE,ALFA,OBJQP,GFIXED,GTP,
     *            CVEC,HESS,W(LPX),W(LQTG),SCALE,X,W(LZY),W(LWRK),
     *            W(LRLAM))
C
      IF (MODE.LT.0) GO TO 280
C
C     CHANGE  X  TO  X + ALFA*P.  UPDATE  AX  ALSO.
C     WE NO LONGER NEED TO REMEMBER JDSAVE, THE LAST CONSTRAINT DELETED.
C
      NSTALL = 0
      JDSAVE = 0
      ZEROLM = .FALSE.
C
      CALL DAXPY(N,ALFA,W(LPX),1,X,1)
      IF (NCLIN.GT.0) CALL DAXPY(NCLIN,ALFA,W(LAP),1,AX,1)
C
      XNORM = DNRM2(N,X,1)
C
C     IF AN UNCONSTRAINED STEP WAS TAKEN, REPEAT THE MAIN LOOP.
C
  120 IF (UNCON) GO TO 20
C
C ---------------------------------------------------------------------
C     ADD A CONSTRAINT TO THE WORKING SET.
C ---------------------------------------------------------------------
C     UPDATE  ISTATE.
C
      IF (HITLOW) ISTATE(JADD) = 1
      IF ( .NOT. HITLOW) ISTATE(JADD) = 2
      IF (BL(JADD).EQ.BU(JADD)) ISTATE(JADD) = 3
C
C     IF A BOUND IS TO BE ADDED, MOVE  X  EXACTLY ONTO IT, EXCEPT WHEN
C     A NEGATIVE STEP WAS TAKEN.  (E04VDW  MAY HAVE HAD TO MOVE TO SOME
C     OTHER CLOSER CONSTRAINT.)
C
      IADD = JADD - N
      IF (JADD.GT.N) GO TO 160
      IF (HITLOW) BND = BL(JADD)
      IF ( .NOT. HITLOW) BND = BU(JADD)
      IF (ALFA.GE.ZERO) X(JADD) = BND
C
      DO 140 IFIX = 1, NFREE
         IF (KFREE(IFIX).EQ.JADD) GO TO 160
  140 CONTINUE
C
C     UPDATE THE  TQ  FACTORS OF THE MATRIX OF CONSTRAINTS IN THE
C     WORKING SET.  USE THE ARRAY  P  AS TEMPORARY WORK SPACE.
C
  160 CALL E04VDZ(MODFYG,MODFYR,ORTHOG,UNITQ,INFORM,IFIX,IADD,JADD,
     *            NACTIV,NCOLR,NCOLZ,NFREE,N,NQ,NROWA,NROWRT,NCOLRT,
     *            KFREE,CONDMX,CSLAST,SNLAST,A,W(LQTG),W(LRT),W(LZY),
     *            W(LWRK),W(LPX))
C
      NCOLR = NCOLR - 1
      NCOLZ = NCOLZ - 1
      NFIXED = N - NFREE
      IF (NFIXED.EQ.0) GO TO 200
      KB = NACTIV + NFIXED
      DO 180 IDUMMY = 1, NFIXED
         KACTIV(KB+1) = KACTIV(KB)
         KB = KB - 1
  180 CONTINUE
  200 IF (JADD.GT.N) GO TO 220
C
C     ADD A BOUND.  IF STABILIZED ELIMINATIONS ARE BEING USED TO UPDATE
C     THE  TQ  FACTORIZATION,  RECOMPUTE THE COMPONENT OF THE GRADIENT
C     CORRESPONDING TO THE NEWLY FIXED VARIABLE.
C     USE THE ARRAY  P  AS TEMPORARY WORK SPACE.
C
      NFREE = NFREE - 1
      KACTIV(NACTIV+1) = JADD
      IF (ORTHOG) GO TO 240
C
      KGFIX = LQTG + NFREE
      MODE = 3
      CALL E04NAU(MODE,UNITQ,QPHESS,N,NACTIV,NCTOTL,NFREE,NHESS,NQ,
     *            NROWH,NCOLH,JADD,KACTIV,KFREE,ALFA,OBJQP,W(KGFIX),GTP,
     *            CVEC,HESS,W(LPX),W(LQTG),SCALE,X,W(LZY),W(LWRK),W(LPX)
     *            )
C
      GO TO 240
C
C     ADD A GENERAL LINEAR CONSTRAINT.
C
  220 NACTIV = NACTIV + 1
      KACTIV(NACTIV) = IADD
C
C     REPEAT THE MAIN LOOP IF THE PROJECTED HESSIAN THAT WAS USED TO
C     COMPUTE THIS SEARCH DIRECTION WAS POSITIVE DEFINITE.
C
  240 IF (NCOLR.EQ.0) POSDEF = .TRUE.
      IF (NCOLR.EQ.0) EMAX = ZERO
C
C ---------------------------------------------------------------------
C     THE PROJECTED HESSIAN WAS NOT SUFFICIENTLY POSITIVE DEFINITE
C     BEFORE THE CONSTRAINT WAS ADDED.  EITHER COMPUTE THE TRUE VALUE
C     OF THE LAST DIAGONAL OF  R  OR  RECOMPUTE THE WHOLE OF ITS LAST
C     COLUMN. USE THE ARRAY  RLAM  AS TEMPORARY WORK SPACE.
C ---------------------------------------------------------------------
      IF ( .NOT. POSDEF) CALL E04NAY(NOCURV,POSDEF,RENEWR,UNITQ,QPHESS,
     *                               N,NCOLR,NCTOTL,NFREE,NQ,NROWH,
     *                               NCOLH,NROWRT,NCOLRT,NHESS,KFREE,
     *                               CSLAST,SNLAST,DRMAX,EMAX,HSIZE,
     *                               RDLAST,HESS,W(LRT),SCALE,W(LZY),
     *                               W(LRLAM),W(LWRK))
C
C     REPEAT THE MAIN LOOP.
C
      GO TO 20
C
C .........................END OF MAIN LOOP............................
C
C     OPTIMAL QP SOLUTION FOUND.
C
  260 INFORM = 0
      GO TO 380
C
C     WEAK LOCAL MINIMUM.
C
  280 INFORM = 1
      GO TO 380
C
C     UNBOUNDED QP.
C
  300 INFORM = 2
      GO TO 380
C
C     UNABLE TO VERIFY OPTIMALITY OF A STATIONARY POINT WITH TINY OR
C     ZERO MULTIPLIERS.
C
  320 INFORM = 3
      GO TO 380
C
C     TOO MANY ITERATIONS WITHOUT CHANGING X.
C
  340 IF (ZEROLM) GO TO 320
      INFORM = 4
      GO TO 380
C
C     TOO MANY ITERATIONS.
C
  360 INFORM = 5
C
C     PRINT FULL SOLUTION.
C
  380 MSG = MSGLVL
      IF (MSG.GE.1) THEN
         WRITE (REC,FMT=99999) INFORM, ITER
         CALL X04BAF(NOUT,REC(1))
         CALL X04BAF(NOUT,REC(2))
      END IF
C
      IF (INFORM.GT.0) CALL E04VDS(LPROB,N,NCLIN0,NCTOTL,NACTIV,NCOLZ,
     *                             NFREE,NROWA,NROWRT,NCOLRT,JSMLST,
     *                             KSMLST,SMLLST,ISTATE,KACTIV,A,
     *                             W(LANORM),W(LQTG),W(LRLAM),W(LRT))
C
      CALL E04VDQ(NFREE,NROWA,NROWJ,N,NCLIN,NCNLN,NCTOTL,BIGBND,NAMED,
     *            IW(LNAMES),LENNAM,NACTIV,ISTATE,KACTIV,A,BL,BU,X,
     *            CLAMDA,W(LRLAM),X)
C
      RETURN
C
C
C     END OF E04NAX (QPCORE)
99999 FORMAT (/' EXIT QP PHASE.   INFORM =',I3,'   ITER =',I4)
99998 FORMAT (/' //E04NAX//      ZTGNRM      DINKY',/' //E04NAX//',1P,
     *  2D11.2)
      END