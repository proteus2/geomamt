      SUBROUTINE G13CCZ(NXY,MTXY,PXY,IW,MW,IS,IC,NC,CXY,CYX,KC,L,NXYG,
     *                  XG,YG,NG,IERROR)
C     MARK 10 RELEASE. NAG COPYRIGHT 1982.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     G13CCZ - THE MAIN AUXILARY FOR G13CCF AND G13CDF
C     - SUPERVISES THE CALCULATION OF THE SMOOTHED SAMPLE CROSS
C     SPECTRUM OF 2 TIME SERIES.
C
C     G13CCF/G13CDF
C     NXY   - NUMBER OF DATA POINTS IN ARRAYS XG AND YG
C     MTXY  - MEAN TREND CORRECTION INDICATOR
C     PXY   - PROPORTION OF DATA FOR SPLIT COSINE BELL TAPER
C     IW    - LAG WINDOW SHAPE
C     MW    - LAG WINDOW CUT OFF/FREQUENCY WIDTH OF WINDOW
C     IS    - ALIGNMENT SHIFT
C     IC    - CROSS COVARIANCE CALC INDICATOR/NO INTERPRETATION
C     NC    - NUMBER OF CROSS COVS CALC/NO INTERPRETATION
C     CXY   - XY CROSS COVARIANCE ARRAY/DANIELL WINDOW SHAPE
C     PROPORTION
C     CYX   - YX CROSS COVARIANCE ARRAY/NO INTERPRETATION
C     KC    - ORDER OF TRANSFORM FOR CROSS COV CALC
C     L     - ORDER OF TRANSFORM/FREQUENCY DIVISION OF ESTIMATES
C     NXYG  - SIZE OF EXTENDED DATA AND SPECTRUM ARRAYS
C     XG    - X SERIES AND REAL PART OF SPECTRUM ARRAY
C     YG    - Y SERIES AND IMAGINARY PART OF SPECTRUM ARRAY
C     NG    - NUMBER OF SPECTRUM ESTIMATES IN XG AND YG
C     IERROR- FAILURE INDICATOR
C
C
C     CALCULATE NG AND PI
C     .. Scalar Arguments ..
      DOUBLE PRECISION  PXY
      INTEGER           IC, IERROR, IS, IW, KC, L, MTXY, MW, NC, NG,
     *                  NXY, NXYG
C     .. Array Arguments ..
      DOUBLE PRECISION  CXY(NC), CYX(NC), XG(NXYG), YG(NXYG)
C     .. Local Scalars ..
      DOUBLE PRECISION  A, B, CCIM, CCRL, CDIM, CDRL, CEIM, CERL, PI,
     *                  S1, S2, S3, S4, S5, THETA
      INTEGER           I, IFAIL1, IR, J, LNK, M, MD1, MD2, NI, NK
C     .. External Functions ..
      DOUBLE PRECISION  G13CAW, X01AAF
      EXTERNAL          G13CAW, X01AAF
C     .. External Subroutines ..
      EXTERNAL          C06EAF, C06EBF, G13CAX, G13CAY, G13CCY
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, MOD, COS, DBLE, SIN, SQRT, INT
C     .. Executable Statements ..
      NG = L/2 + 1
      S1 = 1.0D0
      PI = X01AAF(0.0D0)
C
C     JUMP IF G13CCF AND CROSS COVARIANCES SUPPLIED
      IF (IW.LE.4 .AND. IC.NE.0) GO TO 180
C
C     MEAN OR TREND CORRECT DATA
      CALL G13CAY(XG,NXY,MTXY)
      CALL G13CAY(YG,NXY,MTXY)
C
C     APPLY SPLIT COSINE BELL TAPER
      M = INT(DBLE(NXY)*PXY/2.0D0)
      CALL G13CAX(XG,NXY,M,PI)
      CALL G13CAX(YG,NXY,M,PI)
C
C     PAD XG AND YG BY ZEROS TO LENGTH KC FOR FFT
      M = NXY + 1
      DO 20 I = M, KC
         XG(I) = 0.0D0
         YG(I) = 0.0D0
   20 CONTINUE
