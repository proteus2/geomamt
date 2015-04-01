      SUBROUTINE G13CAZ(NX,MTX,PX,IW,MW,IC,NC,C,KC,L,LG,NXG,XG,NG,STATS,
     *                  IERROR)
C     MARK 10 RELEASE. NAG COPYRIGHT 1982.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 13 REVISED. USE OF MARK 12 X02 FUNCTIONS (APR 1988).
C     MARK 16 REVISED. IER-1126 (JUL 1993).
C
C     G13CAZ - THE MAIN AUXILARY FOR G13CAF AND G13CBF
C     - SUPERVISES THE CALCULATION OF THE SMOOTHED SAMPLE
C     SPECTRUM OF A TIME SERIES AND THE ASSOCIATED STATISTICS.
C
C     G13CAF/G13CBF
C     NX    - NUMBER OF DATA POINTS IN ARRAY XG
C     MTX   - MEAN TREND CORRECTION INDICATOR
C     PX    - PROPORTION OF DATA FOR SPLIT COSINE BELL TAPER
C     IW    - LAG WINDOW SHAPE
C     MW    - LAG WINDOW CUT OFF/FREQUENCY WIDTH OF WINDOW
C     IC    - COVARIANCE CALC INDICATOR/NO INTERPRETATION
C     NC    - NUMBER OF COVS CALC/NO INTERPRETATION
C     C     - COVARIANCE ARRAY/DANIELL WINDOW SHAPE PROPORTION
C     KC    - ORDER OF TRANSFORM FOR COV CALC
C     L     - ORDER OF TRANSFORM/FREQUENCY DIVISION OF ESTIMATES
C     LG    - LOGARITHM INDICATOR
C     NXG   - SIZE OF EXTENDED DATA/SPECTRUM ARRAY
C     XG    - DATA/SPECTRUM ARRAY
C     NG    - NUMBER OF SPECTRUM ESTIMATES IN XG
C     STATS - ARRAY OF SIZE 4 HOLDING
C     DEGREES OF FREEDOM,UPPER AND LOWER
C     CONFIDENCE LIMITS AND BANDWIDTH
C     IERROR- FAILURE INDICATOR
C
C
C     CALCULATE NG AND PI
C     .. Scalar Arguments ..
      DOUBLE PRECISION  PX
      INTEGER           IC, IERROR, IW, KC, L, LG, MTX, MW, NC, NG, NX,
     *                  NXG
C     .. Array Arguments ..
      DOUBLE PRECISION  C(NC), STATS(4), XG(NXG)
C     .. Local Scalars ..
      DOUBLE PRECISION  A, B, PI, S1, S2, S3
      INTEGER           I, IFAIL1, IR, J, LNK, M, NI, NK
C     .. External Functions ..
      DOUBLE PRECISION  G01FCF, G13CAW, X01AAF, X02AMF
      EXTERNAL          G01FCF, G13CAW, X01AAF, X02AMF
C     .. External Subroutines ..
      EXTERNAL          C06EAF, G13CAX, G13CAY
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, AINT, MAX, MOD, LOG, EXP, DBLE, SQRT, INT
C     .. Executable Statements ..
      NG = L/2 + 1
      S1 = 1.0D0
      PI = X01AAF(0.0D0)
C
C     JUMP IF G13CAF AND COVARIANCES SUPPLIED
      IF (IW.LE.4 .AND. IC.NE.0) GO TO 140
C
C
C     MEAN OR TREND CORRECT DATA
      CALL G13CAY(XG,NX,MTX)
C
C     APPLY SPLIT COSINE BELL TAPER
      M = INT(DBLE(NX)*PX/2.0D0)
      CALL G13CAX(XG,NX,M,PI)
C
C     PAD XG BY ZEROS TO LENGTH KC FOR FFT
      M = NX + 1
      DO 20 I = M, KC
         XG(I) = 0.0D0
   20 CONTINUE
