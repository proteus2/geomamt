      SUBROUTINE D01ANW(F,A,B,OMEGA,INTEGR,NRMOM,MAXP1,KSAVE,RESULT,
     *                  ABSERR,NEVAL,RESABS,RESASC,MOMCOM,CHEBMO)
C     MARK 13 RE-ISSUE. NAG COPYRIGHT 1988.
C     BASED ON QUADPACK ROUTINE  QC25O.
C     ..................................................................
C
C        PURPOSE
C           TO COMPUTE  THE  INTEGRAL
C              I = INTEGRAL OF F(X)*W(X) OVER (A,B)
C                  WHERE W(X) = COS(OMEGA*X)
C                     OR W(X) = SIN(OMEGA*X),
C           AND TO COMPUTE J = INTEGRAL OF ABS(F) OVER (A,B).
C           FOR SMALL VALUES OF OMEGA OR SMALL INTERVALS (A,B) THE
C           15-POINT GAUSS-KRONROD RULE IS USED. IN ALL OTHER CASES A
C           GENERALIZED CLENSHAW-CURTIS METHOD IS USED, I.E. A
C           TRUNCATED CHEBYSHEV EXPANSION OF THE FUNCTION F IS COMPUTED
C           ON (A,B), SO THAT THE INTEGRAND CAN BE WRITTEN AS A SUM OF
C           TERMS OF THE FORM W(X)T(K,X), WHERE T(K,X) IS THE CHEBYSHEV
C           POLYNOMIAL OF DEGREE K. THE CHEBYSHEV MOMENTS ARE COMPUTED
C           WITH USE OF A LINEAR RECURRENCE RELATION.
C
C        PARAMETERS
C         ON ENTRY
C           F      - REAL
C                    FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
C                    FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO
C                    BE DECLARED E X T E R N A L IN THE CALLING PROGRAM.
C
C           A      - REAL
C                    LOWER LIMIT OF INTEGRATION
C
C           B      - REAL
C                    UPPER LIMIT OF INTEGRATION
C
C           OMEGA  - REAL
C                    PARAMETER IN THE WEIGHT FUNCTION
C
C           INTEGR - INTEGER
C                    INDICATES WHICH WEIGHT FUNCTION IS TO BE USED
C                       INTEGR = 1   W(X) = COS(OMEGA*X)
C                       INTEGR = 2   W(X) = SIN(OMEGA*X)
C
C           NRMOM  - INTEGER
C                    THE LENGTH OF INTERVAL (A,B) IS EQUAL TO THE LENGTH
C                    OF THE ORIGINAL INTEGRATION INTERVAL DIVIDED BY
C                    2**NRMOM (WE SUPPOSE THAT THE ROUTINE IS USED IN AN
C                    ADAPTIVE INTEGRATION PROCESS, OTHERWISE SET
C                    NRMOM = 0). NRMOM MUST BE ZERO AT THE FIRST CALL.
C
C           MAXP1  - INTEGER
C                    GIVES AN UPPER BOUND ON THE NUMBER OF CHEBYSHEV
C                    MOMENTS WHICH CAN BE STORED, I.E. FOR THE INTERVALS
C                    OF LENGTHS ABS(BB-AA)*2**(-L), L = 0,1,2, ...,
C                    MAXP1-2.
C
C           KSAVE  - INTEGER
C                    KEY WHICH IS ONE WHEN THE MOMENTS FOR THE
C                    CURRENT INTERVAL HAVE BEEN COMPUTED
C
C         ON RETURN
C           RESULT - REAL
C                    APPROXIMATION TO THE INTEGRAL I
C
C           ABSERR - REAL
C                    ESTIMATE OF THE MODULUS OF THE ABSOLUTE
C                    ERROR, WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
C
C           NEVAL  - INTEGER
C                    NUMBER OF INTEGRAND EVALUATIONS
C
C           RESABS - REAL
C                    APPROXIMATION TO THE INTEGRAL J
C
C           RESASC - REAL
C                    APPROXIMATION TO THE INTEGRAL OF ABS(F-I/(B-A))
C
C         ON ENTRY AND RETURN
C           MOMCOM - INTEGER
C                    FOR EACH INTERVAL LENGTH WE NEED TO COMPUTE
C                    THE CHEBYSHEV MOMENTS. MOMCOM COUNTS THE NUMBER
C                    OF INTERVALS FOR WHICH THESE MOMENTS HAVE ALREADY
C                    BEEN COMPUTED. IF NRMOM.LT.MOMCOM OR KSAVE = 1,
C                    THE CHEBYSHEV MOMENTS FOR THE INTERVAL (A,B)
C                    HAVE ALREADY BEEN COMPUTED AND STORED, OTHERWISE
C                    WE COMPUTE THEM AND WE INCREASE MOMCOM.
C
C           CHEBMO - REAL
C                    ARRAY OF DIMENSION AT LEAST (MAXP1,25) CONTAINING
C                    THE MODIFIED CHEBYSHEV MOMENTS FOR THE FIRST MOMCOM
C                    INTERVAL LENGTHS
C
C     ..................................................................
C
C           THE DATA VALUE OF MAXP1 GIVES AN UPPER BOUND
C           ON THE NUMBER OF CHEBYSHEV MOMENTS WHICH CAN BE
C           COMPUTED, I.E. FOR THE INTERVAL (BB-AA), ...,
C           (BB-AA)/2**(MAXP1-2).
C           SHOULD THIS NUMBER BE ALTERED, THE FIRST DIMENSION OF
C           CHEBMO NEEDS TO BE ADAPTED.
C
C           THE VECTOR X CONTAINS THE VALUES COS(K*PI/24)
C           K = 1, ...,11, TO BE USED FOR THE CHEBYSHEV EXPANSION OF F
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  A, ABSERR, B, OMEGA, RESABS, RESASC, RESULT
      INTEGER           INTEGR, KSAVE, MAXP1, MOMCOM, NEVAL, NRMOM
