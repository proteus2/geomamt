      LOGICAL FUNCTION C02AGS(X)
C     MARK 13 RELEASE. NAG COPYRIGHT 1988.
C     BASED ON THE ROUTINE  ISUNRM, WRITTEN BY BRIAN T. SMITH
C
C     THIS FUNCTION RETURNS TRUE IF X IS UNNORMALIZED OR ZERO.
C
C     .. Parameters ..
      DOUBLE PRECISION        ZERO
      PARAMETER               (ZERO=0.0D0)
C     .. Scalar Arguments ..
      DOUBLE PRECISION        X
C     .. Executable Statements ..
      C02AGS = (X+ZERO) .EQ. ZERO
      RETURN
      END