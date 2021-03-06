      SUBROUTINE F07VUZ(UPLO,TRANS,DIAG,NORMIN,N,KD,AB,LDAB,X,SCALE,
     *                  CNORM,INFO)
C     MARK 15 RELEASE. NAG COPYRIGHT 1991.
C     MARK 16 REVISED. IER-1030 (JUN 1993).
C     ENTRY             ZLATBS(UPLO,TRANS,DIAG,NORMIN,N,KD,AB,LDAB,X,
C    *                  SCALE,CNORM,INFO)
C
C  Purpose
C  =======
C
C  ZLATBS solves one of the triangular systems
C
C     A * x = s*b,  A**T * x = s*b,  or  A**H * x = s*b,
C
C  with scaling to prevent overflow, where A is an upper or lower
C  triangular band matrix.  Here A' denotes the transpose of A, x and b
C  are n-element vectors, and s is a scaling factor, usually less than
C  or equal to 1, chosen so that the components of x will be less than
C  the overflow threshold.  If the unscaled problem will not cause
C  overflow, the Level 2 BLAS routine ZTBSV is called.  If the matrix A
C  is singular (A(j,j) = 0 for some j), then s is set to 0 and a
C  non-trivial solution to A*x = 0 is returned.
C
C  Arguments
C  =========
C
C  UPLO    (input) CHARACTER*1
C          Specifies whether the matrix A is upper or lower triangular.
C          = 'U':  Upper triangular
C          = 'L':  Lower triangular
C
C  TRANS   (input) CHARACTER*1
C          Specifies the operation applied to A.
C          = 'N':  Solve A * x = s*b     (No transpose)
C          = 'T':  Solve A**T * x = s*b  (Transpose)
C          = 'C':  Solve A**H * x = s*b  (Conjugate transpose)
C
C  DIAG    (input) CHARACTER*1
C          Specifies whether or not the matrix A is unit triangular.
C          = 'N':  Non-unit triangular
C          = 'U':  Unit triangular
C
C  NORMIN  (input) CHARACTER*1
C          Specifies whether CNORM has been set or not.
C          = 'Y':  CNORM contains the column norms on entry
C          = 'N':  CNORM is not set on entry.  On exit, the norms will
C                  be computed and stored in CNORM.
C
C  N       (input) INTEGER
C          The order of the matrix A.  N >= 0.
C
C  KD      (input) INTEGER
C          The number of subdiagonals or superdiagonals in the
C          triangular matrix A.  KD >= 0.
C
C  AB      (input) COMPLEX array, dimension (LDAB,N)
C          The upper or lower triangular band matrix A, stored in the
C          first KD+1 rows of the array. The j-th column of A is stored
C          in the j-th column of the array AB as follows:
C          if UPLO = 'U', AB(kd+1+i-j,j) = A(i,j) for max(1,j-kd)<=i<=j;
C          if UPLO = 'L', AB(1+i-j,j)    = A(i,j) for j<=i<=min(n,j+kd).
C
C  LDAB    (input) INTEGER
C          The leading dimension of the array AB.  LDAB >= KD+1.
C
C  X       (input/output) COMPLEX array, dimension (N)
C          On entry, the right hand side b of the triangular system.
C          On exit, X is overwritten by the solution vector x.
C
C  SCALE   (output) REAL
C          The scaling factor s for the triangular system
C             A * x = s*b,  A**T * x = s*b,  or  A**H * x = s*b.
C          If SCALE = 0, the matrix A is singular or badly scaled, and
C          the vector x is an exact or approximate solution to A*x = 0.
C
C  CNORM   (input or output) REAL array, dimension (N)
C
C          If NORMIN = 'Y', CNORM is an input variable and CNORM(j)
C          contains the norm of the off-diagonal part of the j-th column
C          of A.  If TRANS = 'N', CNORM(j) must be greater than or equal
C          to the infinity-norm, and if TRANS = 'T' or 'C', CNORM(j)
C          must be greater than or equal to the 1-norm.
C
C          If NORMIN = 'N', CNORM is an output variable and CNORM(j)
C          returns the 1-norm of the offdiagonal part of the j-th column
C          of A.
C
C  INFO    (output) INTEGER
C          = 0:  successful exit
C          < 0:  if INFO = -k, the k-th argument had an illegal value
C
C  Further Details
C  ======= =======
C
C  A rough bound on x is computed; if that is less than overflow, ZTBSV
C  is called, otherwise, specific code is used which checks for possible
C  overflow or divide-by-zero at every operation.
C
C  A columnwise scheme is used for solving A*x = b.  The basic algorithm
C  if A is lower triangular is
C
C       x[1:n] := b[1:n]
C       for j = 1, ..., n
C            x(j) := x(j) / A(j,j)
C            x[j+1:n] := x[j+1:n] - x(j) * A[j+1:n,j]
C       end
C
C  Define bounds on the components of x after j iterations of the loop:
C     M(j) = bound on x[1:j]
C     G(j) = bound on x[j+1:n]
C  Initially, let M(0) = 0 and G(0) = max{x(i), i=1,...,n}.
C
C  Then for iteration j+1 we have
C     M(j+1) <= G(j) / | A(j+1,j+1) |
C     G(j+1) <= G(j) + M(j+1) * | A[j+2:n,j+1] |
C            <= G(j) ( 1 + CNORM(j+1) / | A(j+1,j+1) | )
C
C  where CNORM(j+1) is greater than or equal to the infinity-norm of
C  column j+1 of A, not counting the diagonal.  Hence
C
C     G(j) <= G(0) product ( 1 + CNORM(i) / | A(i,i) | )
C                  1<=i<=j
C  and
C
C     |x(j)| <= ( G(0) / |A(j,j)| ) product ( 1 + CNORM(i) / |A(i,i)| )
C                                   1<=i< j
C
C  Since |x(j)| <= M(j), we use the Level 2 BLAS routine ZTBSV if the
C  reciprocal of the largest M(j), j=1,..,n, is larger than
C  max(underflow, 1/overflow).
C
C  The bound on x(j) is also used to determine when a step in the
C  columnwise method can be performed without fear of overflow.  If
C  the computed bound is greater than a large constant, x is scaled to
C  prevent overflow, but if the bound overflows, x is set to 0, x(j) to
C  1, and scale to 0, and a non-trivial solution to A*x = 0 is found.
C
C  Similarly, a row-wise scheme is used to solve A**T *x = b  or
C  A**H *x = b.  The basic algorithm for A upper triangular is
C
C       for j = 1, ..., n
C            x(j) := ( b(j) - A[1:j-1,j]' * x[1:j-1] ) / A(j,j)
C       end
C
C  We simultaneously compute two bounds
C       G(j) = bound on ( b(i) - A[1:i-1,i]' * x[1:i-1] ), 1<=i<=j
C       M(j) = bound on x(i), 1<=i<=j
C
C  The initial values are G(0) = 0, M(0) = max{b(i), i=1,..,n}, and we
C  add the constraint G(j) >= G(j-1) and M(j) >= M(j-1) for j >= 1.
C  Then the bound on x(j) is
C
C       M(j) <= M(j-1) * ( 1 + CNORM(j) ) / | A(j,j) |
C
C            <= M(0) * product ( ( 1 + CNORM(i) ) / |A(i,i)| )
C                      1<=i<=j
C
C  and we can safely call ZTBSV if 1/M(n) and 1/G(n) are both greater
C  than max(underflow, 1/overflow).
C
C  -- LAPACK auxiliary routine (adapted for NAG Library)
C     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
C     Courant Institute, Argonne National Lab, and Rice University
C
C  =====================================================================
C
C     .. Parameters ..
      DOUBLE PRECISION  ZERO, HALF, ONE, TWO
      PARAMETER         (ZERO=0.0D+0,HALF=0.5D+0,ONE=1.0D+0,TWO=2.0D+0)
C     .. Scalar Arguments ..
      DOUBLE PRECISION  SCALE
      INTEGER           INFO, KD, LDAB, N
      CHARACTER         DIAG, NORMIN, TRANS, UPLO
C     .. Array Arguments ..
      COMPLEX*16        AB(LDAB,*), X(*)
      DOUBLE PRECISION  CNORM(*)
C     .. Local Scalars ..
      COMPLEX*16        CSUMJ, TJJS, USCAL, ZDUM
      DOUBLE PRECISION  BIGNUM, GROW, REC, SMLNUM, TJJ, TMAX, TSCAL,
     *                  XBND, XJ, XMAX
      INTEGER           I, IMAX, J, JFIRST, JINC, JLAST, JLEN, MAIND
      LOGICAL           NOTRAN, NOUNIT, UPPER
C     .. External Functions ..
      COMPLEX*16        ZDOTC, ZDOTU
      DOUBLE PRECISION  DZASUM, X02AJF, X02AMF
      INTEGER           IDAMAX, IZAMAX
      EXTERNAL          ZDOTC, ZDOTU, DZASUM, X02AJF, X02AMF, IDAMAX,
     *                  IZAMAX
C     .. External Subroutines ..
      EXTERNAL          DSCAL, F06AAZ, ZAXPY, ZDSCAL, ZTBSV
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, DBLE, DCMPLX, DCONJG, DIMAG, MAX, MIN
C     .. Statement Functions ..
      DOUBLE PRECISION  CABS1, CABS2
C     .. Statement Function definitions ..
      CABS1(ZDUM) = ABS(DBLE(ZDUM)) + ABS(DIMAG(ZDUM))
      CABS2(ZDUM) = ABS(DBLE(ZDUM)/2.D0) + ABS(DIMAG(ZDUM)/2.D0)
C     .. Executable Statements ..
C
      INFO = 0
      UPPER = (UPLO.EQ.'U' .OR. UPLO.EQ.'u')
      NOTRAN = (TRANS.EQ.'N' .OR. TRANS.EQ.'n')
      NOUNIT = (DIAG.EQ.'N' .OR. DIAG.EQ.'n')
C
C     Test the input parameters.
C
      IF ( .NOT. UPPER .AND. .NOT. (UPLO.EQ.'L' .OR. UPLO.EQ.'l')) THEN
         INFO = -1
      ELSE IF ( .NOT. NOTRAN .AND. .NOT.
     *         (TRANS.EQ.'T' .OR. TRANS.EQ.'t  ')
     *         .AND. .NOT. (TRANS.EQ.'C' .OR. TRANS.EQ.'c')) THEN
         INFO = -2
      ELSE IF ( .NOT. NOUNIT .AND. .NOT. (DIAG.EQ.'U' .OR. DIAG.EQ.'u'))
     *         THEN
         INFO = -3
      ELSE IF ( .NOT. (NORMIN.EQ.'Y' .OR. NORMIN.EQ.'y')
     *         .AND. .NOT. (NORMIN.EQ.'N' .OR. NORMIN.EQ.'n')) THEN
         INFO = -4
      ELSE IF (N.LT.0) THEN
         INFO = -5
      ELSE IF (KD.LT.0) THEN
         INFO = -6
      ELSE IF (LDAB.LT.KD+1) THEN
         INFO = -8
      END IF
      IF (INFO.NE.0) THEN
         CALL F06AAZ('F07VUZ/ZLATBS',-INFO)
         RETURN
      END IF
C
C     Quick return if possible
C
      IF (N.EQ.0) RETURN
C
C     Determine machine dependent parameters to control overflow.
C
      SMLNUM = X02AMF()/X02AJF()
      BIGNUM = ONE/SMLNUM
      SCALE = ONE
C
      IF ((NORMIN.EQ.'N' .OR. NORMIN.EQ.'n')) THEN
C
C        Compute the 1-norm of each column, not including the diagonal.
C
         IF (UPPER) THEN
C
C           A is upper triangular.
C
            DO 20 J = 1, N
               JLEN = MIN(KD,J-1)
               CNORM(J) = DZASUM(JLEN,AB(KD+1-JLEN,J),1)
   20       CONTINUE
         ELSE
C
C           A is lower triangular.
C
            DO 40 J = 1, N
               JLEN = MIN(KD,N-J)
               IF (JLEN.GT.0) THEN
                  CNORM(J) = DZASUM(JLEN,AB(2,J),1)
               ELSE
                  CNORM(J) = ZERO
               END IF
   40       CONTINUE
         END IF
      END IF
C
C     Scale the column norms by TSCAL if the maximum entry in CNORM is
C     greater than BIGNUM/2.
C
      IMAX = IDAMAX(N,CNORM,1)
      TMAX = CNORM(IMAX)
      IF (TMAX.LE.BIGNUM*HALF) THEN
         TSCAL = ONE
      ELSE
         TSCAL = HALF/(SMLNUM*TMAX)
         CALL DSCAL(N,TSCAL,CNORM,1)
      END IF
C
C     Compute a bound on the computed solution vector to see if the
C     Level 2 BLAS routine ZTBSV can be used.
C
      XMAX = ZERO
      DO 60 J = 1, N
         XMAX = MAX(XMAX,CABS2(X(J)))
   60 CONTINUE
      XBND = XMAX
      IF (NOTRAN) THEN
C
C        Compute the growth in A * x = b.
C
         IF (UPPER) THEN
            JFIRST = N
            JLAST = 1
            JINC = -1
            MAIND = KD + 1
         ELSE
            JFIRST = 1
            JLAST = N
            JINC = 1
            MAIND = 1
         END IF
C
         IF (TSCAL.NE.ONE) THEN
            GROW = ZERO
            GO TO 120
         END IF
C
         IF (NOUNIT) THEN
C
C           A is non-unit triangular.
C
C           Compute GROW = 1/G(j) and XBND = 1/M(j).
C           Initially, G(0) = max{x(i), i=1,...,n}.
C
            GROW = HALF/MAX(XBND,SMLNUM)
            XBND = GROW
            DO 80 J = JFIRST, JLAST, JINC
C
C              Exit the loop if the growth factor is too small.
C
               IF (GROW.LE.SMLNUM) GO TO 120
C
C              M(j) = G(j-1) / abs(A(j,j))
C
               TJJS = AB(MAIND,J)
               TJJ = CABS1(TJJS)
               XBND = MIN(XBND,MIN(ONE,TJJ)*GROW)
               IF (TJJ+CNORM(J).GE.SMLNUM) THEN
C
C                 G(j) = G(j-1)*( 1 + CNORM(j) / abs(A(j,j)) )
C
                  GROW = GROW*(TJJ/(TJJ+CNORM(J)))
               ELSE
C
C                 G(j) could overflow, set GROW to 0.
C
                  GROW = ZERO
               END IF
   80       CONTINUE
            GROW = XBND
         ELSE
C
C           A is unit triangular.
C
C           Compute GROW = 1/G(j), where G(0) = max{x(i), i=1,...,n}.
C
            GROW = MIN(ONE,HALF/MAX(XBND,SMLNUM))
            DO 100 J = JFIRST, JLAST, JINC
C
C              Exit the loop if the growth factor is too small.
C
               IF (GROW.LE.SMLNUM) GO TO 120
C
C              G(j) = G(j-1)*( 1 + CNORM(j) )
C
               GROW = GROW*(ONE/(ONE+CNORM(J)))
  100       CONTINUE
         END IF
  120    CONTINUE
C
      ELSE
C
C        Compute the growth in A**T * x = b  or  A**H * x = b.
C
         IF (UPPER) THEN
            JFIRST = 1
            JLAST = N
            JINC = 1
            MAIND = KD + 1
         ELSE
            JFIRST = N
            JLAST = 1
            JINC = -1
            MAIND = 1
         END IF
C
         IF (TSCAL.NE.ONE) THEN
            GROW = ZERO
            GO TO 180
         END IF
C
         IF (NOUNIT) THEN
C
C           A is non-unit triangular.
C
C           Compute GROW = 1/G(j) and XBND = 1/M(j).
C           Initially, M(0) = max{x(i), i=1,...,n}.
C
            GROW = HALF/MAX(XBND,SMLNUM)
            XBND = GROW
            DO 140 J = JFIRST, JLAST, JINC
C
C              Exit the loop if the growth factor is too small.
C
               IF (GROW.LE.SMLNUM) GO TO 180
C
C              G(j) = max( G(j-1), M(j-1)*( 1 + CNORM(j) ) )
C
               XJ = ONE + CNORM(J)
               GROW = MIN(GROW,XBND/XJ)
C
C              M(j) = M(j-1)*( 1 + CNORM(j) ) / abs(A(j,j))
C
               TJJS = AB(MAIND,J)
               TJJ = CABS1(TJJS)
               IF (XJ.GT.TJJ) XBND = XBND*(TJJ/XJ)
  140       CONTINUE
            GROW = MIN(GROW,XBND)
         ELSE
C
C           A is unit triangular.
C
C           Compute GROW = 1/G(j), where G(0) = max{x(i), i=1,...,n}.
C
            GROW = MIN(ONE,HALF/MAX(XBND,SMLNUM))
            DO 160 J = JFIRST, JLAST, JINC
C
C              Exit the loop if the growth factor is too small.
C
               IF (GROW.LE.SMLNUM) GO TO 180
C
C              G(j) = ( 1 + CNORM(j) )*G(j-1)
C
               XJ = ONE + CNORM(J)
               GROW = GROW/XJ
  160       CONTINUE
         END IF
  180    CONTINUE
      END IF
C
      IF ((GROW*TSCAL).GT.SMLNUM) THEN
C
C        Use the Level 2 BLAS solve if the reciprocal of the bound on
C        elements of X is not too small.
C
         CALL ZTBSV(UPLO,TRANS,DIAG,N,KD,AB,LDAB,X,1)
      ELSE
C
C        Use a Level 1 BLAS solve, scaling intermediate results.
C
         IF (XMAX.GT.BIGNUM*HALF) THEN
C
C           Scale X so that its components are less than or equal to
C           BIGNUM in absolute value.
C
            SCALE = (BIGNUM*HALF)/XMAX
            CALL ZDSCAL(N,SCALE,X,1)
            XMAX = BIGNUM
         ELSE
            XMAX = XMAX*TWO
         END IF
C
         IF (NOTRAN) THEN
C
C           Solve A * x = b
C
            DO 220 J = JFIRST, JLAST, JINC
C
C              Compute x(j) = b(j) / A(j,j), scaling x if necessary.
C
               XJ = CABS1(X(J))
               IF (NOUNIT) THEN
                  TJJS = AB(MAIND,J)*TSCAL
               ELSE
                  TJJS = TSCAL
               END IF
               IF (NOUNIT .OR. ( .NOT. NOUNIT .AND. TSCAL.NE.ONE)) THEN
                  TJJ = CABS1(TJJS)
                  IF (TJJ.GT.SMLNUM) THEN
C
C                    abs(A(j,j)) > SMLNUM:
C
                     IF (TJJ.LT.ONE) THEN
                        IF (XJ.GT.TJJ*BIGNUM) THEN
C
C                          Scale x by 1/b(j).
C
                           REC = ONE/XJ
                           CALL ZDSCAL(N,REC,X,1)
                           SCALE = SCALE*REC
                           XMAX = XMAX*REC
                        END IF
                     END IF
                     X(J) = X(J)/TJJS
                     XJ = CABS1(X(J))
                  ELSE IF (TJJ.GT.ZERO) THEN
C
C                    0 < abs(A(j,j)) <= SMLNUM:
C
                     IF (XJ.GT.TJJ*BIGNUM) THEN
C
C                       Scale x by (1/abs(x(j)))*abs(A(j,j))*BIGNUM
C                       to avoid overflow when dividing by A(j,j).
C
                        REC = (TJJ*BIGNUM)/XJ
                        IF (CNORM(J).GT.ONE) THEN
C
C                          Scale by 1/CNORM(j) to avoid overflow when
C                          multiplying x(j) times column j.
C
                           REC = REC/CNORM(J)
                        END IF
                        CALL ZDSCAL(N,REC,X,1)
                        SCALE = SCALE*REC
                        XMAX = XMAX*REC
                     END IF
                     X(J) = X(J)/TJJS
                     XJ = CABS1(X(J))
                  ELSE
C
C                    A(j,j) = 0:  Set x(1:n) = 0, x(j) = 1, and
C                    scale = 0, and compute a solution to A*x = 0.
C
                     DO 200 I = 1, N
                        X(I) = ZERO
  200                CONTINUE
                     X(J) = ONE
                     XJ = ONE
                     SCALE = ZERO
                     XMAX = ZERO
                  END IF
               END IF
C
C              Scale x if necessary to avoid overflow when adding a
C              multiple of column j of A.
C
               IF (XJ.GT.ONE) THEN
                  REC = ONE/XJ
                  IF (CNORM(J).GT.(BIGNUM-XMAX)*REC) THEN
C
C                    Scale x by 1/(2*abs(x(j))).
C
                     REC = REC*HALF
                     CALL ZDSCAL(N,REC,X,1)
                     SCALE = SCALE*REC
                  END IF
               ELSE IF (XJ*CNORM(J).GT.(BIGNUM-XMAX)) THEN
C
C                 Scale x by 1/2.
C
                  CALL ZDSCAL(N,HALF,X,1)
                  SCALE = SCALE*HALF
               END IF
C
               IF (UPPER) THEN
                  IF (J.GT.1) THEN
C
C                    Compute the update
C                       x(max(1,j-kd):j-1) := x(max(1,j-kd):j-1) -
C                                             x(j)* A(max(1,j-kd):j-1,j)
C
                     JLEN = MIN(KD,J-1)
                     CALL ZAXPY(JLEN,-X(J)*TSCAL,AB(KD+1-JLEN,J),1,
     *                          X(J-JLEN),1)
                     I = IZAMAX(J-1,X,1)
                     XMAX = CABS1(X(I))
                  END IF
               ELSE IF (J.LT.N) THEN
C
C                 Compute the update
C                    x(j+1:min(j+kd,n)) := x(j+1:min(j+kd,n)) -
C                                          x(j) * A(j+1:min(j+kd,n),j)
C
                  JLEN = MIN(KD,N-J)
                  IF (JLEN.GT.0) CALL ZAXPY(JLEN,-X(J)*TSCAL,AB(2,J),1,
     *                                      X(J+1),1)
                  I = J + IZAMAX(N-J,X(J+1),1)
                  XMAX = CABS1(X(I))
               END IF
  220       CONTINUE
C
         ELSE IF ((TRANS.EQ.'T' .OR. TRANS.EQ.'t')) THEN
C
C           Solve A**T * x = b
C
            DO 300 J = JFIRST, JLAST, JINC
C
C              Compute x(j) = b(j) - sum A(k,j)*x(k).
C                                    k<>j
C
               XJ = CABS1(X(J))
               USCAL = TSCAL
               REC = ONE/MAX(XMAX,ONE)
               IF (CNORM(J).GT.(BIGNUM-XJ)*REC) THEN
C
C                 If x(j) could overflow, scale x by 1/(2*XMAX).
C
                  REC = REC*HALF
                  IF (NOUNIT) THEN
                     TJJS = AB(MAIND,J)*TSCAL
                  ELSE
                     TJJS = TSCAL
                  END IF
                  TJJ = CABS1(TJJS)
                  IF (TJJ.GT.ONE) THEN
C
C                    Divide by A(j,j) when scaling x if A(j,j) > 1.
C
                     REC = MIN(ONE,REC*TJJ)
                     USCAL = USCAL/TJJS
                  END IF
                  IF (REC.LT.ONE) THEN
                     CALL ZDSCAL(N,REC,X,1)
                     SCALE = SCALE*REC
                     XMAX = XMAX*REC
                  END IF
               END IF
C
               CSUMJ = ZERO
               IF (USCAL.EQ.DCMPLX(ONE)) THEN
C
C                 If the scaling needed for A in the dot product is 1,
C                 call ZDOTU to perform the dot product.
C
                  IF (UPPER) THEN
                     JLEN = MIN(KD,J-1)
                     CSUMJ = ZDOTU(JLEN,AB(KD+1-JLEN,J),1,X(J-JLEN),1)
                  ELSE
                     JLEN = MIN(KD,N-J)
                     IF (JLEN.GT.1) CSUMJ = ZDOTU(JLEN,AB(2,J),1,X(J+1),
     *                                      1)
                  END IF
               ELSE
C
C                 Otherwise, use in-line code for the dot product.
C
                  IF (UPPER) THEN
                     JLEN = MIN(KD,J-1)
                     DO 240 I = 1, JLEN
                        CSUMJ = CSUMJ + (AB(KD+I-JLEN,J)*USCAL)
     *                          *X(J-JLEN-1+I)
  240                CONTINUE
                  ELSE
                     JLEN = MIN(KD,N-J)
                     DO 260 I = 1, JLEN
                        CSUMJ = CSUMJ + (AB(I+1,J)*USCAL)*X(J+I)
  260                CONTINUE
                  END IF
               END IF
C
               IF (USCAL.EQ.DCMPLX(TSCAL)) THEN
C
C                 Compute x(j) := ( x(j) - CSUMJ ) / A(j,j) if 1/A(j,j)
C                 was not used to scale the dotproduct.
C
                  X(J) = X(J) - CSUMJ
                  XJ = CABS1(X(J))
                  IF (NOUNIT) THEN
                     TJJS = AB(MAIND,J)*TSCAL
                  ELSE
                     TJJS = TSCAL
                  END IF
                  IF (NOUNIT .OR. ( .NOT. NOUNIT .AND. TSCAL.NE.ONE))
     *                THEN
C
C                    Compute x(j) = x(j) / A(j,j), scaling if necessary.
C
                     TJJ = CABS1(TJJS)
                     IF (TJJ.GT.SMLNUM) THEN
C
C                       abs(A(j,j)) > SMLNUM:
C
                        IF (TJJ.LT.ONE) THEN
                           IF (XJ.GT.TJJ*BIGNUM) THEN
C
C                             Scale X by 1/abs(x(j)).
C
                              REC = ONE/XJ
                              CALL ZDSCAL(N,REC,X,1)
                              SCALE = SCALE*REC
                              XMAX = XMAX*REC
                           END IF
                        END IF
                        X(J) = X(J)/TJJS
                     ELSE IF (TJJ.GT.ZERO) THEN
C
C                       0 < abs(A(j,j)) <= SMLNUM:
C
                        IF (XJ.GT.TJJ*BIGNUM) THEN
C
C                          Scale x by (1/abs(x(j)))*abs(A(j,j))*BIGNUM.
C
                           REC = (TJJ*BIGNUM)/XJ
                           CALL ZDSCAL(N,REC,X,1)
                           SCALE = SCALE*REC
                           XMAX = XMAX*REC
                        END IF
                        X(J) = X(J)/TJJS
                     ELSE
C
C                       A(j,j) = 0:  Set x(1:n) = 0, x(j) = 1, and
C                       scale = 0 and compute a solution to A**T *x = 0.
C
                        DO 280 I = 1, N
                           X(I) = ZERO
  280                   CONTINUE
                        X(J) = ONE
                        SCALE = ZERO
                        XMAX = ZERO
                     END IF
                  END IF
               ELSE
C
C                 Compute x(j) := x(j) / A(j,j) - CSUMJ if the dot
C                 product has already been divided by 1/A(j,j).
C
                  X(J) = X(J)/TJJS - CSUMJ
               END IF
               XMAX = MAX(XMAX,CABS1(X(J)))
  300       CONTINUE
C
         ELSE
C
C           Solve A**H * x = b
C
            DO 380 J = JFIRST, JLAST, JINC
C
C              Compute x(j) = b(j) - sum A(k,j)*x(k).
C                                    k<>j
C
               XJ = CABS1(X(J))
               USCAL = TSCAL
               REC = ONE/MAX(XMAX,ONE)
               IF (CNORM(J).GT.(BIGNUM-XJ)*REC) THEN
C
C                 If x(j) could overflow, scale x by 1/(2*XMAX).
C
                  REC = REC*HALF
                  IF (NOUNIT) THEN
                     TJJS = DCONJG(AB(MAIND,J))*TSCAL
                  ELSE
                     TJJS = TSCAL
                  END IF
                  TJJ = CABS1(TJJS)
                  IF (TJJ.GT.ONE) THEN
C
C                    Divide by A(j,j) when scaling x if A(j,j) > 1.
C
                     REC = MIN(ONE,REC*TJJ)
                     USCAL = USCAL/TJJS
                  END IF
                  IF (REC.LT.ONE) THEN
                     CALL ZDSCAL(N,REC,X,1)
                     SCALE = SCALE*REC
                     XMAX = XMAX*REC
                  END IF
               END IF
C
               CSUMJ = ZERO
               IF (USCAL.EQ.DCMPLX(ONE)) THEN
C
C                 If the scaling needed for A in the dot product is 1,
C                 call ZDOTC to perform the dot product.
C
                  IF (UPPER) THEN
                     JLEN = MIN(KD,J-1)
                     CSUMJ = ZDOTC(JLEN,AB(KD+1-JLEN,J),1,X(J-JLEN),1)
                  ELSE
                     JLEN = MIN(KD,N-J)
                     IF (JLEN.GT.1) CSUMJ = ZDOTC(JLEN,AB(2,J),1,X(J+1),
     *                                      1)
                  END IF
               ELSE
C
C                 Otherwise, use in-line code for the dot product.
C
                  IF (UPPER) THEN
                     JLEN = MIN(KD,J-1)
                     DO 320 I = 1, JLEN
                        CSUMJ = CSUMJ + (DCONJG(AB(KD+I-JLEN,J))*USCAL)
     *                          *X(J-JLEN-1+I)
  320                CONTINUE
                  ELSE
                     JLEN = MIN(KD,N-J)
                     DO 340 I = 1, JLEN
                        CSUMJ = CSUMJ + (DCONJG(AB(I+1,J))*USCAL)*X(J+I)
  340                CONTINUE
                  END IF
               END IF
C
               IF (USCAL.EQ.DCMPLX(TSCAL)) THEN
C
C                 Compute x(j) := ( x(j) - CSUMJ ) / A(j,j) if 1/A(j,j)
C                 was not used to scale the dotproduct.
C
                  X(J) = X(J) - CSUMJ
                  XJ = CABS1(X(J))
                  IF (NOUNIT) THEN
                     TJJS = DCONJG(AB(MAIND,J))*TSCAL
                  ELSE
                     TJJS = TSCAL
                  END IF
                  IF (NOUNIT .OR. ( .NOT. NOUNIT .AND. TSCAL.NE.ONE))
     *                THEN
C
C                    Compute x(j) = x(j) / A(j,j), scaling if necessary.
C
                     TJJ = CABS1(TJJS)
                     IF (TJJ.GT.SMLNUM) THEN
C
C                       abs(A(j,j)) > SMLNUM:
C
                        IF (TJJ.LT.ONE) THEN
                           IF (XJ.GT.TJJ*BIGNUM) THEN
C
C                             Scale X by 1/abs(x(j)).
C
                              REC = ONE/XJ
                              CALL ZDSCAL(N,REC,X,1)
                              SCALE = SCALE*REC
                              XMAX = XMAX*REC
                           END IF
                        END IF
                        X(J) = X(J)/TJJS
                     ELSE IF (TJJ.GT.ZERO) THEN
C
C                       0 < abs(A(j,j)) <= SMLNUM:
C
                        IF (XJ.GT.TJJ*BIGNUM) THEN
C
C                          Scale x by (1/abs(x(j)))*abs(A(j,j))*BIGNUM.
C
                           REC = (TJJ*BIGNUM)/XJ
                           CALL ZDSCAL(N,REC,X,1)
                           SCALE = SCALE*REC
                           XMAX = XMAX*REC
                        END IF
                        X(J) = X(J)/TJJS
                     ELSE
C
C                       A(j,j) = 0:  Set x(1:n) = 0, x(j) = 1, and
C                       scale = 0 and compute a solution to A**H *x = 0.
C
                        DO 360 I = 1, N
                           X(I) = ZERO
  360                   CONTINUE
                        X(J) = ONE
                        SCALE = ZERO
                        XMAX = ZERO
                     END IF
                  END IF
               ELSE
C
C                 Compute x(j) := x(j) / A(j,j) - CSUMJ if the dot
C                 product has already been divided by 1/A(j,j).
C
                  X(J) = X(J)/TJJS - CSUMJ
               END IF
               XMAX = MAX(XMAX,CABS1(X(J)))
  380       CONTINUE
         END IF
         SCALE = SCALE/TSCAL
      END IF
C
C     Scale the column norms by 1/TSCAL for return.
C
      IF (TSCAL.NE.ONE) THEN
         CALL DSCAL(N,ONE/TSCAL,CNORM,1)
      END IF
C
      RETURN
C
C     End of F07VUZ (ZLATBS)
C
      END
