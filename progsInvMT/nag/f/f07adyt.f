      SUBROUTINE F07ADY(N,A,LDA,K1,K2,IPIV,INCX)
C     MARK 15 RELEASE. NAG COPYRIGHT 1991.
C     ENTRY             DLASWP(N,A,LDA,K1,K2,IPIV,INCX)
C
C  Purpose
C  =======
C
C  DLASWP performs a series of row interchanges on the matrix A.
C  One row interchange is initiated for each of rows K1 through K2 of A.
C
C  Arguments
C  =========
C
C  N       (input) INTEGER
C          The number of columns of the matrix A.
C
C  A       (input/output) REAL array, dimension (LDA,N)
C          On entry, the matrix of column dimension N to which the row
C          interchanges will be applied.
C          On exit, the permuted matrix.
C
C  LDA     (input) INTEGER
C          The leading dimension of the array A.
C
C  K1      (input) INTEGER
C          The first element of IPIV for which a row interchange will
C          be done.
C
C  K2      (input) INTEGER
C          The last element of IPIV for which a row interchange will
C          be done.
C
C  IPIV    (input) INTEGER array, dimension( M*abs(INCX) )
C          The vector of pivot indices.  Only the elements in positions
C          K1 through K2 of IPIV are accessed.
C          IPIV(K) = L implies rows K and L are to be interchanged.
C
C  INCX    (input) INTEGER
C          The increment between succesive values of IPIV.  If IPIV
C          is negative, the pivots are applied in reverse order.
C
C
C  -- LAPACK auxiliary routine (adapted for NAG Library)
C     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
C     Courant Institute, Argonne National Lab, and Rice University
C
C     .. Scalar Arguments ..
      INTEGER           INCX, K1, K2, LDA, N
C     .. Array Arguments ..
      DOUBLE PRECISION  A(LDA,*)
      INTEGER           IPIV(*)
C     .. Local Scalars ..
      INTEGER           I, IP, IX
C     .. External Subroutines ..
      EXTERNAL          DSWAP
C     .. Executable Statements ..
C
C     Interchange row I with row IPIV(I) for each of rows K1 through K2.
C
      IF (INCX.EQ.0) RETURN
      IF (INCX.GT.0) THEN
         IX = K1
      ELSE
         IX = 1 + (1-K2)*INCX
      END IF
      IF (INCX.EQ.1) THEN
         DO 20 I = K1, K2
            IP = IPIV(I)
            IF (IP.NE.I) CALL DSWAP(N,A(I,1),LDA,A(IP,1),LDA)
   20    CONTINUE
      ELSE IF (INCX.GT.1) THEN
         DO 40 I = K1, K2
            IP = IPIV(IX)
            IF (IP.NE.I) CALL DSWAP(N,A(I,1),LDA,A(IP,1),LDA)
            IX = IX + INCX
   40    CONTINUE
      ELSE IF (INCX.LT.0) THEN
         DO 60 I = K2, K1, -1
            IP = IPIV(IX)
            IF (IP.NE.I) CALL DSWAP(N,A(I,1),LDA,A(IP,1),LDA)
            IX = IX + INCX
   60    CONTINUE
      END IF
C
      RETURN
C
C     End of F07ADY (DLASWP)
C
      END
