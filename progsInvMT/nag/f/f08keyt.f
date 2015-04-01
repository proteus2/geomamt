      SUBROUTINE F08KEY(M,N,NB,A,LDA,D,E,TAUQ,TAUP,X,LDX,Y,LDY)
C     MARK 16 RELEASE. NAG COPYRIGHT 1992.
C     ENTRY             DLABRD(M,N,NB,A,LDA,D,E,TAUQ,TAUP,X,LDX,Y,LDY)
C
C  Purpose
C  =======
C
C  DLABRD reduces the first NB rows and columns of a real general
C  m by n matrix A to upper or lower bidiagonal form by an orthogonal
C  transformation Q' * A * P, and returns the matrices X and Y which
C  are needed to apply the transformation to the unreduced part of A.
C
C  If m >= n, A is reduced to upper bidiagonal form; if m < n, to lower
C  bidiagonal form.
C
C  This is an auxiliary routine called by DGEBRD
C
C  Arguments
C  =========
C
C  M       (input) INTEGER
C          The number of rows in the matrix A.
C
C  N       (input) INTEGER
C          The number of columns in the matrix A.
C
C  NB      (input) INTEGER
C          The number of leading rows and columns of A to be reduced.
C
C  A       (input/output) DOUBLE PRECISION array, dimension (LDA,N)
C          On entry, the m by n general matrix to be reduced.
C          On exit, the first NB rows and columns of the matrix are
C          overwritten; the rest of the array is unchanged.
C          If m >= n, elements on and below the diagonal in the first NB
C            columns, with the array TAUQ, represent the orthogonal
C            matrix Q as a product of elementary reflectors; and
C            elements above the diagonal in the first NB rows, with the
C            array TAUP, represent the orthogonal matrix P as a product
C            of elementary reflectors.
C          If m < n, elements below the diagonal in the first NB
C            columns, with the array TAUQ, represent the orthogonal
C            matrix Q as a product of elementary reflectors, and
C            elements on and above the diagonal in the first NB rows,
C            with the array TAUP, represent the orthogonal matrix P as
C            a product of elementary reflectors.
C          See Further Details.
C
C  LDA     (input) INTEGER
C          The leading dimension of the array A.  LDA >= max(1,M).
C
C  D       (output) DOUBLE PRECISION array, dimension (NB)
C          The diagonal elements of the first NB rows and columns of
C          the reduced matrix.  D(i) = A(i,i).
C
C  E       (output) DOUBLE PRECISION array, dimension (NB)
C          The off-diagonal elements of the first NB rows and columns of
C          the reduced matrix.
C
C  TAUQ    (output) DOUBLE PRECISION array dimension (NB)
C          The scalar factors of the elementary reflectors which
C          represent the orthogonal matrix Q. See Further Details.
C
C  TAUP    (output) DOUBLE PRECISION array, dimension (NB)
C          The scalar factors of the elementary reflectors which
C          represent the orthogonal matrix P. See Further Details.
C
C  X       (output) DOUBLE PRECISION array, dimension (LDX,NB)
C          The m-by-nb matrix X required to update the unreduced part
C          of A.
C
C  LDX     (input) INTEGER
C          The leading dimension of the array X. LDX >= M.
C
C  Y       (output) DOUBLE PRECISION array, dimension (LDY,NB)
C          The n-by-nb matrix Y required to update the unreduced part
C          of A.
C
C  LDY     (output) INTEGER
C          The leading dimension of the array Y. LDY >= N.
C
C  Further Details
C  ===============
C
C  The matrices Q and P are represented as products of elementary
C  reflectors:
C
C     Q = H(1) H(2) . . . H(nb)  and  P = G(1) G(2) . . . G(nb)
C
C  Each H(i) and G(i) has the form:
C
C     H(i) = I - tauq * v * v'  and G(i) = I - taup * u * u'
C
C  where tauq and taup are real scalars, and v and u are real vectors.
C
C  If m >= n, v(1:i-1) = 0, v(i) = 1, and v(i:m) is stored on exit in
C  A(i:m,i); u(1:i) = 0, u(i+1) = 1, and u(i+1:n) is stored on exit in
C  A(i,i+1:n); tauq is stored in TAUQ(i) and taup in TAUP(i).
C
C  If m < n, v(1:i) = 0, v(i+1) = 1, and v(i+1:m) is stored on exit in
C  A(i+2:m,i); u(1:i-1) = 0, u(i) = 1, and u(i:n) is stored on exit in
C  A(i,i+1:n); tauq is stored in TAUQ(i) and taup in TAUP(i).
C
C  The elements of the vectors v and u together form the m-by-nb matrix
C  V and the nb-by-n matrix U' which are needed, with X and Y, to apply
C  the transformation to the unreduced part of the matrix, using a block
C  update of the form:  A := A - V*Y' - X*U'.
C
C  The contents of A on exit are illustrated by the following examples
C  with nb = 2:
C
C  m = 6 and n = 5 (m > n):          m = 5 and n = 6 (m < n):
C
C    (  1   1   u1  u1  u1 )           (  1   u1  u1  u1  u1  u1 )
C    (  v1  1   1   u2  u2 )           (  1   1   u2  u2  u2  u2 )
C    (  v1  v2  a   a   a  )           (  v1  1   a   a   a   a  )
C    (  v1  v2  a   a   a  )           (  v1  v2  a   a   a   a  )
C    (  v1  v2  a   a   a  )           (  v1  v2  a   a   a   a  )
C    (  v1  v2  a   a   a  )
C
C  where a denotes an element of the original matrix which is unchanged,
C  vi denotes an element of the vector defining H(i), and ui an element
C  of the vector defining G(i).
C
C  -- LAPACK auxiliary routine (adapted for NAG Library)
C     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
C     Courant Institute, Argonne National Lab, and Rice University
C
C  =====================================================================
C
C     .. Parameters ..
      DOUBLE PRECISION  ZERO, ONE
      PARAMETER         (ZERO=0.0D0,ONE=1.0D0)
