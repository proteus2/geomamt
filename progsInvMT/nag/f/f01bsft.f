      SUBROUTINE F01BSF(N,NZ,A,LICN,IVECT,JVECT,ICN,IKEEP,IW,W,GROW,EPS,
     *                  RMIN,ABORT,IDISP,IFAIL)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     DERIVED FROM HARWELL LIBRARY ROUTINE MA28B
C
C     DECOMPOSES A REAL SPARSE MATRIX USING THE PIVOTAL SEQUENCE
C     PREVIOUSLY OBTAINED BY F01BRF WHEN A MATRIX OF THE SAME
C     SPARSITY PATTERN WAS DECOMPOSED.
C
C     THE PARAMETERS ARE AS FOLLOWS ...
C     N      INTEGER  ORDER OF MATRIX  NOT ALTERED BY SUBROUTINE.
C     NZ     INTEGER  NUMBER OF NON-ZEROS IN INPUT MATRIX  NOT
C     .      ALTERED BY SUBROUTINE.
C     A      REAL ARRAY  LENGTH LICN.  HOLDS NON-ZEROS OF MATRIX ON
C     .      ENTRY AND NON-ZEROS OF FACTORS ON EXIT.  REORDERED
C     .      BY F01BSZ AND ALTERED BY SUBROUTINE F01BSY.
C     LICN   INTEGER  LENGTH OF ARRAYS A AND ICN.  NOT ALTERED BY
C     .      SUBROUTINE.
C     IVECT,JVECT  INTEGER ARRAYS  LENGTH NZ.  HOLD ROW AND COLUMN
C     .      INDICES OF NON-ZEROS RESPECTIVELY.  NOT ALTERED BY
C     .      SUBROUTINE.
C     ICN    INTEGER ARRAY  LENGTH LICN.  SAME ARRAY AS OUTPUT FROM
C     .      F01BRF.  UNCHANGED BY F01BSF.
C     IKEEP  INTEGER ARRAY  LENGTH 5*N.  SAME ARRAY AS OUTPUT FROM
C     .      F01BRF.  UNCHANGED BY F01BSF.
C     IW     INTEGER ARRAY  LENGTH 5*N.
C     .      USED AS WORKSPACE BY F01BSZ AND F01BSY.
C     W      REAL ARRAY  LENGTH N.  USED AS WORKSPACE
C     .      BY F01BSZ, F01BSY AND (OPTIONALLY) F01BRQ.
C     GROW   LOGICAL.  IF TRUE, AN ESTIMATE OF THE INCREASE
C     .      IN SIZE OF ARRAY ELEMENTS DURING L/U DECOMPOSITION
C     .      IS GIVEN BY F01BRQ IN W(1).
C     EPS    REAL.  USED TO TEST FOR SMALL PIVOTS. IF THE USER SETS
C     .      EPS.GT.1.0, NO CHECK IS MADE ON THE SIZE OF THE PIVOTS.
C     RMIN   REAL.  GIVES THE USER SOME INFORMATION ABOUT THE
C     .      STABILITY OF THE DECOMPOSITION.
C     ABORT  LOGICAL.  IF ABORT=TRUE, THE ROUTINE WILL EXIT
C     .      IMMEDIATELY ON DETECTING DUPLICATE ELEMENTS IN THE
C     .      INPUT MATRIX.
C     IDISP  INTEGER ARRAY LENGTH 2.  IDISP(1) AND (2) MUST HAVE THE
C     .      SAME VALUES AS OUTPUT FROM F01BRF. UNCHANGED BY THE
C     .      ROUTINE.
C     IFAIL  INTEGER.  USED AS ERROR FLAG BY THE ROUTINE.
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='F01BSF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  EPS, RMIN
      INTEGER           IFAIL, LICN, N, NZ
      LOGICAL           ABORT, GROW
C     .. Array Arguments ..
      DOUBLE PRECISION  A(LICN), W(N)
      INTEGER           ICN(LICN), IDISP(2), IKEEP(N,5), IVECT(NZ),
     *                  IW(N,5), JVECT(NZ)
C     .. Local Scalars ..
      DOUBLE PRECISION  WMAX
      INTEGER           I1, IEND, IR, ISAVE, NERR
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
      CHARACTER*65      REC(2)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          F01BRQ, F01BSY, F01BSZ, X04AAF, X04BAF
