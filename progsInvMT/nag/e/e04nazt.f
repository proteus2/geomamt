      SUBROUTINE E04NAZ(N,NCLIN,NCLIN0,ISSAVE,JDSAVE,AP,P)
C     MARK 11 RELEASE. NAG COPYRIGHT 1983.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C *********************************************************************
C     E04NAZ  IS CALLED WHEN A CONSTRAINT HAS JUST BEEN DELETED AND THE
C     SIGN OF THE SEARCH DIRECTION  P  MAY BE INCORRECT BECAUSE OF
C     ROUNDING ERRORS IN THE COMPUTATION OF THE PROJECTED GRADIENT ZTG.
C     THE SIGN OF THE SEARCH DIRECTION (AND THEREFORE THE PRODUCT  AP)
C     IS FIXED BY FORCING P TO SATISFY THE CONSTRAINT (WITH INDEX JDSAVE)
C     THAT WAS JUST DELETED.  VARIABLES THAT WERE HELD TEMPORARILY FIXED
C     (WITH ISTATE = 4)  ARE NOT CHECKED FOR FEASIBILITY.
C
C     SYSTEMS OPTIMIZATION LABORATORY, STANFORD UNIVERSITY.
C     ORIGINAL VERSION DECEMBER 1982.
C *********************************************************************
C
C     .. Scalar Arguments ..
      INTEGER           ISSAVE, JDSAVE, N, NCLIN, NCLIN0
C     .. Array Arguments ..
      DOUBLE PRECISION  AP(NCLIN0), P(N)
C     .. Scalars in Common ..
      INTEGER           ISTART, MSG, NOUT
C     .. Local Scalars ..
      DOUBLE PRECISION  ATP, ONE, ZERO
      INTEGER           IDEL
C     .. Local Arrays ..
      CHARACTER*45      REC(3)
C     .. External Subroutines ..
      EXTERNAL          F06FDF, X04BAF
C     .. Common blocks ..
      COMMON            /AE04VC/NOUT, MSG, ISTART
C     .. Data statements ..
      DATA              ZERO, ONE/0.0D+0, 1.0D+0/
C     .. Executable Statements ..
C
      IF (ISSAVE.EQ.4) GO TO 20
C
      IDEL = JDSAVE - N
      IF (JDSAVE.LE.N) ATP = P(JDSAVE)
      IF (JDSAVE.GT.N) ATP = AP(IDEL)
C
      IF (MSG.GE.80) THEN
         WRITE (REC,FMT=99999) JDSAVE, ISSAVE, ATP
         CALL X04BAF(NOUT,REC(1))
         CALL X04BAF(NOUT,REC(2))
         CALL X04BAF(NOUT,REC(3))
      END IF
C
      IF (ISSAVE.EQ.2 .AND. ATP.LE.ZERO .OR. ISSAVE.EQ.1 .AND. ATP.GE.
     *    ZERO) GO TO 20
C
C     REVERSE THE DIRECTION OF  P  AND  AP.
C
      CALL F06FDF(N,(-ONE),P,1,P,1)
      IF (NCLIN.GT.0) CALL F06FDF(NCLIN,(-ONE),AP,1,AP,1)
C
   20 RETURN
C
C
C     END OF E04NAZ  ( QPCHKP )
99999 FORMAT (/' //E04NAZ //  JDSAVE ISSAVE            ATP',/' //E04NA',
     *  'Z // ',2I7,G15.5)
      END
