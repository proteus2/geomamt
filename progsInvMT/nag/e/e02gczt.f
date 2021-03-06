      SUBROUTINE E02GCZ(V1,V2,RMLT,NOTROW,I1,NP2)
C     MARK 8 RELEASE.  NAG COPYRIGHT 1980.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     THIS SUBROUTINE SUBTRACTS FROM THE VECTOR V1 A MULTIPLE OF
C     THE VECTOR V2 STARTING AT THE I1*TH ELEMENT UP TO THE
C     NP2*TH ELEMENT, EXCEPT FOR THE NOTROW*TH ELEMENT.
C     .. Scalar Arguments ..
      DOUBLE PRECISION  RMLT
      INTEGER           I1, NOTROW, NP2
C     .. Array Arguments ..
      DOUBLE PRECISION  V1(NP2), V2(NP2)
C     .. Local Scalars ..
      INTEGER           I, IEND, ISTART
C     .. Executable Statements ..
      IEND = NOTROW - 1
      ISTART = NOTROW + 1
      IF (IEND.LT.I1) GO TO 40
      DO 20 I = I1, IEND
         V1(I) = V1(I) - RMLT*V2(I)
   20 CONTINUE
   40 CONTINUE
      IF (ISTART.GT.NP2) RETURN
      DO 60 I = ISTART, NP2
         V1(I) = V1(I) - RMLT*V2(I)
   60 CONTINUE
      RETURN
      END
