      SUBROUTINE E04HEX(M,N,LSDER,LSFJC,LSHSS,LSHS,LSMON,SECOND,IPRINT,
     *                  MAXFUN,ETA,XTOL,STEPMX,X,FSUMSQ,FVEC,FJAC,LJ,S,
     *                  VT,LVT,NITER,NFTOTL,INFORM,IW,LIW,W,LW)
C     MARK 13 RE-ISSUE. NAG COPYRIGHT 1988.
C     MARK 14C REVISED. IER-879 (NOV 1990).
C     MARK 16 REVISED. IER-991 (JUN 1993).
C
C     **************************************************************
C
C     MINIMIZATION OF A SUM OF SQUARES OF NONLINEAR FUNCTIONS
C     USING A CORRECTED GAUSS-NEWTON METHOD. THE ALGORITHM
C     UTILIZES THE SINGULAR-VALUE DECOMPOSITION AND EITHER FINITE-
C     DIFFERENCE APPROXIMATIONS TO THE SECOND DERIVATIVES OR
C     EXACT SECOND DERIVATIVES.
C
C     PHILIP E. GILL, SUSAN M. PICKEN, WALTER MURRAY, BRIAN T. HINDE
C     AND NICHOLAS I. M. GOULD.
C     D.N.A.C., NATIONAL PHYSICAL LABORATORY, ENGLAND.
C
C     **************************************************************
C
C     Modified to call BLAS.
C     Peter Mayes, NAG Central Office, October 1987.
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  ETA, FSUMSQ, STEPMX, XTOL
      INTEGER           INFORM, IPRINT, LIW, LJ, LVT, LW, M, MAXFUN, N,
     *                  NFTOTL, NITER
      LOGICAL           SECOND
C     .. Array Arguments ..
      DOUBLE PRECISION  FJAC(LJ,N), FVEC(M), S(N), VT(LVT,N), W(LW),
     *                  X(N)
      INTEGER           IW(LIW)
C     .. Subroutine Arguments ..
      EXTERNAL          LSDER, LSFJC, LSHS, LSHSS, LSMON
C     .. Local Scalars ..
      DOUBLE PRECISION  ALPHA, EPSEPS, EPSMCH, GTG, PEPS, PNORM, RTEPS,
     *                  RTOL, SIGMA, SSQNEW, SSQOLD, TAU, TLEPSQ, TOL,
     *                  TOLEPS, U, XNORM
      INTEGER           IFLAG, IGRADE, IV, LEND, LGSSQ, LH, LHK, LP,
     *                  LP2, LPH, LPHESD, LPHESL, LRHS, LUTF, MAXRNK,
     *                  NPHI, NS, NWHY, NWY
      LOGICAL           CONV, GAUSS, NOMOVE, POSDEF
C     .. External Functions ..
      DOUBLE PRECISION  DDOT, DNRM2
      EXTERNAL          DDOT, DNRM2
C     .. External Subroutines ..
      EXTERNAL          E04GBX, E04GDQ, E04GDS, E04GDV, E04GDX, E04GDY,
     *                  E04GDZ, E04HEW, E04HEY, E04LBB, F04AQZ, F04JAZ,
     *                  F06FBF, DGEMV
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, SQRT
C     .. Executable Statements ..
C
C     SET ADDRESSES FOR REAL WORKSPACE.
C
C     **************************************************************
C
C     THE FOLLOWING ADDRESSES AND ARRAY LENGTHS DEFINE BLOCKS OF THE
C     WORKSPACE ARRAY W(LW).
C
C     W(1), LENGTH 2*N + M + M*N   LOCAL WORKSPACE FOR AUXILIARY
C                                  SUBROUTINES.
C
C     W(LRHS), LENGTH N            THE VECTOR NEEDED TO CALCULATE
C                                  P2.
C
C     W(LPHESL), LENGTH N*(N - 1)/2 THE LOWER TRIANGULAR MATRIX
C                                  ASSOCIATED WITH THE CHOLESKY
C                                  FACTORIZATION USED TO CALCULATE
C                                  P2.
C
C     W(LPHESD), LENGTH N          THE DIAGONAL MATRIX ASSOCIATED
C                                  WITH THE CHOLESKY FACTORIZATION
C                                  USED TO CALCULATE P2.
C
C     W(LP), LENGTH N              THE SEARCH DIRECTION VECTOR P.
C
C     W(LP2), LENGTH N             THE PROJECTION OF THE SEARCH
C                                  DIRECTION P2.
C
C     W(LGSSQ), LENGTH N           THE GRADIENT VECTOR OF THE SUM
C                                  OF SQUARES.
C
C     W(LUTF), LENGTH M            THE VECTOR OBTAINED FROM THE
C     .                            PRODUCT OF U TRANSPOSE AND THE
C     .                            VECTOR OF FUNCTION VALUES.  THE
C     .                            MATRIX U IS ASSOCIATED WITH THE
C     .                            SINGULAR VALUE DECOMPOSITION
C     .                                         T
C     .                            J = U * S * V .
C
C     W(LHK), LENGTH N*(N + 1)/2   THE USER-SUPPLIED SECOND
C                                  DERIVATIVE MATRIX.
C
C     THE TOTAL LENGTH OF W SHOULD NOT BE LESS THAN
C     N*N + 7*N + 2*M + N*M OR 9 + 3*M IF N IS 1.
C     IW SHOULD HAVE AT LEAST ONE ELEMENT.
C
C     **************************************************************
C
      LH = N*(N+1)/2
      LRHS = 2*N + M + M*N + 1
      LPHESL = LRHS + N
      LPHESD = LPHESL + N*(N-1)/2
      IF (N.EQ.1) LPHESD = LPHESL + 1
      LP = LPHESD + N
      LP2 = LP + N
      LGSSQ = LP2 + N
      LUTF = LGSSQ + N
      LHK = LUTF + M
      LEND = LHK + LH
      INFORM = 1
      IF (LW.LT.LEND-1) RETURN
