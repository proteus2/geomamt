      SUBROUTINE X03ABY(A,ISIZEA,B,ISIZEB,N,ISTEPA,ISTEPB,CX,DX)
C     MARK 10 RELEASE. NAG COPYRIGHT 1982
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     DOUBLE PRECISION COMPLEX BASE VERSION
C
C     PERFORMS QUADRUPLE PRECISION COMPUTATION FOR X03ABF
C
C     **************************************************************
C     THIS FORTRAN CODE WILL NOT WORK ON ALL MACHINES. IT IS
C     PRESUMED TO WORK IF THE MACHINE SATISFIES ONE OF THE FOLLOWING
C     ASSUMPTIONS.
C
C     A.) THERE ARE AN EVEN NUMBER OF B-ARY DIGITS IN THE MANTISSA
C     -   OF A DOUBLE PRECISION NUMBER (WHERE B IS THE BASE FOR THE
C     -   REPRESENTATION OF FLOATING-POINT NUMBERS), AND THE
C     -   COMPUTED RESULT OF A DOUBLE PRECISION ADDITION,
C     -   SUBTRACTION OR MULTIPLICATION IS EITHER CORRECTLY ROUNDED
C     -   OR CORRECTLY CHOPPED.
C
C     B.) FLOATING-POINT NUMBERS ARE REPRESENTED TO THE BASE 2 (WITH
C     -   ANY NUMBER OF BITS IN THE MANTISSA OF A DOUBLE PRECISION
C     -   NUMBER), AND THE COMPUTED RESULT OF A DOUBLE PRECISION
C     -   ADDITION, SUBTRACTION OR MULTIPLICATION IS CORRECTLY
C     -   ROUNDED.
C
C     REFERENCES-
C
C     T.J. DEKKER  A FLOATING-POINT TECHNIQUE FOR EXTENDING THE
C     AVAILABLE PRECISION. NUMER. MATH. 18, 224-242 (1971)
C
C     S. LINNAINMAA  SOFTWARE FOR DOUBLED-PRECISION FLOATING-POINT
C     COMPUTATIONS. ACM TRANS. MATH. SOFTWARE 7, 272-283 (1981)
C
C     IF THE ABOVE ASSUMPTIONS ARE NOT SATISFIED, THIS ROUTINE MUST
C     BE IMPLEMENTED IN ASSEMBLY LANGUAGE. IN ANY CASE ASSEMBLY
C     LANGUAGE MAY BE PREFERABLE FOR GREATER EFFICIENCY.  CONSULT
C     NAG CENTRAL OFFICE.
C
C     THE ROUTINE MUST SIMULATE THE FOLLOWING QUADRUPLE PRECISION
C     CODING IN PSEUDO-FORTRAN, WHERE
C     - QEXTD CONVERTS FROM DOUBLE TO QUADRUPLE PRECISION
C     - DBLEQ CONVERTS FROM QUADRUPLE TO DOUBLE PRECISION.
C
C     QUADRUPLE PRECISION SUMR, SUMI
C     DOUBLE PRECISION AI, AR, BI, BR, DI, DR
C     SUMR = QEXTD(DBLE(CX))
C     SUMI = QEXTD(DIMAG(CX))
C     IF (N.LT.1) GO TO 200
C     IS = 1
C     IT = 1
C     DO 180 I = 1, N
C        AR = DBLE(A(IS))
C        AI = DIMAG(A(IS))
C        BR = DBLE(B(IT))
C        BI = DIMAG(B(IT))
C        SUMR = SUMR + QEXTD(AR)*QEXTD(BR) - QEXTD(AI)*QEXTD(BI)
C        SUMI = SUMI + QEXTD(AI)*QEXTD(BR) + QEXTD(AR)*QEXTD(BI)
C        IS = IS + ISTEPA
C        IT = IT + ISTEPB
C 180 CONTINUE
C 200 DR = SUMR -- ROUNDED TO DOUBLE PRECISION
C     DI = SUMI -- ROUNDED TO DOUBLE PRECISION
C     DX = DCMPLX(DR,DI)
C
C     **************************************************************
C
C     .. Scalar Arguments ..
      COMPLEX*16        CX, DX
      INTEGER           ISIZEA, ISIZEB, ISTEPA, ISTEPB, N
C     .. Array Arguments ..
      COMPLEX*16        A(ISIZEA), B(ISIZEB)
