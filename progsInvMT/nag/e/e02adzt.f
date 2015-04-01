      SUBROUTINE E02ADZ(MFIRST,MLAST,MTOT,KPLUS1,NROWS,KALL,NDV,X,Y,W,
     *                  XMIN,XMAX,INUP1,NU,WORK1,WORK2,A,S,SERR,EPS,
     *                  IFAIL)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978.
C     MARK 8 REVISED. IER-228 (APR 1980).
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     E02ADZ  COMPUTES WEIGHTED LEAST-SQUARES POLYNOMIAL
C     APPROXIMATIONS TO AN ARBITRARY SET OF DATA POINTS,
C     WITH, IF REQUIRED, SEVERAL SETS OF VALUES OF THE
C     DEPENDENT VARIABLE.
C
C     FORSYTHE-CLENSHAW METHOD WITH MODIFICATIONS DUE TO
C     REINSCH AND GENTLEMAN.
C
C     STARTED - 1973.
C     COMPLETED - 1978.
C     AUTHORS - MGC AND GTA.
C
C     WORK1  AND  WORK2  ARE WORKSPACE AREAS.
C     WORK1(1, R)  CONTAINS THE VALUE OF  X(R)  TRANSFORMED
C     TO THE RANGE  -1  TO  +1.
C     WORK1(2, R)  CONTAINS THE WEIGHTED VALUE OF THE CURRENT
C     ORTHOGONAL POLYNOMIAL (OF DEGREE  I)  AT THE  R TH
C     DATA POINT.
C     WORK2(1, J)  CONTAINS THE COEFFICIENT OF THE CHEBYSHEV
C     POLYNOMIAL OF DEGREE  J - 1  IN THE CHEBYSHEV-SERIES
C     REPRESENTATION OF THE CURRENT ORTHOGONAL POLYNOMIAL
C     (OF DEGREE  I).
C     WORK2(2, J)  CONTAINS THE COEFFICIENT OF THE CHEBYSHEV
C     POLYNOMIAL OF DEGREE  J - 1  IN THE CHEBYSHEV-SERIES
C     REPRESENTATION OF THE PREVIOUS ORTHOGONAL POLYNOMIAL
C     (OF DEGREE  I - 1).
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  XMAX, XMIN
      INTEGER           IFAIL, INUP1, KALL, KPLUS1, MFIRST, MLAST, MTOT,
     *                  NDV, NROWS
C     .. Array Arguments ..
      DOUBLE PRECISION  A(NDV,NROWS,KPLUS1), EPS(NDV,MLAST), NU(INUP1),
     *                  S(NDV,KPLUS1), SERR(KPLUS1), W(MLAST),
     *                  WORK1(2,MTOT), WORK2(2,KPLUS1), X(MLAST),
     *                  Y(NDV,MLAST)
C     .. Local Scalars ..
      DOUBLE PRECISION  ALPIP1, BETAI, BJ, BJP1, BJP2, CIL, D, DF, DI,
     *                  DIM1, DJ, EPSLR, FACTOR, PIJ, SIGMAI, WR, WRPR,
     *                  WRPRSQ, X1, XCAPR, XM
      INTEGER           I, IERROR, II, IM1, INU, IPLUS1, IPLUS2, J,
     *                  JPLUS1, JPLUS2, JREV, K, L, M, MDIST, MR, R
      LOGICAL           WNZ
C     .. Local Arrays ..
      DOUBLE PRECISION  CI(10)
C     .. Intrinsic Functions ..
      INTRINSIC         SQRT
C     .. Executable Statements ..
      K = KPLUS1 - 1
      INU = INUP1 - 1
C
C     TEST THE VALIDITY OF THE DATA.
C
C     CHECK INPUT PARAMETERS.
C
      M = MLAST - MFIRST + 1
      I = KPLUS1 - INU
      IERROR = 5
      IF (MFIRST.LT.1 .OR. INUP1.LT.1 .OR. KPLUS1.LT.INUP1 .OR. M.LT.
     *    I .OR. NDV.LT.1 .OR. (KALL.NE.1 .AND. KALL.NE.0)) GO TO 600
