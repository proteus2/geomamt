      SUBROUTINE C06ECS(X0,Y0,PTS,X1,Y1,M1,X2,Y2,M2,X3,Y3,M3,X4,Y4,M4,M)
C     MARK 8 RELEASE. NAG COPYRIGHT 1979.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     RADIX FIVE COMPLEX FOURIER TRANSFORM KERNEL
C     .. Scalar Arguments ..
      INTEGER           M, M1, M2, M3, M4, PTS
C     .. Array Arguments ..
      DOUBLE PRECISION  X0(PTS), X1(M1), X2(M2), X3(M3), X4(M4),
     *                  Y0(PTS), Y1(M1), Y2(M2), Y3(M3), Y4(M4)
C     .. Local Scalars ..
      DOUBLE PRECISION  A1, A2, ANGLE, AS, AU, B1, B2, C1, C2, C3, C4,
     *                  I0, I1, I2, I3, I4, IA1, IA2, IAS, IAU, IB1,
     *                  IB2, IS1, IS2, ISS, IU1, IU2, R0, R1, R2, R3,
     *                  R4, RA1, RA2, RAS, RAU, RB1, RB2, RS1, RS2, RSS,
     *                  RU1, RU2, S1, S2, S3, S4, T, TWOPI
      INTEGER           J, K, K0, M5, MOVER2
      LOGICAL           FOLD, ZERO
C     .. External Functions ..
      DOUBLE PRECISION  X01AAF
      EXTERNAL          X01AAF
C     .. Intrinsic Functions ..
      INTRINSIC         COS, DBLE, SIN, SQRT
C     .. Executable Statements ..
      M5 = M*5
      MOVER2 = M/2 + 1
      TWOPI = 2.0D0*X01AAF(0.0D0)
      A1 = COS(TWOPI/5.0D0)
      B1 = SIN(TWOPI/5.0D0)
      A2 = COS(2.0D0*TWOPI/5.0D0)
      B2 = SIN(2.0D0*TWOPI/5.0D0)
      AS = -1.0D0/4.0D0
      AU = SQRT(5.0D0)/4.0D0
C
      DO 120 J = 1, MOVER2
         FOLD = J .GT. 1 .AND. 2*J .LT. M + 2
         K0 = J
         ANGLE = TWOPI*DBLE(J-1)/DBLE(M5)
         ZERO = ANGLE .EQ. 0.0D0
         C1 = COS(ANGLE)
         S1 = SIN(ANGLE)
         C2 = C1*C1 - S1*S1
         S2 = S1*C1 + C1*S1
         C3 = C2*C1 - S2*S1
         S3 = S2*C1 + C2*S1
         C4 = C2*C2 - S2*S2
         S4 = S2*C2 + C2*S2
         GO TO 40
   20    CONTINUE
         FOLD = .FALSE.
         K0 = M + 2 - J
         T = C1*A1 + S1*B1
         S1 = C1*B1 - S1*A1
         C1 = T
         T = C2*A2 + S2*B2
         S2 = C2*B2 - S2*A2
         C2 = T
         T = C3*A2 - S3*B2
         S3 = -C3*B2 - S3*A2
         C3 = T
         T = C4*A1 - S4*B1
         S4 = -C4*B1 - S4*A1
         C4 = T
   40    CONTINUE
C
         DO 100 K = K0, PTS, M5
            R0 = X0(K)
            I0 = Y0(K)
            RS1 = X1(K) + X4(K)
            IS1 = Y1(K) + Y4(K)
            RU1 = X1(K) - X4(K)
            IU1 = Y1(K) - Y4(K)
            RS2 = X2(K) + X3(K)
            IS2 = Y2(K) + Y3(K)
            RU2 = X2(K) - X3(K)
            IU2 = Y2(K) - Y3(K)
            RSS = RS1 + RS2
            ISS = IS1 + IS2
            RAS = R0 + RSS*AS
            IAS = I0 + ISS*AS
            RAU = (RS1-RS2)*AU
            IAU = (IS1-IS2)*AU
            RA1 = RAS + RAU
            IA1 = IAS + IAU
            RA2 = RAS - RAU
            IA2 = IAS - IAU
            RB1 = RU1*B1 + RU2*B2
            IB1 = IU1*B1 + IU2*B2
            RB2 = RU1*B2 - RU2*B1
            IB2 = IU1*B2 - IU2*B1
            X0(K) = R0 + RSS
            Y0(K) = I0 + ISS
            IF (ZERO) GO TO 60
            R1 = RA1 + IB1
            I1 = IA1 - RB1
            R2 = RA2 + IB2
            I2 = IA2 - RB2
            R3 = RA2 - IB2
            I3 = IA2 + RB2
            R4 = RA1 - IB1
            I4 = IA1 + RB1
            X1(K) = R1*C1 + I1*S1
            Y1(K) = I1*C1 - R1*S1
            X2(K) = R2*C2 + I2*S2
            Y2(K) = I2*C2 - R2*S2
            X3(K) = R3*C3 + I3*S3
            Y3(K) = I3*C3 - R3*S3
            X4(K) = R4*C4 + I4*S4
            Y4(K) = I4*C4 - R4*S4
            GO TO 80
   60       CONTINUE
            X1(K) = RA1 + IB1
            Y1(K) = IA1 - RB1
            X2(K) = RA2 + IB2
            Y2(K) = IA2 - RB2
            X3(K) = RA2 - IB2
            Y3(K) = IA2 + RB2
            X4(K) = RA1 - IB1
            Y4(K) = IA1 + RB1
   80       CONTINUE
  100    CONTINUE
         IF (FOLD) GO TO 20
  120 CONTINUE
C
      RETURN
      END