C     .. Scalar Arguments ..
      INTEGER           LDA, LDX, LDY, M, N, NB
C     .. Array Arguments ..
      DOUBLE PRECISION  A(LDA,*), D(*), E(*), TAUP(*), TAUQ(*),
     *                  X(LDX,*), Y(LDY,*)
C     .. Local Scalars ..
      INTEGER           I
C     .. External Subroutines ..
      EXTERNAL          DGEMV, DSCAL, F08AEV
C     .. Intrinsic Functions ..
      INTRINSIC         MIN
C     .. Executable Statements ..
C
C     Quick return if possible
C
      IF (M.LE.0 .OR. N.LE.0) RETURN
C
      IF (M.GE.N) THEN
C
C        Reduce to upper bidiagonal form
C
         DO 20 I = 1, NB
C
C           Update A(i:m,i)
C
            CALL DGEMV('No transpose',M-I+1,I-1,-ONE,A(I,1),LDA,Y(I,1),
     *                 LDY,ONE,A(I,I),1)
            CALL DGEMV('No transpose',M-I+1,I-1,-ONE,X(I,1),LDX,A(1,I),
     *                 1,ONE,A(I,I),1)
C
C           Generate reflection Q(i) to annihilate A(i+1:m,i)
C
            CALL F08AEV(M-I+1,A(I,I),A(MIN(I+1,M),I),1,TAUQ(I))
            D(I) = A(I,I)
            IF (I.LT.N) THEN
               A(I,I) = ONE
C
C              Compute Y(i+1:n,i)
C
               CALL DGEMV('Transpose',M-I+1,N-I,ONE,A(I,I+1),LDA,A(I,I),
     *                    1,ZERO,Y(I+1,I),1)
               CALL DGEMV('Transpose',M-I+1,I-1,ONE,A(I,1),LDA,A(I,I),1,
     *                    ZERO,Y(1,I),1)
               CALL DGEMV('No transpose',N-I,I-1,-ONE,Y(I+1,1),LDY,
     *                    Y(1,I),1,ONE,Y(I+1,I),1)
               CALL DGEMV('Transpose',M-I+1,I-1,ONE,X(I,1),LDX,A(I,I),1,
     *                    ZERO,Y(1,I),1)
               CALL DGEMV('Transpose',I-1,N-I,-ONE,A(1,I+1),LDA,Y(1,I),
     *                    1,ONE,Y(I+1,I),1)
               CALL DSCAL(N-I,TAUQ(I),Y(I+1,I),1)
C
C              Update A(i,i+1:n)
C
               CALL DGEMV('No transpose',N-I,I,-ONE,Y(I+1,1),LDY,A(I,1),
     *                    LDA,ONE,A(I,I+1),LDA)
               CALL DGEMV('Transpose',I-1,N-I,-ONE,A(1,I+1),LDA,X(I,1),
     *                    LDX,ONE,A(I,I+1),LDA)
C
C              Generate reflection P(i) to annihilate A(i,i+2:n)
C
               CALL F08AEV(N-I,A(I,I+1),A(I,MIN(I+2,N)),LDA,TAUP(I))
               E(I) = A(I,I+1)
               A(I,I+1) = ONE
