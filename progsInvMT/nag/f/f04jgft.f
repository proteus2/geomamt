      SUBROUTINE F04JGF(M,N,A,NRA,B,TOL,SVD,SIGMA,IRANK,WORK,LWORK,
     *                  IFAIL)
C     MARK 8 RELEASE. NAG COPYRIGHT 1979.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     WRITTEN BY S. HAMMARLING, MIDDLESEX POLYTECHNIC (SVDLS4)
C
C     F04JGF RETURNS THE N ELEMENT VECTOR X, OF MINIMAL
C     LENGTH, THAT MINIMIZES THE EUCLIDEAN LENGTH OF THE M
C     ELEMENT VECTOR R GIVEN BY
C
C     R = B-A*X ,
C
C     WHERE A IS AN M*N (M.GE.N) MATRIX AND B IS AN M ELEMENT
C     VECTOR. X IS OVERWRITTEN ON B.
C
C     THE HOUSEHOLDER QU FACTORIZATION OF A GIVEN BY
C
C     A = Q*(U) ,
C           (0)
C
C     WHERE Q IS ORTHOGONAL AND U IS UPPER TRIANGULAR, IS
C     COMPUTED FIRST.
C
C     IF U IS NON-SINGULAR THEN THE LEAST SQUARES SOLUTION, X,
C     IS OBTAINED VIA THE QU FACTORIZATION.
C
C     ON THE OTHER HAND IF U IS SINGULAR THEN THE SINGULAR VALUE
C     DECOMPOSITION (SVD) OF U IS COMPUTED. THIS, TOGETHER
C     WITH THE QU FACTORIZATION, GIVES THE SVD OF A GIVEN BY
C
C     A = Q1*(D)*(P**T) ,
C            (0)
C
C     WHERE Q1 AND P ARE ORTHOGONAL AND D IS A DIAGONAL MATRIX WITH
C     NON-NEGATIVE DIAGONAL ELEMENTS, THESE BEING THE SINGULAR
C     VALUES OF A.
C
C     IN THIS CASE THE MINIMAL LEAST SQUARES SOLUTION, X, IS
C     OBTAINED VIA THE SVD OF A.
C
C     DECISIONS ON SINGULARITY AND RANK ARE BASED UPON THE
C     USER SUPPLIED PARAMETER TOL.
C
C     INPUT PARAMETERS.
C
C     M     - NUMBER OF ROWS OF A. M MUST BE AT LEAST N.
C
C     N     - NUMBER OF COLUMNS OF A. N MUST BE AT LEAST UNITY.
C
C     A     - AN M*N REAL MATRIX.
C
C     NRA   - ROW DIMENSION OF A AS DECLARED IN THE CALLING PROGRAM.
C             NRA MUST BE AT LEAST M.
C
C     B     - AN M ELEMENT REAL VECTOR.
C
C     TOL   - A RELATIVE TOLERANCE USED TO DETERMINE THE RANK OF A.
C             TOL SHOULD BE CHOSEN AS APPROXIMATELY THE
C             LARGEST RELATIVE ERROR IN THE ELEMENTS OF A.
C             FOR EXAMPLE IF THE ELEMENTS OF A ARE CORRECT
C             TO ABOUT 4 SIGNIFICANT FIGURES THEN TOL
C             SHOULD BE CHOSEN AS ABOUT 5.0*10.0**(-4).
C
C     IFAIL - THE USUAL FAILURE PARAMETER. IF IN DOUBT SET
C             IFAIL TO ZERO BEFORE CALLING THIS ROUTINE.
C
C
C     OUTPUT PARAMETERS.
C
C     A     - IF SVD IS RETURNED AS .TRUE. THEN THE TOP N*N
C             PART OF A CONTAINS THE ORTHOGONAL MATRIX P**T
C             OF THE SVD OF A. IN THIS CASE THE REMAINDER
C             OF A IS USED FOR INTERNAL WORKSPACE.
C             IF SVD IS RETURNED AS .FALSE. THEN A,
C             TOGETHER WITH THE FIRST N ELEMENTS OF THE
C             VECTOR WORK, CONTAINS DETAILS OF THE
C             HOUSEHOLDER QU FACTORIZATION OF A AS RETURNED
C             FROM  ROUTINE F01QAF.
C
C     B     - THE FIRST N ELEMENTS OF B WILL CONTAIN THE
C             SOLUTION VECTOR X.
C
C     SVD   - WILL BE .TRUE. IF THE SVD OF A HAS BEEN
C             COMPUTED AND WILL BE .FALSE. IF ONLY THE QU
C             FACTORIZATION OF A HAS BEEN COMPUTED.
C             IT SHOULD BE NOTED THAT IT IS POSSIBLE FOR SVD TO BE
C             .TRUE. AND FOR IRANK TO BE N. SUCH AN
C             OCCURANCE MEANS THAT THE MATRIX U ONLY JUST
C             FAILED THE TEST FOR NON-SINGULARITY.
C
C     SIGMA - IF M IS GREATER THAN IRANK THEN SIGMA WILL CONTAIN THE
C             STANDARD ERROR GIVEN BY
C             SIGMA=L(R)/SQRT(M-IRANK), WHERE L(R) DENOTES
C             THE EUCLIDEAN LENGTH OF THE RESIDUAL VECTOR
C             R. IF M=IRANK THEN SIGMA IS RETURNED AS ZERO.
C
C     IRANK - THE RANK OF THE MATRIX A.
C
C     IFAIL - ON NORMAL RETURN IFAIL WILL BE ZERO.
C             IN THE UNLIKELY EVENT THAT THE QR ALGORITHM
C             FAILS TO FIND THE SINGULAR VALUES IN 50*N
C             ITERATIONS THEN IFAIL IS SET TO 2. THIS
C             FAILURE CANNOT OCCUR IF THE SVD OF A IS NOT
C             COMPUTED.
C             IF AN INPUT PARAMETER IS INCORRECTLY SUPPLIED
C             THEN IFAIL IS SET TO UNITY.
C
C     WORKSPACE PARAMETERS.
C
C     WORK  - A 4*N ELEMENT VECTOR.
C             IF SVD IS RETURNED AS .TRUE. THEN THE FIRST N
C             ELEMENTS OF WORK WILL CONTAIN THE SINGULAR
C             VALUES OF A ARRANGED IN DESCENDING ORDER.
C             IF SVD IS RETURNED AS .FALSE. THEN THE FIRST
C             N ELEMENTS OF WORK WILL CONTAIN INFORMATION
C             ON THE QU FACTORIZATION OF A. SEE OUTPUT
C             PARAMETER A ABOVE.
C             IF SVD IS RETURNED AS .FALSE. THEN WORK(N+1)
C             WILL CONTAIN THE CONDITION NUMBER
C             L(U)*L(U**(-1)) OF THE UPPER TRIANGULAR
C             MATRIX U.
C             IF SVD IS RETURNED AS .TRUE. THEN WORK(N+1) WILL
C             CONTAIN THE TOTAL NUMBER OF ITERATIONS TAKEN BY THE
C             QR-ALGORITHM.
C
C     LWORK - THE LENGTH OF THE VECTOR WORK. LWORK MUST BE
C             AT LEAST 4*N.
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='F04JGF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  SIGMA, TOL
      INTEGER           IFAIL, IRANK, LWORK, M, N, NRA
      LOGICAL           SVD
C     .. Array Arguments ..
      DOUBLE PRECISION  A(NRA,N), B(M), WORK(LWORK)
C     .. Local Scalars ..
      INTEGER           IERR, NP1, NP2
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          F02WDF, F04JGZ
C     .. Executable Statements ..
      IERR = IFAIL
      IF (IERR.EQ.0) IFAIL = 1
C
      IF (M.LT.N .OR. NRA.LT.M .OR. N.LT.1 .OR. LWORK.LT.4*N)
     *    GO TO 40
C
      NP1 = N + 1
      NP2 = NP1 + 1
      SVD = .FALSE.
C
      CALL F02WDF(M,N,A,NRA,.TRUE.,B,TOL,SVD,IRANK,WORK,WORK,.FALSE.,
     *            WORK,1,.TRUE.,A,NRA,WORK(NP1),LWORK-N,IFAIL)
C
      IF (IFAIL.NE.0) GO TO 20
C
      CALL F04JGZ(M,N,SVD,IRANK,B,A,NRA,WORK,N,B,SIGMA,WORK(NP2),IFAIL)
C
      RETURN
C
   20 IFAIL = 2
   40 IFAIL = P01ABF(IERR,IFAIL,SRNAME,0,P01REC)
      RETURN
      END
