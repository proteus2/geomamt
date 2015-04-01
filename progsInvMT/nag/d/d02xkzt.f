      SUBROUTINE D02XKZ(T,K,YH,NYH,DKY,IFLAG,NEQ,ACOR,H,TN,HU,NQ)
C     MARK 12 RELEASE. NAG COPYRIGHT 1986.
C
C     OLD NAME INTDZ
C
C-----------------------------------------------------------------------
C  TIME INTERPOLATION ROUTINE FOR MULTISTEP METHODS BASED UPON
C  NORDSIECK VECTOR IMPLEMENTATIONS
C----------------------------------------------------------------------
C     .. Scalar Arguments ..
      DOUBLE PRECISION  H, HU, T, TN
      INTEGER           IFLAG, K, NEQ, NQ, NYH
C     .. Array Arguments ..
      DOUBLE PRECISION  ACOR(*), DKY(*), YH(NYH,*)
C     .. Scalars in Common ..
      DOUBLE PRECISION  DUNFLO, HHUSED, RD, UROUND
      INTEGER           IOVFLO
      LOGICAL           FNITER, PETZLD
      CHARACTER*6       ODCODE
C     .. Arrays in Common ..
      DOUBLE PRECISION  EL(13), ELCO(13,12), RDUM1(2), RDUM3(2),
     *                  TESCO(3,12)
      INTEGER           IDUMMY(14)
C     .. Local Scalars ..
      DOUBLE PRECISION  C, C1, C2, C3, DD, HRAT, R, S, TEM, TP
      INTEGER           I, IC, ID, IE, J, JB, JB2, JJ, JJ1, JP1, L, N
C     .. Local Arrays ..
      DOUBLE PRECISION  D(15)
C     .. External Subroutines ..
      EXTERNAL          D02NNQ
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, DBLE
C     .. Common blocks ..
      COMMON            /AD02XK/RDUM1, EL, ELCO, RD, TESCO, RDUM3,
     *                  IDUMMY
      COMMON            /BD02XK/HHUSED, PETZLD, FNITER
      COMMON            /FD02NM/DUNFLO, UROUND, IOVFLO
      COMMON            /ZD02NM/ODCODE
C     .. Save statement ..
      SAVE              /FD02NM/, /AD02XK/, /BD02XK/, /ZD02NM/
C     .. Executable Statements ..
C-----------------------------------------------------------------------
C D02XJZ COMPUTES INTERPOLATED VALUES OF THE K-TH DERIVATIVE OF THE
C DEPENDENT VARIABLE VECTOR Y, AND STORES IT IN DKY.  THIS ROUTINE
C IS CALLED WITHIN THE PACKAGE WITH K = 0 AND T = TOUT, BUT MAY
C ALSO BE CALLED BY THE USER FOR ANY K UP TO THE CURRENT ORDER.
C THE INPUT PARAMETERS ARE..
C
C T         = VALUE OF INDEPENDENT VARIABLE WHERE ANSWERS ARE DESIRED
C             (NORMALLY THE SAME AS THE T LAST RETURNED BY SPRINT).
C             FOR VALID RESULTS, T MUST LIE BETWEEN TCUR - HU AND TCUR.
C             (SEE OPTIONAL OUTPUTS FOR TCUR AND HU.)
C K         = INTEGER ORDER OF THE DERIVATIVE DESIRED.  K MUST SATISFY
C             0 .LE. K .LE. NQCUR, WHERE NQCUR IS THE CURRENT ORDER
C             (SEE OPTIONAL OUTPUTS).  THE CAPABILITY CORRESPONDING
C             TO K = 0, I.E. COMPUTING Y(T), IS ALREADY PROVIDED
C             BY SPRINT DIRECTLY.  SINCE NQCUR .GE. 1, THE FIRST
C             DERIVATIVE DY/DT IS ALWAYS AVAILABLE WITH D02XJZ.
C YH        = THE HISTORY ARRAY YH (NORDSIECK VECTOR).
C NYH       = COLUMN LENGTH OF YH, EQUAL TO THE INITIAL VALUE OF NEQMAX
C             IN THE CALL TO SPRINT
C NEQ       = THE NUMBER OF ORDINARY DIFFERENTIAL EQUATIONS
C
C ACOR(NEQ) = ESTIMATE OF CURRENT LOCAL ERROR GERNERATED BY THE D02NMX
C             CODE
C
C   THE NEXT FOUR PARAMETERS ARE PASSED ACROSS BY COMMON BLOCKS.
C H         = STEPSIZE PROPOSED   *
C             FOR THE NEXT STEP   *
C HU        = LAST STEPSIZE USED. *  THESE ARE PASSED ACROSS BY
C TN        = THE LAST TIME LEVEL.*  THE COMMON BLOCKS BD02NM AND DD02NM
C NQ        = THE ORDER USED.     *
C
C THE OUTPUT PARAMETERS ARE..
C
C DKY       = A REAL ARRAY OF LENGTH NEQ CONTAINING THE COMPUTED VALUE
C             OF THE K-TH DERIVATIVE OF Y(T).
C IFLAG     = INTEGER FLAG, RETURNED AS 0 IF K AND T WERE LEGAL,
C             -1 IF K WAS ILLEGAL, AND -2 IF T WAS ILLEGAL.
C             ON AN ERROR RETURN, A MESSAGE IS ALSO WRITTEN.
C             ON ENTRY IF IFLAG=0 EXTRAPOLATION IS NOT ALLOWED
C             FOR IFLAG OTHERWISE EXTRAPOLATION IS ALLOWED
C-----------------------------------------------------------------------
C THE COMPUTED VALUES IN DKY ARE GOTTEN BY INTERPOLATION USING THE
C NORDSIECK HISTORY ARRAY YH.  THIS ARRAY CORRESPONDS UNIQUELY TO A
C VECTOR-VALUED POLYNOMIAL OF DEGREE NQCUR OR LESS, AND DKY IS SET
C TO THE K-TH DERIVATIVE OF THIS POLYNOMIAL AT T.
C THE FORMULA FOR DKY IS..
C              Q
C  DKY(I)  =  SUM  C(J,K) * (T - TN)**(J-K) * H**(-J) * YH(I,J+1)
C             J=K
C WHERE  C(J,K) = J*(J-1)*...*(J-K+1), Q = NQCUR, TN = TCUR, H = HCUR.
C THE QUANTITIES  NQ = NQCUR, L = NQ+1, N = NEQ, TN, AND H ARE
C COMMUNICATED BY COMMON.  THE ABOVE SUM IS DONE IN REVERSE ORDER.
C IFLAG IS RETURNED NEGATIVE IF EITHER K OR T IS OUT OF BOUNDS.
C-----------------------------------------------------------------------
      N = NEQ
      L = NQ + 1
      IF (K.LT.0 .OR. K.GT.NQ) GO TO 240
      IF (ODCODE.NE.'D02NMX' .OR. PETZLD) GO TO 280
      TP = TN - HU*(1.0D0+100.0D0*UROUND)
      IF ((ABS(T-TN)).LE.(ABS(T*UROUND)*100.0D0) .OR. T.EQ.TN) THEN
         S = 0.0D0
         GO TO 20
      END IF
      IF ((T-TP)*(T-TN).GT.0.0D0 .AND. IFLAG.EQ.0) GO TO 260
      S = (T-TN)/H
