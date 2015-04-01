      SUBROUTINE G02EEZ(JOB,N,ALPHA,X,INCX,TOL,BETA,ZETA)
C     MARK 14 RELEASE. NAG COPYRIGHT 1989.
C
C  F06FRF generates details of a generalized Householder reflection such
C  that
C
C     P*( alpha ) = ( beta ),   P'*P = I.
C       (   x   )   (   0  )
C
C  P is given in the form
C
C     P = I - ( zeta )*( zeta  z' ),
C             (   z  )
C
C  where z is an n element vector and zeta is a scalar that satisfies
C
C     1.0 .le. zeta .le. sqrt( 2.0 ).
C
C  zeta is returned in ZETA unless x is such that
C
C     max( abs( x( i ) ) ) .le. max( eps*abs( alpha ), tol )
C
C  where eps is the relative machine precision and tol is the user
C  supplied value TOL, in which case ZETA is returned as 0.0 and P can
C  be taken to be the unit matrix.
C
C  When  JOB = 0  then only  beta and zeta are computed, otherwise  beta
C  and zeta must be as returned from a call with  JOB = 0, and z is then
C  overwritten on x and beta is overwritten on alpha.
C
C  The routine may be called with  n = 0  and advantage is taken of the
C  case where  n = 1.
C
C
C  Nag Fortran 77 O( n ) basic linear algebra routine.
C
C  -- Written on 25-March-1988.
C     Sven Hammarling, Nag Central Office.
C
C
C     .. Parameters ..
      DOUBLE PRECISION  ONE, ZERO
      PARAMETER         (ONE=1.0D+0,ZERO=0.0D+0)
C     .. Scalar Arguments ..
      DOUBLE PRECISION  ALPHA, BETA, TOL, ZETA
      INTEGER           INCX, JOB, N
C     .. Array Arguments ..
      DOUBLE PRECISION  X(*)
C     .. Local Scalars ..
      DOUBLE PRECISION  EPS, SCALE, SSQ
      LOGICAL           FIRST
C     .. External Functions ..
      DOUBLE PRECISION  X02AJF
      EXTERNAL          X02AJF
C     .. External Subroutines ..
      EXTERNAL          F06FJF, DSCAL
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, MAX, SQRT
C     .. Save statement ..
      SAVE              EPS, FIRST
C     .. Data statements ..
      DATA              FIRST/.TRUE./
C     .. Executable Statements ..
      IF (JOB.EQ.0) THEN
         IF (N.LT.1) THEN
            ZETA = ZERO
            BETA = ALPHA
         ELSE IF ((N.EQ.1) .AND. (X(1).EQ.ZERO)) THEN
            ZETA = ZERO
            BETA = ALPHA
         ELSE
C
            IF (FIRST) THEN
               FIRST = .FALSE.
               EPS = X02AJF()
            END IF
C
C           Treat case where P is a 2 by 2 matrix specially.
C
            IF (N.EQ.1) THEN
C
C              Deal with cases where  ALPHA = zero  and
C              abs( X( 1 ) ) .le. max( EPS*abs( ALPHA ), TOL )  first.
C
               IF (ALPHA.EQ.ZERO) THEN
                  ZETA = ONE
                  BETA = ABS(X(1))
               ELSE IF (ABS(X(1)).LE.MAX(EPS*ABS(ALPHA),TOL)) THEN
                  ZETA = ZERO
                  BETA = ALPHA
               ELSE
                  IF (ABS(ALPHA).GE.ABS(X(1))) THEN
                     BETA = ABS(ALPHA)*SQRT(1+(X(1)/ALPHA)**2)
                  ELSE
                     BETA = ABS(X(1))*SQRT(1+(ALPHA/X(1))**2)
                  END IF
                  ZETA = SQRT((ABS(ALPHA)+BETA)/BETA)
                  IF (ALPHA.GE.ZERO) BETA = -BETA
               END IF
            ELSE
C
C              Now P is larger than 2 by 2.
C
               SSQ = ONE
               SCALE = ZERO
               CALL F06FJF(N,X,INCX,SCALE,SSQ)
C
C              Treat cases where  SCALE = zero,
C              SCALE .le. max( EPS*abs( ALPHA ), TOL )  and
C              ALPHA = zero  specially.
C              Note that  SCALE = max( abs( X( i ) ) ).
C
               IF ((SCALE.EQ.ZERO) .OR. (SCALE.LE.MAX(EPS*ABS(ALPHA)
     *             ,TOL))) THEN
                  ZETA = ZERO
                  BETA = ALPHA
               ELSE IF (ALPHA.EQ.ZERO) THEN
                  ZETA = ONE
                  BETA = SCALE*SQRT(SSQ)
               ELSE
                  IF (SCALE.LT.ABS(ALPHA)) THEN
                     BETA = ABS(ALPHA)*SQRT(1+SSQ*(SCALE/ALPHA)**2)
                  ELSE
                     BETA = SCALE*SQRT(SSQ+(ALPHA/SCALE)**2)
                  END IF
                  ZETA = SQRT((BETA+ABS(ALPHA))/BETA)
                  IF (ALPHA.GT.ZERO) BETA = -BETA
               END IF
            END IF
         END IF
      ELSE IF (ZETA.NE.ZERO) THEN
         CALL DSCAL(N,-1/(ZETA*BETA),X,INCX)
         ALPHA = BETA
      END IF
C
      RETURN
      END
