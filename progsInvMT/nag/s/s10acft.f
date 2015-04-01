      DOUBLE PRECISION FUNCTION S10ACF(X,IFAIL)
C     MARK 5A REVISED - NAG COPYRIGHT 1976
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 14 REVISED. IER-750 (DEC 1989).
C     COSH(X)
C     **************************************************************
C
C     TO EXTRACT THE CORRECT CODE FOR A PARTICULAR MACHINE-RANGE,
C     ACTIVATE THE STATEMENTS CONTAINED IN COMMENTS BEGINNING  CDD ,
C     WHERE  DD  IS THE APPROXIMATE NUMBER OF SIGNIFICANT DECIMAL
C     DIGITS REPRESENTED BY THE MACHINE
C     DELETE THE ILLEGAL DUMMY STATEMENTS OF THE FORM
C     * EXPANSION (NNNN) *
C
C     ALSO INSERT APPROPRIATE DATA STATEMENTS TO DEFINE CONSTANTS
C     WHICH DEPEND ON THE RANGE OF NUMBERS REPRESENTED BY THE
C     MACHINE, RATHER THAN THE PRECISION (SUITABLE STATEMENTS FOR
C     SOME MACHINES ARE CONTAINED IN COMMENTS BEGINNING CRD WHERE
C     D IS A DIGIT WHICH SIMPLY DISTINGUISHES A GROUP OF MACHINES).
C     DELETE THE ILLEGAL DUMMY DATA STATEMENTS WITH VALUES WRITTEN
C     *VALUE*
C
C     **************************************************************
C
C     .. Parameters ..
      CHARACTER*6                      SRNAME
      PARAMETER                        (SRNAME='S10ACF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION                 X
      INTEGER                          IFAIL
C     .. Local Scalars ..
      DOUBLE PRECISION                 U, XOVFL, Y
C     .. Local Arrays ..
      CHARACTER*1                      P01REC(1)
C     .. External Functions ..
      INTEGER                          P01ABF
      EXTERNAL                         P01ABF
C     .. Intrinsic Functions ..
      INTRINSIC                        ABS, EXP, SIGN
C     .. Data statements ..
C     RANGE DEPENDENT CONSTANTS
C     XOVFL ---- * MAXIMUM ARGUMENT FOR EXP *
      DATA XOVFL/ 7.080D+2/
C
CR1   DATA XOVFL/172.0D0/
CR2   DATA XOVFL/87.0D0/
CR3   DATA XOVFL/174.0D0/
CR4   DATA XOVFL/674.0D0/
CR5   DATA XOVFL/706.0D0/
C     .. Executable Statements ..
C
C     ERROR TEST
      IF (ABS(X).GT.XOVFL) GO TO 40
      U = X
      IFAIL = 0
   20 Y = EXP(U)
      S10ACF = 0.5D0*(Y+1.0D0/Y)
      RETURN
C
   40 IFAIL = P01ABF(IFAIL,1,SRNAME,0,P01REC)
      U = SIGN(XOVFL,X)
      GO TO 20
C
      END