C     .. Array Arguments ..
      DOUBLE PRECISION  CHEBMO(MAXP1,25)
C     .. Function Arguments ..
      DOUBLE PRECISION  F
      EXTERNAL          F
C     .. Local Scalars ..
      DOUBLE PRECISION  AC, AN, AN2, AS, ASAP, ASS, CENTR, CONC, CONS,
     *                  COSPAR, EPMACH, ESTC, ESTS, HLGTH, OFLOW, P2,
     *                  P3, P4, PAR2, PAR22, PARINT, RESC12, RESC24,
     *                  RESS12, RESS24, SINPAR, UFLOW
      INTEGER           I, ISYM, J, K, M, NMAC, NOEQ1, NOEQU
C     .. Local Arrays ..
      DOUBLE PRECISION  CHEB12(13), CHEB24(25), D(28), D1(28), D2(28),
     *                  D3(28), FVAL(25), V(28), X(11)
C     .. External Functions ..
      DOUBLE PRECISION  D01ANY, X02AJF, X02AMF
      EXTERNAL          D01ANY, X02AJF, X02AMF
C     .. External Subroutines ..
      EXTERNAL          D01ANX, D01APZ
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, COS, SIN
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
     *                  X(11)/0.130526192220051591548406227895489D+00/,
     *                  NMAC/28/