C
C      SET UP D(I) COEFFS FOR C 1 INTERPOLANT
C
   20 HRAT = H/HU
      IFLAG = 0
      IF (H.EQ.HU) HRAT = 1.0D0
      TEM = HRAT*HRAT
      D(1) = 0.0D0
      D(2) = 0.0D0
      DO 40 I = 1, L
         D(I+2) = -ELCO(I,NQ)*TESCO(2,NQ)*TEM
         TEM = TEM*HRAT
   40 CONTINUE
C
      IC = 1
      ID = 1
      IE = 1
      IF (K.EQ.0) GO TO 80
      JJ1 = L - K
      DO 60 JJ = JJ1, NQ
         ID = ID*(JJ+1)
         IE = IE*(JJ+2)
         IC = IC*JJ
   60 CONTINUE
   80 C1 = DBLE(IC)
      C2 = DBLE(ID)
      C3 = DBLE(IE)
      DD = D(L)*C1 + S*(D(L+1)*C2+C3*D(L+2)*S)
      DO 100 I = 1, N
         DKY(I) = C1*YH(I,L) + ACOR(I)*DD
  100 CONTINUE
      IF (K.EQ.NQ) GO TO 200
      JB2 = NQ - K
      DO 180 JB = 1, JB2
         J = NQ - JB
         JP1 = J + 1
         IC = 1
         IF (K.EQ.0) GO TO 140
         JJ1 = JP1 - K
         DO 120 JJ = JJ1, J
            IC = IC*JJ
  120    CONTINUE
  140    C = DBLE(IC)
         DO 160 I = 1, N
            DKY(I) = C*(YH(I,JP1)+ACOR(I)*D(JP1)) + S*DKY(I)
  160    CONTINUE
  180 CONTINUE
      IF (K.EQ.0) RETURN
  200 R = H**(-K)
      DO 220 I = 1, N
         DKY(I) = R*DKY(I)
  220 CONTINUE
      RETURN
C
  240 CALL D02NNQ(
     *'        INTERNAL TIME INTERPOLATION ROUTINE               ERROR T
     *HE ORDER K (=I1) IS ILLEGAL',1,1,K,0,0,0.0D0,0.0D0)
      IFLAG = -1
      RETURN
  260 CALL D02NNQ(
     *'        INTERNAL TIME INTERPOLATION ROUTINE               ENTERED
     * WITH T (=R1) ILLEGAL',1,0,0,0,1,T,0.0D0)
      CALL D02NNQ(' T NOT IN INTERVAL TCUR - HU (= R1) TO TCUR (=R2)',1,
     *            0,0,0,2,TP,TN)
      IFLAG = -2
      RETURN
  280 CALL D02NNQ(
     *'        INTERNAL TIME INTERPOLATION ROUTINE               ENTERED
     * WITH B.D.F. INTEGRATOR AND PETZLD = .TRUE. OR WITH        AN ILLE
     *GAL INTEGRATOR',1,0,0,0,0,0.0D0,0.0D0)
      IFLAG = -3
      RETURN
      END
