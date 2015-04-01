      SUBROUTINE F07QRF(UPLO,N,AP,IPIV,INFO)
C     MARK 15 RELEASE. NAG COPYRIGHT 1991.
C     .. Entry Points ..
      ENTRY             ZSPTRF(UPLO,N,AP,IPIV,INFO)
C
C  Purpose
C  =======
C
C  ZSPTRF computes the factorization of a complex symmetric matrix A
C  stored in packed format using the Bunch-Kaufman diagonal pivoting
C  method:
C
C     A = U*D*U'  or  A = L*D*L'
C
C  where U (or L) is a product of permutation and unit upper (lower)
C  triangular matrices, U' is the transpose of U, and D is symmetric and
C  block diagonal with 1-by-1 and 2-by-2 diagonal blocks.
C
C  Arguments
C  =========
C
C  UPLO    (input) CHARACTER*1
C          Specifies whether the upper or lower triangular part of the
C          symmetric matrix A is stored:
C          = 'U':  Upper triangular
C          = 'L':  Lower triangular
C
C  N       (input) INTEGER
C          The order of the matrix A.  N >= 0.
C
C  AP      (input/output) COMPLEX array, dimension (N*(N+1)/2)
C          On entry, the upper or lower triangle of the symmetric matrix
C          A, packed columnwise in a linear array.  The j-th column of A
C          is stored in the array AP as follows:
C          if UPLO = 'U', AP(i + (j-1)*j/2) = A(i,j) for 1<=i<=j;
C          if UPLO = 'L', AP(i + (j-1)*(2n-j)/2) = A(i,j) for j<=i<=n.
C
C          On exit, the block diagonal matrix D and the multipliers used
C          to obtain the factor U or L, stored as a packed triangular
C          matrix overwriting A (see below for further details).
C
C  IPIV    (output) INTEGER array, dimension (N)
C          Details of the interchanges and the block structure of D.
C          If IPIV(k) > 0, then rows and columns k and IPIV(k) were
C          interchanged and D(k,k) is a 1-by-1 diagonal block.
C          If UPLO = 'U' and IPIV(k) = IPIV(k-1) < 0, then rows and
C          columns k-1 and -IPIV(k) were interchanged and D(k-1:k,k-1:k)
C          is a 2-by-2 diagonal block.  If UPLO = 'L' and IPIV(k) =
C          IPIV(k+1) < 0, then rows and columns k+1 and -IPIV(k) were
C          interchanged and D(k:k+1,k:k+1) is a 2-by-2 diagonal block.
C
C  INFO    (output) INTEGER
C          = 0: successful exit
C          < 0: if INFO = -k, the k-th argument had an illegal value
C          > 0: if INFO = k, D(k,k) is exactly zero.  The factorization
C               has been completed, but the block diagonal matrix D is
C               exactly singular, and division by zero will occur if it
C               is used to solve a system of equations.
C
C  Further Details
C  ===============
C
C  If UPLO = 'U', then A = U*D*U', where
C     U = P(n)*U(n)* ... *P(k)U(k)* ...,
C  i.e., U is a product of terms P(k)*U(k), where k decreases from n to
C  1 in steps of 1 or 2, and D is a block diagonal matrix with 1-by-1
C  and 2-by-2 diagonal blocks D(k).  P(k) is a permutation matrix as
C  defined by IPIV(k), and U(k) is a unit upper triangular matrix, such
C  that if the diagonal block D(k) is of order s (s = 1 or 2), then
C
C             (   I    v    0   )   k-s
C     U(k) =  (   0    I    0   )   s
C             (   0    0    I   )   n-k
C                k-s   s   n-k
C
C  If s = 1, D(k) overwrites A(k,k), and v overwrites A(1:k-1,k).
C  If s = 2, the upper triangle of D(k) overwrites A(k-1,k-1), A(k-1,k),
C  and A(k,k), and v overwrites A(1:k-2,k-1:k).
C
C  If UPLO = 'L', then A = L*D*L', where
C     L = P(1)*L(1)* ... *P(k)*L(k)* ...,
C  i.e., L is a product of terms P(k)*L(k), where k increases from 1 to
C  n in steps of 1 or 2, and D is a block diagonal matrix with 1-by-1
C  and 2-by-2 diagonal blocks D(k).  P(k) is a permutation matrix as
C  defined by IPIV(k), and L(k) is a unit lower triangular matrix, such
C  that if the diagonal block D(k) is of order s (s = 1 or 2), then
C
C             (   I    0     0   )  k-1
C     L(k) =  (   0    I     0   )  s
C             (   0    v     I   )  n-k-s+1
C                k-1   s  n-k-s+1
C
C  If s = 1, D(k) overwrites A(k,k), and v overwrites A(k+1:n,k).
C  If s = 2, the lower triangle of D(k) overwrites A(k,k), A(k+1,k),
C  and A(k+1,k+1), and v overwrites A(k+2:n,k:k+1).
C
C  -- LAPACK routine (adapted for NAG Library)
C     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
C     Courant Institute, Argonne National Lab, and Rice University
C
C  =====================================================================
C
C     .. Parameters ..
      DOUBLE PRECISION  ZERO, ONE
      PARAMETER         (ZERO=0.0D+0,ONE=1.0D+0)
      DOUBLE PRECISION  EIGHT, SEVTEN
      PARAMETER         (EIGHT=8.0D+0,SEVTEN=17.0D+0)
      COMPLEX*16        CONE
      PARAMETER         (CONE=(1.0D+0,0.0D+0))
