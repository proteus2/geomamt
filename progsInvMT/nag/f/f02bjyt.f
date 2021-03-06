      SUBROUTINE F02BJY(N,A,IA,B,IB,ALFR,ALFI,BETA,MATZ,Z,IZ)
C     MARK 6 RELEASE  NAG COPYRIGHT 1977
C     MARK 8 REVISED. IER-232 (MAR 1980).
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     THIS SUBROUTINE IS THE THIRD STEP OF THE QZ ALGORITHM
C     FOR SOLVING GENERALIZED MATRIX EIGENVALUE PROBLEMS,
C     SIAM J. NUMER. ANAL. 10, 241-256(1973) BY MOLER AND STEWART.
C
C     THIS SUBROUTINE ACCEPTS A PAIR OF REAL MATRICES, ONE OF THEM
C     IN QUASI-TRIANGULAR FORM AND THE OTHER IN UPPER TRIANGULAR
C     FORM.
C     IT REDUCES THE QUASI-TRIANGULAR MATRIX FURTHER, SO THAT ANY
C     REMAINING 2-BY-2 BLOCKS CORRESPOND TO PAIRS OF COMPLEX
C     EIGENVALUES, AND RETURNS QUANTITIES WHOSE RATIOS GIVE THE
C     GENERALIZED EIGENVALUES.  IT IS USUALLY PRECEDED BY F02BJW
C     AND F02BJX AND MAY BE FOLLOWED BY F02BJZ.
C
C     ON INPUT
C
C     N IS THE ORDER OF THE MATRICES.
C
C     A CONTAINS A REAL UPPER QUASI-TRIANGULAR MATRIX.
C
C     IA MUST SPECIFY THE FIRST DIMENSION OF THE ARRAY A AS
C     DECLARED IN THE CALLING (SUB)PROGRAM.  IA.GE.N
C
C     B CONTAINS A REAL UPPER TRIANGULAR MATRIX.  IN ADDITION,
C     LOCATION B(N,1) CONTAINS THE TOLERANCE QUANTITY (EPSB)
C     COMPUTED AND SAVED IN F02BJX.
C
C     IB MUST SPECIFY THE FIRST DIMENSION OF THE ARRAY B AS
C     DECLARED IN THE CALLING (SUB)PROGRAM.  IB.GE.N
C
C     MATZ SHOULD BE SET TO .TRUE. IF THE RIGHT HAND
C     TRANSFORMATIONS
C     ARE TO BE ACCUMULATED FOR LATER USE IN COMPUTING
C     EIGENVECTORS, AND TO .FALSE. OTHERWISE.
C
C     Z CONTAINS, IF MATZ HAS BEEN SET TO .TRUE., THE
C     TRANSFORMATION MATRIX PRODUCED IN THE REDUCTIONS BY F02BJW
C     AND F02BJX, IF PERFORMED, OR ELSE THE IDENTITY MATRIX.
C     IF MATZ HAS BEEN SET TO .FALSE., Z IS NOT REFERENCED.
C
C     IZ MUST SPECIFY THE FIRST DIMENSION OF THE ARRAY Z AS
C     DECLARED IN THE CALLING (SUB)PROGRAM.  IZ.GE.N
C
C     ON OUTPUT
C
C     A HAS BEEN REDUCED FURTHER TO A QUASI-TRIANGULAR MATRIX
C     IN WHICH ALL NONZERO SUBDIAGONAL ELEMENTS CORRESPOND TO
C     PAIRS OF COMPLEX EIGENVALUES.
C
C     B IS STILL IN UPPER TRIANGULAR FORM, ALTHOUGH ITS ELEMENTS
C     HAVE BEEN ALTERED.  B(N,1) IS UNALTERED.
C
C     ALFR AND ALFI CONTAIN THE REAL AND IMAGINARY PARTS OF THE
C     DIAGONAL ELEMENTS OF THE TRIANGULAR MATRIX THAT WOULD BE
C     OBTAINED IF A WERE REDUCED COMPLETELY TO TRIANGULAR FORM
C     BY UNITARY TRANSFORMATIONS.  NON-ZERO VALUES OF ALFI OCCUR
C     IN PAIRS, THE FIRST MEMBER POSITIVE AND THE SECOND NEGATIVE.
C
C     BETA CONTAINS THE DIAGONAL ELEMENTS OF THE CORRESPONDING B,
C     NORMALIZED TO BE REAL AND NON-NEGATIVE.  THE GENERALIZED
C     EIGENVALUES ARE THEN THE RATIOS ((ALFR+I*ALFI)/BETA).
C
C     Z CONTAINS THE PRODUCT OF THE RIGHT HAND TRANSFORMATIONS
C     (FOR ALL THREE STEPS) IF MATZ HAS BEEN SET TO .TRUE.
C
C     IMPLEMENTED FROM EISPACK BY
C     W. PHILLIPS OXFORD UNIVERSITY COMPUTING SERVICE.
C
C     .. Scalar Arguments ..
      INTEGER           IA, IB, IZ, N
      LOGICAL           MATZ
