      SUBROUTINE E04GDY(M,N,MAXRNK,IGRADE,NWHY,TAU,EPSMCH,FVEC,FJAC,LJ,
     *                  S,VT,LVT,UTF,GAUSS,NOMOVE,W,LW)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978.
C     MARK 8 REVISED. IER-233 (APR 1980).
C     MARK 8B REVISED. IER-265 (SEP 1980).
C     MARK 11 REVISED. IER-439 (FEB 1984).
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     **************************************************************
C
C     COMPUTE THE SINGULAR VALUE DECOMPOSITION OF THE JACOBIAN
C     MATRIX.  DETERMINE THE GRADE OF THE JACOBIAN AND WHETHER THE
C     GAUSS-NEWTON STEP SHOULD BE CORRECTED.
C     E04GDY USES MAX(3*N, N + M*N) ELEMENTS OF REAL WORKSPACE.
C
C     PHILIP E. GILL, SUSAN M. PICKEN, WALTER MURRAY AND
C     NICHOLAS I. M. GOULD.
C     D.N.A.C., NATIONAL PHYSICAL LABORATORY, ENGLAND.
C
C     **************************************************************
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  EPSMCH, TAU
      INTEGER           IGRADE, LJ, LVT, LW, M, MAXRNK, N, NWHY
      LOGICAL           GAUSS, NOMOVE
C     .. Array Arguments ..
      DOUBLE PRECISION  FJAC(LJ,N), FVEC(M), S(N), UTF(M), VT(LVT,N),
     *                  W(LW)
C     .. Local Scalars ..
      DOUBLE PRECISION  TOLRNK
      INTEGER           IFLAG
      LOGICAL           ROUTE
C     .. External Functions ..
      INTEGER           F02WDY
      EXTERNAL          F02WDY
C     .. External Subroutines ..
      EXTERNAL          E04GDU, E04GDW, E04GDX, H01CAU
C     .. Executable Statements ..
      IF (NOMOVE) GO TO 20
C
C     COMPUTE THE SINGULAR VALUE DECOMPOSITION OF THE JACOBIAN
C     MATRIX, USING NPL NOSL VERSION OF S. HAMMARLING'S
C     ROUTINE F02WAX (SVDGN1).
C
      NWHY = 4
C
C     SET IFLAG = 1, SO THAT IF AN ERROR OCCURS IN THE SINGULAR
C     VALUE DECOMPOSITION CONTROL RETURNS TO THE CALLING ROUTINE.
C
      IFLAG = 1
      CALL E04GDX(IFLAG,M,N,FJAC,LJ,VT,LVT,FVEC,S,.TRUE.,UTF,W,LW)
C
C     IF THE S.V.D. ROUTINE HAS BEEN UNABLE TO FACTORIZE THE
C     JACOBIAN MATRIX, THE MINIMIZATION IS TERMINATED.
C
      IF (IFLAG.EQ.1) RETURN
      CALL H01CAU(M,UTF)
      NWHY = 0
C
C     CALCULATE THE RANK OF THE MATRIX, MAXRNK.
C
      TOLRNK = 1.0D+1*EPSMCH
      MAXRNK = F02WDY(N,S,TOLRNK)
      ROUTE = .TRUE.
      IF (MAXRNK.LT.IGRADE) IGRADE = MAXRNK
      IF (TAU.GT.1.0D-1 .OR. (TAU.GT.1.0D-2 .AND. GAUSS)) GO TO 40
   20 ROUTE = .FALSE.
      IF (TAU.GT.1.0D-2) GO TO 40
C
C     THE GAUSS-NEWTON STEP WILL BE CORRECTED.
C     IF THE LAST STEP TAKEN WAS GAUSS-NEWTON, PARTITION THE ORDERED
C     DIAGONAL ELEMENTS INTO TWO SECTIONS OF ROUGHLY EQUAL CONDITION
C     NUMBER.
C
      IF (GAUSS) CALL E04GDW(N,MAXRNK,S,IGRADE)
C
C     IF THE LAST STEP TAKEN WAS NOT GAUSS-NEWTON, RE-PARTITION THE
C     DIAGONAL SO THAT IGRADE IS REDUCED.
C
      IF ( .NOT. GAUSS) CALL E04GDU(N,S,IGRADE)
   40 GAUSS = ROUTE
      IF (GAUSS) IGRADE = MAXRNK
      RETURN
C
C     END OF E04GDY   (GTSVD)
C
      END
