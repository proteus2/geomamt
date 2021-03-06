      SUBROUTINE F02WUF(N,A,LDA,NCOLB,B,LDB,WANTQ,Q,LDQ,SV,WANTP,WORK,
     *                  IFAIL)
C     MARK 14 RELEASE. NAG COPYRIGHT 1989.
C
C  1. Purpose
C     =======
C
C  F02WUF  returns all, or part, of the  singular value decomposition of
C  a real upper triangular matrix.
C
C  2. Description
C     ===========
C
C  The n by n upper triangular matrix R is factorized as
C
C     R = Q*S*P',
C
C  where  Q and P  are  n by n orthogonal matrices and  S  is an  n by n
C  diagonal  matrix   with  non-negative  diagonal  elements,   sv( 1 ),
C  sv( 2 ), ..., sv( n ), ordered such that
C
C     sv( 1 ) .ge. sv( 2 ) .ge. ... .ge. sv( n ) .ge. 0.
C
C  The  columns of  Q  are the  left-hand  singular vectors  of  R,  the
C  diagonal elements of  S are the singular values of  R and the columns
C  of  P are the right-hand singular vectors of  R.
C
C  Either or both of Q and P' may be requested and the matrix C given by
C
C     C = Q'*B,
C
C  where B is an n by ncolb given matrix, may also be requested.
C
C  The  routine  obtains  the  singular  value  decomposition  by  first
C  reducing  R  to  bidiagonal form  by means of  Givens plane rotations
C  and  then  using  the  QR algorithm  to  obtain  the  singular  value
C  decomposition  of the  bidiagonal form.
C
C  3. Parameters
C     ==========
C
C  N      - INTEGER.
C
C           On entry,  N must specify the order of the matrix R.  N must
C           be  at  least zero. When  N = 0  then an immediate return is
C           effected.
C
C           Unchanged on exit.
C
C  A      - REAL             array of DIMENSION ( LDA, n ).
C
C           Before entry,  the leading  N by N  upper triangular part of
C           the array  A  must contain the  upper triangular  matrix  R.
C
C           If  WANTP is .TRUE.  then on exit, the N by N part of A will
C           contain  the  n by n  orthogonal matrix  P',  otherwise  the
C           N by N  upper triangular  part  of  A  is  used as  internal
C           workspace,  but  the  strictly lower triangular  part  of  A
C           is not referenced.
C
C  LDA    - INTEGER.
C
C           On entry, LDA  must  specify  the  leading dimension of  the
C           array  A  as declared in the calling (sub) program. LDA must
C           be at least  n.
C
C           Unchanged on exit.
C
C  NCOLB  - On entry,  NCOLB  must specify the  number of columns of the
C           matrix  B  and must be at least  zero.  When  NCOLB = 0  the
C           array  B  is not referenced.
C
C  B      - REAL             array of DIMENSION ( LDB, ncolb ).
C
C           Before entry with  NCOLB .gt. 0, the leading N by NCOLB part
C           of the array  B  must contain the  matrix to be  transformed
C           and  on exit,  B  is overwritten  by the  n by ncolb  matrix
C           Q'*B.
C
C  LDB    - INTEGER.
C
C           On entry, LDB  must  specify  the  leading dimension of  the
C           array  B  as declared  in the  calling  (sub) program.  When
C           NCOLB .gt. 0  then LDB must be at least  n.
C
C           Unchanged on exit.
C
C  WANTQ  - LOGICAL.
C
C           On entry,  WANTQ must be .TRUE. if the matrix Q is required.
C           If  WANTQ is .FALSE.  then  the array  Q  is not referenced.
C
C           Unchanged on exit.
C
C  Q      - REAL             array of DIMENSION ( LDQ, n ).
C
C           On exit with  WANTQ as .TRUE.,  the leading  N by N  part of
C           the array Q will contain the orthogonal matrix Q.  Otherwise
C           the array  Q  is not referenced.
C
C  LDQ    - INTEGER.
C
C           On entry, LDQ  must  specify  the  leading dimension of  the
C           array  Q  as declared  in the  calling  (sub) program.  When
C           WANTQ is .TRUE.,  LDQ  must be at least n.
C
C           Unchanged on exit.
C
C  SV     - REAL array of DIMENSION at least ( n ).
C
C           On exit, the array  SV will contain the  n diagonal elements
C           of the matrix S.
C
C  WANTP  - LOGICAL.
C
C           On entry, WANTP must be .TRUE. if the matrix P' is required,
C           in which case  P'  is overwritten on the array A,  otherwise
C           WANTP must be .FALSE..
C
C           Unchanged on exit.
C
C  WORK   - REAL array of DIMENSION at least  ( max( 1, lwork ) ), where
C           lwork must satisfy:
C
C              lwork = 2*( n - 1 ) when
C                 ncolb = 0  and  WANTQ and WANTP are .FALSE.,
C
C              lwork = 3*( n - 1 ) when
C                 either  ncolb = 0  and  WANTQ is .FALSE.  and
C                 WANTP is .TRUE.,  or  WANTP is .FALSE.  and  one or
C                 both of  ncolb .gt. 0  and  WANTQ is .TRUE.
C
C              lwork = 5*( n - 1 ) otherwise.
C
C           The array   WORK  is used as  internal workspace by  F06XUF.
C           On exit,  WORK( n )  contains the total number of iterations
C           taken by the QR algorithm.
C
C  IFAIL  - INTEGER.
C
C           Before entry,  IFAIL  must contain one of the values -1 or 0
C           or 1 to specify noisy soft failure or noisy hard failure  or
C           silent soft failure. ( See Chapter P01 for further details.)
C
C           On successful  exit  IFAIL  will be  zero,  otherwise  IFAIL
C           will be set to a  non-zero value  indicating either  that an
C           input parameter  has been  incorrectly set,  or that the  QR
C           algorithm  is not  converging.  See  the  next  section  for
C           further details.
C
C  4. Diagnostic Information
C     ======================
C
C  IFAIL = -1
C
C     One or more of the following conditions holds:
C
C        N     .lt. 0
C        LDA   .lt. N
C        NCOLB .lt. 0
C        LDB   .lt. N  and  NCOLB .gt. 0
C        LDQ   .lt. N  and  WANTQ  is  true
C
C  IFAIL .gt. 0
C
C     The  QR algorithm  has failed to converge in  50*N iterations.  In
C     this  case  sv( 1 ), sv( 2 ), ..., sv( IFAIL )  may not  have been
C     found correctly  and the remaining singular values  may not be the
C     smallest.  The matrix  R will nevertheless have been factorized as
C     R = Q*E*P', where E is a bidiagonal matrix with  sv( 1 ), sv( 2 ),
C     ..., sv( n )  as the  diagonal elements and  work( 1 ), work( 2 ),
C     ..., work( n - 1 )  as the super-diagonal elements.
C
C     This failure is not likely to occur.
C
C  If  on  entry,  IFAIL  was  either  -1 or 0  then  further diagnostic
C  information  will  be  output  on  the  error message  channel. ( See
C  routine  X04AAF. )
C
C  5. Further information
C     ===================
C
C  Following the use of this routine the rank of R may be estimated by
C  a call to the INTEGER function F06KLF.  The statement:
C
C     IRANK = F06KLF( N, SV, 1, TOL )
C
C  returns  the value  ( k - 1 ), in  IRANK,  where  k  is the  smallest
C  integer  for  which   sv( k ) .lt. tol*sv( 1 ),   where  tol  is  the
C  tolerance supplied in  TOL, so that  IRANK is an estimate of the rank
C  of  S  and thus also of  R.  If  TOL is supplied as negative then the
C  relative machine precision ( see routine X02AJF ) is used in place of
C  TOL.
C
C
C  Nag Fortran 77 Auxiliary linear algebra routine.
C
C  -- Written on 10-January-1988.
C     Sven Hammarling, Nag Central Office.
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='F02WUF')
C     .. Scalar Arguments ..
      INTEGER           IFAIL, LDA, LDB, LDQ, N, NCOLB
      LOGICAL           WANTP, WANTQ
