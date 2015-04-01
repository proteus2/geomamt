      SUBROUTINE D01AQY(F,A,B,C,RESULT,ABSERR,KRUL,NEVAL)
C     MARK 13 RE-ISSUE. NAG COPYRIGHT 1988.
C     BASED ON QUADPACK ROUTINE  QC25C.
C     ..................................................................
C
C        PURPOSE
C           TO COMPUTE I = INTEGRAL OF F*W OVER (A,B) WITH ERROR
C           ESTIMATE, WHERE W(X) = 1/(X-C)
C
C        PARAMETERS
C           F      - REAL
C                    FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
C                    F(X). THE ACTUAL NAME FOR F NEEDS TO BE DECLARED
C                    E X T E R N A L  IN THE DRIVER PROGRAM.
C
C           A      - REAL
C                    LEFT END POINT OF THE INTEGRATION INTERVAL
C
C           B      - REAL
C                    RIGHT END POINT OF THE INTEGRATION INTERVAL,
C                    B.GT.A
C
C           C      - REAL
C                    PARAMETER IN THE WEIGHT FUNCTION
C
C           RESULT - REAL
C                    APPROXIMATION TO THE INTEGRAL
C                    RESULT IS COMPUTED BY USING A GENERALIZED
C                    CLENSHAW-CURTIS METHOD IF C LIES WITHIN TEN PERCENT
C                    OF THE INTEGRATION INTERVAL. IN THE OTHER CASE THE
C                    15-POINT KRONROD RULE OBTAINED BY OPTIMAL ADDITION
C                    OF ABSCISSAE TO THE 7-POINT GAUSS RULE, IS APPLIED.
C
C           ABSERR - REAL
C                    ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
C                    WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
C
C           KRUL   - INTEGER
C                    KEY WHICH IS DECREASED BY 1 IF THE 15-POINT
C                    GAUSS-KRONROD SCHEME HAS BEEN USED
C
C           NEVAL  - INTEGER
C                    NUMBER OF INTEGRAND EVALUATIONS
C
C     ..................................................................
C
C           THE VECTOR X CONTAINS THE VALUES COS(K*PI/24),
C           K = 1, ..., 11, TO BE USED FOR THE CHEBYSHEV SERIES
C           EXPANSION OF F
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  A, ABSERR, B, C, RESULT
      INTEGER           KRUL, NEVAL
C     .. Function Arguments ..
      DOUBLE PRECISION  F
      EXTERNAL          F
C     .. Local Scalars ..
      DOUBLE PRECISION  AK22, AMOM0, AMOM1, AMOM2, CC, CENTR, HLGTH, P2,
     *                  P3, P4, RES12, RES24, RESABS, RESASC, U
      INTEGER           I, ISYM, K, KP
C     .. Local Arrays ..
      DOUBLE PRECISION  CHEB12(13), CHEB24(25), FVAL(25), X(11)
C     .. External Functions ..
      DOUBLE PRECISION  D01AQZ
      EXTERNAL          D01AQZ
C     .. External Subroutines ..
      EXTERNAL          D01ANX, D01APZ
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, LOG
C     .. Data statements ..
      DATA              X(1)/0.991444861373810411144557526928563D+00/,
     *                  X(2)/0.965925826289068286749743199728897D+00/,
     *                  X(3)/0.923879532511286756128183189396788D+00/,
     *                  X(4)/0.866025403784438646763723170752936D+00/,
     *                  X(5)/0.793353340291235164579776961501299D+00/,
     *                  X(6)/0.707106781186547524400844362104849D+00/,
     *                  X(7)/0.608761429008720639416097542898164D+00/,
     *                  X(8)/0.500000000000000000000000000000000D+00/,
     *                  X(9)/0.382683432365089771728459984030399D+00/,
     *                  X(10)/0.258819045102520762348898837624048D+00/,
     *                  X(11)/0.130526192220051591548406227895489D+00/
