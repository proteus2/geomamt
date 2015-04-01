      SUBROUTINE E04GDS(M,N,NS,LPH,IGRADE,EPSMCH,UTF,S,PHESL,PHESD,RHS,
     *                  NPHI)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978.
C     MARK 8 REVISED. IER-233 (APR 1980).
C     MARK 8B REVISED. IER-265 (SEP 1980).
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 16 REVISED. IER-990 (JUN 1993).
C
C     **************************************************************
C
C     ADDS THE SQUARE OF THE SINGULAR VALUE TO THE APPROPRIATE
C     DIAGONAL ELEMENT OF VTHV. MODIFIES THE RIGHT-HAND-SIDE VECTOR
C     AND FORMS THE MODIFIED LDLT FACTORIZATION.
C
C     PHILIP E. GILL, WALTER MURRAY, SUSAN M. PICKEN
C     AND BRIAN T. HINDE
C     D.N.A.C., NATIONAL PHYSICAL LABORATORY, ENGLAND.
C
C     **************************************************************
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  EPSMCH
      INTEGER           IGRADE, LPH, M, N, NPHI, NS
C     .. Array Arguments ..
      DOUBLE PRECISION  PHESD(NS), PHESL(LPH), RHS(NS), S(N), UTF(M)
C     .. Local Scalars ..
      DOUBLE PRECISION  DELTA, SI
      INTEGER           I, IS
C     .. External Subroutines ..
      EXTERNAL          F01BQZ
C     .. Executable Statements ..
      DO 20 I = 1, NS
         IS = IGRADE + I
         SI = S(IS)
         PHESD(I) = PHESD(I) + SI*SI
         RHS(I) = -RHS(I) + SI*UTF(IS)
   20 CONTINUE
C
C     FIND THE MODIFIED LDLT FACTORIZATION BY CALLING F01BQZ
C     (FRMCHL) WITH SOFT FAILURE OPTION.
C
      DELTA = EPSMCH
      NPHI = 1
      CALL F01BQZ(NS,DELTA,PHESL,LPH,PHESD,NPHI)
      RETURN
C
C     END OF E04GDS   (FRMEQ)
C
      END