C     .. Array Arguments ..
      DOUBLE PRECISION  A(IA,N), ALFI(N), ALFR(N), B(IB,N), BETA(N),
     *                  Z(IZ,N)
C     .. Local Scalars ..
      DOUBLE PRECISION  A1, A11, A11I, A11R, A12, A12I, A12R, A1I, A2,
     *                  A21, A22, A22I, A22R, A2I, AN, B11, B12, B22,
     *                  BN, C, CQ, CZ, D, DI, DR, E, EI, EPSB, HALF,
     *                  ONE, R, S, SQI, SQR, SSI, SSR, SZI, SZR, T, TI,
     *                  TR, U1, U2, V1, V2, ZERO
      INTEGER           EN, I, ISW, J, NA, NN
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, SQRT
C     .. Data statements ..
      DATA              ZERO/0.0D0/, HALF/0.5D0/, ONE/1.0D0/
C     .. Executable Statements ..
      EPSB = B(N,1)
      ISW = 1
C     FIND EIGENVALUES OF QUASI-TRIANGULAR MATRICES.
C     FOR EN=N STEP -1 UNTIL 1 DO --
      DO 520 NN = 1, N
         EN = N + 1 - NN
         NA = EN - 1
         IF (ISW.EQ.2) GO TO 500
         IF (EN.EQ.1) GO TO 20
         IF (A(EN,NA).NE.ZERO) GO TO 40
C        1-BY-1 BLOCK, ONE REAL ROOT
   20    ALFR(EN) = A(EN,EN)
         IF (B(EN,EN).LT.ZERO) ALFR(EN) = -ALFR(EN)
         BETA(EN) = ABS(B(EN,EN))
         ALFI(EN) = ZERO
         GO TO 520
C        2-BY-2 BLOCK
   40    IF (ABS(B(NA,NA)).LE.EPSB) GO TO 200
         IF (ABS(B(EN,EN)).GT.EPSB) GO TO 60
         A1 = A(EN,EN)
         A2 = A(EN,NA)
         BN = ZERO
         GO TO 120
   60    AN = ABS(A(NA,NA)) + ABS(A(NA,EN)) + ABS(A(EN,NA)) +
     *        ABS(A(EN,EN))
         BN = ABS(B(NA,NA)) + ABS(B(NA,EN)) + ABS(B(EN,EN))
         A11 = A(NA,NA)/AN
         A12 = A(NA,EN)/AN
         A21 = A(EN,NA)/AN
         A22 = A(EN,EN)/AN
         B11 = B(NA,NA)/BN
         B12 = B(NA,EN)/BN
         B22 = B(EN,EN)/BN
         E = A11/B11
         EI = A22/B22
         S = A21/(B11*B22)
         T = (A22-E*B22)/B22
         IF (ABS(E).LE.ABS(EI)) GO TO 80
         E = EI
         T = (A11-E*B11)/B11
   80    C = HALF*(T-S*B12)
         D = C*C + S*(A12-E*B12)
         IF (D.LT.ZERO) GO TO 280
C        TWO REAL ROOTS.
C        ZERO BOTH A(EN,NA) AND B(EN,NA)
         E = E + C + SQRT(D)
         IF (C.LT.ZERO) E = E - 2.0D0*SQRT(D)
         A11 = A11 - E*B11
         A12 = A12 - E*B12
         A22 = A22 - E*B22
         IF (ABS(A11)+ABS(A12).LT.ABS(A21)+ABS(A22)) GO TO 100
         A1 = A12
         A2 = A11
         GO TO 120
  100    A1 = A22
         A2 = A21
C        CHOOSE AND APPLY REAL Z
  120    S = ABS(A1) + ABS(A2)
         U1 = A1/S
         U2 = A2/S
         R = SQRT(U1*U1+U2*U2)
         IF (U1.LT.ZERO) R = -R
         V1 = -(U1+R)/R
         V2 = -U2/R
         U2 = V2/V1
C
         DO 140 I = 1, EN
            T = A(I,EN) + U2*A(I,NA)
            A(I,EN) = A(I,EN) + T*V1
            A(I,NA) = A(I,NA) + T*V2
            T = B(I,EN) + U2*B(I,NA)
            B(I,EN) = B(I,EN) + T*V1
            B(I,NA) = B(I,NA) + T*V2
  140    CONTINUE
C
         IF ( .NOT. MATZ) GO TO 180
C
         DO 160 I = 1, N
            T = Z(I,EN) + U2*Z(I,NA)
            Z(I,EN) = Z(I,EN) + T*V1
            Z(I,NA) = Z(I,NA) + T*V2
  160    CONTINUE
C
  180    IF (BN.EQ.ZERO) GO TO 260
         IF (AN.LT.ABS(E)*BN) GO TO 200
         A1 = B(NA,NA)
         A2 = B(EN,NA)
         GO TO 220
  200    A1 = A(NA,NA)
         A2 = A(EN,NA)
