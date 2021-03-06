      SUBROUTINE E01DAW(NORDER,XMIN,XMAX,M,X,NSETS,F,IF1,IF2,LF,NKNOTS,
     *                  LAMBDA,LLMBDA,C,IC1,IC2,LC,UFCTR,LUFCTR,KNOT,
     *                  LKNOT,XROW,LXROW,WRK,LWRK,IFAIL)
C     MARK 14 RELEASE. NAG COPYRIGHT 1989.
C     A DASL routine, unmodified except for name, and calls to
C     DASL routine VCONST replaced by functionally equivalent NAG,
C     and a call to E01DAQ modified slightly as explained below.
C
C     **********************************************************
C
C     D A S L  -  DATA APPROXIMATION SUBROUTINE LIBRARY
C
C     SUBROUTINE B1I       POLYNOMIAL SPLINE INTERPOLANT
C     ==============       TO ARBITRARY DATA
C                          - BASE VERSION
C
C     CREATED 10 09 79.  UPDATED 24 06 82.  RELEASE 00/09
C
C     AUTHORS ... MAURICE G. COX AND PAULINE E. M. CURTIS.
C     NATIONAL PHYSICAL LABORATORY, TEDDINGTON,
C     MIDDLESEX TW11 OLW, ENGLAND.
C
C     (C)  CROWN COPYRIGHT 1979-1982
C
C     **********************************************************
C
C     B1I.  DETERMINES UNIVARIATE POLYNOMIAL SPLINE
C     INTERPOLANTS IN THE FOLLOWING WAY.
C
C     (1)  INITIALIZE A BAND UPPER TRIANGULAR MATRIX  U
C          AND RIGHT HAND SIDE VECTORS  THETA  TO ZERO.
C
C     (2)  FOR EACH VALUE OF  I  FROM  1  TO  M
C
C          (2.1)  FORM IN  XROW  THE VALUES OF THE B-SPLINE
C                 BASIS FUNCTIONS AT  X(I).
C
C          (2.2)  UPDATE THE SYSTEM  (U, THETA)  TO INCLUDE
C                 THE OBSERVATION  (XROW, FROW),  WHERE
C                 FROW  DENOTES THE ROW VECTOR OF  NSETS
C                 ELEMENTS CONTAINING THE F-VALUES
C                 CORRESPONDING TO  X(I).
C
C     (3)  SOLVE THE RESULTING SYSTEM  U*C = THETA.
C
C     INPUT PARAMETERS
C        NORDER   ORDER (DEGREE + 1) OF SPLINE(S)  S
C        XMIN,
C        XMAX     LOWER AND UPPER ENDPOINTS OF INTERVAL
C        M        NUMBER OF INDEPENDENT VARIABLE VALUES
C        X        INDEPENDENT VARIABLE VALUES
C        NSETS    NUMBER OF SPLINES
C        F        DEPENDENT VARIABLE VALUES
C        IF1,
C        IF2      INDEX INCREMENTS OF  F
C        LF       DIMENSION OF  F
C        NKNOTS   NUMBER OF INTERIOR KNOTS
C
C     OUTPUT (AND ASSOCIATED) PARAMETERS
C        LAMBDA   INTERIOR KNOTS
C        LLMBDA   DIMENSION OF  LAMBDA
C        C        B-SPLINE COEFFICIENTS OF  S
C        IC1,
C        IC2      INDEX INCREMENTS OF  C
C        LC       DIMENSION OF  C
C        UFCTR    BAND UPPER TRIANGULAR MATRIX  U,
C                    STORED BY ROWS
C        LUFCTR   DIMENSION OF  UFCTR.  .GE. NUFCTR =
C                    NORDER*(M + NKNOTS + 1)/2
C
C     WORKSPACE (AND ASSOCIATED DIMENSION) PARAMETERS
C        KNOT     KNOTS USED IN COMPUTING B-SPLINE BASIS
C                    FOR CURRENT X-VALUE
C        LKNOT    DIMENSION OF  KNOT.  .GE. 2*NORDER.
C        XROW     OBSERVATIONAL ROW CONTAINING B-SPLINE
C                    BASIS VALUES FOR CURRENT X-VALUE
C        LXROW    DIMENSION OF  XROW.  .GE. M.
C        WRK      REAL WORKSPACE REQUIRED BY  ERB
C        LWRK     DIMENSION OF  WRK.  .GE.  NSETS.
C
C     FAILURE INDICATOR PARAMETER
C        IFAIL    FAILURE INDICATOR
C                    1 - NUMERICALLY SINGULAR SYSTEM
C
C     ----------------------------------------------------------
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  XMAX, XMIN
      INTEGER           IC1, IC2, IF1, IF2, IFAIL, LC, LF, LKNOT,
     *                  LLMBDA, LUFCTR, LWRK, LXROW, M, NKNOTS, NORDER,
     *                  NSETS
