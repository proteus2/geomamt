      DOUBLE PRECISION FUNCTION S10ABF(X,IFAIL)
C     MARK 5A REVISED - NAG COPYRIGHT 1976
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     MARK 14 REVISED. IER-749 (DEC 1989).
C     SINH(X)
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
      PARAMETER                        (SRNAME='S10ABF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION                 X
      INTEGER                          IFAIL
C     .. Local Scalars ..
      DOUBLE PRECISION                 T, U, XOVFL, Y
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
      U = X
      IF (ABS(X).GT.XOVFL) GO TO 40
      IFAIL = 0
C     TEST FOR SMALL X RANGE
      IF (ABS(X).GT.1.0D0) GO TO 20
C
C     ARGUMENT OF EXPANSION
      T = 2.0D0*X*X - 1.0D0
C
C      * EXPANSION (0009) *
C
C     EXPANSION (0009) EVALUATED AS Y(T)  --PRECISION 08E
C08   Y = ((((+1.7618931D-7)*T+2.5499397D-5)*T+2.1587794D-3)
C08  *    *T+8.7575097D-2)*T + 1.0854416D+0
C
C     EXPANSION (0009) EVALUATED AS Y(T)  --PRECISION 12E
C12   Y = (((((+7.98070428867D-10)*T+1.76189312394D-7)
C12  *    *T+2.54983994550D-5)*T+2.15877935982D-3)
C12  *    *T+8.75750976244D-2)*T + 1.08544164127D+0
C
C     EXPANSION (0009) EVALUATED AS Y(T)  --PRECISION 14E
C14   Y = ((((((+2.5513771373170D-12)*T+7.9807042886654D-10)
C14  *    *T+1.7618548532814D-7)*T+2.5498399454983D-5)
C14  *    *T+2.1587793612570D-3)*T+8.7575097624375D-2)*T +
C14  *     1.0854416412726D+0
C
C     EXPANSION (0009) EVALUATED AS Y(T)  --PRECISION 16E
      Y = ((((((+2.551377137317034D-12)*T+7.980704288665359D-10)
     *    *T+1.761854853281383D-7)*T+2.549839945498292D-5)
     *    *T+2.158779361257021D-3)*T+8.757509762437522D-2)*T +
     *     1.085441641272607D+0
C
C     EXPANSION (0009) EVALUATED AS Y(T)  --PRECISION 18E
C18   Y = (((((((+6.06282157636642837D-15)*T+2.55137713731703375D-12)
C18  *    *T+7.98059818928777249D-10)*T+1.76185485328138266D-7)
C18  *    *T+2.54983994602878876D-5)*T+2.15877936125702130D-3)
C18  *    *T+8.75750976243745588D-2)*T + 1.08544164127260700D+0
C
C
      S10ABF = X*Y
      RETURN
C
   20 Y = EXP(U)
      S10ABF = (Y-1.0D0/Y)*0.5D0
      RETURN
C
   40 IFAIL = P01ABF(IFAIL,1,SRNAME,0,P01REC)
      U = SIGN(XOVFL,X)
      GO TO 20
C
      END
