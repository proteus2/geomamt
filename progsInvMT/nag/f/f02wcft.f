      SUBROUTINE F02WCF(M,N,MINMN,A,NRA,Q,NRQ,SV,PT,NRPT,WORK,LWORK,
     *                  IFAIL)
C     MARK 8 RELEASE. NAG COPYRIGHT 1979.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     WRITTEN BY S. HAMMARLING, MIDDLESEX POLYTECHNIC (SVDGN3)
C
C     F02WCF RETURNS THE SINGULAR VALUE DECOMPOSITION (SVD) OF
C     THE M*N MATRIX A GIVEN BY
C
C     A = Q*D*(P**T) ,
C
C     WHERE Q IS AN M*M ORTHOGONAL MATRIX, P IS AN N*N
C     ORTHOGONAL MATRIX AND D IS AN M*N DIAGONAL MATRIX WITH
C     NON-NEGATIVE DIAGONAL ELEMENTS, THESE BEING THE SINGULAR
C     VALUES OF A.
C
C     THE SINGULAR VALUES ARE RETURNED IN THE MIN(M,N) ELEMENT
C     VECTOR SV. THE FIRST MIN(M,N) COLUMNS OF Q AND THE FIRST
C     MIN(M,N) ROWS OF P**T ARE RETURNED.
C
C     INPUT PARAMETERS.
C
C     M     - THE NUMBER OF ROWS OF A. M MUST BE AT LEAST UNITY.
C
C     N     - THE NUMBER OF COLUMNS OF A. N MUST BE AT LEAST UNITY.
C
C     MINMN - MUST BE EQUAL TO THE MINIMUM OF M AND N.
C
C     A     - THE M*N REAL MATRIX TO BE FACTORIZED.
C
C     NRA   - ROW DIMENSION OF A AS DECLARED IN THE CALLING PROGRAM.
C             NRA MUST BE AT LEAST M.
C
C     NRQ   - ROW DIMENSION OF Q AS DECLARED IN THE CALLING PROGRAM.
C             NRQ MUST BE AT LEAST M.
C
C     NRPT  - ROW DIMENSION OF PT AS DECLARED IN THE CALLING PROGRAM
C             NRPT MUST BE AT LEAST MINMN.
C
C     IFAIL - THE USUAL FAILURE PARAMETER. IF IN DOUBT SET
C             IFAIL TO ZERO BEFORE CALLING F02WCF.
C
C     OUTPUT PARAMETERS.
C
C     Q     - AN M*MINMN MATRIX CONTAINING THE FIRST MINMN
C             COLUMNS OF THE LEFT-HAND ORTHOGONAL MATRIX OF
C             THE SVD.
C             THE ROUTINE MAY BE CALLED WITH Q=A, SO LONG
C             AS IT IS NOT CALLED WITH PT=A.
C
C     SV    - A MINMN ELEMENT VECTOR CONTAINING THE
C             SINGULAR VALUES OF A ARRANGED IN DESCENDING
C             SEQUENCE.
C
C     PT    - A MINMN*N MATRIX CONTAINING THE FIRST MINMN
C             ROWS OF THE MATRIX P**T.
C             THE ROUTINE MAY BE CALLED WITH PT=A, SO LONG
C             AS IT IS NOT CALLED WITH Q=A.
C
C     IFAIL - ON NORMAL RETURN IFAIL WILL BE ZERO.
C             IN THE UNLIKELY EVENT THAT THE QR-ALGORITHM
C             FAILS TO FIND THE SINGULAR VALUES IN 50*MINMN
C             ITERATIONS THEN IFAIL WILL BE 2 OR MORE AND
C             SUCH THAT SV(1),SV(2),..,SV(IFAIL-1) MAY NOT
C             HAVE BEEN FOUND. SEE WORK BELOW.
C             IF AN INPUT PARAMETER IS INCORRECTLY SUPPLIED
C             THEN IFAIL IS SET TO UNITY.
C
C     WORKSPACE PARAMETERS.
C
C     WORK  - EITHER A 3*MINMN ELEMENT VECTOR OR A
C             (3*MINMN+MINMN**2) ELEMENT VECTOR.
C             IF IFAIL IS 2 OR MORE ON RETURN THEN THE
C             MATRIX A IS GIVEN BY A=Q*B*(P**T), WHERE B IS
C             THE UPPER F01LZFONAL MATRIX WITH SV AS ITS
C             DIAGONAL AND ELEMENTS WORK(2),WORK(3),...,
C             WORK(MINMN) AS ITS SUPER-DIAGONAL.
C             WORK(1) RETURNS THE TOTAL NUMBER OF ITERATIONS TAKEN
C             BY THE QR-ALGORITHM.
C
C     LWORK - LENGTH OF THE VECTOR WORK.
C             LWORK MUST BE AT LEAST 3*MINMN, BUT UNLESS M
C             IS CLOSE TO N AND PROVIDED THAT SUFFICIENT
C             STORAGE IS AVAILABLE, THEN IT IS STRONGLY
C             RECOMMENDED THAT LWORK BE AT LEAST (3*MINMN +
C             MINMN**2).
C             IF M IS NOT CLOSE TO N THEN THE ROUTINE IS
C             LIKELY TO BE CONSIDERABLY FASTER WITH THE
C             LARGER VALUE OF LWORK.
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='F02WCF')
C     .. Scalar Arguments ..
      INTEGER           IFAIL, LWORK, M, MINMN, N, NRA, NRPT, NRQ
