      SUBROUTINE G01AGF(X,Y,NOBS,ISORT,NSTEPX,NSTEPY,IFAIL)
C     MARK 14 RE-ISSUE.  NAG COPYRIGHT 1989.
C     G01AGF PLOTS TWO ARRAYS AGAINST ONE ANOTHER
C     ON A CHARACTER PRINTING DEVICE WITH A CHOSEN NUMBER
C     OF CHARACTER POSITIONS IN EACH DIRECTION
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='G01AGF')
C     .. Scalar Arguments ..
      INTEGER           IFAIL, NOBS, NSTEPX, NSTEPY
C     .. Array Arguments ..
      DOUBLE PRECISION  X(NOBS), Y(NOBS)
      INTEGER           ISORT(NOBS)
C     .. Local Scalars ..
      DOUBLE PRECISION  AIX, AIY, STEPX, STEPY, XMN, XMX, XNMIN, YMN,
     *                  YMX, YNMIN, ZMPN, ZMPP
      INTEGER           IFA, J, MAXAX, MAXAY, MAXBX, MAXBY, NSX, NSY
C     .. Local Arrays ..
      CHARACTER*80      P01REC(1)
C     .. External Functions ..
      DOUBLE PRECISION  X02AJF
      INTEGER           P01ABF
      EXTERNAL          X02AJF, P01ABF
C     .. External Subroutines ..
      EXTERNAL          G01AGY, G01AGZ, M01CAF, M01DAF, M01ZAF
C     .. Intrinsic Functions ..
      INTRINSIC         AINT, MAX, MIN
C     .. Executable Statements ..
      IFA = 1
      IF (NOBS.LT.1) GO TO 140
      IFA = 0
      ZMPP = 1.0D0 + 2.0D0*X02AJF()
      ZMPN = 1.0D0 - 2.0D0*X02AJF()
      CALL M01DAF(Y,1,NOBS,'D',ISORT,IFA)
      CALL M01CAF(Y,1,NOBS,'D',IFA)
      CALL M01ZAF(ISORT,1,NOBS,IFA)
      YMX = Y(1)
      YMN = Y(NOBS)
      XMX = X(1)
      XMN = XMX
      IF (NOBS.EQ.1) GO TO 40
      DO 20 J = 2, NOBS
         XMN = MIN(X(J),XMN)
         XMX = MAX(X(J),XMX)
   20 CONTINUE
   40 IF (YMN.NE.YMX) GO TO 60
      YMN = YMN - 1.0D0
      YMX = YMX + 1.0D0
   60 IF (XMN.NE.XMX) GO TO 80
      XMN = XMN - 1.0D0
      XMX = XMX + 1.0D0
   80 NSX = MAX(MIN(NSTEPX,133),10)
      NSY = MAX(NSTEPY,10)
      CALL G01AGZ(XMN,XMX,NSX,XNMIN,STEPX,MAXAX,MAXBX)
      AIX = AINT(ZMPP*(XNMIN/STEPX))
      IF (XNMIN.LT.0.0D0 .AND. AIX*STEPX.GT.ZMPN*XNMIN) AIX = AIX -
     *    1.0D0
      IF (XMN.GT.(AIX+0.5D0)*STEPX) GO TO 100
      XNMIN = XNMIN - STEPX
      NSX = NSX + 1
  100 CALL G01AGZ(YMN,YMX,NSY,YNMIN,STEPY,MAXAY,MAXBY)
      AIY = AINT(ZMPP*(YNMIN/STEPY))
      IF (YNMIN.LT.0.0D0 .AND. AIY*STEPY.GT.ZMPN*YNMIN) AIY = AIY -
     *    1.0D0
      IF (YMN.GT.(AIY+0.5D0)*STEPY) GO TO 120
      YNMIN = YNMIN - STEPY
      NSY = NSY + 1
  120 CALL G01AGY(X,Y,XNMIN,STEPX,NSX,YNMIN,STEPY,NSY,NOBS,MAXAX,MAXBX,
     *            ISORT,MAXAY,MAXBY)
      IFAIL = 0
      GO TO 160
  140 IFAIL = P01ABF(IFAIL,IFA,SRNAME,0,P01REC)
  160 RETURN
      END
