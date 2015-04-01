      SUBROUTINE G02BHF(N,M,X,IX,MISS,XMISS,MISTYP,NVARS,KVAR,XBAR,STD,
     *                  SSP,ISSP,R,IR,NCASES,IFAIL)
C     MARK 4 RELEASE NAG COPYRIGHT 1974.
C     MARK 4.5 REVISED IER-53/46
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     NAG SUBROUTINE G02BHF
C     WRITTEN 17. 8.73 BY PAUL GRIFFITHS (OXFORD UNIVERSITY)
C
C     COMPUTES MEANS, STANDARD DEVIATIONS, SUMS OF SQUARES AND
C     CROSS-PRODUCTS OF DEVIATIONS FROM MEANS, AND PEARSON PRODUCT-
C     MOMENT CORRELATION COEFFICIENTS FOR A SET OF DATA IN
C     SPECIFIED COLUMNS OF THE ARRAY X, OMITTING COMPLETELY ANY
C     CASES WITH A MISSING OBSERVATION FOR ANY VARIABLE (OVER ALL M
C     VARIABLES IF MISTYP=1, OR OVER ONLY THE NVARS VARIABLES IN
C     THE SELECTED SUBSET IF MISTYP=0
C
C     USES NAG ERROR ROUTINE P01AAF
C     NAG LIBRARY ROUTINE    X02BEF
C
C
C     ABOVE DATA STATEMENT MAY BE MACHINE DEPENDENT -- DEPENDS ON
C     NUMBER OF CHARACTERS WHICH MAY BE STORED IN A REAL VARIABLE
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='G02BHF')
C     .. Scalar Arguments ..
      INTEGER           IFAIL, IR, ISSP, IX, M, MISTYP, N, NCASES, NVARS
C     .. Array Arguments ..
      DOUBLE PRECISION  R(IR,NVARS), SSP(ISSP,NVARS), STD(NVARS),
     *                  X(IX,M), XBAR(NVARS), XMISS(M)
      INTEGER           KVAR(NVARS), MISS(M)
C     .. Local Scalars ..
      DOUBLE PRECISION  ACC, S, XCASES
      INTEGER           I, IERROR, ISTART, J, JV, K, KV, NM
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
C     .. External Functions ..
      INTEGER           P01ABF, X02BEF
      EXTERNAL          P01ABF, X02BEF
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, SQRT, DBLE, INT
C     .. Executable Statements ..
      ACC = 0.1D0**(X02BEF(ACC)-2)
      IERROR = 0
      IF (MISTYP.GT.1 .OR. MISTYP.LT.0) IERROR = 5
      IF (IX.LT.N .OR. ISSP.LT.NVARS .OR. IR.LT.NVARS) IERROR = 3
      IF (NVARS.LT.2 .OR. NVARS.GT.M) IERROR = 2
      IF (N.LT.2) IERROR = 1
      IF (IERROR) 20, 20, 760
   20 DO 40 I = 1, NVARS
         IF (KVAR(I).LT.1 .OR. KVAR(I).GT.M) GO TO 700
   40 CONTINUE
      XCASES = 0.0D0
C
C     RE-ARRANGE MISSING VALUE INFORMATION FOR EFFICIENCY
C
      NM = 0
      IF (MISTYP) 60, 60, 120
   60 DO 100 JV = 1, NVARS
         I = KVAR(JV)
         IF (MISS(I)) 100, 100, 80
   80    NM = NM + 1
         MISS(NM) = I
         XMISS(NM) = XMISS(I)
  100 CONTINUE
      GO TO 180
  120 DO 160 I = 1, M
         IF (MISS(I)) 160, 160, 140
  140    NM = NM + 1
         MISS(NM) = I
         XMISS(NM) = XMISS(I)
  160 CONTINUE
  180 IF (NM) 300, 300, 200
C
C     SOME MISSING VALUES ARE INVOLVED
C
  200 DO 280 I = 1, N
         DO 220 K = 1, NM
            J = MISS(K)
            IF (ABS(X(I,J)-XMISS(K)).LE.ABS(ACC*XMISS(K))) GO TO 280
  220    CONTINUE
         ISTART = I + 1
         DO 260 J = 1, NVARS
            JV = KVAR(J)
            DO 240 K = J, NVARS
               SSP(K,J) = 0.0D0
  240       CONTINUE
            XBAR(J) = X(I,JV)
  260    CONTINUE
         GO TO 400
  280 CONTINUE
      GO TO 720
C
C     NO MISSING VALUES INVOLVED IN FACT
C
  300 XCASES = DBLE(N)
      DO 380 J = 1, NVARS
         JV = KVAR(J)
         S = 0.0D0
         DO 320 I = 1, N
            S = S + X(I,JV)
  320    CONTINUE
         XBAR(J) = S/XCASES
         DO 360 K = 1, J
            KV = KVAR(K)
            S = 0.0D0
            DO 340 I = 1, N
               S = S + (X(I,JV)-XBAR(J))*(X(I,KV)-XBAR(K))
  340       CONTINUE
            SSP(J,K) = S
  360    CONTINUE
  380 CONTINUE
      GO TO 500
C
C     SECOND AND SUBSEQUENT CASES WHEN MISSING VALUES ARE SPECOFIED
C
  400 IF (ISTART.GT.N) GO TO 740
      XCASES = 1.0D0
      DO 480 I = ISTART, N
         DO 420 K = 1, NM
            J = MISS(K)
            IF (ABS(X(I,J)-XMISS(K)).LE.ABS(ACC*XMISS(K))) GO TO 480
  420    CONTINUE
         XCASES = XCASES + 1.0D0
         S = (XCASES-1.0D0)/XCASES
         DO 460 J = 1, NVARS
            JV = KVAR(J)
            DO 440 K = J, NVARS
               KV = KVAR(K)
               SSP(K,J) = SSP(K,J) + (X(I,JV)-XBAR(J))*(X(I,KV)-XBAR(K))
     *                    *S
  440       CONTINUE
            XBAR(J) = XBAR(J)*S + X(I,JV)/XCASES
  460    CONTINUE
  480 CONTINUE
      IF (XCASES.LT.1.5D0) GO TO 740
C
C     DO THIS WHETHER OR NOT MISSING VALUES ARE INVOLVED
C
  500 DO 660 J = 1, NVARS
         S = SSP(J,J)
         IF (S) 520, 520, 540
  520    STD(J) = 0.0D0
         GO TO 560
  540    STD(J) = SQRT(S)
  560    DO 640 K = 1, J
            S = STD(J)*STD(K)
            IF (S) 580, 580, 600
  580       R(J,K) = 0.0D0
            GO TO 620
  600       R(J,K) = SSP(J,K)/S
  620       R(K,J) = R(J,K)
            SSP(K,J) = SSP(J,K)
  640    CONTINUE
  660 CONTINUE
      S = SQRT(XCASES-1.0D0)
      DO 680 J = 1, NVARS
         STD(J) = STD(J)/S
  680 CONTINUE
      NCASES = INT(XCASES+0.5D0)
      IFAIL = 0
      RETURN
  700 IERROR = 4
      GO TO 760
  720 NCASES = 0
      IERROR = 6
      GO TO 760
  740 NCASES = 1
      IERROR = 7
  760 IFAIL = P01ABF(IFAIL,IERROR,SRNAME,0,P01REC)
      RETURN
      END