C     .. Intrinsic Functions ..
      INTRINSIC         MOD
C     .. Executable Statements ..
      ISAVE = IFAIL
C     NERR IS THE UNIT NUMBER FOR ERROR MESSAGES
      CALL X04AAF(0,NERR)
C     SIMPLE DATA CHECK ON VARIABLES.
      IF (N.GT.0) GO TO 20
      IFAIL = 1
      GO TO 120
   20 IF (NZ.GT.0) GO TO 40
      IFAIL = 2
      GO TO 120
   40 IF (LICN.GE.NZ) GO TO 60
      IFAIL = 3
      GO TO 120
C
   60 CALL F01BSZ(N,A,LICN,IVECT,JVECT,NZ,ICN,IKEEP,IKEEP(1,4)
     *            ,IKEEP(1,5),IKEEP(1,2),IKEEP(1,3),IW(1,3),IW,W(1)
     *            ,ABORT,IDISP,IFAIL)
C     WMAX IS LARGEST ELEMENT IN MATRIX.
      WMAX = W(1)
      IF (IFAIL.NE.0) GO TO 120
C
C     PERFORM ROW-GAUSS ELIMINATION ON THE STRUCTURE RECEIVED FROM
C     F01BSZ
C
      IFAIL = ISAVE
      CALL F01BSY(N,ICN,A,LICN,IKEEP,IKEEP(1,4),IDISP,IKEEP(1,2)
     *            ,IKEEP(1,3),W,IW,EPS,RMIN,IFAIL)
      IF (IFAIL.EQ.0) GO TO 100
      IF (IFAIL.GT.0) GO TO 80
      IR = -IFAIL
      IFAIL = 6
      GO TO 120
   80 IR = IFAIL
      IFAIL = 7
C
C     OPTIONALLY CALCULATE THE GROWTH PARAMETER.
  100 I1 = IDISP(1)
      IEND = LICN - I1 + 1
      IF (GROW) CALL F01BRQ(N,ICN,A(I1),IEND,IKEEP,IKEEP(1,4),W)
C     INCREMENT ESTIMATE BY LARGEST ELEMENT IN INPUT MATRIX.
      IF (GROW) W(1) = W(1) + WMAX
      IF (IFAIL.EQ.0) GO TO 160
C
  120 CONTINUE
C     ** CODE FOR OUTPUT OF ERROR MESSAGES *************************
      IF (MOD(ISAVE/10,10).EQ.0) GO TO 140
      CALL X04AAF(0,NERR)
      IF (IFAIL.EQ.1) WRITE (REC,FMT=99999) N
      IF (IFAIL.EQ.2) WRITE (REC,FMT=99998) NZ
      IF (IFAIL.EQ.3) WRITE (REC,FMT=99997) LICN, NZ
      IF (IFAIL.EQ.6) WRITE (REC,FMT=99996) IR
      IF (IFAIL.EQ.7) WRITE (REC,FMT=99995) IR
      IF (IFAIL.EQ.8) WRITE (REC,FMT=99994)
      IF ((IFAIL.GE.1 .AND. IFAIL.LE.3)
     *    .OR. (IFAIL.GE.6 .AND. IFAIL.LE.8)) THEN
         CALL X04BAF(NERR,REC(1))
         CALL X04BAF(NERR,REC(2))
      END IF
C     ** END OF CODE FOR OUTPUT OF ERROR MESSAGES ******************
C
  140 IFAIL = P01ABF(ISAVE,IFAIL,SRNAME,0,P01REC)
  160 RETURN
C
99999 FORMAT (/' ON ENTRY N .LE. 0 , N =',I10)
99998 FORMAT (/' ON ENTRY NZ .LE. 0 , NZ =',I10)
99997 FORMAT (/' ON ENTRY LICN .LT. NZ , LICN = ',I8,'  NZ = ',I8)
99996 FORMAT (/' NUMERICAL SINGULARITY IN ROW ',I4,' - DECOMPOSITION A',
     *  'BORTED')
99995 FORMAT (/' SUBTHRESHOLD PIVOT IN ROW ',I4,' - DECOMPOSITION COMP',
     *  'LETED')
99994 FORMAT (/' DUPLICATE ELEMENTS FOUND ON INPUT - SEE ADVISORY MESS',
     *  'AGES')
      END
