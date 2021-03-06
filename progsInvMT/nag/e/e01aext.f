      SUBROUTINE E01AEX(M,X,IP,N,LOCX,C,NC,XNEW,IXNEXT,YNEW,NORDP1,CNEW,
     *                  D)
C     MARK 8 RELEASE. NAG COPYRIGHT 1979.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     *******************************************************
C
C     NPL ALGORITHMS LIBRARY ROUTINE DIVDIF
C
C     CREATED 17 07 79.  UPDATED 14 05 80.  RELEASE 00/08
C
C     AUTHORS ... MAURICE G. COX AND MICHAEL A. SINGER.
C     NATIONAL PHYSICAL LABORATORY, TEDDINGTON,
C     MIDDLESEX TW11 OLW, ENGLAND
C
C     *******************************************************
C
C     E01AEX.  AN ALGORITHM TO DETERMINE THE NEXT COEFFICIENT
C     IN THE NEWTON FORM OF AN INTERPOLATING POLYNOMIAL
C
C     INPUT PARAMETERS
C        M        NUMBER OF DISTINCT X-VALUES.
C        X        INDEPENDENT VARIABLE VALUES,
C                    NORMALIZED TO  (-1, 1)
C        IP       HIGHEST ORDER OF DERIVATIVE AT EACH X-VALUE
C        N        NUMBER OF INTERPOLATING CONDITIONS.
C                    N = M + IP(1) + IP(2) + ... + IP(M).
C        LOCX     POINTERS TO X-VALUES IN CONSTRUCTING
C                    NEWTON FORM OF POLYNOMIAL
C        C        NEWTON COEFFICIENTS DETERMINED SO FAR
C        NC       NUMBER OF NEWTON COEFFICIENTS DETERMINED SO FAR
C        XNEW     ELEMENT OF  X  ASSOCIATED WITH NEW
C                    NEWTON COEFFICIENT
C        IXNEXT   NUMBER OF X-VALUES SO FAR INCORPORATED
C                    (INCLUDING  XNEW)
C        YNEW     SCALED DERIVATIVE VALUE CORRESPONDING TO
C                    XNEW  AND  NORDP1
C        NORDP1   ONE PLUS ORDER OF DERIVATIVE
C                    ASSOCIATED WITH  YNEW
C
C     INPUT/OUTPUT PARAMETERS
C        D        ELEMENTS IN PREVIOUS, AND THEN NEW, UPWARD
C                    SLOPING DIAGONAL OF DIVIDED DIFFERENCE TABLE
C
C     OUTPUT PARAMETERS
C        CNEW     NEW NEWTON COEFFICIENT GENERATED
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  CNEW, XNEW, YNEW
      INTEGER           IXNEXT, M, N, NC, NORDP1
C     .. Array Arguments ..
      DOUBLE PRECISION  C(N), D(N), X(M)
      INTEGER           IP(M), LOCX(M)
C     .. Local Scalars ..
      DOUBLE PRECISION  DIF
      INTEGER           IC, IS, IX, K, LOCXI
C     .. Executable Statements ..
      IC = NC - NORDP1 + 1
      D(1) = YNEW
      IF (IXNEXT.EQ.1) GO TO 60
      IS = 0
      IX = 0
      DO 40 K = 1, IC
         IF (K.LE.IS) GO TO 20
         IX = IX + 1
         LOCXI = LOCX(IX)
         IS = IS + IP(LOCXI) + 1
         DIF = X(LOCXI) - XNEW
   20    IF (NORDP1.EQ.1) D(K+1) = (C(K)-D(K))/DIF
         IF (NORDP1.GT.1) D(K+1) = (D(K+1)-D(K))/DIF
   40 CONTINUE
   60 CNEW = D(IC+1)
      RETURN
C
C     END E01AEX
C
      END