C
C              Compute X(i+1:m,i)
C
               CALL DGEMV('No transpose',M-I,N-I,ONE,A(I+1,I+1),LDA,
     *                    A(I,I+1),LDA,ZERO,X(I+1,I),1)
               CALL DGEMV('Transpose',N-I,I,ONE,Y(I+1,1),LDY,A(I,I+1),
     *                    LDA,ZERO,X(1,I),1)
               CALL DGEMV('No transpose',M-I,I,-ONE,A(I+1,1),LDA,X(1,I),
     *                    1,ONE,X(I+1,I),1)
               CALL DGEMV('No transpose',I-1,N-I,ONE,A(1,I+1),LDA,
     *                    A(I,I+1),LDA,ZERO,X(1,I),1)
               CALL DGEMV('No transpose',M-I,I-1,-ONE,X(I+1,1),LDX,
     *                    X(1,I),1,ONE,X(I+1,I),1)
               CALL DSCAL(M-I,TAUP(I),X(I+1,I),1)
            END IF
   20    CONTINUE
      ELSE
C
C        Reduce to lower bidiagonal form
C
         DO 40 I = 1, NB
C
C           Update A(i,i:n)
C
            CALL DGEMV('No transpose',N-I+1,I-1,-ONE,Y(I,1),LDY,A(I,1),
     *                 LDA,ONE,A(I,I),LDA)
            CALL DGEMV('Transpose',I-1,N-I+1,-ONE,A(1,I),LDA,X(I,1),LDX,
     *                 ONE,A(I,I),LDA)
C
C           Generate reflection P(i) to annihilate A(i,i+1:n)
C
            CALL F08AEV(N-I+1,A(I,I),A(I,MIN(I+1,N)),LDA,TAUP(I))
            D(I) = A(I,I)
            IF (I.LT.M) THEN
               A(I,I) = ONE
C
C              Compute X(i+1:m,i)
C
               CALL DGEMV('No transpose',M-I,N-I+1,ONE,A(I+1,I),LDA,
     *                    A(I,I),LDA,ZERO,X(I+1,I),1)
               CALL DGEMV('Transpose',N-I+1,I-1,ONE,Y(I,1),LDY,A(I,I),
     *                    LDA,ZERO,X(1,I),1)
               CALL DGEMV('No transpose',M-I,I-1,-ONE,A(I+1,1),LDA,
     *                    X(1,I),1,ONE,X(I+1,I),1)
               CALL DGEMV('No transpose',I-1,N-I+1,ONE,A(1,I),LDA,A(I,I)
     *                    ,LDA,ZERO,X(1,I),1)
               CALL DGEMV('No transpose',M-I,I-1,-ONE,X(I+1,1),LDX,
     *                    X(1,I),1,ONE,X(I+1,I),1)
               CALL DSCAL(M-I,TAUP(I),X(I+1,I),1)
C
C              Update A(i+1:m,i)
C
               CALL DGEMV('No transpose',M-I,I-1,-ONE,A(I+1,1),LDA,
     *                    Y(I,1),LDY,ONE,A(I+1,I),1)
               CALL DGEMV('No transpose',M-I,I,-ONE,X(I+1,1),LDX,A(1,I),
     *                    1,ONE,A(I+1,I),1)
C
C              Generate reflection Q(i) to annihilate A(i+2:m,i)
C
               CALL F08AEV(M-I,A(I+1,I),A(MIN(I+2,M),I),1,TAUQ(I))
               E(I) = A(I+1,I)
               A(I+1,I) = ONE
C
C              Compute Y(i+1:n,i)
C
               CALL DGEMV('Transpose',M-I,N-I,ONE,A(I+1,I+1),LDA,
     *                    A(I+1,I),1,ZERO,Y(I+1,I),1)
               CALL DGEMV('Transpose',M-I,I-1,ONE,A(I+1,1),LDA,A(I+1,I),
     *                    1,ZERO,Y(1,I),1)
               CALL DGEMV('No transpose',N-I,I-1,-ONE,Y(I+1,1),LDY,
     *                    Y(1,I),1,ONE,Y(I+1,I),1)
               CALL DGEMV('Transpose',M-I,I,ONE,X(I+1,1),LDX,A(I+1,I),1,
     *                    ZERO,Y(1,I),1)
               CALL DGEMV('Transpose',I,N-I,-ONE,A(1,I+1),LDA,Y(1,I),1,
     *                    ONE,Y(I+1,I),1)
               CALL DSCAL(N-I,TAUQ(I),Y(I+1,I),1)
            END IF
   40    CONTINUE
      END IF
      RETURN
C
C     End of F08KEY (DLABRD)
C
      END
