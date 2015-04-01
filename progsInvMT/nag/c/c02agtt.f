      SUBROUTINE C02AGT(A0,B0,C0,ZSM,ZLG)
C     MARK 13 RELEASE. NAG COPYRIGHT 1988.
C     BASED ON THE ROUTINE  QDRTC, WRITTEN BY BRIAN T. SMITH
C
C     THIS SUBROUTINE DETERMINES THE ROOTS OF THE QUADRATIC EQUATION
C
C         A0*X**2 + B0*X + C0
C
C     WHERE A0, B0, AND C0 ARE REAL COEFFICIENTS, AND ZSM AND ZLG
C     THE SMALLEST AND LARGEST ROOT IN MAGNITUDE, RESPECTIVELY.
C
C     THE ROOTS ARE COMPUTED TO WITHIN A RELATIVE ERROR OF A FEW
C     UNITS IN THE LAST PLACE (DEPENDING ON THE ACCURACY OF THE
C     BASIC ARITHMETIC OPERATIONS) EXCEPT WHEN UNDERFLOW OR OVERFLOW
C     OCCURS IN WHICH CASE THE TRUE ROOTS ARE WITHIN A FEW UNITS IN
C     THE LAST PLACE OF THE UNDERFLOW OR OVERFLOW THRESHOLD.
C
C     IF THE LEADING COEFFICIENT IS ZERO, THE LARGER ROOT IS
C     SET TO THE LARGEST MACHINE REPRESENTABLE NUMBER AND THE
C     OVERFLOW FLAG OVFLOW IS SET TRUE.  IF ALL THREE COEFFICIENTS ARE
C     ZERO, THE OVERFLOW FLAG IS SET, BOTH ROOTS ARE SET TO THE LARGEST
C     REPRESENTABLE NUMBER, BUT NO DIVIDE CHECK IS CREATED.
C
C     THIS PROGRAM IS DESIGNED TO TAKE ADVANTAGE OF SYSTEMS THAT REPORT
C     OVERFLOW AND UNDERFLOW CONDITIONS IN AN EFFICIENT WAY.  THAT IS,
C     IF, WHENEVER AN OVERFLOW OR UNDERFLOW OCCURS, CERTAIN FLAGS ARE
C     SET (THAT IS, THE LOGICAL VARIABLES OVFLOW AND UNFLOW IN THE
C     COMMON BLOCK AC02AG), C02AGT CAN USE THESE INDICATORS TO INDICATE
C     THAT THE ROOTS OVERFLOW OR UNDERFLOW AND CANNOT BE REPRESENTED.
C
C     HOWEVER, AS IMPLEMENTED IN THE NAG LIBRARY, THE ROUTINE SIMPLY
C     ASSUMES THAT THE MACHINE TERMINATES ON OVERFLOW AND IGNORES
C     UNDERFLOW.
C
C     C02AGX -- DETERMINE THE EXPONENT OF A NUMBER IN TERMS OF THE
C               MODEL.
C     C02AGR -- FORM A NUMBER WITH A GIVEN MANTISSA AND EXPONENT
C               PRECISION.
C
C     .. Parameters ..
      DOUBLE PRECISION  HALF, ONE, ZERO
      PARAMETER         (HALF=0.5D0,ONE=1.0D0,ZERO=0.0D0)
C     .. Scalar Arguments ..
      DOUBLE PRECISION  A0, B0, C0
C     .. Array Arguments ..
      DOUBLE PRECISION  ZLG(2), ZSM(2)
C     .. Scalars in Common ..
      DOUBLE PRECISION  DEPS, FINITY, SQRTFY, SQRTTY, TINY
      INTEGER           EMAXM1, EMINM1, EXPDEP, LRGEXP
      LOGICAL           OVFLOW, UNFLOW
C     .. Local Scalars ..
      DOUBLE PRECISION  A, B, C, D, SC, SQRTD
      INTEGER           EXPBSQ, SCLEXP
