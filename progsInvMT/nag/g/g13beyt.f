      SUBROUTINE G13BEY(MPQS,NXSP,NBF,KFC,KEF,MT,MPAB,MQAB,KCP,MPSG,
     *                  MQSG,NP,NPS,NS,MSN,MSPA,MSPB,IMP,MOP,MIS,MRN)
C     MARK 11 RELEASE. NAG COPYRIGHT 1983.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     SUBROUTINE G13BEY ASSIGNS SUBSCRIPTS TO EACH OF THE 15
C     TYPES OF DERIVATIVE ASSOCIATED WITH THE Y SERIES,
C     AND TO EACH OF THE 8 TYPES ASSOCIATED WITH EACH INPUT SERIES,
C     TO INDICATE WHICH OF THE A(T),B(T) SETS IS RELEVANT.
C     IT ALSO GIVES THE NUMBER OF TIMES EACH SET IS TO BE REPEATED,
C     THE TOTAL NUMBER OF SETS, AND THE IDENTIFICATION AND
C     PROCESSING ORDER OF THE A(T),B(T) SETS
C
C
C     ZEROISE THE OUTPUT ARRAYS
C
C     .. Scalar Arguments ..
      INTEGER           IMP, KCP, KEF, KFC, NBF, NP, NPS, NS, NXSP
C     .. Array Arguments ..
      INTEGER           MIS(IMP), MOP(4), MPAB(15), MPQS(4), MPSG(15),
     *                  MQAB(8,NXSP), MQSG(8,NXSP), MRN(IMP), MSN(IMP),
     *                  MSPA(IMP), MSPB(IMP), MT(4,NXSP)
C     .. Local Scalars ..
      INTEGER           I, J, K, NGW, NNB, NNP, NNQ, NNR, NPX, NWD, NXS
C     .. External Subroutines ..
      EXTERNAL          G13BEN, G13BEP, G13BEX
C     .. Executable Statements ..
      DO 20 I = 1, 15
         MPSG(I) = 0
         MPAB(I) = 0
   20 CONTINUE
      DO 60 I = 1, 8
         DO 40 J = 1, NXSP
            MQSG(I,J) = 0
            MQAB(I,J) = 0
   40    CONTINUE
   60 CONTINUE
C
C     ASSIGN GENERAL RESIDUAL SERIES
C
      MPAB(1) = 1
      MPSG(1) = 1
      KCP = 1
C
C     ASSIGN ARIMA SET
C
      DO 80 I = 1, 4
         IF (MPQS(I).LE.0) GO TO 80
         KCP = KCP + 1
         MPAB(I+1) = KCP
         MPSG(I+1) = MPQS(I)
   80 CONTINUE
      IF (NBF.LE.0) GO TO 120
C
C     ASSIGN BACK FORECASTS
C
      KCP = KCP + 1
      MPAB(6) = KCP
      MPSG(6) = NBF
      IF (KEF.EQ.1) GO TO 120
C
C     ASSIGN BF*ARIMA COMBINATIONS
C
      DO 100 I = 1, 4
         IF (MPQS(I).LE.0) GO TO 100
         KCP = KCP + 1
         MPAB(I+6) = KCP
  100 CONTINUE
  120 IF (KFC.LE.0) GO TO 160
C
C     ASSIGN CONSTANT
C
      KCP = KCP + 1
      MPAB(11) = KCP
      MPSG(11) = 1
      IF (KEF.NE.3) GO TO 160
C
C     ASSIGN CONSTANT*ARIMA COMBINATIONS
C
      DO 140 I = 1, 4
         IF (MPQS(I).LE.0) GO TO 140
         KCP = KCP + 1
         MPAB(I+11) = KCP
  140 CONTINUE
  160 IF (NXSP.LE.1) GO TO 280
      NXS = NXSP - 1
C
C     PROCESS EACH INPUT SERIES IN TURN
C
      DO 260 I = 1, NXS