C     .. Scalar Arguments ..
      INTEGER           INFO, N
      CHARACTER         UPLO
C     .. Array Arguments ..
      COMPLEX*16        AP(*)
      INTEGER           IPIV(*)
C     .. Local Scalars ..
      COMPLEX*16        C, D11, D12, D21, D22, R1, R2, S, T, T1, T2, Z,
     *                  ZDUM
      DOUBLE PRECISION  ABSAKK, ALPHA, COLMAX, ROWMAX
      INTEGER           IMAX, J, JC, JMAX, K, KC, KK, KNC, KP, KPC,
     *                  KSTEP, KX, NPP
      LOGICAL           UPPER
C     .. External Functions ..
      INTEGER           IZAMAX
      EXTERNAL          IZAMAX
C     .. External Subroutines ..
      EXTERNAL          ZAXPY, ZSCAL, ZSWAP, F06AAZ, F07NRW, F07NRX,
     *                  F07QRV
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, DIMAG, MAX, DBLE, SQRT
C     .. Statement Functions ..
      DOUBLE PRECISION  CABS1
C     .. Statement Function definitions ..
      CABS1(ZDUM) = ABS(DBLE(ZDUM)) + ABS(DIMAG(ZDUM))
C     .. Executable Statements ..
C
C     Test the input parameters.
C
      INFO = 0
      UPPER = (UPLO.EQ.'U' .OR. UPLO.EQ.'u')
      IF ( .NOT. UPPER .AND. .NOT. (UPLO.EQ.'L' .OR. UPLO.EQ.'l')) THEN
         INFO = -1
      ELSE IF (N.LT.0) THEN
         INFO = -2
      END IF
      IF (INFO.NE.0) THEN
         CALL F06AAZ('F07QRF/ZSPTRF',-INFO)
         RETURN
      END IF
C
C     Initialize ALPHA for use in choosing pivot block size.
C
      ALPHA = (ONE+SQRT(SEVTEN))/EIGHT
C
      IF (UPPER) THEN
C
C        Factorize A as U*D*U' using the upper triangle of A
C
C        K is the main loop index, decreasing from N to 1 in steps of
C        1 or 2
C
         K = N
         KC = (N-1)*N/2 + 1
   20    CONTINUE
         KNC = KC
C
C        If K < 1, exit from loop
C
         IF (K.LT.1) GO TO 180
         KSTEP = 1
C
C        Determine rows and columns to be interchanged and whether
C        a 1-by-1 or 2-by-2 pivot block will be used
C
         ABSAKK = CABS1(AP(KC+K-1))
C
C        IMAX is the row-index of the largest off-diagonal element in
C        column K, and COLMAX is its absolute value
C
         IF (K.GT.1) THEN
            IMAX = IZAMAX(K-1,AP(KC),1)
            COLMAX = CABS1(AP(KC+IMAX-1))
         ELSE
            COLMAX = ZERO
         END IF
C
         IF (MAX(ABSAKK,COLMAX).EQ.ZERO) THEN
C
C           Column K is zero: set INFO and continue
C
            IF (INFO.EQ.0) INFO = K
            KP = K
         ELSE
            IF (ABSAKK.GE.ALPHA*COLMAX) THEN
C
C              no interchange, use 1-by-1 pivot block
C
               KP = K
            ELSE
C
C              JMAX is the column-index of the largest off-diagonal
C              element in row IMAX, and ROWMAX is its absolute value
C
               ROWMAX = ZERO
               JMAX = IMAX
               KX = IMAX*(IMAX+1)/2 + IMAX
               DO 40 J = IMAX + 1, K
                  IF (CABS1(AP(KX)).GT.ROWMAX) THEN
                     ROWMAX = CABS1(AP(KX))
                     JMAX = J
                  END IF
                  KX = KX + J
   40          CONTINUE
               KPC = (IMAX-1)*IMAX/2 + 1
               IF (IMAX.GT.1) THEN
                  JMAX = IZAMAX(IMAX-1,AP(KPC),1)
                  ROWMAX = MAX(ROWMAX,CABS1(AP(KPC+JMAX-1)))
               END IF