C     .. External Functions ..
      DOUBLE PRECISION  C02AGR
      INTEGER           C02AGX
      EXTERNAL          C02AGR, C02AGX
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, MAX, MIN, SIGN, SQRT
C     .. Common blocks ..
      COMMON            /AC02AG/OVFLOW, UNFLOW
      COMMON            /BC02AG/FINITY, SQRTFY, SQRTTY, TINY, DEPS,
     *                  EMINM1, EMAXM1, EXPDEP, LRGEXP
C     .. Save statement ..
      SAVE              /AC02AG/, /BC02AG/
C     .. Executable Statements ..
C
C     INITIALIZE LOCAL VARIABLES WITH THE INPUT COEFFICIENTS.
C
      A = A0
      B = -B0
      C = C0
C
C     CHECK FOR  A = ZERO  OR  C = ZERO.
C
      IF (A.NE.ZERO) THEN
         IF (C.NE.ZERO) THEN
C
C           AT THIS POINT, A AND C ARE NON-ZERO.
C
C           SCALE THE COEFFICIENTS SO THAT THE PRODUCT A * C IS NEAR
C           1.0D0 IN MAGNITUDE.  THIS AVOIDS SPURIOUS UNDERFLOW/OVERFLOW
C           CONDITIONS WHEN THE TRUE RESULTS ARE WITHIN RANGE.
C
C           THE SCALE FACTOR IS A POWER OF THE BASE NEAR TO
C           SQRT(ABS(A*C)).  THIS CHOICE AVOIDS UNNECESSARY ROUNDING
C           ERRORS BUT IS EXPENSIVE TO COMPUTE WHEN FLOATING POINT
C           MANIPULATIVE FUNCTIONS ARE NOT AVAILABLE IN MACHINE CODE.
C
            SCLEXP = (C02AGX(A)+C02AGX(C))/2
C
C           THE SCALE FACTOR IS  BASE ** SCLEXP.  IF A AND C ARE SCALED
C           USING THIS SCALE FACTOR AS A DIVIDEND, THEN THE
C           THE SCALED PRODUCT A'*C' IS BETWEEN BASE**(-2) AND
C           BASE IN MAGNITUDE, WHERE BASE IS THE BASE FOR MODEL NUMBERS
C           OF THE TYPE OF A.
C
C           BUT BEFORE PERFORMING THE SCALING, CHECK TO SEE IF IT IS
C           NECESSARY -- THAT IS, IF B IS SO LARGE IN MAGNITUDE THAT
C           B**2 EXCEEDS ABS(4*A*C) BY MORE THAN THE RELATIVE MACHINE
C           PRECISION FOR THE DOUBLE PRECISION DATA TYPE,
C           THE DISCRIMINANT IS IN EFFECT B AND NO SCALING IS REQUIRED.
C           HOWEVER, IF B IS SO SMALL IN MAGNITUDE THAT ABS(4*A*C)
C           EXCEEDS B**2 IN MAGNITUDE BY MORE THAN THIS SAME RELATIVE
C           MACHINE PRECISION, B IS IN EFFECT ZERO, BUT A AND C ARE
C           STILL SCALED TO AVOID SPURIOUS UNDERFLOWS/OVERFLOWS.
C
C           COMPUTE THE EXPONENT OF THE SQUARE OF THE SCALED B.
C
            IF (ABS(B).NE.ZERO) THEN
               EXPBSQ = 2*(C02AGX(B)-SCLEXP)
            ELSE
               EXPBSQ = -2*EXPDEP
            END IF
C
C           CHECK IF B**2 IS TOO BIG.
C
            IF (EXPBSQ.LE.EXPDEP) THEN
C
C              B**2 IS NOT TOO BIG.  SCALING WILL BE PERFORMED.
C
C              A AND C SHOULD BE SCALED USING THE USUAL SCALE
C              MANIPULATION FUNCTION BUT FOR EFFICIENCY, THE
C              SCALING IS PERFORMED BY DIVISION.
C
               SCLEXP = MIN(SCLEXP+1,EMAXM1)
               SCLEXP = MAX(SCLEXP,EMINM1)
               SC = C02AGR(ONE,SCLEXP)
C
C              CHECK IF IT IS TOO SMALL.
C
               IF (EXPBSQ.LT.-EXPDEP) THEN
