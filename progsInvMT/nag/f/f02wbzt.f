      SUBROUTINE F02WBZ(M,N,C,NRC,PT,NRPT,WORK)
C     MARK 8 RELEASE. NAG COPYRIGHT 1979.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 13 REVISED. USE OF MARK 12 X02 FUNCTIONS (APR 1988).
C     WRITTEN BY S. HAMMARLING, MIDDLESEX POLYTECHNIC (GIVNPT)
C
C     F02WBZ RETURNS THE FIRST M ROWS OF THE N*N ORTHOGONAL
C     MATRIX Q FOR THE FACTORIZATION OF ROUTINE F01QBF
C
C     M MUST NOT BE LARGER THAN N
C
C     DETAILS OF Q MUST BE SUPPLIED IN THE M*N MATRIX C AS
C     RETURNED FROM ROUTINE F01QBF.
C
C     Q IS RETURNED IN THE M*N MATRIX PT.
C
C     THE ROUTINE MAY BE CALLED WITH PT=C.
C
C     NRC AND NRPT MUST BE THE ROW DIMENSIONS OF C AND PT
C     RESPECTIVELY AS DECLARED IN THE CALLING PROGRAM AND MUST
C     EACH BE AT LEAST M.
C
C     THE M ELEMENT VECTOR WORK IS REQUIRED FOR INTERNAL WORKSPACE.
C
C     .. Scalar Arguments ..
      INTEGER           M, N, NRC, NRPT
C     .. Array Arguments ..
      DOUBLE PRECISION  C(NRC,N), PT(NRPT,N), WORK(M)
C     .. Local Scalars ..
      DOUBLE PRECISION  BIG, CS, RSQTPS, SN, SQTEPS
      INTEGER           I, J, JF, JL, K, KM1, MP1
C     .. External Functions ..
      DOUBLE PRECISION  X02AJF, X02AMF
      EXTERNAL          X02AJF, X02AMF
C     .. External Subroutines ..
      EXTERNAL          F01LZW, F01LZY
C     .. Intrinsic Functions ..
      INTRINSIC         SQRT
C     .. Executable Statements ..
      BIG = 1.0D0/X02AMF()
      SQTEPS = SQRT(X02AJF())
      RSQTPS = 1.0D0/SQTEPS
C
      MP1 = M + 1
      DO 160 K = 1, M
         IF (K.EQ.1) GO TO 40
         KM1 = K - 1
C
         DO 20 I = 1, KM1
            WORK(I) = 0.0D0
   20    CONTINUE
C
   40    WORK(K) = 1.0D0
         JF = MP1
         IF (M.EQ.N) GO TO 100
         JL = N
C
   60    DO 80 J = JF, JL
C
            CALL F01LZW(-C(K,J),CS,SN,SQTEPS,RSQTPS,BIG)
C
            PT(K,J) = 0.0D0
C
            CALL F01LZY(K,CS,SN,WORK,PT(1,J))
C
   80    CONTINUE
C
  100    IF (JF.EQ.1 .OR. K.EQ.1) GO TO 120
         JF = 1
         JL = KM1
         GO TO 60
C
  120    DO 140 I = 1, K
            PT(I,K) = WORK(I)
  140    CONTINUE
C
  160 CONTINUE
C
      RETURN
      END