C
C        DERIVE NUMBERS OF OMEGAS,DELTAS AND PRE-XS
C
         CALL G13BEX(MT,I,NXSP,NNB,NNP,NNQ,NNR,NWD,NGW,NPX)
C
C        ASSIGN DELTA
C
         IF (NGW.EQ.NWD) GO TO 180
         KCP = KCP + 1
         MQAB(1,I) = KCP
         MQSG(1,I) = NWD - NGW
C
C        ASSIGN PRE-X
C
  180    IF (NNR.NE.3) GO TO 200
         KCP = KCP + 1
         MQAB(2,I) = KCP
         MQSG(2,I) = NPX
  200    KCP = KCP + 1
C
C        ASSIGN T.F. OMEGA
C
         IF (NNR.EQ.1) GO TO 220
         MQAB(8,I) = KCP
         MQSG(8,I) = NGW
         GO TO 260
C
C        ASSIGN SIMPLE OMEGA
C
  220    MQAB(3,I) = KCP
         MQSG(3,I) = 1
         IF (KEF.NE.3) GO TO 260
C
C        ASSIGN SIMPLE OMEGA*ARIMA COMBINATIONS
C
         DO 240 J = 1, 4
            IF (MPQS(J).LE.0) GO TO 240
            KCP = KCP + 1
            MQAB(J+3,I) = KCP
  240    CONTINUE
  260 CONTINUE
C
C     DERIVE MSN(PROCESSING ORDER), MSPA AND MSPB(RELATIVE START
C     POINTS), MIS AND MRN(MEANS OF IDENTITY) FOR SUCCESSIVELY
C     THE GENERAL DERIVATIVE SERIES,THE BACK-FORECASTS,THE CONSTANT,
C     SIMPLE OMEGA,PRE-X,T.F. OMEGAS AND DELTAS, AND
C     THE ARIMA PARAMETERS
C
  280 MSN(1) = 1
      MSPA(1) = 0
      MSPB(1) = 0
      MIS(1) = 0
      MRN(1) = 1
      K = 1
      CALL G13BEP(MPAB,MPSG,6,MSN,MSPA,MSPB,IMP,K,1,1,0,MIS,MRN)
      MOP(1) = K
      CALL G13BEP(MPAB,MPSG,11,MSN,MSPA,MSPB,IMP,K,1,1,0,MIS,MRN)
      IF (NXSP.LE.1) GO TO 300
      CALL G13BEN(MQAB,MQSG,1,NXS,NXSP,3,MSN,MSPA,MSPB,IMP,K,1,1,MIS,
     *            MRN)
  300 MOP(2) = K
      IF (NXSP.LE.1) GO TO 320
      CALL G13BEN(MQAB,MQSG,1,NXS,NXSP,2,MSN,MSPA,MSPB,IMP,K,1,1,MIS,
     *            MRN)
  320 MOP(3) = K
      IF (NXSP.LE.1) GO TO 360
      DO 340 J = 1, NXS
         CALL G13BEN(MQAB,MQSG,J,J,NXSP,8,MSN,MSPA,MSPB,IMP,K,1,1,MIS,
     *               MRN)
         CALL G13BEN(MQAB,MQSG,J,J,NXSP,1,MSN,MSPA,MSPB,IMP,K,0,1,MIS,
     *               MRN)
  340 CONTINUE
  360 J = -NP
      CALL G13BEP(MPAB,MPSG,2,MSN,MSPA,MSPB,IMP,K,0,1,J,MIS,MRN)
      CALL G13BEP(MPAB,MPSG,3,MSN,MSPA,MSPB,IMP,K,0,1,0,MIS,MRN)
      J = -(NS*NPS)
      CALL G13BEP(MPAB,MPSG,4,MSN,MSPA,MSPB,IMP,K,0,NS,J,MIS,MRN)
      CALL G13BEP(MPAB,MPSG,5,MSN,MSPA,MSPB,IMP,K,0,NS,0,MIS,MRN)
      MOP(4) = K
      RETURN
      END