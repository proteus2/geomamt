      SUBROUTINE X03AAF(A,ISIZEA,B,ISIZEB,N,ISTEPA,ISTEPB,C1,C2,D1,D2,
     *                  SW,IFAIL)
C     MARK 10 RE-ISSUE. NAG COPYRIGHT 1982
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 12 REVISED. IER-524 (AUG 1986).
C     DOUBLE PRECISION BASE VERSION
C
C     CALCULATES THE VALUE OF A SCALAR PRODUCT USING BASIC OR
C     ADDITIONAL PRECISION AND ADDS IT TO A BASIC OR ADDITIONAL
C     PRECISION INITIAL VALUE.
C
C     FOR THIS DOUBLE PRECISION VERSION, ALL ADDITIONAL (I.E.
C     QUADRUPLE) PRECISION COMPUTATION IS PERFORMED BY THE AUXILIARY
C     ROUTINE X03AAY.  SEE THE COMMENTS AT THE HEAD OF THAT ROUTINE
C     CONCERNING IMPLEMENTATION.
C
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='X03AAF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  C1, C2, D1, D2
      INTEGER           IFAIL, ISIZEA, ISIZEB, ISTEPA, ISTEPB, N
      LOGICAL           SW
C     .. Array Arguments ..
      DOUBLE PRECISION  A(ISIZEA), B(ISIZEB)
C     .. Local Scalars ..
      DOUBLE PRECISION  SUM
      INTEGER           I, IERR, IS, IT
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          X03AAY
C     .. Executable Statements ..
      IERR = 0
      IF (ISTEPA.LE.0 .OR. ISTEPB.LE.0) IERR = 1
      IF (ISIZEA.LT.(N-1)*ISTEPA+1 .OR. ISIZEB.LT.(N-1)*ISTEPB+1)
     *    IERR = 2
      IF (IERR.EQ.0) GO TO 20
      IFAIL = P01ABF(IFAIL,IERR,SRNAME,0,P01REC)
      RETURN
   20 IFAIL = 0
      IF (SW) GO TO 80
C
C     BASIC PRECISION CALCULATION
C
      SUM = C1
      IF (N.LT.1) GO TO 60
      IS = 1
      IT = 1
      DO 40 I = 1, N
         SUM = SUM + A(IS)*B(IT)
         IS = IS + ISTEPA
         IT = IT + ISTEPB
   40 CONTINUE
   60 D1 = SUM
      D2 = 0.0D0
      RETURN
C
C     ADDITIONAL PRECISION COMPUTATION
C
   80 CALL X03AAY(A,ISIZEA,B,ISIZEB,N,ISTEPA,ISTEPB,C1,C2,D1,D2)
      RETURN
      END