C
               IF (ABSAKK.GE.ALPHA*COLMAX*(COLMAX/ROWMAX)) THEN
C
C                 no interchange, use 1-by-1 pivot block
C
                  KP = K
               ELSE IF (CABS1(AP(KPC+IMAX-1)).GE.ALPHA*ROWMAX) THEN
C
C                 interchange rows and columns K and IMAX, use 1-by-1
C                 pivot block
C
                  KP = IMAX
               ELSE
C
C                 interchange rows and columns K-1 and IMAX, use 2-by-2
C                 pivot block
C
                  KP = IMAX
                  KSTEP = 2
               END IF
            END IF
C
            KK = K - KSTEP + 1
            IF (KSTEP.EQ.2) KNC = KNC - K + 1
            IF (KP.NE.KK) THEN
C
C              Interchange rows and columns KK and KP in the leading
C              submatrix A(1:k,1:k)
C
               CALL ZSWAP(KP,AP(KNC),1,AP(KPC),1)
               KX = KNC + KP - 1
               DO 60 J = KK, KP, -1
                  T = AP(KNC+J-1)
                  AP(KNC+J-1) = AP(KX)
                  AP(KX) = T
                  KX = KX - J + 1
   60          CONTINUE
               IF (KSTEP.EQ.2) THEN
                  T = AP(KC+K-2)
                  AP(KC+K-2) = AP(KC+KP-1)
                  AP(KC+KP-1) = T
               END IF
            END IF
C
C           Update the leading submatrix
C
            IF (KSTEP.EQ.1) THEN
C
C              1-by-1 pivot block D(k): column k now holds
C
C              W(k) = U(k)*D(k)
C
C              where U(k) is the k-th column of U
C
C              Perform a rank-1 update of A(1:k-1,1:k-1) as
C
C              A := A - U(k)*D(k)*U(k)' = A - W(k)*1/D(k)*W(k)'
C
               R1 = CONE/AP(KC+K-1)
               CALL F07QRV(UPLO,K-1,-R1,AP(KC),1,AP)
C
C              Store U(k) in column k
C
               CALL ZSCAL(K-1,R1,AP(KC),1)
            ELSE
C
C              2-by-2 pivot block D(k): columns k and k-1 now hold
C
C              ( W(k-1) W(k) ) = ( U(k-1) U(k) )*D(k)
C
C              where U(k) and U(k-1) are the k-th and (k-1)-th columns
C              of U
C
C              Perform a rank-2 update of A(1:k-2,1:k-2) as
C
C              A := A - ( U(k-1) U(k) )*D(k)*( U(k-1) U(k) )'
C                 = A - ( W(k-1) W(k) )*inv(D(k))*( W(k-1) W(k) )'
C
C              Convert this to two rank-1 updates by using the eigen-
C              decomposition of D(k)
C
               CALL F07NRX(AP(KC-1),AP(KC+K-2),AP(KC+K-1),R1,R2,Z,C,S)
C
               IF (CABS1(Z).NE.ZERO) THEN
C
C                 Apply two rank-1 updates to A(1:k-2,1:k-2) using the
C                 eigendecomposition of D(k).
C
                  R1 = CONE/R1
                  R2 = CONE/R2
                  CALL F07NRW(K-2,AP(KNC),1,AP(KC),1,C,S)
                  CALL F07QRV(UPLO,K-2,-R1,AP(KNC),1,AP)
                  CALL F07QRV(UPLO,K-2,-R2,AP(KC),1,AP)
C
C                 Store the multipliers in columns K and K-1
C
                  CALL ZSCAL(K-2,R1,AP(KNC),1)
                  CALL ZSCAL(K-2,R2,AP(KC),1)
                  CALL F07NRW(K-2,AP(KNC),1,AP(KC),1,C,-S)
               ELSE
C
C                 Apply a rank-2 update to A(1:k-2,1:k-2) using the
C                 explicit inverse of D(K) = [a b; b c], computed as
C                                 (1/b)      (  c/b    -1  )
C                 inv(D(k)) = -------------- (             )
C                             1 - (a/b)(c/b) (  -1     a/b )
C
                  D12 = CONE/AP(KC+K-2)
                  D11 = AP(KC+K-1)*D12
                  D22 = AP(KC-1)*D12
                  Z = -D12/(CONE-D11*D22)
                  JC = KNC - K + 2
                  DO 80 J = K - 2, 1, -1