C     .. Array Arguments ..
      DOUBLE PRECISION  A(LDA,*), B(LDB,*), Q(LDQ,*), SV(*), WORK(*)
C     .. Local Scalars ..
      INTEGER           IERR, NCOLP, NCOLQ
C     .. Local Arrays ..
      DOUBLE PRECISION  DUMMY(1)
      CHARACTER*80      REC(2)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          F02SWF, F02SXF, F02SYF, P01ABY
C     .. Executable Statements ..
C
C     Check the input parameters.
C
      IERR = 0
      IF (N.LT.0) CALL P01ABY(N,'N',IFAIL,IERR,SRNAME)
      IF (LDA.LT.N) CALL P01ABY(LDA,'LDA',IFAIL,IERR,SRNAME)
      IF (NCOLB.LT.0) CALL P01ABY(NCOLB,'NCOLB',IFAIL,IERR,SRNAME)
      IF ((LDB.LT.N) .AND. (NCOLB.GT.0)) CALL P01ABY(LDB,'LDB',IFAIL,
     *    IERR,SRNAME)
      IF ((LDQ.LT.N) .AND. (WANTQ)) CALL P01ABY(LDQ,'LDQ',IFAIL,IERR,
     *    SRNAME)
      IF (IERR.GT.0) THEN
         WRITE (REC,FMT=99999) IERR
         IFAIL = P01ABF(IFAIL,-1,SRNAME,1,REC)
         RETURN
      END IF
      IF (N.EQ.0) THEN
         IFAIL = P01ABF(IFAIL,0,SRNAME,0,REC)
         RETURN
      END IF
C
C     Perform the factorization.
C
C     First  reduce  the  matrix  R  to  bidiagonal form.  The  diagonal
C     elements  will  be  in   SV  and  the  super-diagonals  in   WORK.
C
      CALL F02SWF(N,A,LDA,SV,WORK,NCOLB,B,LDB,WANTQ,Q,LDQ,IERR)
      IF (WANTP) THEN
         CALL F02SXF(N,A,LDA,0,DUMMY,1,WORK(N),IERR)
         NCOLP = N
      ELSE
         NCOLP = 0
      END IF
      IF (WANTQ) THEN
         NCOLQ = N
      ELSE
         NCOLQ = 0
      END IF
C
C     Next find the SVD of the bidiagonal matrix.
C
      IERR = 1
      CALL F02SYF(N,SV,WORK,NCOLB,B,LDB,NCOLQ,Q,LDQ,NCOLP,A,LDA,WORK(N),
     *            IERR)
      IF (IERR.NE.0) THEN
         WRITE (REC,FMT=99998) IERR
         IFAIL = P01ABF(IFAIL,IERR,SRNAME,2,REC)
      ELSE
         IFAIL = P01ABF(IFAIL,0,SRNAME,0,REC)
      END IF
      RETURN
C
C
C     End of F02WUF. ( SUTQR )
C
99999 FORMAT ('    The input parameters contained ',I2,' error(s)')
99998 FORMAT ('    The QR algorithm has failed to converge.',/'    ',I6,
     *       ' singular values have NOT been found.')
      END
