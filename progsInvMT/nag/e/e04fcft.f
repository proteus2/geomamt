      SUBROUTINE E04FCF(M,N,LSFN1,LSMON,IPRINT,MAXCAL,ETA,XTOL,STEPMX,X,
     *                  FSUMSQ,FVEC,FJAC,LJ,S,VT,LVT,NITER,NFTOTL,IW,
     *                  LIW,W,LW,IFAIL)
C     MARK 13 RE-ISSUE. NAG COPYRIGHT 1988.
C
C     **************************************************************
C
C     E04FCF IS A COMPREHENSIVE QUASI-NEWTON ALGORITHM FOR FINDING
C     AN UNCONSTRAINED MINIMUM OF A SUM OF SQUARES OF M NONLINEAR
C     FUNCTIONS IN N VARIABLES (M .GE. N).  NO DERIVATIVES ARE
C     REQUIRED.
C
C     THE ROUTINE IS ESSENTIALLY IDENTICAL TO THE SUBROUTINE LSNDN
C     IN THE NPL ALGORITHMS LIBRARY (REF. NO. E4/22/F).
C
C     PHILIP E. GILL, ENID M. R. LONG, WALTER MURRAY,
C     SUSAN M. PICKEN AND BRIAN T. HINDE
C     D.N.A.C., NATIONAL PHYSICAL LABORATORY, ENGLAND
C
C     **************************************************************
C
C     Modified to output explanatory messages.
C     Peter Mayes, NAG Central Office, December 1987.
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='E04FCF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  ETA, FSUMSQ, STEPMX, XTOL
      INTEGER           IFAIL, IPRINT, LIW, LJ, LVT, LW, M, MAXCAL, N,
     *                  NFTOTL, NITER
C     .. Array Arguments ..
      DOUBLE PRECISION  FJAC(LJ,N), FVEC(M), S(N), VT(LVT,N), W(LW),
     *                  X(N)
      INTEGER           IW(LIW)
C     .. Subroutine Arguments ..
      EXTERNAL          LSFN1, LSMON
C     .. Local Scalars ..
      INTEGER           LW1, LW2, NREC, NWHY
C     .. Local Arrays ..
      CHARACTER*80      P01REC(2)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          E04FCW, E04FCZ
C     .. Executable Statements ..
      NWHY = 1
C
C     Input values will be checked by E04FCZ
C
      CALL E04FCZ(M,N,E04FCW,LSFN1,LSMON,IPRINT,MAXCAL,ETA,XTOL,STEPMX,
     *            X,FSUMSQ,FVEC,FJAC,LJ,S,VT,LVT,NITER,NFTOTL,NWHY,IW,
     *            LIW,W,LW)
      IF (NWHY.LT.0) THEN
         P01REC(1) = ' ** Negative value of IFLAG set in LSQFUN by user'
         NREC = 1
      ELSE IF (NWHY.EQ.1) THEN
         LW1 = 6*N + M*N + 2*M + N*(N-1)/2
         LW2 = 7 + 3*M
         IF (N.LT.1) THEN
            WRITE (P01REC,FMT=99999) N
            NREC = 1
         ELSE IF (M.LT.N) THEN
            WRITE (P01REC,FMT=99998) M, N
            NREC = 1
         ELSE IF (MAXCAL.LT.1) THEN
            WRITE (P01REC,FMT=99997) MAXCAL
            NREC = 1
         ELSE IF (ETA.LT.0.0D0 .OR. ETA.GE.1.0D0) THEN
            WRITE (P01REC,FMT=99996) ETA
            NREC = 1
         ELSE IF (XTOL.LT.0.0D0) THEN
            WRITE (P01REC,FMT=99995) XTOL
            NREC = 1
         ELSE IF (STEPMX.LT.XTOL) THEN
            WRITE (P01REC,FMT=99994) STEPMX, XTOL
            NREC = 2
         ELSE IF (LJ.LT.M) THEN
            WRITE (P01REC,FMT=99993) LJ, M
            NREC = 1
         ELSE IF (LVT.LT.N) THEN
            WRITE (P01REC,FMT=99992) LVT, N
            NREC = 1
         ELSE IF (LIW.LT.1) THEN
            WRITE (P01REC,FMT=99991) LIW
            NREC = 1
         ELSE IF (LW.LT.LW1 .AND. N.GT.1) THEN
            WRITE (P01REC,FMT=99990) LW, LW1
            NREC = 2
         ELSE IF (LW.LT.LW2 .AND. N.EQ.1) THEN
            WRITE (P01REC,FMT=99989) LW, LW2
            NREC = 2
         END IF
      ELSE IF (NWHY.EQ.2) THEN
         WRITE (P01REC,FMT=99988) MAXCAL
         NREC = 1
      ELSE IF (NWHY.EQ.3) THEN
         P01REC(1) =
     *   ' ** The conditions for a minimum have not all been satisfied,'
         P01REC(2) = ' ** but a lower point could not be found'
         NREC = 2
      ELSE IF (NWHY.EQ.4) THEN
         P01REC(1) =
     *       ' ** Failure in computing SVD of estimated Jacobian matrix'
         NREC = 1
      END IF
      IFAIL = P01ABF(IFAIL,NWHY,SRNAME,NREC,P01REC)
      RETURN
C
C     END OF E04FCF   (LSNDN)
C
99999 FORMAT (' ** On entry, N must be at least 1: N =',I16)
99998 FORMAT (' ** On entry, M must be at least N: M =',I16,', N =',I16)
99997 FORMAT (' ** On entry, MAXCAL must be at least 1: MAXCAL =',I16)
99996 FORMAT (' ** On entry, ETA must satisfy 0.le.ETA.lt.1: ETA =',1P,
     *       D13.5)
99995 FORMAT (' ** On entry, XTOL must be at least 0.0: XTOL =',1P,
     *       D13.5)
99994 FORMAT (' ** On entry, STEPMX must be at least XTOL:',/' ** STEP',
     *       'MX =',1P,D13.5,', XTOL =',1P,D13.5)
99993 FORMAT (' ** On entry, LJ must be at least M: LJ =',I16,', M =',
     *       I16)
99992 FORMAT (' ** On entry, LV must be at least N: LV =',I16,', N =',
     *       I16)
99991 FORMAT (' ** On entry, LIW must be at least 1: LIW =',I16)
99990 FORMAT (' ** On entry, LW must be at least 6*N + M*N + 2*M + N*(',
     *       'N-1)/2 if N.gt.1:',/' ** LW =',I16,
     *       ', LW must be at least',I16)
99989 FORMAT (' ** On entry, LW must be at least 7 + 3*M if N.eq.1:',
     *       /' ** LW =',I16,', LW must be at least',I16)
99988 FORMAT (' ** There have been MAXCAL calls to LSQFUN: MAXCAL =',
     *       I16)
      END