C
C     ALL THE WORKSPACE ADDRESSES ARE NOW ALLOCATED.
C
      CALL E04GDZ(M,N,E04GBX,LSFJC,MAXFUN,ETA,XTOL,STEPMX,X,SSQNEW,FVEC,
     *            FJAC,LJ,LVT,NITER,NFTOTL,NWHY,RTEPS,RTOL,LEND,TOL,
     *            IGRADE,PEPS,W(LGSSQ),SSQOLD,GAUSS,TAU,ALPHA,PNORM,
     *            EPSMCH,NOMOVE,IW,LIW,W,LW)
      POSDEF = .TRUE.
      IF (NWHY.NE.0) GO TO 240
      TOLEPS = RTOL + EPSMCH
      TLEPSQ = TOLEPS*TOLEPS
      EPSEPS = EPSMCH*EPSMCH
C
C     .................START OF THE ITERATION LOOP.................
C
   20 NWHY = 2
      IF (NFTOTL.GT.MAXFUN) GO TO 180
      NWHY = 0
C
C     COMPUTE THE SINGULAR VALUE DECOMPOSITION OF THE JACOBIAN
C     MATRIX.  DETERMINE THE GRADE OF THE JACOBIAN AND WHETHER
C     THE GAUSS-NEWTON DIRECTION SHOULD BE CORRECTED.
C
   40 IF (NOMOVE) CALL E04GDV(N,VT,LVT)
      CALL E04GDY(M,N,MAXRNK,IGRADE,NWHY,TAU,EPSMCH,FVEC,FJAC,LJ,S,VT,
     *            LVT,W(LUTF),GAUSS,NOMOVE,W,LW)
      IF (NWHY.NE.0) GO TO 240
C
C     OVERALL CONVERGENCE CRITERION.
C
      GTG = DDOT(N,W(LGSSQ),1,W(LGSSQ),1)
      XNORM = DNRM2(N,X,1)
      U = 1.0D+0 + SSQNEW
      CONV = .FALSE.
      IF (NITER.GT.0 .AND. ALPHA*PNORM.LT.TOLEPS*(1.0D+0+XNORM)
     *    .AND. ABS(SSQOLD-SSQNEW).LT.TLEPSQ*U .AND. GTG.LT.PEPS*U*
     *    U .OR. SSQNEW.LT.EPSEPS .OR. GTG.LT.SQRT(SSQNEW)*EPSMCH)
     *    CONV = .TRUE.
      U = S(1)
      U = SSQNEW/(1.0D+0+U*U)
      U = U*U
      IF (U.LT.RTEPS .AND. CONV) CALL E04GDV(N,VT,LVT)
      IF (U.LT.RTEPS .AND. CONV) GO TO 180
C
C     COMPUTE THE GRADED GAUSS-NEWTON DIRECTION
C
      IF (IGRADE.EQ.0 .OR. CONV) GO TO 60
      CALL F04JAZ(M,N,IGRADE,S,N,W(LUTF),VT,LVT,W(LP),SIGMA,W)
      GO TO 80
   60 CALL F06FBF(N,0.0D0,W(LP),1)
C
C     TRANSPOSE VT AND IF NECESSARY FIND A CORRECTION TO THE
C     GAUSS-NEWTON DIRECTION OF SEARCH
C
   80 CALL E04GDV(N,VT,LVT)
      IF (GAUSS .AND. .NOT. CONV) GO TO 160
      NS = N - IGRADE
      IF (CONV) NS = N
      IV = N - NS
      IF (NS.EQ.0) GO TO 160
      LPH = NS*(NS-1)/2
      IF (NS.EQ.1) LPH = 1