C
C                    Compute inv(D(k)) * A(j,k-1:k)'
C
                     T1 = Z*(D11*AP(KNC+J-1)-AP(KC+J-1))
                     T2 = Z*(D22*AP(KC+J-1)-AP(KNC+J-1))
C
C                    Update column j of A
C
                     CALL ZAXPY(J,-T1,AP(KNC),1,AP(JC),1)
                     CALL ZAXPY(J,-T2,AP(KC),1,AP(JC),1)
C
C                    Store the multipliers in columns K-1 and K
C
                     AP(KNC+J-1) = T1
                     AP(KC+J-1) = T2
                     JC = JC - J + 1
   80             CONTINUE
               END IF
            END IF
         END IF
C
C        Store details of the interchanges in IPIV
C
         IF (KSTEP.EQ.1) THEN
            IPIV(K) = KP
         ELSE
            IPIV(K) = -KP
            IPIV(K-1) = -KP
         END IF
C
C        Decrease K and return to the start of the main loop
C
         K = K - KSTEP
         KC = KNC - K
         GO TO 20
C
      ELSE
C
C        Factorize A as L*D*L' using the lower triangle of A
C
C        K is the main loop index, increasing from 1 to N in steps of
C        1 or 2
C
         K = 1
         KC = 1
         NPP = N*(N+1)/2
  100    CONTINUE
         KNC = KC
C
C        If K > N, exit from loop
C
         IF (K.GT.N) GO TO 180
         KSTEP = 1
C
C        Determine rows and columns to be interchanged and whether
C        a 1-by-1 or 2-by-2 pivot block will be used
C
         ABSAKK = CABS1(AP(KC))
C
C        IMAX is the row-index of the largest off-diagonal element in
C        column K, and COLMAX is its absolute value
C
         IF (K.LT.N) THEN
            IMAX = K + IZAMAX(N-K,AP(KC+1),1)
            COLMAX = CABS1(AP(KC+IMAX-K))
         ELSE
            COLMAX = ZERO
         END IF
C
         IF (MAX(ABSAKK,COLMAX).EQ.ZERO) THEN
C
C           Column K is zero: set INFO and continue
C
            IF (INFO.EQ.0) INFO = K
            KP = K
         ELSE
            IF (ABSAKK.GE.ALPHA*COLMAX) THEN
C
C              no interchange, use 1-by-1 pivot block
C
               KP = K
            ELSE
C
C              JMAX is the column-index of the largest off-diagonal
C              element in row IMAX, and ROWMAX is its absolute value
C
               ROWMAX = ZERO
               KX = KC + IMAX - K
               DO 120 J = K, IMAX - 1
                  IF (CABS1(AP(KX)).GT.ROWMAX) THEN
                     ROWMAX = CABS1(AP(KX))
                     JMAX = J
                  END IF
                  KX = KX + N - J
  120          CONTINUE
               KPC = NPP - (N-IMAX+1)*(N-IMAX+2)/2 + 1
               IF (IMAX.LT.N) THEN
                  JMAX = IMAX + IZAMAX(N-IMAX,AP(KPC+1),1)
                  ROWMAX = MAX(ROWMAX,CABS1(AP(KPC+JMAX-IMAX)))
               END IF
C
               IF (ABSAKK.GE.ALPHA*COLMAX*(COLMAX/ROWMAX)) THEN
C
C                 no interchange, use 1-by-1 pivot block
C
                  KP = K
               ELSE IF (CABS1(AP(KPC)).GE.ALPHA*ROWMAX) THEN
C
C                 interchange rows and columns K and IMAX, use 1-by-1
C                 pivot block
C
                  KP = IMAX
               ELSE
C
C                 interchange rows and columns K+1 and IMAX, use 2-by-2
C                 pivot block
C
                  KP = IMAX
                  KSTEP = 2
               END IF
            END IF
C
            KK = K + KSTEP - 1
            IF (KSTEP.EQ.2) KNC = KNC + N - K + 1
            IF (KP.NE.KK) THEN
C
C              Interchange rows and columns KK and KP in the trailing
C              submatrix A(k:n,k:n)
C
               CALL ZSWAP(N-KP+1,AP(KNC+KP-KK),1,AP(KPC),1)
               KX = KNC + KP - KK
               DO 140 J = KK, KP
                  T = AP(KNC+J-KK)
                  AP(KNC+J-KK) = AP(KX)
                  AP(KX) = T
                  KX = KX + N - J
  140          CONTINUE
               IF (KSTEP.EQ.2) THEN
                  T = AP(KC+1)
                  AP(KC+1) = AP(KC+KP-K)
                  AP(KC+KP-K) = T
               END IF
            END IF