C     .. Executable Statements ..
C
C
C           LIST OF MAJOR VARIABLES
C           ----------------------
C           CENTR  - MID POINT OF THE INTEGRATION INTERVAL
C           HLGTH  - HALF LENGTH OF THE INTEGRATION INTERVAL
C           FVAL   - VALUE OF THE FUNCTION F AT THE POINTS
C                    (B-A)*0.5*COS(K*PI/12) + (B+A)*0.5
C                    K = 0, ...,24
C           CHEB12 - COEFFICIENTS OF THE CHEBYSHEV SERIES EXPANSION
C                    OF DEGREE 12, FOR THE FUNCTION F, IN THE
C                    INTERVAL (A,B)
C           CHEB24 - COEFFICIENTS OF THE CHEBYSHEV SERIES EXPANSION
C                    OF DEGREE 24, FOR THE FUNCTION F, IN THE
C                    INTERVAL (A,B)
C           RESC12 - APPROXIMATION TO THE INTEGRAL OF
C                    COS(0.5*(B-A)*OMEGA*X)*F(0.5*(B-A)*X+0.5*(B+A))
C                    OVER (-1,+1), USING THE CHEBYSHEV SERIES
C                    EXPANSION OF DEGREE 12
C           RESC24 - APPROXIMATION TO THE SAME INTEGRAL, USING THE
C                    CHEBYSHEV SERIES EXPANSION OF DEGREE 24
C           RESS12 - THE ANALOGUE OF RESC12 FOR THE SINE
C           RESS24 - THE ANALOGUE OF RESC24 FOR THE SINE
C
      EPMACH = X02AJF()
      UFLOW = X02AMF()
      OFLOW = 1.0D+00/UFLOW
      CENTR = 5.0D-01*(B+A)
      HLGTH = 5.0D-01*(B-A)
      PARINT = OMEGA*HLGTH
C
C           COMPUTE THE INTEGRAL USING THE 15-POINT GAUSS-KRONROD
C           FORMULA IF THE VALUE OF THE PARAMETER IN THE INTEGRAND
C           IS SMALL OR IF THE LENGTH OF THE INTEGRATION INTERVAL
C           IS LESS THAN (BB-AA)/2**(MAXP1-2), WHERE (AA,BB) IS THE
C           ORIGINAL INTEGRATION INTERVAL
C
      IF (ABS(PARINT).GT.2.0D+00) GO TO 20
      CALL D01APZ(F,D01ANY,OMEGA,P2,P3,P4,INTEGR,A,B,RESULT,ABSERR,
     *            RESABS,RESASC)
      NEVAL = 15
      GO TO 380
C
C           COMPUTE THE INTEGRAL USING THE GENERALIZED CLENSHAW-
C           CURTIS METHOD
C
   20 CONC = HLGTH*COS(CENTR*OMEGA)
      CONS = HLGTH*SIN(CENTR*OMEGA)
      RESASC = OFLOW
      NEVAL = 25
C
C           CHECK WHETHER THE CHEBYSHEV MOMENTS FOR THIS INTERVAL
C           HAVE ALREADY BEEN COMPUTED
C
      IF (NRMOM.LT.MOMCOM .OR. KSAVE.EQ.1) GO TO 280
C
C           COMPUTE A NEW SET OF CHEBYSHEV MOMENTS
C
      M = MOMCOM + 1
      PAR2 = PARINT*PARINT
      PAR22 = PAR2 + 2.0D+00
      SINPAR = SIN(PARINT)
      COSPAR = COS(PARINT)
C
C           COMPUTE THE CHEBYSHEV MOMENTS WITH RESPECT TO COSINE
C
      V(1) = 2.0D+00*SINPAR/PARINT
      V(2) = (8.0D+00*COSPAR+(PAR2+PAR2-8.0D+00)*SINPAR/PARINT)/PAR2
      V(3) = (3.2D+01*(PAR2-1.2D+01)*COSPAR+(2.0D+00*((PAR2-8.0D+01)
     *       *PAR2+1.92D+02)*SINPAR)/PARINT)/(PAR2*PAR2)
      AC = 8.0D+00*COSPAR
      AS = 2.4D+01*PARINT*SINPAR
      IF (ABS(PARINT).GT.2.4D+01) GO TO 140
