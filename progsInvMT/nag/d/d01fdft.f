      SUBROUTINE D01FDF(N,F,SIGMA,REGION,LIMIT,R0,U,RESULT,NPTS,IFAIL)
C     MARK 10 RELEASE. NAG COPYRIGHT 1982.
C     MARK 10C REVISED. IER-425 (JUL 1983).
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 13 REVISED. USE OF MARK 12 X02 FUNCTIONS (APR 1988).
C
C     MULTIPLE INTEGRATION
C
C     THIS SUBROUTINE CALCULATES AN APPROXIMATION TO-
C        D1      DN
C        I ......I F(X1,...,XN) DX1 .. DXN        (SIGMA .LT. 0)
C        C1      CN
C
C      OR
C
C        I ......I F(X1,...,XN) DX1 .. DXN        (SIGMA .GE. 0)
C     N-SPHERE RADIUS SIGMA
C
C     MULTIPLE INTEGRATION BASED ON THE METHOD OF SAG AND SZEKERES,
C     NUMERICAL EVALUATION OF HIGH DIMENSIONAL INTEGRALS -
C     MATHS.COMP. V18,245-253,1964.
C
C     INPUT ARGUMENTS
C     ----- ----------
C
C      N     - INTEGER NUMBER OF DIMENSIONS (1 .LE. N .LE. 30)
C      F     - EXTERNALLY DECLARED REAL USER FUNCTION INTEGRAND
C              HAVING ARGUMENTS (N,X) WHERE X IS A REAL ARRAY
C              OF DIMENSION N WHOSE ELEMENTS ARE THE VARIABLE
C              VALUES.
C      SIGMA - THIS DETERMINES THE DOMAIN OF INTEGRATION AS FOLLOWS
C              (A) SIGMA .LT. 0.
C              THE INTEGRATION IS CARRIED OUT OVER THE PRODUCT
C              REGION DETERMINED BY THE USER SUPPLIED SUBROUTINE
C              REGION.
C              (B) SIGMA .GE. 0.
C              THE INTEGRATION IS CARRIED OUT OVER THE N-SPHERE
C              OF RADIUS SIGMA. IN THIS CASE SUBROUTINE REGION IS
C              NOT CALLED AND IS SIMPLY SUPPLIED AS A DUMMY ROUTINE.
C      REGION- EXTERNALLY DECLARED USER SUBROUTINE WITH ARGUMENTS
C              (N,X,J,C,D) WHICH CALCULATES THE LOWER LIMIT C
C              AND THE UPPER LIMIT D CORRESPONDING TO THE ARRAY
C              VARIABLE X(J). C AND D MAY DEPEND ON X(1)..X(J-1).
C      LIMIT - APPROXIMATE NO. OF INTEGRAND EVALUATIONS TO BE USED.
C              IT MUST BE GREATER THAN 100. IN VERY LOW DIMENSIONS
C              IT MAY NOT BE POSSIBLE TO ATTAIN THIS AS AN UPPER
C              LIMIT DUE TO INTERNAL STORAGE LIMITATIONS (YY(30)).
C      R0    - ADJUSTABLE PARAMETER, TYPICAL VALUE 0.8,
C              (0 .LT. R0 .LE. 1)
C      U     - ADJUSTABLE PARAMETER, TYPICAL VALUE 1.5,(U .GT. 0)
C      IFAIL - INTEGER, NAG FAILURE PARAMETER
C              IFAIL=0, HARD FAIL
C              IFAIL=1, SOFT FAIL
C
C     OUTPUT ARGUMENTS
C     ------ ----------
C
C      RESULT- APPROXIMATE VALUE OF INTEGRAL
C      NPTS  - ACTUAL NUMBER OF INTEGRAND EVALUATIONS.
C      IFAIL - IFAIL=0, NORMAL EXIT
C              IFAIL=1, INVALID N VALUE (N .GT. 30)
C              IFAIL=2, INVALID LIMIT VALUE
C              IFAIL=3, INVALID R0 VALUE
C              IFAIL=4, INVALID U VALUE
C
C     REGION
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='D01FDF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  R0, RESULT, SIGMA, U
      INTEGER           IFAIL, LIMIT, N, NPTS
C     .. Function Arguments ..
      DOUBLE PRECISION  F
      EXTERNAL          F
C     .. Subroutine Arguments ..
      EXTERNAL          REGION
C     .. Scalars in Common ..
      DOUBLE PRECISION  FACT, QF, RMOD, TMAX, TOT
      INTEGER           ICOUNT, ISG
C     .. Arrays in Common ..
      DOUBLE PRECISION  YY(30)
C     .. Local Scalars ..
      DOUBLE PRECISION  G, H, H4, PI, Q, R, RM, TS, XNL
      INTEGER           I, IER, IF, IR, K, KK, LAYER, NDIM, NL, NX
C     .. Local Arrays ..
      DOUBLE PRECISION  Y(30)
      CHARACTER*1       P01REC(1)
