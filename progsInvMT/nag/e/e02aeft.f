      SUBROUTINE E02AEF(NPLUS1,A,XCAP,P,IFAIL)
C     NAG LIBRARY SUBROUTINE  E02AEF
C
C     E02AEF  EVALUATES A POLYNOMIAL FROM ITS CHEBYSHEV-
C     SERIES REPRESENTATION.
C
C     CLENSHAW METHOD WITH MODIFICATIONS DUE TO REINSCH
C     AND GENTLEMAN.
C
C     USES NAG LIBRARY ROUTINES  P01ABF  AND  X02AJF.
C     USES INTRINSIC FUNCTION  ABS.
C
C     STARTED - 1973.
C     COMPLETED - 1976.
C     AUTHOR - MGC AND JGH.
C
C     NAG COPYRIGHT 1975
C     MARK 5 RELEASE
C     MARK 7 REVISED IER-140 (DEC 1978)
C     MARK 9 REVISED. IER-352 (SEP 1981)
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 13 REVISED. USE OF MARK 12 X02 FUNCTIONS (APR 1988).
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='E02AEF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  P, XCAP
      INTEGER           IFAIL, NPLUS1
C     .. Array Arguments ..
      DOUBLE PRECISION  A(NPLUS1)
C     .. Local Scalars ..
      DOUBLE PRECISION  BK, BKP1, BKP2, DK, ETA, FACTOR
      INTEGER           IERROR, K, KREV, N, NPLUS2
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
C     .. External Functions ..
      DOUBLE PRECISION  X02AJF
      INTEGER           P01ABF
      EXTERNAL          X02AJF, P01ABF
C     .. Intrinsic Functions ..
      INTRINSIC         ABS
C     .. Executable Statements ..
      IERROR = 0
      ETA = X02AJF()
C     INSERT CALL TO X02AJF
C
C     ETA  IS THE SMALLEST POSITIVE NUMBER SUCH THAT
C     THE COMPUTED VALUE OF  1.0 + ETA  EXCEEDS UNITY.
C
      IF (NPLUS1.GE.1) GO TO 20
      IERROR = 2
      GO TO 180
   20 IF (ABS(XCAP).LE.1.0D0+4.0D0*ETA) GO TO 40
      IERROR = 1
      P = 0.0D0
      GO TO 180
   40 IF (NPLUS1.GT.1) GO TO 60
      P = 0.5D0*A(1)
      GO TO 180
   60 N = NPLUS1 - 1
      NPLUS2 = N + 2
      K = NPLUS2
      IF (XCAP.GT.0.5D0) GO TO 140
      IF (XCAP.GE.-0.5D0) GO TO 100
C
C     GENTLEMAN*S MODIFIED RECURRENCE.
C
      FACTOR = 2.0D0*(1.0D0+XCAP)
      DK = 0.0D0
      BK = 0.0D0
      DO 80 KREV = 1, N
         K = K - 1
         DK = A(K) - DK + FACTOR*BK
         BK = DK - BK
   80 CONTINUE
      P = 0.5D0*A(1) - DK + 0.5D0*FACTOR*BK
      GO TO 180
C
C     CLENSHAW*S ORIGINAL RECURRENCE.
C
  100 FACTOR = 2.0D0*XCAP
      BKP1 = 0.0D0
      BK = 0.0D0
      DO 120 KREV = 1, N
         K = K - 1
         BKP2 = BKP1
         BKP1 = BK
         BK = A(K) - BKP2 + FACTOR*BKP1
  120 CONTINUE
      P = 0.5D0*A(1) - BKP1 + 0.5D0*FACTOR*BK
      GO TO 180
C
C     REINSCH*S MODIFIED RECURRENCE.
C
  140 FACTOR = 2.0D0*(1.0D0-XCAP)
      DK = 0.0D0
      BK = 0.0D0
      DO 160 KREV = 1, N
         K = K - 1
         DK = A(K) + DK - FACTOR*BK
         BK = BK + DK
  160 CONTINUE
      P = 0.5D0*A(1) + DK - 0.5D0*FACTOR*BK
  180 IF (IERROR) 200, 220, 200
  200 IFAIL = P01ABF(IFAIL,IERROR,SRNAME,0,P01REC)
      RETURN
  220 IFAIL = 0
      RETURN
      END