C
C           COMPUTE THE CHEBYSHEV MOMENTS AS THE
C           SOLUTIONS OF A BOUNDARY VALUE PROBLEM WITH 1
C           INITIAL VALUE (V(3)) AND 1 END VALUE (COMPUTED
C           USING AN ASYMPTOTIC FORMULA)
C
      NOEQU = NMAC - 3
      NOEQ1 = NOEQU - 1
      AN = 6.0D+00
      DO 40 K = 1, NOEQ1
         AN2 = AN*AN
         D(K) = -2.0D+00*(AN2-4.0D+00)*(PAR22-AN2-AN2)
         D2(K) = (AN-1.0D+00)*(AN-2.0D+00)*PAR2
         D1(K) = (AN+3.0D+00)*(AN+4.0D+00)*PAR2
         V(K+3) = AS - (AN2-4.0D+00)*AC
         AN = AN + 2.0D+00
   40 CONTINUE
      AN2 = AN*AN
      D(NOEQU) = -2.0D+00*(AN2-4.0D+00)*(PAR22-AN2-AN2)
      V(NOEQU+3) = AS - (AN2-4.0D+00)*AC
      V(4) = V(4) - 5.6D+01*PAR2*V(3)
      ASS = PARINT*SINPAR
      ASAP = (((((2.10D+02*PAR2-1.0D+00)*COSPAR-(1.05D+02*PAR2-6.3D+01)
     *       *ASS)/AN2-(1.0D+00-1.5D+01*PAR2)*COSPAR+1.5D+01*ASS)
     *       /AN2-COSPAR+3.0D+00*ASS)/AN2-COSPAR)/AN2
      V(NOEQU+3) = V(NOEQU+3) - 2.0D+00*ASAP*PAR2*(AN-1.0D+00)
     *             *(AN-2.0D+00)
C
C           SOLVE THE TRIDIAGONAL SYSTEM BY MEANS OF GAUSSIAN
C           ELIMINATION WITH PARTIAL PIVOTING
C
      DO 60 I = 1, NOEQU
         D3(I) = 0.0D+00
   60 CONTINUE
      D2(NOEQU) = 0.0D+00
      DO 100 I = 1, NOEQ1
         IF (ABS(D1(I)).LE.ABS(D(I))) GO TO 80
         AN = D1(I)
         D1(I) = D(I)
         D(I) = AN
         AN = D2(I)
         D2(I) = D(I+1)
         D(I+1) = AN
         D3(I) = D2(I+1)
         D2(I+1) = 0.0D+00
         AN = V(I+4)
         V(I+4) = V(I+3)
         V(I+3) = AN
   80    D(I+1) = D(I+1) - D2(I)*D1(I)/D(I)
         D2(I+1) = D2(I+1) - D3(I)*D1(I)/D(I)
         V(I+4) = V(I+4) - V(I+3)*D1(I)/D(I)
  100 CONTINUE
      V(NOEQU+3) = V(NOEQU+3)/D(NOEQU)
      V(NOEQU+2) = (V(NOEQU+2)-D2(NOEQ1)*V(NOEQU+3))/D(NOEQ1)
      DO 120 I = 2, NOEQ1
         K = NOEQU - I
         V(K+3) = (V(K+3)-D3(K)*V(K+5)-D2(K)*V(K+4))/D(K)
  120 CONTINUE
      GO TO 180
C
C           COMPUTE THE CHEBYSHEV MOMENTS BY MEANS OF FORWARD
C           RECURSION
C
  140 AN = 4.0D+00
      DO 160 I = 4, 13
         AN2 = AN*AN
         V(I) = ((AN2-4.0D+00)*(2.0D+00*(PAR22-AN2-AN2)*V(I-1)-AC)
     *          +AS-PAR2*(AN+1.0D+00)*(AN+2.0D+00)*V(I-2))
     *          /(PAR2*(AN-1.0D+00)*(AN-2.0D+00))
         AN = AN + 2.0D+00
  160 CONTINUE
  180 DO 200 J = 1, 13
         CHEBMO(M,2*J-1) = V(J)
  200 CONTINUE
C
C           COMPUTE THE CHEBYSHEV MOMENTS WITH RESPECT TO SINE
C
      V(1) = 2.0D+00*(SINPAR-PARINT*COSPAR)/PAR2
      V(2) = (1.8D+01-4.8D+01/PAR2)*SINPAR/PAR2 +
     *       (-2.0D+00+4.8D+01/PAR2)*COSPAR/PARINT
      AC = -2.4D+01*PARINT*COSPAR
      AS = -8.0D+00*SINPAR
      CHEBMO(M,2) = V(1)
      CHEBMO(M,4) = V(2)
      IF (ABS(PARINT).GT.2.4D+01) GO TO 240
      DO 220 K = 3, 12
         AN = K
         CHEBMO(M,2*K) = -SINPAR/(AN*(2.0D+00*AN-2.0D+00)) -
     *                   2.5D-01*PARINT*(V(K+1)/AN-V(K)/(AN-1.0D+00))
  220 CONTINUE
      GO TO 280