C
C     CHECK THAT THE VALUES OF X(R) ARE NON-DECREASING AND
C     DETERMINE THE NUMBER (MDIST) OF DISTINCT VALUES OF X(R)
C     WITH NON-ZERO WEIGHT
C
      IERROR = 2
      MDIST = 1
      IF (W(MFIRST).EQ.0.0D+0) MDIST = 0
      L = MFIRST + 1
      IF (L.GT.MLAST) GO TO 40
      WNZ = W(MFIRST) .NE. 0.0D+0
      DO 20 R = L, MLAST
         IF (X(R).LT.X(R-1)) GO TO 600
         IF (X(R).GT.X(R-1)) WNZ = .FALSE.
         IF (W(R).EQ.0.0D+0 .OR. WNZ) GO TO 20
         MDIST = MDIST + 1
         WNZ = .TRUE.
   20 CONTINUE
C
C     CHECK THAT XMIN.LT.XMAX AND THAT XMIN AND XMAX SPAN THE DATA
C     X VALUES.
C
   40 IERROR = 1
      IF (XMIN.GT.X(MFIRST) .OR. XMAX.LT.X(MLAST) .OR. XMIN.GE.XMAX)
     *    GO TO 600
C
C     IF THE NUMBER OF DISTINCT VALUES OF  X(R)  WITH NON-ZERO
C     WEIGHT IS LESS THAN THE NUMBER OF INDEPENDENT COEFFICIENTS
C     IN THE FIT OF MAXIMUM DEGREE  K  THERE IS NO UNIQUE
C     POLYNOMIAL
C     APPROXIMATION OF THAT DEGREE.
C
      L = K - INU
      IERROR = 3
      IF (MDIST.LE.L) GO TO 600
C
C     CHECK THAT  NROWS  HAS BEEN SET SUFFICIENTLY LARGE.
C
      IERROR = 5
      IF (KALL.EQ.1 .AND. NROWS.LT.KPLUS1) GO TO 600
      IF (INUP1.EQ.1) GO TO 80
C
C     NORMALIZE THE FORCING FACTOR SO THAT ITS LEADING COEFFICIENT
C     IS UNITY, CHECKING THAT THIS COEFFICIENT WAS NOT ZERO.
C
      IERROR = 4
      DI = NU(INUP1)
      IF (DI.EQ.0.0D0) GO TO 600
      DO 60 I = 1, INUP1
         WORK2(1,I) = NU(I)/DI
         WORK2(2,I) = 0.0D0
   60 CONTINUE
C
   80 IERROR = 0
      X1 = XMIN
      XM = XMAX
      D = XM - X1
C
C     THE INITIAL VALUES OF EPS(L,R) (L = 1,2,....NDV AND R =
C     MFIRST, MFIRST+1,....MLAST) OF THE WEIGHTED RESIDUALS AND
C     THE VALUES WORK1(1,R)(R=1,2...M) OF THE NORMALIZED
C     INDEPENDENT VARIABLE ARE COMPUTED. N.B. WORK1(1,R) IS
C     COMPUTED FROM THE EXPRESSION BELOW RATHER THAN THE MORE
C     NATURAL FORM   (2.0*X(R) - X1 - XM)/D
C     SINCE THE FORMER GUARANTEES THE COMPUTED VALUE TO DIFFER FROM
C     THE TRUE VALUE BY AT MOST  4.0*MACHINE ACCURACY,  WHEREAS THE
C     LATTER HAS NO SUCH GUARANTEE.
C
C     MDIST IS NOW USED TO RECORD THE TOTAL NUMBER OF DATA POINTS
C     WITH NON-ZERO WEIGHT.
C
      MDIST = 0
      DO 120 R = MFIRST, MLAST
         WR = W(R)
         IF (WR.NE.0.0D0) MDIST = MDIST + 1
         MR = R - MFIRST + 1
         DO 100 L = 1, NDV
            EPS(L,R) = WR*Y(L,R)
  100    CONTINUE
         WORK1(1,MR) = ((X(R)-X1)-(XM-X(R)))/D
  120 CONTINUE
      IM1 = INU*KALL + 1
      BETAI = 0.0D0
      DO 160 JPLUS1 = 1, KPLUS1
         SERR(JPLUS1) = 0.0D0
         DO 140 L = 1, NDV
            A(L,IM1,JPLUS1) = 0.0D0
  140    CONTINUE
  160 CONTINUE
      DO 560 IPLUS1 = INUP1, KPLUS1