C     .. Array Arguments ..
      DOUBLE PRECISION  A(NRA,N), PT(NRPT,N), Q(NRQ,MINMN), SV(MINMN),
     *                  WORK(LWORK)
C     .. Local Scalars ..
      INTEGER           I, IERR, J, K1, K2, K3
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          F01LZF, F01QAF, F01QBF, F02SZF, F02WAY, F02WBY,
     *                  F02WBZ, F02WCX, F02WCY, F02WCZ
C     .. Intrinsic Functions ..
      INTRINSIC         MIN
C     .. Executable Statements ..
      IERR = IFAIL
      IF (IERR.EQ.0) IFAIL = 1
C
      IF (MINMN.NE.MIN(M,N) .OR. NRA.LT.M .OR. NRQ.LT.M .OR. NRPT.LT.
     *    MINMN .OR. LWORK.LT.3*MINMN .OR. M.LT.1 .OR. N.LT.1)
     *    GO TO 180
C
      K1 = MINMN + 1
      K2 = MINMN + K1
      IF (LWORK.LT.MINMN*(3+MINMN)) GO TO 60
C
      K3 = MINMN + K2
      IF (M.LT.N) GO TO 20
C
C     FAST SVD WITH M.GE.N FOLLOWS.
C
      CALL F01QAF(M,N,A,NRA,Q,NRQ,WORK(K1),IFAIL)
C
      CALL F01LZF(N,Q,NRQ,WORK(K3),N,.FALSE.,WORK,.TRUE.,.FALSE.,WORK,1,
     *            1,.FALSE.,WORK,1,1,SV,WORK,WORK,WORK,IFAIL)
C
      CALL F02WCZ(M,N,Q,NRQ,WORK(K1),Q,NRQ)
C
      CALL F02WAY(N,WORK(K3),N,PT,NRPT)
C
      CALL F02WCY(N,WORK(K3),N,WORK(K3),N,WORK(K1),WORK(K2))
C
      IFAIL = 1
      CALL F02SZF(N,SV,WORK,SV,.FALSE.,WORK,.TRUE.,WORK(K3)
     *            ,N,N,.TRUE.,PT,NRPT,N,WORK,WORK(K1),WORK(K2),IFAIL)
C
      CALL F02WCX(M,N,Q,NRQ,WORK(K3),N,WORK(K1),2*N)
