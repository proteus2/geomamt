      SUBROUTINE E01DAN(NKNOTS,LAMBDA,LLMBDA,X,JINTVL)
C     MARK 14 RELEASE. NAG COPYRIGHT 1989.
C     A DASL routine, unmodified except for name.
C
C     **********************************************************
C
C     D A S L  -  DATA APPROXIMATION SUBROUTINE LIBRARY
C
C     SUBROUTINE INTVL     INTERVAL SEARCH FOR THE SPLINE
C     ================     SUBINTERVAL CONTAINING  X
C
C     CREATED 13 06 79.  UPDATED 23 06 82.  RELEASE 00/05
C
C     AUTHORS ... DEREK BUSH, MAURICE G. COX, PAULINE E. M.
C                 CURTIS AND J. GEOFFREY HAYES
C     NATIONAL PHYSICAL LABORATORY, TEDDINGTON,
C     MIDDLESEX  TW11 0LW, ENGLAND
C
C     (C)  CROWN COPYRIGHT 1979-1982
C
C     **********************************************************
C
C     INTVL.  CALCULATES  JINTVL,  THE SPLINE
C     INTERVAL WITHIN WHICH  X  LIES.
C
C        JINTVL = 0       FOR  X .LT. LAMBDA(1),
C        JINTVL = NKNOTS  FOR LAMBDA(NKNOTS) .LE. X,
C        OTHERWISE  JINTVL  IS SUCH THAT
C           LAMBDA(JINTVL) .LE. X .LT. LAMBDA(JINTVL + 1).
C
C     INPUT PARAMETERS
C        NKNOTS   NUMBER OF INTERIOR KNOTS
C        LAMBDA   INTERIOR KNOTS
C        LLMBDA   DIMENSION OF LAMBDA
C        X        ABSCISSA VALUE
C
C     INPUT/OUTPUT PARAMETER
C        JINTVL   INTERVAL INDEX ASSOCIATED WITH  X
C
C     ----------------------------------------------------------
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  X
      INTEGER           JINTVL, LLMBDA, NKNOTS
C     .. Array Arguments ..
      DOUBLE PRECISION  LAMBDA(LLMBDA)
C     .. Local Scalars ..
      INTEGER           JTEMP
C     .. External Subroutines ..
      EXTERNAL          E01DAP
C     .. Executable Statements ..
C
C     DISPENSE FIRST WITH THE CASES WHERE THERE ARE NO KNOTS,
C     WHERE  X .LT. LAMBDA(1),  WHERE  X .GE. LAMBDA(NKNOTS)
C
      JTEMP = 0
      IF (NKNOTS.EQ.0) GO TO 20
      IF (X.LT.LAMBDA(1)) GO TO 20
      JTEMP = NKNOTS
      IF (X.GE.LAMBDA(NKNOTS)) GO TO 20
      JTEMP = JINTVL
C
C     DETERMINE THE SPLINE SUBINTERVAL INDEX IN THE
C     GENERAL CASE
C
      IF (JTEMP.EQ.NKNOTS) JTEMP = NKNOTS - 1
      IF (JTEMP.EQ.0) JTEMP = 1
      IF ( .NOT. (LAMBDA(JTEMP).LE.X .AND. X.LT.LAMBDA(JTEMP+1)))
     *    CALL E01DAP(NKNOTS,LAMBDA,X,JTEMP)
   20 JINTVL = JTEMP
      RETURN
C
C     END E01DAN
C
      END