C
C        SET STARTING VALUES FOR DEGREE  I.
C
         II = (IPLUS1-1)*KALL + 1
         IPLUS2 = IPLUS1 + 1
         IF (IPLUS1.EQ.KPLUS1) GO TO 240
         IF (KALL.EQ.0) GO TO 220
         DO 200 JPLUS1 = IPLUS2, KPLUS1
            DO 180 L = 1, NDV
               A(L,II,JPLUS1) = 0.0D0
  180       CONTINUE
  200    CONTINUE
  220    WORK2(1,IPLUS2) = 0.0D0
         WORK2(2,IPLUS2) = 0.0D0
  240    ALPIP1 = 0.0D0
         DI = 0.0D0
         DO 260 L = 1, NDV
            CI(L) = 0.0D0
  260    CONTINUE
         WORK2(1,IPLUS1) = 1.0D0
         IF (KPLUS1.GT.1) WORK2(2,1) = WORK2(1,2)
         DO 440 R = MFIRST, MLAST
            IF (W(R).EQ.0.0D0) GO TO 440
            MR = R - MFIRST + 1
            XCAPR = WORK1(1,MR)
C
C           THE WEIGHTED VALUE WORK1(2, R)  OF THE ORTHOGONAL POLYNOMIAL
C           OF DEGREE I AT X = X(R) IS COMPUTED BY RECURRENCE FROM ITS
C           CHEBYSHEV-SERIES REPRESENTATION.
C
            IF (IPLUS1.GT.1) GO TO 280
            WRPR = W(R)*0.5D0*WORK2(1,1)
            WORK1(2,MR) = WRPR
            GO TO 400
  280       J = IPLUS2
            IF (XCAPR.GT.0.5D0) GO TO 360
            IF (XCAPR.GE.-0.5D0) GO TO 320
C
C           GENTLEMAN*S MODIFIED RECURRENCE.
C
            FACTOR = 2.0D0*(1.0D0+XCAPR)
            DJ = 0.0D0
            BJ = 0.0D0
            DO 300 JREV = 2, IPLUS1
               J = J - 1
               DJ = WORK2(1,J) - DJ + FACTOR*BJ
               BJ = DJ - BJ
  300       CONTINUE
            WRPR = W(R)*(0.5D0*WORK2(1,1)-DJ+0.5D0*FACTOR*BJ)
            WORK1(2,MR) = WRPR
            GO TO 400
C
C           CLENSHAW*S ORIGINAL RECURRENCE.
C
  320       FACTOR = 2.0D0*XCAPR
            BJP1 = 0.0D0
            BJ = 0.0D0
            DO 340 JREV = 2, IPLUS1
               J = J - 1
               BJP2 = BJP1
               BJP1 = BJ
               BJ = WORK2(1,J) - BJP2 + FACTOR*BJP1
  340       CONTINUE
            WRPR = W(R)*(0.5D0*WORK2(1,1)-BJP1+0.5D0*FACTOR*BJ)
            WORK1(2,MR) = WRPR
            GO TO 400
C
C           REINSCH*S MODIFIED RECURRENCE.
C
  360       FACTOR = 2.0D0*(1.0D0-XCAPR)
            DJ = 0.0D0
            BJ = 0.0D0
            DO 380 JREV = 2, IPLUS1
               J = J - 1
               DJ = WORK2(1,J) + DJ - FACTOR*BJ
               BJ = BJ + DJ
  380       CONTINUE
            WRPR = W(R)*(0.5D0*WORK2(1,1)+DJ-0.5D0*FACTOR*BJ)
            WORK1(2,MR) = WRPR