C     .. Local Scalars ..
      DOUBLE PRECISION  AI, AR, BI, BR, CONS, DI, DR, HAI, HAR, HBI,
     *                  HBR, R, S, SUMI, SUMMI, SUMMR, SUMR, TAI, TAR,
     *                  TBI, TBR, Z, ZZ
      INTEGER           I, IS, IT
C     .. Intrinsic Functions ..
      INTRINSIC         DCMPLX, ABS, DBLE, DIMAG
C     .. Data statements ..
C     ************* IMPLEMENTATION-DEPENDENT CONSTANT **************
C     CONS MUST BE SET TO  B**(T - INT(T/2)) + 1 , WHERE T IS THE
C     NUMBER OF B-ARY DIGITS IN THE MANTISSA OF A DOUBLE PRECISION
C     NUMBER.
C     FOR B = 16 AND T = 14 (E.G. IBM 370) OR
C     FOR B = 2 AND T = 56 (E.G. DEC VAX-11)
C     DATA CONS /268435457.0D0/
      DATA CONS /1.34217729000000D+8/ 
C     **************************************************************
C     .. Executable Statements ..
      SUMR = DBLE(CX)
      SUMMR = 0.0D0
      SUMI = DIMAG(CX)
      SUMMI = 0.0D0
      IF (N.LT.1) GO TO 200
      IS = 1
      IT = 1
      DO 180 I = 1, N
         AR = DBLE(A(IS))
         AI = DIMAG(A(IS))
         BR = DBLE(B(IT))
         BI = DIMAG(B(IT))
         Z = AR*CONS
         HAR = (AR-Z) + Z
         TAR = AR - HAR
         Z = AI*CONS
         HAI = (AI-Z) + Z
         TAI = AI - HAI
         Z = BR*CONS
         HBR = (BR-Z) + Z
         TBR = BR - HBR
         Z = BI*CONS
         HBI = (BI-Z) + Z
         TBI = BI - HBI
         Z = AR*BR
         ZZ = (((HAR*HBR-Z)+HAR*TBR)+TAR*HBR) + TAR*TBR
         R = Z + SUMR
         IF (ABS(Z).GT.ABS(SUMR)) GO TO 20
         S = (((SUMR-R)+Z)+ZZ) + SUMMR
         GO TO 40
   20    S = (((Z-R)+SUMR)+SUMMR) + ZZ
   40    SUMR = R + S
         SUMMR = (R-SUMR) + S
         Z = AI*BI
         ZZ = (((HAI*HBI-Z)+HAI*TBI)+TAI*HBI) + TAI*TBI
         R = -Z + SUMR
         IF (ABS(Z).GT.ABS(SUMR)) GO TO 60
         S = (((SUMR-R)-Z)-ZZ) + SUMMR
         GO TO 80
   60    S = (((-Z-R)+SUMR)+SUMMR) - ZZ
   80    SUMR = R + S
         SUMMR = (R-SUMR) + S
         Z = AI*BR
         ZZ = (((HAI*HBR-Z)+HAI*TBR)+TAI*HBR) + TAI*TBR
         R = Z + SUMI
         IF (ABS(Z).GT.ABS(SUMI)) GO TO 100
         S = (((SUMI-R)+Z)+ZZ) + SUMMI
         GO TO 120
  100    S = (((Z-R)+SUMI)+SUMMI) + ZZ
  120    SUMI = R + S
         SUMMI = (R-SUMI) + S
         Z = AR*BI
         ZZ = (((HAR*HBI-Z)+HAR*TBI)+TAR*HBI) + TAR*TBI
         R = Z + SUMI
         IF (ABS(Z).GT.ABS(SUMI)) GO TO 140
         S = (((SUMI-R)+Z)+ZZ) + SUMMI
         GO TO 160
  140    S = (((Z-R)+SUMI)+SUMMI) + ZZ
  160    SUMI = R + S
         SUMMI = (R-SUMI) + S
         IS = IS + ISTEPA
         IT = IT + ISTEPB
  180 CONTINUE
C 200 DR = SUMR + (SUMMR+SUMMR)
C     DI = SUMI + (SUMMI+SUMMI)
C     *************** IMPLEMENTATION DEPENDENT CODE ****************
C     THE PREVIOUS TWO STATEMENTS ASSUME THAT THE RESULT OF A DOUBLE
C     PRECISION ADDITION IS TRUNCATED.  IF IT IS ROUNDED, THEN
C     THE STATEMENTS MUST BE CHANGED TO
  200 DR = SUMR + SUMMR
      DI = SUMI + SUMMI
C     **************************************************************
      DX = DCMPLX(DR,DI)
      RETURN
      END