C
C     TRANSFORM OF LENGTH KC
      IFAIL1 = 1
      CALL C06EAF(XG,KC,IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 40
      IERROR = 2
      GO TO 820
C     FORM MODULI
   40 XG(1) = XG(1)*XG(1)
      M = (KC+1)/2
      NI = KC + 1
      IF (M.LT.2) GO TO 80
      DO 60 I = 2, M
         NI = NI - 1
         S1 = XG(I)
         S2 = XG(NI)
         S3 = S1*S1 + S2*S2
         XG(I) = S3
         XG(NI) = S3
   60 CONTINUE
   80 M = M + 1
      IF (MOD(KC,2).EQ.0) XG(M) = XG(M)*XG(M)
C     JUMP OUT IF DANIELL WINDOW
      IF (IW.GT.4) GO TO 260
C     FORM COVARIANCES
      IFAIL1 = 1
      CALL C06EAF(XG,KC,IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 100
      IERROR = 2
      GO TO 820
  100 S1 = SQRT(DBLE(KC))
      DO 120 I = 1, NC
         C(I) = S1*XG(I)/DBLE(NX)
  120 CONTINUE
  140 CONTINUE
C
C     APPLY LAG WINDOW AND SET UP
C     SEQUENCE FOR FFT OF LENGTH L
      XG(1) = C(1)
      NI = L + 1
      IF (MW.EQ.1) GO TO 180
      A = DBLE(MW)
      DO 160 I = 2, MW
         NI = NI - 1
         S3 = DBLE(I-1)/A
         S1 = C(I)*G13CAW(IW,S3,PI)
         XG(I) = S1
         XG(NI) = S1
  160 CONTINUE
  180 M = MW + 1
      NI = NI - 1
      IF (M.GT.NI) GO TO 220
      DO 200 I = M, NI
         XG(I) = 0.0D0
  200 CONTINUE
  220 CONTINUE
C
C     TRANSFORM OF LENGTH L
      IFAIL1 = 1
      CALL C06EAF(XG,L,IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 240
      IERROR = 3
      GO TO 820
C
C     CALC SCALE FACTOR
  240 S3 = SQRT(DBLE(L))/(2.0D0*PI)
      S2 = 8.0D0/(8.0D0-5.0D0*PX)
      S3 = S3*S2
      GO TO 360
C
C     COME HERE FOR DANIELL WINDOW
  260 CONTINUE
C     ASCERTAIN R IN KC = R * L
      IR = KC/L
C     MAKE ROOM IN XG FOR THE NG SPECTRUM ESTIMATES
      S1 = XG(1)
      S2 = XG(M)
      A = 0.0D0
C
C     LOOP THROUGH WEIGHTS TO SMOOTH SPECTRUM
C
C     WEIGHT AT POINT ZERO
      B = 1.0D0
      A = A + B
      M = 1
C     LOOP THROUGH SPECTRUM ESTIMATES
      DO 280 I = 1, NG
         NK = MAX(M,KC+2-M)
         IF (NK.LT.NI) S3 = S2
         IF (NK.GE.NI .AND. NK.LE.KC) S3 = XG(NK)
         IF (NK.GT.KC) S3 = S1
         XG(I) = B*S3
         M = M + IR
  280 CONTINUE
      IF (MW.EQ.NX) GO TO 340
C
C     WEIGHTS AT POINTS +-I FROM POINT ZERO
      M = INT(DBLE(KC)/(2.0D0*DBLE(MW)))
      IF (M.LE.0) GO TO 340
      DO 320 I = 1, M
         S3 = 2.0D0*DBLE(MW*I)/DBLE(KC)
         B = 1.0D0
         IF (S3.GT.C(1)) B = (1.0D0-S3)/(1.0D0-C(1))
         A = A + 2.0D0*B
         LNK = I
C        LOOP THROUGH SPECTRUM ESTIMATES
C        FOR EACH FIXED WEIGHT AT POINT +-I
         DO 300 J = 1, NG
            NK = MOD(LNK,KC) + 1
            NK = MAX(NK,KC+2-NK)
            IF (NK.LT.NI) S3 = S2
            IF (NK.GE.NI .AND. NK.LE.KC) S3 = XG(NK)
            IF (NK.GT.KC) S3 = S1
            NK = ABS(LNK-2*I)
            NK = MOD(NK,KC) + 1
            NK = MAX(NK,KC+2-NK)
            IF (NK.LT.NI) S3 = S3 + S2
            IF (NK.GE.NI .AND. NK.LE.KC) S3 = S3 + XG(NK)
            IF (NK.GT.KC) S3 = S3 + S1
            XG(J) = XG(J) + B*S3
            LNK = LNK + IR
  300    CONTINUE
  320 CONTINUE
  340 CONTINUE
C
C     CALC SCALE FACTOR
      S3 = (8.0D0-5.0D0*PX)*2.0D0*PI*DBLE(NX)*A
      S3 = 8.0D0*DBLE(KC)/S3
C
C     OTHER WINDOWS REJOIN DANIELL HERE
C     APPLY SCALE FACTOR TO ESTIMATES
  360 DO 380 I = 1, NG
         XG(I) = XG(I)*S3
         IF (XG(I).LT.0.0D0) IERROR = 4
  380 CONTINUE
C
C     PAD ARRAY XG WITH ZEROS AFTER ESTIMATES
      M = NG + 1
      IF (M.GT.NXG) GO TO 420
      DO 400 I = M, NXG
         XG(I) = 0.0D0
  400 CONTINUE
  420 CONTINUE
C
C     CALCULATE DEGREES OF FREEDOM
      S2 = (128.0D0-93.0D0*PX)/(2.0D0*(8.0D0-5.0D0*PX)**2)
      GO TO (440,460,480,500,520) IW
  440 S1 = 1.0D0
      GO TO 560
  460 S1 = 1.0D0/3.0D0
      GO TO 560
  480 S1 = 3.0D0/8.0D0
      GO TO 560
  500 S1 = 151.0D0/560.0D0
      GO TO 560
  520 IF (MW.EQ.NX) GO TO 540
      S1 = 2.0D0*(1.0D0+2.0D0*C(1))/(3.0D0*(1.0D0+C(1))**2)
      GO TO 560
  540 STATS(1) = 2.0D0/S2
      GO TO 580
  560 STATS(1) = DBLE(NX)/(S1*S2*DBLE(MW))
  580 STATS(1) = AINT(STATS(1)+0.5D0)
C
C     CALCULATE BANDWIDTH
      IF (IW.EQ.5 .AND. MW.EQ.NX) GO TO 600
      STATS(4) = PI/(S1*DBLE(MW))
      GO TO 620
  600 STATS(4) = 2.0D0*PI/DBLE(NX)
  620 CONTINUE
C
C     CALCULATE LOWER AND UPPER 95 PERCENT LIMITS
      M = INT(STATS(1))
      S2 = 0.025D0
      IFAIL1 = 1
      A = G01FCF(S2,DBLE(M),IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 640
      IF (IERROR.NE.4) IERROR = 5
      GO TO 680
  640 S2 = 0.975D0
      IFAIL1 = 1
      B = G01FCF(S2,DBLE(M),IFAIL1)
      IF (IFAIL1.EQ.0) GO TO 660
      IF (IERROR.NE.4) IERROR = 5
      GO TO 680
  660 STATS(2) = STATS(1)/B
      STATS(3) = STATS(1)/A
C
C
C     TAKE LOGARITHMS-
  680 IF (LG.EQ.0 .OR. IERROR.EQ.4) GO TO 800
      A = LOG(X02AMF())
      B = EXP(A)
C
C     -OF ESTIMATES
      DO 720 I = 1, NG
         IF (XG(I).LT.B) GO TO 700
         XG(I) = LOG(XG(I))
         GO TO 720
  700    XG(I) = A
  720 CONTINUE
C
C     -OF CONFIDENCE LIMITS
      IF (IERROR.EQ.5) GO TO 800
      IF (STATS(2).LT.B) GO TO 740
      STATS(2) = LOG(STATS(2))
      GO TO 760
  740 STATS(2) = A
  760 IF (STATS(3).LT.B) GO TO 780
      STATS(3) = LOG(STATS(3))
      GO TO 800
  780 STATS(3) = A
  800 CONTINUE
C
C     TERMINATE
C
  820 RETURN
      END