C
C     FORM A SYMMETRIC APPROXIMATION TO THE SECOND DERIVATIVE TERM
C     OF THE SUM OF SQUARES.
C
      IF (SECOND) GO TO 100
      CALL E04HEW(M,N,LPH,NS,EPSMCH,E04GBX,LSFJC,IV,X,FVEC,FJAC,LJ,VT,
     *            LVT,W(LP),W(LPHESL),W(LPHESD),W(LRHS),IFLAG,IW,LIW,W,
     *            LW)
      IF (IFLAG.LT.0) NWHY = IFLAG
      IF (NWHY.NE.0) GO TO 240
      NFTOTL = NFTOTL + NS
      GO TO 140
  100 IF (NOMOVE) GO TO 120
      NWHY = 0
      CALL LSHSS(NWHY,M,N,LH,LSHS,FVEC,X,W(LHK),IW,LIW,W,LW)
      IF (NWHY.LT.0) GO TO 240
  120 CONTINUE
      CALL E04HEY(N,LH,LPH,NS,IV,VT,LVT,W(LP),W(LPHESL),W(LPHESD),
     *            W(LRHS),W(LHK),W)
C
C     ADD THE SQUARE OF THE SINGULAR VALUE TO THE APPROPRIATE
C     DIAGONAL ELEMENT OF VTHV. MODIFY THE RIGHT-HAND-SIDE VECTOR
C     AND FORM THE MODIFIED LDLT FACTORIZATION.
C
  140 CALL E04GDS(M,N,NS,LPH,IV,EPSMCH,W(LUTF),S,W(LPHESL),W(LPHESD),
     *            W(LRHS),NPHI)
      POSDEF = NPHI .EQ. 0
      IF (POSDEF .AND. CONV) GO TO 180
C
C     USE THE CHOLESKY FACTORIZATION TO FIND THE CORRECTION TO THE
C     GAUSS-NEWTON DIRECTION OF SEARCH. FIRST FORM A PROJECTION
C     OF THE REQUIRED DIRECTION.
C
      IF ( .NOT. CONV) CALL F04AQZ(NS,LPH,W(LPHESL),W(LPHESD),W(LRHS),
     *                             W(LP2))
      IF (CONV) CALL E04LBB(N,LPH,NPHI,W(LPHESL),W(LP2))
C
C     ADD V2*P2 TO THE VECTOR P.
C
      CALL DGEMV('Normal',N,NS,1.0D0,VT(1,IV+1),LVT,W(LP2),1,1.0D0,W(LP)
     *           ,1)
C
C     COMPUTE THE STEPLENGTH ALPHA. IF NECESSARY, PRINT DETAILS OF
C     THE CURRENT ITERATION.
C
  160 CALL E04GDQ(M,N,LSDER,E04GBX,LSFJC,RTEPS,ETA,IGRADE,IPRINT,LSMON,
     *            STEPMX,EPSMCH,TAU,XNORM,NOMOVE,X,FVEC,FJAC,LJ,W(LGSSQ)
     *            ,W(LP),S,ALPHA,PNORM,SSQNEW,SSQOLD,NITER,NFTOTL,NWHY,
     *            IFLAG,IW,LIW,W,LW)
      IF (NWHY.LT.0) GO TO 240
      NWHY = 0
C
C     IF IFLAG = 0 A LOWER POINT HAS BEEN FOUND.
C
      IF (IFLAG.EQ.0) GO TO 20
C
C     A LOWER POINT COULD NOT BE FOUND.
C
      NOMOVE = .TRUE.
      IF (IGRADE.GT.0) GO TO 40
      NWHY = 3
C
C     ....................END OF ITERATION LOOP....................
C
  180 FSUMSQ = SSQNEW
      IF (NOMOVE) GO TO 220
C
C     MAXIMUM NUMBER OF FUNCTION EVALUATIONS EXCEEDED.
C     COMPUTE SVD AT CURRENT POINT.
C
      IF (NWHY.NE.2) GO TO 200
      NWY = 1
      CALL E04GDX(NWY,M,N,FJAC,LJ,VT,LVT,FVEC,S,.TRUE.,W(LUTF),W,LW)
      IF (NWY.EQ.0) CALL E04GDV(N,VT,LVT)
      IF (NWY.EQ.0) GO TO 200
      NWHY = 4
      GO TO 240
C
C     TRANSPOSE ELEMENTS OF VT TO GIVE MATRIX V ON EXIT.
C
  200 CONTINUE
C
C     IF  REQUIRED, PRINT OUT DETAILS OF LOWEST POINT FOUND.
C
  220 IF (IPRINT.GE.0 .AND. NWHY.NE.1) CALL LSMON(M,N,X,FVEC,FJAC,LJ,S,
     *    IGRADE,NITER,NFTOTL,IW,LIW,W,LW)
  240 INFORM = NWHY
      RETURN
C
C     END OF E04HEX   (LSMIN2)
C
      END