C
C     TRANSFORM OF LENGTH KC
      IFAIL1 = 1
      CALL C06EAF(XG,KC,IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 40
      IERROR = 2
      GO TO 580
   40 CONTINUE
      IFAIL1 = 1
      CALL C06EAF(YG,KC,IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 60
      IERROR = 2
      GO TO 580
C     FORM X YCONJ IN XG
   60 XG(1) = XG(1)*YG(1)
      M = (KC+1)/2
      NI = KC + 1
      IF (M.LT.2) GO TO 100
      DO 80 I = 2, M
         NI = NI - 1
         S1 = XG(I)
         S2 = XG(NI)
         S3 = YG(I)
         S4 = YG(NI)
         S5 = S1*S3 + S2*S4
         XG(I) = S5
         S5 = S2*S3 - S1*S4
         XG(NI) = S5
   80 CONTINUE
  100 M = M + 1
      IF (MOD(KC,2).NE.0) GO TO 120
      XG(M) = XG(M)*YG(M)
  120 CONTINUE
C     JUMP OUT IF DANIELL WINDOW
      IF (IW.GT.4) GO TO 320
C     FORM CROSS COVARIANCES
      IFAIL1 = 1
      CALL C06EBF(XG,KC,IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 140
      IERROR = 2
      GO TO 580
  140 S1 = SQRT(DBLE(KC))/DBLE(NXY)
      S2 = S1*XG(1)
      CXY(1) = S2
      CYX(1) = S2
      NI = KC
      DO 160 I = 2, NC
         CXY(I) = S1*XG(I)
         CYX(I) = S1*XG(NI)
         NI = NI - 1
  160 CONTINUE
  180 CONTINUE
C
C     APPLY LAG WINDOW AND SET UP
C     SEQUENCE FOR FFT OF LENGTH L
      MD1 = MW + IS
      A = DBLE(MW)
      J = -IS - 1
      DO 200 I = 1, MD1
         J = J + 1
         S3 = DBLE(ABS(J))/A
         XG(I) = CXY(I)*G13CAW(IW,S3,PI)
  200 CONTINUE
      MD2 = MW - IS
      NI = L
      IF (MD2.LT.2) GO TO 240
      J = IS
      DO 220 I = 2, MD2
         J = J + 1
         S3 = DBLE(ABS(J))/A
         XG(NI) = CYX(I)*G13CAW(IW,S3,PI)
         NI = NI - 1
  220 CONTINUE
  240 M = MD1 + 1
      IF (M.GT.NI) GO TO 280
      DO 260 I = M, NI
         XG(I) = 0.0D0
  260 CONTINUE
  280 CONTINUE
C
C     TRANSFORM OF LENGTH L
      IFAIL1 = 1
      CALL C06EAF(XG,L,IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 300
      IERROR = 3
      GO TO 580
C
C     CALC SCALE FACTOR
  300 S3 = SQRT(DBLE(L))/(2.0D0*PI)
      S2 = 8.0D0/(8.0D0-5.0D0*PXY)
      S3 = S3*S2
      GO TO 440
C
C     COME HERE FOR DANIELL WINDOW
  320 CONTINUE
C     COPY XG INTO YG LEAVING XG TO ACCUMULATE TERMS
      DO 340 I = 1, KC
         YG(I) = XG(I)
  340 CONTINUE
C     ASCERTAIN R IN KC = R * L
      IR = KC/L
C
C     LOOP THROUGH WEIGHTS TO SMOOTH SPECTRUM
C
C     WEIGHT AT POINT ZERO
      A = 0.0D0
      B = 1.0D0
      A = A + B
      M = 0
      NI = L + 1
C     LOOP THROUGH SPECTRUM ESTIMATES
      DO 360 I = 1, NG
         CALL G13CCY(YG,KC,M,S1,S2)
         XG(I) = S1*B
         IF (NI.NE.(L+1) .AND. NI.NE.I) XG(NI) = S2*B
         M = M + IR
         NI = NI - 1
  360 CONTINUE
      IF (MW.EQ.NXY) GO TO 420
C
C     WEIGHTS AT POINTS +-I FROM POINT ZERO
      M = INT(DBLE(KC)/(2.0D0*DBLE(MW)))
      IF (M.LE.0) GO TO 420
      DO 400 I = 1, M
         S3 = 2.0D0*DBLE(MW*I)/DBLE(KC)
         B = 1.0D0
         IF (S3.GT.CXY(1)) B = (1.0D0-S3)/(1.0D0-CXY(1))
         A = A + 2.0D0*B
         THETA = -2.0D0*PI*DBLE(IS*I)/DBLE(KC)
         CCRL = B*COS(THETA)
         CCIM = B*SIN(THETA)
         CERL = CCRL
         CEIM = -CCIM
         LNK = I
         NI = L + 1
C        LOOP THROUGH SPECTRUM ESTIMATES
C        FOR EACH FIXED WEIGHT AT POINT +-I
         DO 380 J = 1, NG
            CALL G13CCY(YG,KC,LNK,S1,S2)
            CDRL = S1*CCRL - S2*CCIM
            CDIM = S1*CCIM + S2*CCRL
            S1 = CDRL
            S2 = CDIM
            XG(J) = XG(J) + S1
            IF (NI.NE.(L+1) .AND. NI.NE.J) XG(NI) = XG(NI) + S2
            NK = LNK - 2*I
            CALL G13CCY(YG,KC,NK,S1,S2)
            CDRL = S1*CERL - S2*CEIM
            CDIM = S1*CEIM + S2*CERL
            S1 = CDRL
            S2 = CDIM
            XG(J) = XG(J) + S1
            IF (NI.NE.(L+1) .AND. NI.NE.J) XG(NI) = XG(NI) + S2
            LNK = LNK + IR
            NI = NI - 1
  380    CONTINUE
  400 CONTINUE
  420 CONTINUE
C
C     CALC SCALE FACTOR
      S3 = (8.0D0-5.0D0*PXY)*2.0D0*PI*DBLE(NXY)*A
      S3 = 8.0D0*DBLE(KC)/S3
C
C     OTHER WINDOWS REJOIN DANIELL HERE
C     APPLY SCALE FACTOR TO ESTIMATES
  440 DO 460 I = 1, L
         XG(I) = XG(I)*S3
  460 CONTINUE
C
C     SHIFT IMAGINARY PART INTO YG
      YG(1) = 0.0D0
      M = (L+1)/2
      IF (M.LT.2) GO TO 500
      NI = L
      A = -1.0D0
      IF (IW.EQ.5) A = 1.0D0
      DO 480 I = 2, M
         YG(I) = A*XG(NI)
         NI = NI - 1
  480 CONTINUE
  500 M = M + 1
      IF (MOD(L,2).NE.0) GO TO 520
      YG(M) = 0.0D0
  520 CONTINUE
C
C     PAD ARRAYS XG AND YG WITH ZEROS AFTER ESTIMATES
      M = NG + 1
      IF (M.GT.NXYG) GO TO 560
      DO 540 I = M, NXYG
         XG(I) = 0.0D0
         YG(I) = 0.0D0
  540 CONTINUE
  560 CONTINUE
C
C     TERMINATE
  580 RETURN
      END
