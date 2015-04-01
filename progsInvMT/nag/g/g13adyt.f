      SUBROUTINE G13ADY(COV,TOR,ERR,WA,IQ1,EPSILN,MAXITN,IFAIL1)
C     MARK 9 RELEASE. NAG COPYRIGHT 1981.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     G13ADY CALCULATES PRELIMINARY
C     ESTIMATES OF MOVING AVERAGE PARAMETERS FOR G13ADZ
C     (CRAMER WOLD FACTORISATION)
C
C     PARAMETERS
C     COV      - ARRAY OF COVARIANCES, OVERWRITTEN BY
C     UNSCALED RESIDUAL VARIANCE AND PARAMETERS
C     IF ESTIMATION SUCCESSFUL
C     TOR      - M.A. PARAMETER EQUATION SOLUTIONS
C     ERR      - ARRAY FOR ERROR VALUES AND PARAMETER CORRECTIONS
C     WA       - WORKING ARRAY
C     IQ1      - NO. OF PARAMETERS+1=SIZE OF ABOVE ARRAYS
C     EPSILN   - USED TO CALCULATE CONVERGENCE CRITERION
C     MAXITN   - MAXIMUM NUMBER OF ITERATIONS
C     IFAIL1   - SUCCESS/FAILURE INDICATOR
C
C     USES NAG LIBRARY ROUTINE G13ADX
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  EPSILN
      INTEGER           IFAIL1, IQ1, MAXITN
C     .. Array Arguments ..
      DOUBLE PRECISION  COV(IQ1), ERR(IQ1), TOR(IQ1), WA(IQ1)
C     .. Local Scalars ..
      DOUBLE PRECISION  EPS
      INTEGER           I, IQMI, ITERN, J, K
C     .. External Subroutines ..
      EXTERNAL          G13ADX
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, SQRT
C     .. Executable Statements ..
      EPS = EPSILN*COV(1)
      ITERN = 0
      TOR(1) = SQRT(COV(1))
      DO 20 I = 2, IQ1
         TOR(I) = COV(I)/COV(1)
   20 CONTINUE
C
C     CALCULATE ERRORS
C
   40 DO 80 I = 1, IQ1
         ERR(I) = COV(I)
         IQMI = IQ1 + 1 - I
         DO 60 J = 1, IQMI
            K = J + I - 1
            ERR(I) = ERR(I) - TOR(J)*TOR(K)
   60    CONTINUE
   80 CONTINUE
C
C     TEST ERRORS FOR CONVERGENCE
C
      DO 100 I = 1, IQ1
         IF (ABS(ERR(I)).GE.EPS) GO TO 120
  100 CONTINUE
      GO TO 160
  120 IF (ITERN.GE.MAXITN) GO TO 200
C
C     CALCULATE TOR CORRECTIONS IN ERR
C
      CALL G13ADX(TOR,ERR,WA,IQ1,IFAIL1)
      IF (IFAIL1.NE.0) GO TO 200
C
C     CORRECT TOR BY DELTA (STORED IN ERR)
C
      DO 140 I = 1, IQ1
         TOR(I) = TOR(I) + ERR(I)
  140 CONTINUE
      ITERN = ITERN + 1
      GO TO 40
C
C     COME HERE IF CONVERGENCE IS ACHIEVED
C
  160 CONTINUE
      COV(1) = TOR(1)*TOR(1)
      DO 180 I = 2, IQ1
         COV(I) = -TOR(I)/TOR(1)
  180 CONTINUE
      IFAIL1 = 0
      RETURN
C
C     COME HERE IF MAXIMUM ITERATIONS REACHED
C     OR IF EQUATIONS HAVE NO SOLUTION
C
  200 CONTINUE
      IFAIL1 = 1
      RETURN
      END