C     .. Executable Statements ..
C
C
C           LIST OF MAJOR VARIABLES
C           ----------------------
C           FVAL   - VALUE OF THE FUNCTION F AT THE POINTS
C                    COS(K*PI/24),  K = 0, ..., 24
C           CHEB12 - CHEBYSHEV SERIES EXPANSION COEFFICIENTS, FOR THE
C                    FUNCTION F, OF DEGREE 12
C           CHEB24 - CHEBYSHEV SERIES EXPANSION COEFFICIENTS, FOR THE
C                    FUNCTION F, OF DEGREE 24
C           RES12  - APPROXIMATION TO THE INTEGRAL CORRESPONDING TO THE
C                    USE OF CHEB12
C           RES24  - APPROXIMATION TO THE INTEGRAL CORRESPONDING TO THE
C                    USE OF CHEB24
C           D01AQZ  - EXTERNAL FUNCTION SUBPROGRAM DEFINING THE WEIGHT
C                    FUNCTION
C           HLGTH  - HALF-LENGTH OF THE INTERVAL
C           CENTR  - MID POINT OF THE INTERVAL
C
      CC = (2.0D+00*C-B-A)/(B-A)
      IF (ABS(CC).LT.1.1D+00) GO TO 20
C
C           APPLY THE 15-POINT GAUSS-KRONROD SCHEME.
C
      KRUL = KRUL - 1
      CALL D01APZ(F,D01AQZ,C,P2,P3,P4,KP,A,B,RESULT,ABSERR,RESABS,
     *            RESASC)
      NEVAL = 15
      IF (RESASC.EQ.ABSERR) KRUL = KRUL + 1
      GO TO 100
C
C           USE THE GENERALIZED CLENSHAW-CURTIS METHOD.
C
   20 HLGTH = 5.0D-01*(B-A)
      CENTR = 5.0D-01*(B+A)
      NEVAL = 25
      FVAL(1) = 5.0D-01*F(HLGTH+CENTR)
      FVAL(13) = F(CENTR)
      FVAL(25) = 5.0D-01*F(CENTR-HLGTH)
      DO 40 I = 2, 12
         U = HLGTH*X(I-1)
         ISYM = 26 - I
         FVAL(I) = F(U+CENTR)
         FVAL(ISYM) = F(CENTR-U)
   40 CONTINUE
C
C           COMPUTE THE CHEBYSHEV SERIES EXPANSION.
C
      CALL D01ANX(X,FVAL,CHEB12,CHEB24)
C
C           THE MODIFIED CHEBYSHEV MOMENTS ARE COMPUTED BY FORWARD
C           RECURSION, USING AMOM0 AND AMOM1 AS STARTING VALUES.
C
      AMOM0 = LOG(ABS((1.0D+00-CC)/(1.0D+00+CC)))
      AMOM1 = 2.0D+00 + CC*AMOM0
      RES12 = CHEB12(1)*AMOM0 + CHEB12(2)*AMOM1
      RES24 = CHEB24(1)*AMOM0 + CHEB24(2)*AMOM1
      DO 60 K = 3, 13
         AMOM2 = 2.0D+00*CC*AMOM1 - AMOM0
         AK22 = (K-2)*(K-2)
         IF ((K/2)*2.EQ.K) AMOM2 = AMOM2 - 4.0D+00/(AK22-1.0D+00)
         RES12 = RES12 + CHEB12(K)*AMOM2
         RES24 = RES24 + CHEB24(K)*AMOM2
         AMOM0 = AMOM1
         AMOM1 = AMOM2
   60 CONTINUE
      DO 80 K = 14, 25
         AMOM2 = 2.0D+00*CC*AMOM1 - AMOM0
         AK22 = (K-2)*(K-2)
         IF ((K/2)*2.EQ.K) AMOM2 = AMOM2 - 4.0D+00/(AK22-1.0D+00)
         RES24 = RES24 + CHEB24(K)*AMOM2
         AMOM0 = AMOM1
         AMOM1 = AMOM2
   80 CONTINUE
      RESULT = RES24
      ABSERR = ABS(RES24-RES12)
  100 RETURN
      END