C     .. External Functions ..
      DOUBLE PRECISION  D01FDW, S10AAF, X01AAF, X02AJF
      INTEGER           P01ABF
      EXTERNAL          D01FDW, S10AAF, X01AAF, X02AJF, P01ABF
C     .. External Subroutines ..
      EXTERNAL          D01FDZ
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, MIN, LOG, DBLE, SQRT, INT
C     .. Common blocks ..
      COMMON            /AD01FD/YY, RMOD, TMAX, TOT, QF, FACT, ISG,
     *                  ICOUNT
C     .. Executable Statements ..
      NDIM = N
      RESULT = 0.0D0
      ICOUNT = 0
      IER = 0
      IF (SIGMA.EQ.0.0D0) GO TO 320
      IER = 1
      IF (NDIM.LT.1 .OR. NDIM.GT.30) GO TO 320
      IER = 2
      IF (LIMIT.LT.100) GO TO 320
      IER = 3
      IF (R0.LE.0.0D0 .OR. R0.GE.1.0D0) GO TO 320
      IER = 4
      IF (U.LE.0.0D0) GO TO 320
      IER = 0
      TMAX = -0.5D0*LOG(0.5D0*X02AJF())
      PI = X01AAF(0.0D0)
C
C     SELECT SPHERE OR PRODUCT REGION
C
      ISG = 1
      IF (SIGMA.LT.0.0D0) ISG = 0
      K = (NDIM+1)/2
      IF ((NDIM/2)*2-NDIM) 60, 20, 60
   20 H = 1.0D0
      DO 40 I = 1, K
         H = H*DBLE(I)
   40 CONTINUE
      GO TO 100
   60 H = SQRT(PI)
      DO 80 I = 1, K
         H = H*DBLE(2*I-1)*0.5D0
   80 CONTINUE
C
C     CALCULATE APPROXIMATE NUMBER OF LAYERS TO BE USED.
C
  100 XNL = -DBLE(NDIM)/8.0D0 + (DBLE(LIMIT)*H*0.5D0)**(2.0D0/DBLE(NDIM)
     *      )/(PI*0.5D0)
      NL = 400
      IF (XNL.LE.399.0D0) NL = INT(XNL) + 1
      H4 = R0/SQRT(DBLE(NDIM)+8.0D0*DBLE(NL-1))
      H = 4.0D0*H4
      KK = INT(2.0D0*(R0-H4)/H) + 2
      Q = 1.0D0
      DO 120 I = 1, KK
         YY(I) = H4*Q*DBLE(2*I-1)
         Q = -Q
  120 CONTINUE
C
C     SELECT LAYERS
C
      DO 300 LAYER = 1, NL
         R = H4*SQRT(DBLE(NDIM)+8.0D0*DBLE(LAYER-1))
         IF (ISG.EQ.0) GO TO 180
C
C        SPHERE TRANSFORMATION
C        FACT=JACOBIAN
C
         RM = U/(1.0D0-R*R)
         TS = RM*R
         IF (ABS(TS).GE.TMAX) GO TO 300
         IF = 0
         G = S10AAF(TS,IF)
         QF = SIGMA*G/R
         FACT = RM*RM*(1.0D0+R*R)*(1.0D0-G*G)*QF**(NDIM-1)*SIGMA
         IF (LAYER.NE.1) GO TO 260
         Q = QF*YY(1)
         DO 140 I = 1, NDIM
            Y(I) = Q
  140    CONTINUE
         TOT = F(NDIM,Y)
         DO 160 I = 1, NDIM
            Y(I) = -Q
  160    CONTINUE
         TOT = (TOT+F(NDIM,Y))*FACT
         GO TO 240
C
C        PRODUCT REGION TRANSFORMATION
C
  180    RMOD = U/(1.0D0-R)
         IF (LAYER.NE.1) GO TO 260
         TS = RMOD*YY(1)
         IF (ABS(TS).GE.TMAX) GO TO 300
         IF = 0
         Q = S10AAF(TS,IF)
         FACT = RMOD*((1.0D0-Q*Q)*RMOD)**NDIM
         DO 200 I = 1, NDIM
            Y(I) = Q
  200    CONTINUE
         TOT = D01FDW(F,Y,NDIM,REGION)
         DO 220 I = 1, NDIM
            Y(I) = -Q
  220    CONTINUE
         TOT = (TOT+D01FDW(F,Y,NDIM,REGION))*FACT
  240    ICOUNT = ICOUNT + 2
         GO TO 300
  260    NX = MIN(LAYER-1,NDIM)
C
C        SELECT POINTS IN LAYER
C        IR IS NUMBER OF NON-UNIT CO-ORDINATE PARAMETERS
C
         DO 280 IR = 1, NX
            CALL D01FDZ(LAYER,IR,NDIM,F,REGION)
  280    CONTINUE
  300 CONTINUE
      RESULT = TOT/U/2.0D0*H**NDIM
  320 NPTS = ICOUNT
      IFAIL = P01ABF(IFAIL,IER,SRNAME,0,P01REC)
      RETURN
      END