C
C           Update the trailing submatrix
C
            IF (KSTEP.EQ.1) THEN
C
C              1-by-1 pivot block D(k): column k now holds
C
C              W(k) = L(k)*D(k)
C
C              where L(k) is the k-th column of L
C
               IF (K.LT.N) THEN
C
C                 Perform a rank-1 update of A(k+1:n,k+1:n) as
C
C                 A := A - L(k)*D(k)*L(k)' = A - W(k)*(1/D(k))*W(k)'
C
                  R1 = CONE/AP(KC)
                  CALL F07QRV(UPLO,N-K,-R1,AP(KC+1),1,AP(KC+N-K+1))
C
C                 Store L(k) in column K
C
                  CALL ZSCAL(N-K,R1,AP(KC+1),1)
               END IF
            ELSE
C
C              2-by-2 pivot block D(k): columns K and K+1 now hold
C
C              ( W(k) W(k+1) ) = ( L(k) L(k+1) )*D(k)
C
C              where L(k) and L(k+1) are the k-th and (k+1)-th columns
C              of L
C
               IF (K.LT.N-1) THEN
C
C                 Perform a rank-2 update of A(k+2:n,k+2:n) as
C
C                 A := A - ( L(k) L(k+1) )*D(k)*( L(k) L(k+1) )'
C                    = A - ( W(k) W(k+1) )*inv(D(k))*( W(k) W(k+1) )'
C
C                 Convert this to two rank-1 updates by using the eigen-
C                 decomposition of D(k)
C
                  CALL F07NRX(AP(KC),AP(KC+1),AP(KNC),R1,R2,Z,C,S)
C
                  IF (CABS1(Z).NE.ZERO) THEN
C
C                    Apply two rank-1 updates to A(k+2:n,k+2:n) using
C                    the eigendecomposition of D(k)
C
                     R1 = CONE/R1
                     R2 = CONE/R2
                     CALL F07NRW(N-K-1,AP(KC+2),1,AP(KNC+1),1,C,S)
                     CALL F07QRV(UPLO,N-K-1,-R1,AP(KC+2),1,AP(KNC+N-K))
                     CALL F07QRV(UPLO,N-K-1,-R2,AP(KNC+1),1,AP(KNC+N-K))
C
C                    Store the multipliers in columns K and K+1
C
                     CALL ZSCAL(N-K-1,R1,AP(KC+2),1)
                     CALL ZSCAL(N-K-1,R2,AP(KNC+1),1)
                     CALL F07NRW(N-K-1,AP(KC+2),1,AP(KNC+1),1,C,-S)
                  ELSE
C
C                    Apply a rank-2 update to A(k+2:n,k+2:n) using the
C                    explicit inverse of D(K) = [a b; b c], computed as
C                                    (1/b)      (  c/b    -1  )
C                    inv(D(k)) = -------------- (             )
C                                1 - (a/b)(c/b) (  -1     a/b )
C
                     D21 = CONE/AP(KC+1)
                     D11 = AP(KNC)*D21
                     D22 = AP(KC)*D21
                     Z = -D21/(CONE-D11*D22)
                     JC = KNC + N - K
                     DO 160 J = K + 2, N
C
C                       Compute inv(D(k)) * A(j,k:k+1)'
C
                        T1 = Z*(D11*AP(KC+J-K)-AP(KNC+J-(K+1)))
                        T2 = Z*(D22*AP(KNC+J-(K+1))-AP(KC+J-K))
C
C                       Update column j of A
C
                        CALL ZAXPY(N-J+1,-T1,AP(KC+J-K),1,AP(JC),1)
                        CALL ZAXPY(N-J+1,-T2,AP(KNC+J-(K+1)),1,AP(JC),1)
C
C                       Store the multipliers in columns K and K+1
C
                        AP(KC+J-K) = T1
                        AP(KNC+J-(K+1)) = T2
                        JC = JC + N - J + 1
  160                CONTINUE
                  END IF
               END IF
            END IF
         END IF
C
C        Store details of the interchanges in IPIV
C
         IF (KSTEP.EQ.1) THEN
            IPIV(K) = KP
         ELSE
            IPIV(K) = -KP
            IPIV(K+1) = -KP
         END IF
C
C        Increase K and return to the start of the main loop
C
         K = K + KSTEP
         KC = KNC + N - K + 2
         GO TO 100
C
      END IF
C
  180 CONTINUE
      RETURN
C
C     End of F07QRF (ZSPTRF)
C
      END