C
C                 B IS TOO SMALL.  SET IT TO ZERO.
C
                  B = ZERO
               ELSE
C
C                 B IS NEITHER TOO LARGE NOR TOO SMALL.  SCALE IT.
C
                  B = (B/SC)*HALF
               END IF
               A = A/SC
               C = C/SC
               D = B*B - A*C
               SQRTD = SQRT(ABS(D))
               IF (D.LE.ZERO) THEN
C
C                 THE ROOTS ARE COMPLEX.
C
                  ZLG(1) = B/A
                  ZLG(2) = ABS(SQRTD/A)
                  ZSM(1) = ZLG(1)
                  ZSM(2) = -ZLG(2)
               ELSE
C
C                 THE ROOTS ARE REAL AND SQRTD IS NOT ZERO.
C
                  B = SIGN(SQRTD,B) + B
                  ZSM(1) = C/B
                  ZSM(2) = ZERO
                  ZLG(1) = B/A
                  ZLG(2) = ZERO
C
C                 BECAUSE OF ROUNDING ERRORS IN THE SQUARE ROOT AND
C                 DIVISIONS ABOVE (PARTICULARLY ON MACHINES THAT
C                 TRUNCATE AND ONLY WHEN B IS SMALL), THE REAL ROOTS MAY
C                 BE IMPROPERLY ORDERED -- SET THEM SO THAT THE SMALLER
C                 ONE IS OPPOSITE IN SIGN TO THE LARGER ONE.
C
                  IF (ABS(ZLG(1)).LT.ABS(ZSM(1))) THEN
                     ZSM(1) = -ZLG(1)
                     ZSM(2) = -ZLG(2)
                  END IF
               END IF
            ELSE
C
C              AT THIS POINT, B IS VERY LARGE; IN THIS CASE, THE
C              COEFFICIENTS NEED NOT BE SCALED AS THE DISCRIMINANT
C              IS ESSENTIALLY B.
C
               ZSM(1) = C/B
               ZSM(2) = ZERO
               ZLG(1) = B/A
               ZLG(2) = ZERO
C
C              BECAUSE OF ROUNDING ERRORS IN THE SQUARE ROOT AND
C              DIVISIONS ABOVE (PARTICULARLY ON MACHINES THAT TRUNCATE
C              AND ONLY WHEN B IS SMALL), THE REAL ROOTS MAY BE
C              IMPROPERLY ORDERED -- SET THEM SO THAT THE SMALLER ONE
C              IS OPPOSITE IN SIGN TO THE LARGER ONE.
C
               IF (ABS(ZLG(1)).LT.ABS(ZSM(1))) THEN
                  ZSM(1) = -ZLG(1)
                  ZSM(2) = -ZLG(2)
               END IF
            END IF
         ELSE
C
C           C IS ZERO, BUT A IS NOT.
C
            ZSM(1) = ZERO
            ZSM(2) = ZERO
            ZLG(1) = B/A
            ZLG(2) = ZERO
         END IF
      ELSE
C
C        A IS ZERO.  INDICATE THAT AT LEAST ONE ROOT HAS OVERFLOWED.
C
         OVFLOW = .TRUE.
         ZLG(1) = FINITY
         ZLG(2) = ZERO
         IF (B.EQ.ZERO .AND. C.NE.ZERO) THEN
C
C           A AND B ARE ZERO, BUT C IS NOT.  SET THE ROOTS TO INFINITY
C           BUT OF OPPOSITE SIGN TO INDICATE THIS.
C
            ZSM(1) = -ZLG(1)
            ZSM(2) = -ZLG(2)
         ELSE
            IF (B.EQ.ZERO) THEN
C
C              ALL COEFFICIENTS ARE ZERO.  SET BOTH ROOTS TO + INFINITY.
C
               ZSM(1) = ZLG(1)
               ZSM(2) = ZLG(2)
            ELSE
C
C              A IS ZERO, BUT B IS NOT.  COMPUTE THE SMALLER ROOT.
C
               ZSM(1) = C/B
               ZSM(2) = ZERO
            END IF
         END IF
      END IF
      RETURN
      END