C
C           THE COEFFICIENTS CI(L) OF THE I TH ORTHOGONAL POLYNOMIAL
C           L=1,2....NDV AND THE COEFFICIENTS ALPIP1 AND BETAI IN THE
C           THREE-TERM RECURRENCE RELATION FOR THE ORTHOGONAL
C           POLYNOMIALS ARE COMPUTED.
C
  400       WRPRSQ = WRPR**2
            DI = DI + WRPRSQ
            DO 420 L = 1, NDV
               CI(L) = CI(L) + WRPR*EPS(L,R)
  420       CONTINUE
            ALPIP1 = ALPIP1 + WRPRSQ*XCAPR
  440    CONTINUE
         DO 460 L = 1, NDV
            CI(L) = CI(L)/DI
  460    CONTINUE
         IF (IPLUS1.NE.INUP1) BETAI = DI/DIM1
         ALPIP1 = 2.0D0*ALPIP1/DI
C
C        THE WEIGHTED RESIDUALS EPS(L,R)(L=1,2....NDV AND R=MFIRST,
C        MFIRST+1....MLAST) FOR DEGREE I ARE COMPUTED, TOGETHER
C        WITH THEIR SUM OF SQUARES, SIGMAI
C
         DF = MDIST - (IPLUS1-INU)
         DO 500 L = 1, NDV
            CIL = CI(L)
            SIGMAI = 0.0D0
            DO 480 R = MFIRST, MLAST
               IF (W(R).EQ.0.0D0) GO TO 480
               MR = R - MFIRST + 1
               EPSLR = EPS(L,R) - CIL*WORK1(2,MR)
               EPS(L,R) = EPSLR
               SIGMAI = SIGMAI + EPSLR**2
  480       CONTINUE
C
C           THE ROOT MEAN SQUARE RESIDUAL  S(L, I + 1)  FOR DEGREE  I
C           IS THEORETICALLY UNDEFINED IF  M = I + 1 - INU  (THE
C           CONDITION FOR THE POLYNOMIAL TO PASS EXACTLY THROUGH THE
C           DATA POINTS). SHOULD THIS CASE ARISE THE R.M.S. RESIDUAL
C           IS SET TO ZERO.
C
            IF (DF.LE.0.0D0) S(L,IPLUS1) = 0.0D0
            IF (DF.GT.0.0D0) S(L,IPLUS1) = SQRT(SIGMAI/DF)
  500    CONTINUE
C
C        THE CHEBYSHEV COEFFICIENTS A(L, I+1, 1), A(L, I+1, 2)....
C        A(L, I+1, I+1) IN THE POLYNOMIAL APPROXIMATION OF DEGREE I
C        TO EACH SET OF VALUES OF THE INDEPENDENT VARIABLE
C        (L=1,2,...,NDV) TOGETHER WITH THE COEFFICIENTS
C        WORK2(1, 1), WORK2(1, 2), ..., WORK2(1, I + 1),   IN THE
C        CHEBYSHEV-SERIES REPRESENTATION OF THE  (I + 1) TH
C        ORTHOGONAL POLYNOMIAL ARE COMPUTED.
C
         DO 540 JPLUS1 = 1, IPLUS1
            JPLUS2 = JPLUS1 + 1
            PIJ = WORK2(1,JPLUS1)
            SERR(JPLUS1) = SERR(JPLUS1) + PIJ**2/DI
            DO 520 L = 1, NDV
               A(L,II,JPLUS1) = A(L,IM1,JPLUS1) + CI(L)*PIJ
  520       CONTINUE
            IF (JPLUS1.EQ.KPLUS1) GO TO 560
            WORK2(1,JPLUS1) = WORK2(1,JPLUS2) + WORK2(2,JPLUS1) -
     *                        ALPIP1*PIJ - BETAI*WORK2(2,JPLUS2)
            WORK2(2,JPLUS2) = PIJ
  540    CONTINUE
         DIM1 = DI
         IM1 = II
  560 CONTINUE
      DO 580 IPLUS1 = 1, KPLUS1
         SERR(IPLUS1) = 1.0D0/SQRT(SERR(IPLUS1))
  580 CONTINUE
  600 IFAIL = IERROR
      RETURN
      END