C        CHOOSE AND APPLY REAL Q
  220    S = ABS(A1) + ABS(A2)
         IF (S.EQ.ZERO) GO TO 260
         U1 = A1/S
         U2 = A2/S
         R = SQRT(U1*U1+U2*U2)
         IF (U1.LT.ZERO) R = -R
         V1 = -(U1+R)/R
         V2 = -U2/R
         U2 = V2/V1
C
         DO 240 J = NA, N
            T = A(NA,J) + U2*A(EN,J)
            A(NA,J) = A(NA,J) + T*V1
            A(EN,J) = A(EN,J) + T*V2
            T = B(NA,J) + U2*B(EN,J)
            B(NA,J) = B(NA,J) + T*V1
            B(EN,J) = B(EN,J) + T*V2
  240    CONTINUE
C
  260    A(EN,NA) = ZERO
         B(EN,NA) = ZERO
         ALFR(NA) = A(NA,NA)
         ALFR(EN) = A(EN,EN)
         IF (B(NA,NA).LT.ZERO) ALFR(NA) = -ALFR(NA)
         IF (B(EN,EN).LT.ZERO) ALFR(EN) = -ALFR(EN)
         BETA(NA) = ABS(B(NA,NA))
         BETA(EN) = ABS(B(EN,EN))
         ALFI(EN) = ZERO
         ALFI(NA) = ZERO
         GO TO 500
C        TWO COMPLEX ROOTS
  280    E = E + C
         EI = SQRT(-D)
         A11R = A11 - E*B11
         A11I = EI*B11
         A12R = A12 - E*B12
         A12I = EI*B12
         A22R = A22 - E*B22
         A22I = EI*B22
         IF (ABS(A11R)+ABS(A11I)+ABS(A12R)+ABS(A12I).LT.ABS(A21)
     *       +ABS(A22R)+ABS(A22I)) GO TO 300
         A1 = A12R
         A1I = A12I
         A2 = -A11R
         A2I = -A11I
         GO TO 320
  300    A1 = A22R
         A1I = A22I
         A2 = -A21
         A2I = ZERO
C        CHOOSE COMPLEX Z
  320    CZ = SQRT(A1*A1+A1I*A1I)
         IF (CZ.EQ.ZERO) GO TO 340
         SZR = (A1*A2+A1I*A2I)/CZ
         SZI = (A1*A2I-A1I*A2)/CZ
         R = SQRT(CZ*CZ+SZR*SZR+SZI*SZI)
         CZ = CZ/R
         SZR = SZR/R
         SZI = SZI/R
         GO TO 360
  340    SZR = ONE
         SZI = ZERO
  360    IF (AN.LT.(ABS(E)+EI)*BN) GO TO 380
         A1 = CZ*B11 + SZR*B12
         A1I = SZI*B12
         A2 = SZR*B22
         A2I = SZI*B22
         GO TO 400
  380    A1 = CZ*A11 + SZR*A12
         A1I = SZI*A12
         A2 = CZ*A21 + SZR*A22
         A2I = SZI*A22
C        CHOOSE COMPLEX Q
  400    CQ = SQRT(A1*A1+A1I*A1I)
         IF (CQ.EQ.ZERO) GO TO 420
         SQR = (A1*A2+A1I*A2I)/CQ
         SQI = (A1*A2I-A1I*A2)/CQ
         R = SQRT(CQ*CQ+SQR*SQR+SQI*SQI)
         CQ = CQ/R
         SQR = SQR/R
         SQI = SQI/R
         GO TO 440
  420    SQR = ONE
         SQI = ZERO
C        COMPUTE DIAGONAL ELEMENTS THAT WOULD RESULT
C        IF TRANSFORMATIONS WERE APPLIED
  440    SSR = SQR*SZR + SQI*SZI
         SSI = SQR*SZI - SQI*SZR
         I = 1
         TR = CQ*CZ*A11 + CQ*SZR*A12 + SQR*CZ*A21 + SSR*A22
         TI = CQ*SZI*A12 - SQI*CZ*A21 + SSI*A22
         DR = CQ*CZ*B11 + CQ*SZR*B12 + SSR*B22
         DI = CQ*SZI*B12 + SSI*B22
         GO TO 480
  460    I = 2
         TR = SSR*A11 - SQR*CZ*A12 - CQ*SZR*A21 + CQ*CZ*A22
         TI = -SSI*A11 - SQI*CZ*A12 + CQ*SZI*A21
         DR = SSR*B11 - SQR*CZ*B12 + CQ*CZ*B22
         DI = -SSI*B11 - SQI*CZ*B12
  480    T = TI*DR - TR*DI
         J = NA
         IF (T.LT.ZERO) J = EN
         R = SQRT(DR*DR+DI*DI)
         BETA(J) = BN*R
         ALFR(J) = AN*(TR*DR+TI*DI)/R
         ALFI(J) = AN*T/R
         IF (I.EQ.1) GO TO 460
  500    ISW = 3 - ISW
  520 CONTINUE
C
      RETURN
      END