C
      IF (IFAIL.EQ.0) RETURN
      GO TO 180
C
C     FAST SVD WITH M.LT.N FOLLOWS.
C
   20 CALL F01QBF(M,N,A,NRA,PT,NRPT,WORK(K1),IFAIL)
C
      CALL F01LZF(M,PT,NRPT,WORK(K3),M,.FALSE.,WORK,.TRUE.,.FALSE.,WORK,
     *            1,1,.FALSE.,WORK,1,1,SV,WORK,WORK,WORK,IFAIL)
C
      CALL F02WBZ(M,N,PT,NRPT,PT,NRPT,WORK(K1))
C
      CALL F02WCY(M,WORK(K3),M,Q,NRQ,WORK(K1),WORK(K2))
C
      CALL F02WAY(M,WORK(K3),M,WORK(K3),M)
C
      IFAIL = 1
      CALL F02SZF(M,SV,WORK,SV,.FALSE.,WORK,.TRUE.,Q,NRQ,M,.TRUE.,
     *            WORK(K3),M,M,WORK,WORK(K1),WORK(K2),IFAIL)
C
      DO 40 J = 1, N
C
         CALL F02WBY(M,M,WORK(K3),M,PT(1,J),PT(1,J),WORK(K1))
C
   40 CONTINUE
C
      IF (IFAIL.EQ.0) RETURN
      GO TO 180
C
   60 IF (M.LT.N) GO TO 120
C
C     SLOW SVD WITH M.GE.N FOLLOWS.
C
      CALL F01QAF(M,N,A,NRA,Q,NRQ,WORK(K1),IFAIL)
C
      DO 100 J = 1, N
         DO 80 I = 1, N
            PT(I,J) = Q(I,J)
   80    CONTINUE
  100 CONTINUE
C
      CALL F02WCZ(M,N,Q,NRQ,WORK(K1),Q,NRQ)
C
      CALL F01LZF(N,PT,NRPT,PT,NRPT,.FALSE.,WORK,.FALSE.,.TRUE.,Q,NRQ,M,
     *            .FALSE.,WORK,1,1,SV,WORK,WORK,WORK,IFAIL)
C
      CALL F02WAY(N,PT,NRPT,PT,NRPT)
C
      IFAIL = 1
      CALL F02SZF(N,SV,WORK,SV,.FALSE.,WORK,.TRUE.,Q,NRQ,M,.TRUE.,PT,
     *            NRPT,N,WORK,WORK(K1),WORK(K2),IFAIL)
C
      IF (IFAIL.EQ.0) RETURN
      GO TO 180
C
C     SLOW SVD WITH M.LT.N FOLLOWS.
C
  120 CALL F01QBF(M,N,A,NRA,PT,NRPT,WORK(K1),IFAIL)
C
      DO 160 J = 1, M
         DO 140 I = 1, M
            Q(I,J) = PT(I,J)
  140    CONTINUE
  160 CONTINUE
C
      CALL F02WBZ(M,N,PT,NRPT,PT,NRPT,WORK(K1))
C
      CALL F01LZF(M,Q,NRQ,Q,NRQ,.FALSE.,WORK,.TRUE.,.FALSE.,WORK,1,1,
     *            .TRUE.,PT,NRPT,N,SV,WORK,WORK(K1),WORK(K2),IFAIL)
C
      CALL F02WCY(M,Q,NRQ,Q,NRQ,WORK(K1),WORK(K2))
C
      IFAIL = 1
      CALL F02SZF(M,SV,WORK,SV,.FALSE.,WORK,.TRUE.,Q,NRQ,M,.TRUE.,PT,
     *            NRPT,N,WORK,WORK(K1),WORK(K2),IFAIL)
C
      IF (IFAIL.EQ.0) RETURN
C
  180 IFAIL = P01ABF(IERR,IFAIL,SRNAME,0,P01REC)
      RETURN
      END