C
C           COMPUTE THE CHEBYSHEV MOMENTS BY MEANS OF
C           FORWARD RECURSION
C
  240 AN = 3.0D+00
      DO 260 I = 3, 12
         AN2 = AN*AN
         V(I) = ((AN2-4.0D+00)*(2.0D+00*(PAR22-AN2-AN2)*V(I-1)+AS)
     *          +AC-PAR2*(AN+1.0D+00)*(AN+2.0D+00)*V(I-2))
     *          /(PAR2*(AN-1.0D+00)*(AN-2.0D+00))
         AN = AN + 2.0D+00
         CHEBMO(M,2*I) = V(I)
  260 CONTINUE
  280 IF (NRMOM.LT.MOMCOM) M = NRMOM + 1
      IF (MOMCOM.LT.(MAXP1-1) .AND. NRMOM.GE.MOMCOM) MOMCOM = MOMCOM + 1
C
C           COMPUTE THE COEFFICIENTS OF THE CHEBYSHEV EXPANSIONS
C           OF DEGREES 12 AND 24 OF THE FUNCTION F
C
      FVAL(1) = 5.0D-01*F(CENTR+HLGTH)
      FVAL(13) = F(CENTR)
      FVAL(25) = 5.0D-01*F(CENTR-HLGTH)
      DO 300 I = 2, 12
         ISYM = 26 - I
         FVAL(I) = F(HLGTH*X(I-1)+CENTR)
         FVAL(ISYM) = F(CENTR-HLGTH*X(I-1))
  300 CONTINUE
      CALL D01ANX(X,FVAL,CHEB12,CHEB24)
C
C           COMPUTE THE INTEGRAL AND ERROR ESTIMATES
C
      RESC12 = CHEB12(13)*CHEBMO(M,13)
      RESS12 = 0.0D+00
      ESTC = ABS(CHEB24(25)*CHEBMO(M,25)) + ABS((CHEB12(13)-CHEB24(13))
     *       *CHEBMO(M,13))
      ESTS = 0.0D+00
      K = 11
      DO 320 J = 1, 6
         RESC12 = RESC12 + CHEB12(K)*CHEBMO(M,K)
         RESS12 = RESS12 + CHEB12(K+1)*CHEBMO(M,K+1)
         ESTC = ESTC + ABS((CHEB12(K)-CHEB24(K))*CHEBMO(M,K))
         ESTS = ESTS + ABS((CHEB12(K+1)-CHEB24(K+1))*CHEBMO(M,K+1))
         K = K - 2
  320 CONTINUE
      RESC24 = CHEB24(25)*CHEBMO(M,25)
      RESS24 = 0.0D+00
      RESABS = ABS(CHEB24(25))
      K = 23
      DO 340 J = 1, 12
         RESC24 = RESC24 + CHEB24(K)*CHEBMO(M,K)
         RESS24 = RESS24 + CHEB24(K+1)*CHEBMO(M,K+1)
         RESABS = RESABS + ABS(CHEB24(K)) + ABS(CHEB24(K+1))
         IF (J.LE.5) ESTC = ESTC + ABS(CHEB24(K)*CHEBMO(M,K))
         IF (J.LE.5) ESTS = ESTS + ABS(CHEB24(K+1)*CHEBMO(M,K+1))
         K = K - 2
  340 CONTINUE
      RESABS = RESABS*ABS(HLGTH)
      IF (INTEGR.EQ.2) GO TO 360
      RESULT = CONC*RESC24 - CONS*RESS24
      ABSERR = ABS(CONC*ESTC) + ABS(CONS*ESTS)
      GO TO 380
  360 RESULT = CONC*RESS24 + CONS*RESC24
      ABSERR = ABS(CONC*ESTS) + ABS(CONS*ESTC)
  380 RETURN
      END
