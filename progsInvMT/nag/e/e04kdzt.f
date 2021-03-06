      SUBROUTINE E04KDZ(IFLAG,N,X,HESL,LH,HESD,IW,LIW,W,LW)
C
C     MARK 6 RELEASE NAG COPYRIGHT 1977
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     **************************************************************
C
C     E04KDZ (UHESS) IS A DUMMY SUBROUTINE WHICH MUST BE INCLUDED
C     WITH E04LBR AND CALLED AS THE ACTUAL ARGUMENT FOR SHESS
C     WHENEVER USERH IS FALSE AND THE USER HAS NOT SUPPLIED AN
C     ALTERNATIVE SUBROUTINE FOR THE CALCULATION OF THE HESSIAN. IN
C     PARTICULAR, THE ROUTINE IS NEEDED BY E04KDF.
C
C     PHILIP E. GILL, WALTER MURRAY, SUSAN M. PICKEN, MARGARET H.
C     WRIGHT AND ENID M. R. LONG, D.N.A.C., NATIONAL PHYSICAL
C     LABORATORY, ENGLAND
C
C     **************************************************************
C
C     .. Scalar Arguments ..
      INTEGER           IFLAG, LH, LIW, LW, N
C     .. Array Arguments ..
      DOUBLE PRECISION  HESD(N), HESL(LH), W(LW), X(N)
      INTEGER           IW(LIW)
C     .. Executable Statements ..
      RETURN
C
C     END OF E04KDZ (UHESS)
C
      END