C     .. Array Arguments ..
      DOUBLE PRECISION  C(LC), F(LF), KNOT(LKNOT), LAMBDA(LLMBDA),
     *                  UFCTR(LUFCTR), WRK(LWRK), X(M), XROW(LXROW)
C     .. Local Scalars ..
      INTEGER           I, IERROR, IF, JINTVL, JNTVL0, LASTCL, NUFCTR
C     .. External Subroutines ..
      EXTERNAL          E01DAL, E01DAM, E01DAN, E01DAQ, E01DAR, E01DAS,
     *                  E01DAV
C     .. Executable Statements ..
C
C     NUMBER OF ELEMENTS WITHIN BAND OF  U
C
      NUFCTR = (NORDER*(M+NKNOTS+1))/2
C
C     INITIALIZE  U  AND RIGHT HAND SIDE VECTORS  THETA
C     (HELD IN LOCATIONS SUBSEQUENTLY TO BE OCCUPIED BY  C)
C
C      CALL E01DAQ ( M, NSETS, NUFCTR, UFCTR, LUFCTR, C, IC1,
C     *             IC2, LC, WRK(1), 0, 1, WRK(1), 0, 1 )
C
C     Call above modified to that below so that E01DAQ can call
C     NAG routine F06FBF instead of DASL routine VCONST.
C     ( E01DAQ calls VCONST with N = NSETS, IV1 = 0, LV = 1 . i.e
C     VCONST initialises element WRK(1), NSETS times. Making the
C     call to F06FBF instead initialises elements WRK(1)..WRK(NSETS)
C     one time each. This makes no difference since the results are
C     ignored anyway. )
C
      CALL E01DAQ(M,NSETS,NUFCTR,UFCTR,LUFCTR,C,IC1,IC2,LC,WRK(1),1,
     *            LWRK,WRK(1),1,LWRK)
C
C     INITIALIZE NUMBER OF RIGHTMOST COLUMN OF  U  THAT
C     CONTAINS NONZERO ELEMENTS
C
      LASTCL = 0
C
C     INITIALIZE INTERVAL NUMBER
C
      JINTVL = 0
C
C     INITIALIZE KNOTS
C
      CALL E01DAM(NORDER,NKNOTS,XMIN,XMAX,LAMBDA,LLMBDA,JINTVL,KNOT,
     *            LKNOT)
C
C     INITIALIZE ORDINATE INDEX
C
      IF = 1 - IF1
C
C     COUNT OVER DATA POINTS
C
      DO 20 I = 1, M
C
C        UPDATE ORDINATE INDEX
C
         IF = IF + IF1
C
C        PREVIOUS INTERVAL NUMBER
C
         JNTVL0 = JINTVL
C
C        NUMBER OF INTERVAL CONTAINING  X(I)
C
         CALL E01DAN(NKNOTS,LAMBDA,LLMBDA,X(I),JINTVL)
C
C        IF THE CURRENT DATA ABSCISSA LIES IN AN INTERVAL
C        DIFFERENT FROM THAT CONSIDERED PREVIOUSLY,
C        ASSEMBLE THE  2*NORDER  KNOTS THAT RELATE TO THE
C        B-SPLINES OF ORDER  NORDER  THAT ARE NONZERO IN
C        THE INTERVAL NUMBERED  JINTVL  CONTAINING  X(I)
C
         IF (JINTVL.NE.JNTVL0) CALL E01DAM(NORDER,NKNOTS,XMIN,XMAX,
     *                              LAMBDA,LLMBDA,JINTVL,KNOT,LKNOT)
C
C        FORM THE VALUES AT  X(I)  OF THE B-SPLINE BASIS
C        FUNCTIONS THAT ARE NONZERO WITHIN THIS INTERVAL
C        AND INSERT THEM INTO THE RELEVANT PART OF  XROW
C
         CALL E01DAV(NORDER,KNOT,LKNOT,X(I),XROW(JINTVL+1))
C
C        UPDATE  U, THETA  AND  LASTCL  (E01DAR  REQUIRES
C        WORKSPACE OF  NSETS  REAL ELEMENTS)
C
         CALL E01DAR(M,NORDER,JINTVL+1,XROW,NSETS,F(IF),IF2,LF-IF+1,
     *               LASTCL,UFCTR,LUFCTR,C,IC1,IC2,LC,WRK,LWRK)
   20 CONTINUE
C
C     CHECK THAT  U  IS NONSINGULAR
C
      CALL E01DAS(M,NORDER,UFCTR,LUFCTR,IERROR)
C
C     SOLVE  U*C = THETA
C
      IF (IERROR.EQ.0) CALL E01DAL(M,NORDER,UFCTR,LUFCTR,NSETS,0,C,IC1,
     *                             IC2,LC)
      IFAIL = IERROR
      RETURN
C
C     END E01DAW
C
      END
